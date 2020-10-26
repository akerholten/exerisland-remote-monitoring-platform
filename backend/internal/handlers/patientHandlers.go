package handlers

import (
	"HealthWellnessRemoteMonitoring/internal/constants"
	"HealthWellnessRemoteMonitoring/internal/cookie"
	"HealthWellnessRemoteMonitoring/internal/db"
	"context"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"time"
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

func UploadSession(w http.ResponseWriter, r *http.Request) {
	log.Printf("Got a request for uploading session from a patient ...")
	defer r.Body.Close()

	ctx := context.Background()

	// Authentication ...
	shortId := r.Header.Get("Personal-ID")

	if shortId == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Unsuccessful"))
		return
	}

	userId, err := db.GetUserIdFromShortId(shortId, ctx)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Unsuccessful"))
		return
	}

	var session db.Session

	respBody, err := ioutil.ReadAll(r.Body)
	if err != nil {
		w.WriteHeader(http.StatusForbidden)
		return
	}

	err = json.Unmarshal(respBody, &session)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		log.Printf("Error unmarshaling: %s, error: %v", string(respBody), err)
		return
	}
	if len(session.Duration) < 1 {
		_, err := w.Write([]byte("Duration in session upload invalid"))
		if err != nil {
			log.Printf("Error when duration was invalid and writing bytes: %v", err)
		}
		return
	}

	session.CreatedAt = time.Now().Format(time.RFC3339)

	err = db.AddSessionToPatient(*userId, session, ctx)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write([]byte("Success"))
}
