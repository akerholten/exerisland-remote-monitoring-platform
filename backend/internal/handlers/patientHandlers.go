package handlers

import (
	"HealthWellnessRemoteMonitoring/internal/constants"
	"HealthWellnessRemoteMonitoring/internal/cookie"
	"HealthWellnessRemoteMonitoring/internal/db"
	"context"
	"encoding/json"
	"log"
	"net/http"
)

func GetPersonalInfoHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("Got a request for personal info from a patient ...")
	defer r.Body.Close()

	ctx := context.Background()

	// Authentication ...
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
	if user.UserType != constants.PatientType {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}

	// Get patients based on ID
	patient, err := db.GetPatientInfoFromId(user.UserID, ctx)
	if err != nil {
		log.Printf("Could not fetch patient from this user, err was: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	// Marshal it into json and return
	patientJson, err := json.Marshal(patient)
	if err != nil {
		log.Printf("Could not marshal patient from this user before return, err was: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write(patientJson)
}
