package db

import (
	"HealthWellnessRemoteMonitoring/internal/constants"
	"HealthWellnessRemoteMonitoring/internal/tools"
	"context"
	"errors"
	"fmt"
	"log"

	firebaseDB "firebase.google.com/go/db"
)

type Patient struct {
	FirstName string    `json:"firstName" valid:"printableascii, required"`
	LastName  string    `json:"lastName" valid:"printableascii, required"`
	Email     string    `json:"email" valid:"email, required"`
	BirthDate string    `json:"birthDate" valid:"printableascii, optional"`
	Note      string    `json:"note" valid:"printableascii, optional"`
	ShortID   string    `json:"shortID" valid:"alphanum, optional"`
	Sessions  []Session `json:"sessions" valid:"-"`
	// Activites       []Activity       `json:"activities" valid:"-"`
	Recommendations []Recommendation `json:"recommendations" valid:"-"`
}

type PatientShortIDTableEntry struct {
	PatientID string `json:"patientID" valid:"alphanum, optional"`
}

type PatientSignupData struct {
	FirstName string `json:"firstName" valid:"printableascii, required"`
	LastName  string `json:"lastName" valid:"printableascii, required"`
	Email     string `json:"email" valid:"email, required"`
	BirthDate string `json:"birthDate" valid:"printableascii, required"`
	Note      string `json:"note" valid:"printableascii, optional"`
}

type Session struct {
	Duration   string     `json:"duration" valid:"printableascii, optional"`  // time thing? ISO8601 string
	CreatedAt  string     `json:"createdAt" valid:"printableascii, optional"` // timestamp ISO8601 string
	Activities []Activity `json:"activities" valid:"-"`                       // possibly stored as Activity IDs ?
}

type Activity struct {
	MinigameID string   `json:"minigameID" valid:"alphanum, required"`
	Metrics    []Metric `json:"metrics" valid:"-"`
}

type Metric struct {
	Name  string `json:"firstName" valid:"alphanum, required"`
	Value string `json:"value" valid:"alphanum, required"`
	Unit  string `json:"unit" valid:"alphanum, optional"`
}

type Recommendation struct {
	ObserverID  string   `json:"observerID" valid:"alphanum, required"` // Which observer who authored the recommendation
	MinigameID  string   `json:"minigameID" valid:"alphanum, required"`
	Goals       []Metric `json:"goals" valid:"-"`
	Results     []Metric `json:"results" valid:"-"`
	CompletedAt string   `json:"completedAt" valid:"integer, optional"` // timestamp
	Deadline    string   `json:"deadline" valid:"integer, optional"`    // timestamp
	Status      string   `json:"status" valid:"alphanum, optional"`     // "In Progress", "Not Started", "Completed", "Expired"
	Activities  []string `json:"activities" valid:"-"`                  // Activities linked to completing this recommendation
}

func AddToPatientTable(user PatientSignupData, ctx context.Context) (string, string, error) {

	// TODO: Implement similarly to observerInterface adding to observertable
	// But also add other stuff here, like the shortID
	log.Printf("Adding new user with mail: %s ...\n", user.Email)
	patient := Patient{
		FirstName: user.FirstName,
		LastName:  user.LastName,
		Email:     user.Email,
		BirthDate: user.BirthDate,
		Note:      user.Note,
		// ShortID: user.
		// Sessions: user.
		// Recommendations: user.
	}

	// ----- GENERATE LONG ID -----
	patientTable := DBClient().Database.NewRef(TablePatient)

	i := 0
	var newKey string
	var err error
	for {
		newKey, err = tools.GetNewLongUniqueID(i) // Comment out when done debugging
		if err != nil {
			log.Panicf("Error: %v", err)
			return "", "", err
		}

		// Check if the ID already exist in database
		newTableEntry := patientTable.Child(newKey)

		var existPatient Patient

		err = newTableEntry.Get(ctx, &existPatient)
		if err != nil {
			return "", "", err
		}

		// If it doesn't exist, we can safely create it so we break loop
		if len(existPatient.FirstName) <= 1 {
			break
		}

		i++

		if i == 5 {
			return "", "", fmt.Errorf("\nCould not fill Patient DB with new object, looped through %d times\n", i)
		}
	}

	// ----- GENERATE SHORT ID -----
	patientShortIdTable := DBClient().Database.NewRef(TablePatientShortID)

	i = 0
	var newShortKey string
	for {
		newShortKey = tools.GetNewShortUniqueID(constants.PatientShortIDLength, int64(i)) // Comment out when done debugging
		if err != nil {
			log.Panicf("Error: %v", err)
			return "", "", err
		}

		// Check if the ID already exist in database
		newTableEntry := patientShortIdTable.Child(newShortKey)

		var existPatient PatientShortIDTableEntry

		err = newTableEntry.Get(ctx, &existPatient)
		if err != nil {
			return "", "", err
		}

		// If it doesn't exist, we can safely create it so we break loop
		if len(existPatient.PatientID) <= 1 {
			break
		}

		i++

		if i == 5 {
			return "", "", fmt.Errorf("\nCould not fill Patient Short ID table DB with new object, looped through %d times\n", i)
		}
	}

	patient.ShortID = newShortKey

	err = patientTable.Child(newKey).Set(ctx, patient)
	if err != nil {
		log.Panicf("Error when setting new data %v", err)
		return "", "", err
	}

	patientShortIDEntry := PatientShortIDTableEntry{
		PatientID: newKey,
	}

	err = patientShortIdTable.Child(newShortKey).Set(ctx, patientShortIDEntry)
	if err != nil {
		log.Panicf("Error when setting new data %v", err)
		return "", "", err
	}

	// Everything went okay
	log.Printf("New patient added at key %s", newKey)
	return newKey, newShortKey, nil
}

func GetPatientInfoFromId(userId string, ctx context.Context) (*Patient, error) {
	var patient Patient

	patientInfoRef := DBClient().Database.NewRef(TablePatient).Child(userId)

	err := patientInfoRef.Get(ctx, &patient)
	if err != nil {
		return nil, err
	}
	if len(patient.Email) < 1 {
		return nil, errors.New("Could not find patient")
	}

	// Retrieving and filling sessions / activities data
	tempSessions, err := getPatientSessions(patientInfoRef, ctx)
	if err != nil {
		return nil, err
	}

	patient.Sessions = *tempSessions

	// TODO: Fill the rest of the data, recommendations, sessions, activites, and so on

	// Everything went ok so we return patient and nil
	return &patient, nil
}

func getPatientSessions(patientRef *firebaseDB.Ref, ctx context.Context) (*[]Session, error) {
	var sessions []Session

	results, err := patientRef.Child(TableSessions).OrderByKey().GetOrdered(ctx)
	if err != nil {
		return nil, err
	}

	for _, r := range results {
		var currentSession Session

		if err := r.Unmarshal(&currentSession); err != nil {
			return &sessions, err
		}
		if len(currentSession.CreatedAt) < 1 {
			log.Printf("Skipping this session, because CreatedAt was not set to anything, most likely invalid")
			continue
		}

		tempActivities, err := getPatientActivities(patientRef, r.Key(), ctx)
		if err != nil {
			return &sessions, err
		}

		currentSession.Activities = *tempActivities

		sessions = append(sessions, currentSession)
	}

	return &sessions, nil
}

func getPatientActivities(patientRef *firebaseDB.Ref, sessionKey string, ctx context.Context) (*[]Activity, error) {
	var activities []Activity

	results, err := patientRef.Child(TableSessions).Child(sessionKey).Child("activities").OrderByKey().GetOrdered(ctx)
	if err != nil {
		return nil, err
	}

	for _, r := range results {
		var id string

		if err := r.Unmarshal(&id); err != nil {
			return &activities, err
		}

		currentActivity, err := getPatientActivity(patientRef, id, ctx)
		if err != nil {
			return nil, err
		}
		if currentActivity == nil {
			continue
		}

		activities = append(activities, *currentActivity)
	}

	return &activities, nil
}

func getPatientActivity(patientRef *firebaseDB.Ref, activityKey string, ctx context.Context) (*Activity, error) {
	var activity Activity

	err := patientRef.Child(TableActivities).Child(activityKey).Get(ctx, &activity)
	if err != nil {
		return nil, err
	}
	if len(activity.MinigameID) < 1 {
		log.Printf("This activity's minigameId was invalid, meaning the activity most likely is invalid, skipping")
		return nil, nil
	}

	// Retrieving metrics from this specific activity
	tempMetrics, err := getMetrics(patientRef.Child(TableActivities).Child(activityKey).Child("metrics"), ctx)
	if err != nil {
		return &activity, err
	}

	activity.Metrics = *tempMetrics

	return &activity, nil
}

func getMetrics(metricsRef *firebaseDB.Ref, ctx context.Context) (*[]Metric, error) {
	var metrics []Metric

	metricsInTable, err := metricsRef.OrderByKey().GetOrdered(ctx)
	if err != nil {
		return nil, err
	}

	for _, r := range metricsInTable {
		var tempMetric Metric

		if err := r.Unmarshal(&tempMetric); err != nil {
			return &metrics, err
		}
		if len(tempMetric.Name) < 1 {
			continue
		}

		metrics = append(metrics, tempMetric)
	}

	return &metrics, nil
}
