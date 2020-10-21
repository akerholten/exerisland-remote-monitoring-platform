package main

import (
	"HealthWellnessRemoteMonitoring/internal/RemoteMonitoring"
	"HealthWellnessRemoteMonitoring/internal/constants"
	"HealthWellnessRemoteMonitoring/internal/handlers"
	"HealthWellnessRemoteMonitoring/internal/tools"
	"fmt"
	"os"

	"log"
	"net/http"

	gorillaHandlers "github.com/gorilla/handlers"
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

	// Setting up CORS settings
	// see https://stackoverflow.com/questions/40985920/making-golang-gorilla-cors-handler-work
	// RemoteMonitoring_ORIGIN_ALLOWED is like `scheme://dns[:port]`, or `*` (insecure)

	log.Printf("Origin allowed is: %s", os.Getenv("RemoteMonitoring_ORIGIN_ALLOWED"))
	headersOk := gorillaHandlers.AllowedHeaders([]string{"X-Requested-With", "Content-Type", "Authorization", "Access-Control-Allow-Credentials", "Access-Control-Allow-Origin"})
	originsOk := gorillaHandlers.AllowedOrigins([]string{os.Getenv("RemoteMonitoring_ORIGIN_ALLOWED"), "http://localhost:3000"}) //os.Getenv("RemoteMonitoring_ORIGIN_ALLOWED")
	allowCreds := gorillaHandlers.AllowCredentials()
	methodsOk := gorillaHandlers.AllowedMethods([]string{"GET", "HEAD", "POST", "PUT", "OPTIONS"})
	// exposedHeaders := gorillaHandlers.ExposedHeaders([]string{"*"})

	// Debug func
	router.HandleFunc("/debugFunc", DebugHandler).Methods(http.MethodGet)

	// Authentication handlers //SignupHandler Below
	router.HandleFunc("/signup", handlers.SignupHandler).Methods(http.MethodPost).Headers("Content-Type", "application/json; charset=utf-8") // TODO: regexp for more content-types to be accepted
	router.HandleFunc("/manualLogin", handlers.ManualLoginHandler).Methods(http.MethodPost).Headers("Content-Type", "application/json; charset=utf-8")
	router.HandleFunc("/logout", handlers.LogoutHandler).Methods(http.MethodPost)
	router.HandleFunc("/cookieLogin", handlers.CookieLoginHandler).Methods(http.MethodPost)
	router.HandleFunc("/verifyObserver", handlers.VerifyObserverHandler).Methods(http.MethodPost)

	// Observer handlers
	router.HandleFunc("/addPatient", handlers.AddPatientHandler).Methods(http.MethodPost).Headers("Content-Type", "application/json; charset=utf-8")
	router.HandleFunc("/getAllPatients", handlers.GetPatientsHandler).Methods(http.MethodGet)

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
	log.Fatal(http.ListenAndServe(fmt.Sprintf("%s:%d", RemoteMonitoring.ServerAddress, RemoteMonitoring.Port), gorillaHandlers.CORS(originsOk, headersOk, methodsOk, allowCreds)(router)))
	// log.Fatal(server.ListenAndServeTLS("", ""))
}

func DebugHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()
	// ctx := context.Background()
	// DebugFunctionality(ctx)
	log.Printf("Unique short ID: %s", tools.GetNewShortUniqueID(0, int64(constants.PatientShortIDLength)))

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
