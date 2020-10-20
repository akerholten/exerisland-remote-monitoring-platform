package handlers

import (
	"HealthWellnessRemoteMonitoring/internal/constants"
	"HealthWellnessRemoteMonitoring/internal/cookie"
	"HealthWellnessRemoteMonitoring/internal/db"
	"HealthWellnessRemoteMonitoring/internal/tools"
	"context"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"

	validator "github.com/asaskevich/govalidator"
)

func AddPatientHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("Got a signup request...")
	defer r.Body.Close()
	if r.Header.Get("Content-Type") != "application/json; charset=utf-8" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	var signupData db.PatientSignupData

	respBody, err := ioutil.ReadAll(r.Body)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	err = json.Unmarshal(respBody, &signupData)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		log.Printf("Error unmarshaling: %s, error: %v", string(respBody), err)
	}

	if len(signupData.Email) < 8 {
		_, err := w.Write([]byte("Email is shorter than 8 characters"))
		if err != nil {
			log.Printf("Error when email was too short and writing bytes: %v", err)
		}
		return
	}

	if len(signupData.Email) > 100 {
		_, err := w.Write([]byte("Email is longer than 100 characters"))
		if err != nil {
			log.Printf("Error when email was too long and writing bytes: %v", err)
		}
		return
	}

	if len(signupData.FirstName) > 100 {
		_, err := w.Write([]byte("FirstName is longer than 100 characters"))
		if err != nil {
			log.Printf("Error when FirstName was too long and writing bytes: %v", err)
		}
		return
	}

	if len(signupData.LastName) > 100 {
		_, err := w.Write([]byte("FirstName is longer than 100 characters"))
		if err != nil {
			log.Printf("Error when FirstName was too long and writing bytes: %v", err)
		}
		return
	}

	if len(signupData.Note) > 100 {
		_, err := w.Write([]byte("Note is longer than 100 characters"))
		if err != nil {
			log.Printf("Error when Note was too long and writing bytes: %v", err)
		}
		return
	}

	valid, err := validator.ValidateStruct(signupData)
	if err != nil || !valid {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	ctx := context.Background()

	loginUserData := db.SignupUser{
		Email:     signupData.Email,
		FirstName: signupData.FirstName,
		LastName:  signupData.LastName,
		// Password: signupData.
		UserType: constants.PatientType,
		// OrganizationID: "",
		// UserID: signupData.
	}

	exists, err := db.IsExistingUser(loginUserData.Email, ctx)
	if err != nil {
		log.Panicf("Error: %v", err) // return should be called here and I think panic does so
	}
	if exists { // If the user actually already exists, it can't be created again
		w.WriteHeader(http.StatusConflict)
		w.Write([]byte("Account with that email already exist"))
		return
	}

	// ----- ADD TO THE PATIENT TABLE AND SHORT ID PATIENT TABLE -----
	longId, shortId, err := db.AddToPatientTable(signupData, ctx)
	if err != nil {
		log.Panicf("Error: %v", err)
	}

	// ----- ADD TO THE USER LOGIN TABLE -----
	loginUserData.UserID = longId
	// Salting and hashing a temporary password (just their shortID)
	loginUserData.Password = tools.ConvertPlainPassword(loginUserData.Email, shortId)

	err = db.AddToUserTable(loginUserData, ctx)
	if err != nil {
		log.Panicf("\nUser was not added to user table, error: %v\n", err)
		return
	}

	// ----- ADD THE PATIENT ID TO THE OBSERVERS LIST OF PATIENTS  -----
	clientCookie, err := cookie.FetchCookie(r)
	if err != nil {
		// This could mean that the cookie is not present so technically not a internal server error, but could be bad request
		log.Printf("Could not fetch cookie, err was: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	user, err := db.GetUserFromCookie(clientCookie, ctx)
	if err != nil {
		log.Printf("Could not fetch user from cookie, err was: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}
	if user == nil {
		log.Printf("Could not fetch user from cookie, err was: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if user.UserType != constants.ObserverType {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}

	log.Printf("Cookie token is now: " + clientCookie.Token + "\nCookie id is now: " + clientCookie.UserID)

	err = db.AddPatientToObserver(clientCookie, loginUserData.UserID, ctx)
	if err != nil {
		log.Printf("Could not add patient to observers list of patients, err was: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.Write([]byte("Patient added!"))
}
