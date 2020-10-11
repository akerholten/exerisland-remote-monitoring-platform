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

func SignupHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	if r.Header.Get("Content-Type") != "application/json" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	var signupData db.SignupUser

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

	if len(signupData.Password) < 8 {
		_, err := w.Write([]byte("Password is shorter than 8 characters"))
		if err != nil {
			log.Printf("Error when password was too short and writing bytes: %v", err)
		}
		return
	}

	if len(signupData.Password) > 100 {
		_, err := w.Write([]byte("Password is longer than 100 characters"))
		if err != nil {
			log.Printf("Error when password was too long and writing bytes: %v", err)
		}
		return
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

	valid, err := validator.ValidateStruct(signupData)
	if err != nil || !valid {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	ctx := context.Background()

	exists, err := db.IsExistingUser(signupData.Email, ctx)
	if err != nil {
		log.Panicf("Error: %v", err) // return should be called here and I think panic does so
	}
	if exists { // If the user actually already exists, it can't be created again
		w.WriteHeader(http.StatusConflict)
		w.Write([]byte("Account with that email already exist"))
		return
	}

	// Salting and hashing password
	signupData.Password = tools.ConvertPlainPassword(signupData.Email, signupData.Password)

	if signupData.UserType == constants.ObserverType {
		longId, err := db.AddToObserverTable(signupData, ctx)
		if err != nil {
			log.Panicf("Error: %v", err)
		}
		signupData.UserID = longId

		err = db.AddToUserTable(signupData, ctx)
		if err != nil {
			log.Panicf("\nUser was not added to user table, error: %v\n", err)
		}
	}
	// else if signupData.UserType == constants.PatientType {
	// @TODO: Do same as above but with patient interface
	// }

	// tools.DebugFunctionality(ctx)
	// log.Printf("Unique short ID: %s", tools.GetNewShortUniqueID(constants.PatientShortIDLength))

	// longId, err := tools.GetNewLongUniqueID()
	// if err != nil {
	// 	log.Panicf("Error: %v", err)
	// }

	// log.Printf("Unique short ID: %s", longId)

	w.Write([]byte("User added!"))
}

func ManualLoginHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	if r.Header.Get("Content-Type") != "application/json" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	var form db.LoginForm

	respBody, err := ioutil.ReadAll(r.Body)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	err = json.Unmarshal(respBody, &form)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		log.Printf("Error unmarshaling: %s, error: %v", string(respBody), err)
	}

	if len(form.Password) < 8 {
		_, err := w.Write([]byte("Wrong email or password"))
		if err != nil {
			log.Printf("Error when password was too short and writing bytes: %v", err)
		}
		return
	}

	if len(form.Password) > 100 {
		_, err := w.Write([]byte("Wrong email or password"))
		if err != nil {
			log.Printf("Error when password was too long and writing bytes: %v", err)
		}
		return
	}

	if len(form.Email) < 8 {
		_, err := w.Write([]byte("Wrong email or password"))
		if err != nil {
			log.Printf("Error when email was too short and writing bytes: %v", err)
		}
		return
	}

	if len(form.Email) > 100 {
		_, err := w.Write([]byte("Wrong email or password"))
		if err != nil {
			log.Printf("Error when email was too long and writing bytes: %v", err)
		}
		return
	}

	valid, err := validator.ValidateStruct(form)
	if err != nil || !valid {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	ctx := context.Background()

	// Salting and hashing password
	form.Password = tools.ConvertPlainPassword(form.Email, form.Password)

	authenticated, id, err := db.AuthenticateUser(form, ctx)

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("Failed"))
		log.Panicf("Error logging in, err: %v", err)
		return
	}

	if !authenticated {
		w.WriteHeader(http.StatusNotFound)
		w.Write([]byte("Failed"))
		return
	}

	// TODO: Create cookie here (on client, and store on DB, delete old cookies on same hardware) and that links to the users ID
	encodedCookie, err := cookie.CreateCookie(w, id, r.URL.Path)
	if err != nil {
		log.Printf("Could not create cookie, err was: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	dbCookie := db.CookieData{
		UserID: id,
		Token:  encodedCookie,
	}

	// TODO: only delete cookies that are related to the specific hardware of the user
	// currently it will log out from all other instances when logging in to a new instance on new hardware/computer
	// TODO: possibly this could even be temporarily removed and that would be okay for now
	err = db.DeleteAllUserCookies(id, ctx)
	if err != nil {
		log.Printf("Could not delete user cookies, err was: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	log.Printf("Logged in to user with ID: %s", id)

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Success"))
}
