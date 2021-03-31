package db

import (
	"HealthWellnessRemoteMonitoring/internal/constants"
	"HealthWellnessRemoteMonitoring/internal/tools"
	"context"
	"errors"
	"fmt"
	"log"
	"time"

	firebaseDB "firebase.google.com/go/db"
)

type SimplePatientData struct {
	FirstName          string `json:"firstName" valid:"printableascii, required"`
	LastName           string `json:"lastName" valid:"printableascii, required"`
	Email              string `json:"email" valid:"email, required"`
	BirthDate          string `json:"birthDate" valid:"printableascii, optional"`
	Note               string `json:"note" valid:"printableascii, optional"`
	ShortID            string `json:"shortID" valid:"alphanum, optional"`
	RecentActivityDate string `json:"recentActivityDate" valid:"printableascii, optional"`
}

type Patient struct {
	FirstName          string    `json:"firstName" valid:"printableascii, required"`
	LastName           string    `json:"lastName" valid:"printableascii, required"`
	Email              string    `json:"email" valid:"email, required"`
	BirthDate          string    `json:"birthDate" valid:"printableascii, optional"`
	Note               string    `json:"note" valid:"printableascii, optional"`
	ShortID            string    `json:"shortID" valid:"alphanum, optional"`
	RecentActivityDate string    `json:"recentActivityDate" valid:"printableascii, optional"`
	Sessions           []Session `json:"sessions,omitempty" valid:",optional"`
	// Activites       []Activity       `json:"activities" valid:"-"`
	Recommendations []Recommendation `json:"recommendations,omitempty" valid:",optional"`
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
	Id         int        `json:"id" valid:"integer, optional"`
	Duration   string     `json:"duration" valid:"printableascii, optional"`  // time thing? ISO8601 string
	CreatedAt  string     `json:"createdAt" valid:"printableascii, optional"` // timestamp ISO8601 string
	Activities []Activity `json:"activities,omitempty" valid:",optional"`     // possibly stored as Activity IDs ?
}

// type UploadSession struct {
// 	ShortID        string  `json:"shortID" valid:"alphanum, optional"`
// 	CurrentSession Session `json:"session" valid:"-"`
// }

type Activity struct {
	MinigameID string   `json:"minigameID" valid:"alphanum, required"`
	Metrics    []Metric `json:"metrics,omitempty" valid:",optional"`
}

type Metric struct {
	Id    string `json:"id" valid:"alphanum, required"`
	Name  string `json:"name" valid:"alphanum, required"`
	Value int    `json:"value" valid:"integer, required"`
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
	SessionIDs  []string `json:"sessionIDs" valid:"-"`                  // Session linked to completing this recommendation (might not be needed)
}

func AddToPatientTableWithoutData(ctx context.Context) (string, string, error) {

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

		if i == 30 {
			return "", "", fmt.Errorf("\nCould not fill Patient Short ID table DB with new object, looped through %d times\n", i)
		}
	}

	// Set user data to generated short ID
	patient := Patient{
		FirstName: "User",
		LastName:  newShortKey,
		Email:     newShortKey + "@" + constants.WebsiteDomain,
		BirthDate: time.Now().Format(time.RFC3339),
		Note:      newShortKey,
		ShortID:   newShortKey,
		// Sessions: user.
		// Recommendations: user.
	}

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

		if i == 30 {
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
	// This function has to retrieve a "simpler" struct type, that does not contain any
	// arrays, as they caused problems with unmarshalling from the side of firebaseDB.Get(ctx, &patient)
	var simplePatientData SimplePatientData

	patientInfoRef := DBClient().Database.NewRef(TablePatient).Child(userId)

	err := patientInfoRef.Get(ctx, &simplePatientData)
	if err != nil {
		return nil, err
	}
	if len(simplePatientData.Email) < 1 {
		return nil, errors.New("Could not find patient")
	}

	patient := Patient{
		FirstName:          simplePatientData.FirstName,
		LastName:           simplePatientData.LastName,
		Email:              simplePatientData.Email,
		BirthDate:          simplePatientData.BirthDate,
		Note:               simplePatientData.Note,
		ShortID:            simplePatientData.ShortID,
		RecentActivityDate: simplePatientData.RecentActivityDate,
	}

	// Retrieving and filling sessions / activities data
	tempSessions, err := getPatientSessions(patientInfoRef, ctx)
	if err != nil {
		return nil, err
	}

	patient.Sessions = *tempSessions

	// TODO: Fill the rest of the data, recommendations, and so on

	// Everything went ok so we return patient and nil
	return &patient, nil
}

func AddSessionToPatient(userId string, session Session, ctx context.Context) (string, error) {
	patientRef := DBClient().Database.NewRef(TablePatient).Child(userId)
	err := patientRef.Child("recentActivityDate").Set(ctx, time.Now().Format(time.RFC3339))
	if err != nil {
		return "", err
	}

	patientSessionsRef := patientRef.Child(TableSessions)

	sessionRef, err := patientSessionsRef.Push(ctx, session)
	if err != nil {
		return "", err
	}

	// For retrieving length of existing sessions
	existingSessions, err := patientRef.Child(TableSessions).OrderByKey().GetOrdered(ctx)
	if err != nil {
		return "", err
	}

	// Set the ID so that it can be received from front-end
	// The ID will always be the index + 1, so it starts from 1
	err = sessionRef.Child("id").Set(ctx, len(existingSessions))
	if err != nil {
		return "", err
	}

	log.Print("Added a new thing at " + sessionRef.Key)
	// TODO: Possibly need to use sessionRef for filling in activity array within?

	return sessionRef.Key, nil
}

func UpdateSessionOnPatient(userId string, sessionID string, session Session, ctx context.Context) error {
	patientRef := DBClient().Database.NewRef(TablePatient).Child(userId)
	err := patientRef.Child("recentActivityDate").Set(ctx, time.Now().Format(time.RFC3339))
	if err != nil {
		return err
	}

	patientSessionRef := patientRef.Child(TableSessions).Child(sessionID)

	// to keep the id of where it is
	var countedID int
	patientSessionRef.Child("id").Get(ctx, &countedID)

	err = patientSessionRef.Set(ctx, session) //.Push(ctx, session)
	if err != nil {
		return err
	}

	// For retrieving length of existing sessions
	// existingSessions, err := patientRef.Child(TableSessions).OrderByKey().GetOrdered(ctx)
	// if err != nil {
	// 	return err
	// }

	// Set the ID so that it can be received from front-end
	// The ID will always be the index + 1, so it starts from 1
	err = patientSessionRef.Child("id").Set(ctx, countedID)
	if err != nil {
		return err
	}

	log.Print("Updated a thing at " + patientSessionRef.Key)
	// TODO: Possibly need to use sessionRef for filling in activity array within?

	return nil
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

		// Ehm... System.Obsolete()..... this is not required.. it works right out of the box somehow....
		// although other array things in firebase did not work, this seem to work
		// alright thats quite nice though :-)

		// tempActivities, err := getPatientActivities(patientRef, r.Key(), ctx)
		// if err != nil {
		// 	return &sessions, err
		// }

		// currentSession.Activities = *tempActivities

		sessions = append(sessions, currentSession)
	}

	return &sessions, nil
}

func getPatientActivities(patientRef *firebaseDB.Ref, sessionKey string, ctx context.Context) (*[]Activity, error) {
	var activities []Activity

	activitiesRef := patientRef.Child(TableSessions).Child(sessionKey).Child("activities")

	results, err := activitiesRef.OrderByKey().GetOrdered(ctx)
	if err != nil {
		return nil, err
	}

	for _, r := range results {
		var activity Activity

		if err := r.Unmarshal(&activity); err != nil {
			return &activities, err
		}
		if len(activity.MinigameID) < 1 {
			continue
		}

		tempMetrics, err := getMetrics(activitiesRef.Child(r.Key()).Child("metrics"), ctx)
		if err != nil {
			return &activities, err
		}

		activity.Metrics = *tempMetrics

		activities = append(activities, activity)
	}

	return &activities, nil
}

// func getPatientActivity(patientRef *firebaseDB.Ref, activityKey string, ctx context.Context) (*Activity, error) {
// 	var activity Activity
// 	log.Print("10")

// 	err := patientRef.Child(TableActivities).Child(activityKey).Get(ctx, &activity)
// 	if err != nil {
// 		return nil, err
// 	}
// 	if len(activity.MinigameID) < 1 {
// 		log.Printf("This activity's minigameId was invalid, meaning the activity most likely is invalid, skipping")
// 		return nil, nil
// 	}

// 	// Retrieving metrics from this specific activity
// 	tempMetrics, err := getMetrics(patientRef.Child(TableActivities).Child(activityKey).Child("metrics"), ctx)
// 	if err != nil {
// 		return &activity, err
// 	}

// 	activity.Metrics = *tempMetrics

// 	return &activity, nil
// }

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
