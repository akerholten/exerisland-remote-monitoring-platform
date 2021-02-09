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
	log.Printf("Got a signup request...")
	defer r.Body.Close()
	if r.Header.Get("Content-Type") != "application/json; charset=utf-8" {
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

	if len(signupData.FirstName) > 100 {
		_, err := w.Write([]byte("FirstName is longer than 100 characters"))
		if err != nil {
			log.Printf("Error when FirstName was too long and writing bytes: %v", err)
		}
		return
	}

	if len(signupData.LastName) > 100 {
		_, err := w.Write([]byte("LastName is longer than 100 characters"))
		if err != nil {
			log.Printf("Error when LastName was too long and writing bytes: %v", err)
		}
		return
	}

	if len(signupData.OrganizationID) > 100 {
		_, err := w.Write([]byte("OrganizationID is longer than 100 characters"))
		if err != nil {
			log.Printf("Error when OrganizationID was too long and writing bytes: %v", err)
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
	if r.Header.Get("Content-Type") != "application/json; charset=utf-8" {
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

	if len(form.Password) < 3 {
		w.WriteHeader(http.StatusUnauthorized)
		_, err := w.Write([]byte("Wrong email or password"))
		if err != nil {
			log.Printf("Error when password was too short and writing bytes: %v", err)
		}
		return
	}

	if len(form.Password) > 100 {
		w.WriteHeader(http.StatusUnauthorized)
		_, err := w.Write([]byte("Wrong email or password"))
		if err != nil {
			log.Printf("Error when password was too long and writing bytes: %v", err)
		}
		return
	}

	if len(form.Email) < 4 {
		w.WriteHeader(http.StatusUnauthorized)
		_, err := w.Write([]byte("Wrong email or password"))
		if err != nil {
			log.Printf("Error when email was too short and writing bytes: %v", err)
		}
		return
	}

	if len(form.Email) > 100 {
		w.WriteHeader(http.StatusUnauthorized)
		_, err := w.Write([]byte("Wrong email or password"))
		if err != nil {
			log.Printf("Error when email was too long and writing bytes: %v", err)
		}
		return
	}

	valid, err := validator.ValidateStruct(form)
	if err != nil || !valid {
		// Hacky fix to allow people to login without using websitedomain email if registered through Unity endpoint
		form.Email = form.Email + "@" + constants.WebsiteDomain

		valid, err = validator.ValidateStruct(form)

		if err != nil || !valid {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}

	ctx := context.Background()

	// Salting and hashing password
	form.Password = tools.ConvertPlainPassword(form.Email, form.Password)

	userInfo, id, err := db.AuthenticateUser(form, ctx)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("Failed"))
		log.Panicf("Error logging in, err: %v", err)
		return
	}

	if userInfo == nil {
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

	// THIS is a bit messy, but keep it for now if it works
	// (issue is that cookie must be encoded on user's end, but decoded on DB end) (a bit weird structure here)

	tempEncodedDbCookie := db.CookieData{
		UserID: id,
		Token:  encodedCookie,
	}

	decodedDbCookie, err := cookie.DecodeCookieData(tempEncodedDbCookie)
	if err != nil {
		log.Printf("Error decoding cookie data, err was: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
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

	err = db.AddToCookieTable(decodedDbCookie, ctx)
	if err != nil {
		log.Printf("Could not add cookie to db table, err was: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	log.Printf("Logged in to user with ID: %s", id)

	w.WriteHeader(http.StatusOK)
	w.Write([]byte(userInfo.UserType))
}

func CookieLoginHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	clientCookie, err := cookie.FetchCookie(r)
	if err != nil {
		// This could mean that the cookie is not present so technically not a internal server error, but could be bad request
		log.Printf("Could not fetch cookie, err was: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	ctx := context.Background()

	err = cookie.AuthenticateCookie(w, clientCookie, ctx)
	if err != nil {
		log.Printf("Could not authenticate cookie, err was: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	// TODO: Potentially return a JSON-object containing some data about the user to use on front-end here
	// such as user type ("observer", "patient"/"user"), names, etc, etc? for now just success

	w.WriteHeader(http.StatusAccepted)
	w.Write([]byte("Success"))
}

func LogoutHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	clientCookie, err := cookie.FetchCookie(r)
	if err != nil {
		// This could mean that the cookie is not present so technically not a internal server error, but could be bad request
		log.Printf("Could not fetch cookie, err was: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	err = cookie.DeleteClientCookie(w, r.URL.Path)
	if err != nil {
		log.Printf("Could not delete client cookie, err was: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	ctx := context.Background()

	err = cookie.AuthenticateCookie(w, clientCookie, ctx)
	if err != nil {
		log.Printf("Could not authenticate client cookie, err was: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	err = db.DeleteCookie(clientCookie.Token, ctx)
	if err != nil {
		log.Printf("Could not delete db cookie with token, err was: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	// TODO: Potentially return a JSON-object containing some data about the user to use on front-end here
	// such as user type ("observer", "patient"/"user"), names, etc, etc? for now just success

	w.WriteHeader(http.StatusAccepted)
	w.Write([]byte("Success"))
}

func VerifyObserverHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	clientCookie, err := cookie.FetchCookie(r)
	if err != nil {
		// This could mean that the cookie is not present so technically not a internal server error, but could be bad request
		log.Printf("Could not fetch cookie, err was: %v", err)
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	ctx := context.Background()

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

	if user.UserType != constants.ObserverType {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}

	w.WriteHeader(http.StatusAccepted)
	w.Write([]byte("Success"))
}

func AuthenticateUserType(r *http.Request, userType string) bool {
	defer r.Body.Close()

	clientCookie, err := cookie.FetchCookie(r)
	if err != nil {
		// This could mean that the cookie is not present so technically not a internal server error, but could be bad request
		log.Printf("Could not fetch cookie, err was: %v", err)
		return false
	}

	ctx := context.Background()

	user, err := db.GetUserFromCookie(clientCookie, ctx)
	if err != nil {
		log.Printf("Could not fetch user from cookie, err was: %v", err)
		return false
	}
	if user == nil {
		log.Printf("Could not fetch user from cookie, err was: %v", err)
		return false
	}

	if user.UserType != userType {
		return false
	}

	return true
}
