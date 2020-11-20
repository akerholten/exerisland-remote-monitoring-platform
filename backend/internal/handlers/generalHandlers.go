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

	// Get static list of minigames
	minigames := db.GetMinigames()

	// Marshal into json
	minigamesJson, err := json.Marshal(minigames)
	if err != nil {
		log.Printf("Could not marshal minigames before return, err was: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	// Everything went ok, return minigames list as json
	w.WriteHeader(http.StatusOK)
	w.Write(minigamesJson)
}
