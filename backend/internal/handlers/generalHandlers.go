package handlers

import (
	"HealthWellnessRemoteMonitoring/internal/db"
	"encoding/json"
	"log"
	"net/http"
)

func GetMinigamesHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("Got a request for getting minigames list ...")
	defer r.Body.Close()

	// ctx := context.Background()

	// TODO: Possibly some authentication? Probably not needed though

	// Get patients based on ID
	minigames := db.GetMinigames()
	// if err != nil {
	// 	log.Printf("Could not fetch patient from this user, err was: %v", err)
	// 	w.WriteHeader(http.StatusInternalServerError)
	// 	return
	// }

	// Marshal it into json and return
	minigamesJson, err := json.Marshal(minigames)
	if err != nil {
		log.Printf("Could not marshal minigames before return, err was: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	w.Write(minigamesJson)
}
