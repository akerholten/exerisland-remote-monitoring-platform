package db

import (
	"context"
	"fmt"
	"time"

	firebase "firebase.google.com/go"
	firebaseDB "firebase.google.com/go/db"
)

// DATABASE Tables
const (

	// Observer ...
	TableObserver = "observer"
	// User ...
	TableUser = "user"
	// User ...
	TableMinigame = "minigame"
)

// COOKIE Const
const (
	// CookieName ...
	CookieName = "HealthWellnessMonitoring"
	// CookieExpiration ...
	CookieExpiration = time.Hour * 24 * 7
)

type Database interface {
	InitConfig()                                                  // Firebase config setup and return?
	CreateAppSession(ctx context.Context, config firebase.Config) // Create the app session connection with firebase (might possibly also need firebaseconfig)
	CreateDatabaseSession(ctx context.Context, app firebase.App)

	// ----- Authentication API -----
	AuthenticateUser(user interface{})  // Basically login
	AuthenticateAdmin(user interface{}) // Basically verify that it is an admin
	GetCookie(cookie interface{})
	DeleteCookie(cookieId string)

	// ----- Unity Game API ----- //@TODO: Replace interfaces with proper structs that is defined?
	// need to identify the user through some ID that gets created on front-end when added as patient
	GetRecommendation(id int)
	GetRecommendations()

	PostSession(session interface{}) // The user ID also must be sent? (questionmark)
	PostActivity(sessionId int, activity interface{})
	PostMetric(sessionId int, activityId int, metric interface{})

	UpdateRecommendation(recommendationId int, recommendation interface{})
	UpdateSession(sessionId int, session interface{})

	// ----- WEB Front-end API -----
	GetObserver()
	GetPatient(patientId string)
	GetPatients() // Patients that the observer can access
	GetSession(patientId string, sessionId int)
	GetSessions(patientId string)
	// These below might be redundant as it is already contained in session?
	GetActivity(patientId string, sessionId int, activityId int) // Can potentially send session{} interface in here? or this might be redundant
	GetActivities(patientId string, sessionId int)
	GetMetric(patientId string, sessionId int, activityId int, metricId int)
	GetMetrics(patientId string, sessionId int, activityId int)
	GetMinigame(minigameId int)
	GetMinigames()
	// GetRecommendation(patientId string, recommendationId int) // Duplicate method? wut
	// GetRecommendations(patientId string) // Duplicate method? wut

	PostObserver(observer interface{})
	PostPatient(patient interface{})
	PostRecommendation(patientId string, recommendation interface{})

	AddPatientToObserver(observerId string, patientId string)

	RemoveObserver(observerId string)                            // remove == set a bool as not active (not actually remove)
	RemovePatient(patientId string)                              // remove == set a bool as not active (not actually remove)
	RemoveRecommendation(patientId string, recommendationId int) // remove == set a bool as not active (not actually remove)

	// ----- Admin API? -----
	PostMinigame(minigame interface{})
	UpdateMinigame(minigameId int, minigame interface{})
	RemoveMinigame(minigameId int) // remove == set a bool as not active (not actually remove)
}

func InitConfig() *firebase.Config {
	fmt.Println("Setting up config for firebase...")

	config := &firebase.Config{
		DatabaseURL: "https://vr-health-remotemonitoring.firebaseio.com/", // TODO: move to static global variable?
	}
	return config
}

func CreateAppSession(ctx context.Context, config *firebase.Config) (*firebase.App, error) {
	fmt.Println("Dialing firebase for app session...")

	app, err := firebase.NewApp(ctx, config)
	if err != nil {
		return nil, err
	}

	return app, nil
}

func CreateDatabaseSession(ctx context.Context, app *firebase.App) (*firebaseDB.Client, error) {
	fmt.Println("Dialing firebase for database client session...")

	dB, err := app.Database(ctx)
	if err != nil {
		return nil, err
	}

	return dB, nil
}
