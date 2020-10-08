package main

import (
	"HealthWellnessRemoteMonitoring/internal/tools"
	"context"
	"net/http"
	// "HealthWellnessRemoteMonitoring/internal/tools"
)

func main() {
	// Call main functionality, run app from here

	ctx := context.Background()
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

	// router := mux.NewRouter().StrictSlash(false)
	// router.HandleFunc("/cookielogin", CookieLoginHandler).Methods(http.MethodPost)

	// // Debug tools
	tools.DebugFunctionality(ctx)

}

func DebugHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

}
