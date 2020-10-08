package main

import (
	"HealthWellnessRemoteMonitoring/internal/RemoteMonitoring"
	"HealthWellnessRemoteMonitoring/internal/tools"
	"fmt"

	"context"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	// "HealthWellnessRemoteMonitoring/internal/tools"
)

func main() {
	// Call main functionality, run app from here

	// fmt.Println("Remote monitoring booting up...")

	// config := db.InitConfig()

	// app, err := db.CreateAppSession(ctx, config)
	// if err != nil {
	// 	log.Fatalf("Couldn't get app, error was %v\n", err)
	// }

	// dBClient, err := db.CreateDatabaseSession(ctx, app)
	// if err != nil {
	// 	log.Fatalf("Couldn't get databaseclient, error was %v\n", err)
	// }

	// fmt.Println("Database client successfully set up!")

	router := mux.NewRouter().StrictSlash(false)
	router.HandleFunc("/debugFunc", DebugHandler).Methods(http.MethodGet)

	// // Debug tools

	log.Printf("\nListening through port %v...\n", RemoteMonitoring.Port)
	// secure false: only when http, don't use in production
	//Csrf := csrf.Protect(securecookie.GenerateRandomKey(32),csrf.Secure(false))
	log.Fatal(http.ListenAndServe(fmt.Sprintf("%s:%d", RemoteMonitoring.ServerAddress, RemoteMonitoring.Port), router))
}

func DebugHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	ctx := context.Background()
	tools.DebugFunctionality(ctx)

	w.Write([]byte("Hello from response writer"))
}
