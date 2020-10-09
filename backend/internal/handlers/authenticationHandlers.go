package handlers

import (
	"HealthWellnessRemoteMonitoring/internal/constants"
	"HealthWellnessRemoteMonitoring/internal/db"
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
