package main

import (
	"HealthWellnessRemoteMonitoring/internal/RemoteMonitoring"
	"HealthWellnessRemoteMonitoring/internal/constants"
	"HealthWellnessRemoteMonitoring/internal/handlers"
	"HealthWellnessRemoteMonitoring/internal/tools"
	"fmt"

	"log"
	"net/http"

	"github.com/gorilla/mux"
	// "golang.org/x/crypto/acme/autocert" // For HTTPS in production
)

func main() {
	// Call main functionality, run app from here

	// certManager := autocert.Manager{
	// 	Prompt: autocert.AcceptTOS,
	// 	Cache:  autocert.DirCache("./certs"),
	// }

	// Booting up router
	log.Printf("Setting up http mux router ...\n")
	router := mux.NewRouter().StrictSlash(false)

	// Debug func
	router.HandleFunc("/debugFunc", DebugHandler).Methods(http.MethodGet)

	// Authentication handlers //SignupHandler Below
	router.HandleFunc("/signup", handlers.SignupHandler).Methods(http.MethodPost).Headers("Content-Type", "application/json")
	router.HandleFunc("/manualLogin", handlers.ManualLoginHandler).Methods(http.MethodPost).Headers("Content-Type", "application/json")
	router.HandleFunc("/cookieLogin", NotImplementedHandler).Methods(http.MethodPost).Headers("Content-Type", "application/json")

	// Debug tools

	log.Printf("\nListening through port %v...\n", RemoteMonitoring.Port)

	// server := &http.Server{
	// 	Addr:    ":https",
	// 	Handler: router,
	// 	TLSConfig: &tls.Config{
	// 		GetCertificate: certManager.GetCertificate,
	// 	},
	// }

	// secure false: only when http, don't use in production
	//Csrf := csrf.Protect(securecookie.GenerateRandomKey(32),csrf.Secure(false))

	// go http.ListenAndServe(fmt.Sprintf(":http://%s:%d", RemoteMonitoring.ServerAddress, RemoteMonitoring.Port), certManager.HTTPHandler(nil))
	log.Fatal(http.ListenAndServe(fmt.Sprintf("%s:%d", RemoteMonitoring.ServerAddress, RemoteMonitoring.Port), router))
	// log.Fatal(server.ListenAndServeTLS("", ""))
}

func DebugHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	// ctx := context.Background()
	// DebugFunctionality(ctx)
	log.Printf("Unique short ID: %s", tools.GetNewShortUniqueID(constants.PatientShortIDLength))

	longId, err := tools.GetNewLongUniqueID(0)
	if err != nil {
		log.Panicf("Error: %v", err)
	}

	log.Printf("Unique short ID: %s", longId)

	w.Write([]byte("Hello from response writer"))
}

func NotImplementedHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	w.WriteHeader(http.StatusNoContent)
	w.Write([]byte("Method not implemented yet"))
}
