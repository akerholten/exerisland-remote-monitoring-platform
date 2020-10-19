package cookie

import (
	"HealthWellnessRemoteMonitoring/internal/constants"
	"HealthWellnessRemoteMonitoring/internal/db"
	"HealthWellnessRemoteMonitoring/internal/tools"
	"context"
	"errors"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"time"

	"github.com/gorilla/securecookie"
)

type RMCookieManager struct {
	secureCookieInstance *securecookie.SecureCookie
}

// Singleton setup
var (
	manager *RMCookieManager
)

func CookieManager() *RMCookieManager {
	if manager == nil {
		// ctx := context.Background()

		manager = InitNewManager()
	}
	return manager
}

func InitNewManager() *RMCookieManager {
	var manager RMCookieManager

	// Might use some persistent hash and block keys here later? for persistent cookie verification
	// this will create new instance everytime the server reboots etc as of now (redendering previous cookies useless)
	// That again might be a security measurement so yeah
	log.Printf("Initializing new cookie manager ...")
	manager.secureCookieInstance = securecookie.New(securecookie.GenerateRandomKey(32), securecookie.GenerateRandomKey(32))

	return &manager
}

// FetchCookie retrieves the client cookie and decodes its content.
// Returns the decoded data and an error
func FetchCookie(r *http.Request) (db.CookieData, error) {

	cookieData := db.CookieData{}

	cookie, err := r.Cookie(constants.CookieName)
	if err != nil {
		return cookieData, err
	}
	err = CookieManager().secureCookieInstance.Decode(constants.CookieName, cookie.Value, &cookieData)
	if err != nil {
		return cookieData, err
	}

	return cookieData, nil
}

// CreateCookie creates a client cookie with login credentials and encodes it
// encoded data will be returned as string as well as set in http
func CreateCookie(w http.ResponseWriter, id string, urlString string) (string, error) {
	timeCreated := time.Now().UnixNano()
	token := tools.CreateHash(string(timeCreated) + id)
	userID := id

	u, err := url.Parse(urlString)
	if err != nil {
		return "", err
	}
	cookieData := db.CookieData{
		UserID: userID,
		Token:  token,
	}
	// Checks that err == nil such that nothing went wrong
	if encoded, err := CookieManager().secureCookieInstance.Encode(constants.CookieName, cookieData); err == nil {
		tokenCookie := http.Cookie{
			Name:     constants.CookieName,
			Value:    encoded,
			Domain:   u.Hostname(),
			Expires:  time.Now().Add(constants.CookieExpiration),
			Secure:   false, // TODO: Should this be true? maybe? // WAS false
			HttpOnly: true,
		}

		http.SetCookie(w, &tokenCookie)
		return encoded, nil
	}
	return "", errors.New("Could not create cookie")
}

// DeleteClientCookie deletes(overwrites) client cookie. Returns error if it failed
func DeleteClientCookie(w http.ResponseWriter, urlString string) error {
	u, err := url.Parse(urlString)
	if err != nil {
		// errors.New("error at url parse error: %+v", err)
		return err
	}
	cookieData := db.CookieData{
		UserID: "",
		Token:  "",
	}
	if encoded, err := CookieManager().secureCookieInstance.Encode(constants.CookieName, cookieData); err == nil {
		tokenCookie := http.Cookie{
			Name:     constants.CookieName,
			Value:    encoded,
			Domain:   u.Hostname(),
			Expires:  time.Now(),
			Secure:   false,
			HttpOnly: false,
		}

		http.SetCookie(w, &tokenCookie)
		return nil
	}
	return errors.New("Failed to delete client cookie")
}

// DeleteDBCookie deletes all cookies with same user id as sent cookie
// Returns error if failed
func DeleteDBCookie(clientCookie db.CookieData, ctx context.Context) error {
	if len(clientCookie.Token) <= 0 {
		return errors.New("Invalid token in cookie")
	}
	encodedDbCookie, err := db.GetCookie(clientCookie, ctx)
	if err != nil {
		log.Panicf("Something went wrong getting cookie, err: %v", err)
	}

	dbData, err := DecodeCookieData(*encodedDbCookie)
	if err != nil {
		log.Panicf("Something went wrong decoding cookie, err: %v", err)
	}

	if dbData != clientCookie {
		return fmt.Errorf("clientCookie did not match db")
	}
	db.DeleteCookie(dbData.UserID, ctx)
	return nil
}

// DecodeDBCookieData decodes cookie data
// Returns decoded cookie data if success
func DecodeCookieData(data db.CookieData) (db.CookieData, error) {
	decodeData := db.CookieData{}

	err := CookieManager().secureCookieInstance.Decode(constants.CookieName, data.Token, &decodeData)
	if err != nil {
		return db.CookieData{}, err
	}

	return decodeData, nil
}

// AuthenticateCookie checks client cookie towards db cookie to validate the client cookie
// Returns an error if authentication failed
func AuthenticateCookie(w http.ResponseWriter, clientCookie db.CookieData, ctx context.Context) error {
	if len(clientCookie.Token) <= 0 {
		return errors.New("Invalid token in cookie")
	}

	// GetCookie will return nil if the cookie does not exist
	dbCookie, err := db.GetCookie(clientCookie, ctx)
	if err != nil {
		log.Panicf("Something went wrong getting cookie, err: %v", err)
	}

	// If not authenticated
	if dbCookie == nil {
		return errors.New("clientCookie did not match db")
	}

	// Everything went alright, successfully authenticated, so we return nil
	return nil
}
