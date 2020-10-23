package db

import (
	"HealthWellnessRemoteMonitoring/internal/constants"
	"HealthWellnessRemoteMonitoring/internal/tools"
	"context"
	"errors"
	"fmt"
	"log"
)

type Patient struct {
	FirstName       string           `json:"firstName" valid:"printableascii, required"`
	LastName        string           `json:"lastName" valid:"printableascii, required"`
	Email           string           `json:"email" valid:"email, required"`
	BirthDate       string           `json:"birthDate" valid:"printableascii, optional"`
	Note            string           `json:"note" valid:"printableascii, optional"`
	ShortID         string           `json:"shortID" valid:"alphanum, optional"`
	Sessions        []Session        `json:"sessions" valid:"-"`
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
	Duration   int        `json:"duration" valid:"integer, optional"`  // time thing?
	CreatedAt  string     `json:"createdAt" valid:"integer, optional"` // timestamp
	Activities []Activity `json:"activities" valid:"-"`
}

type Activity struct {
	MinigameID string   `json:"minigameID" valid:"alphanum, required"`
	Metrics    []Metric `json:"goals" valid:"-"`
}

type Metric struct {
	Name  string `json:"firstName" valid:"alphanum, required"`
	Value string `json:"value" valid:"alphanum, required"`
	Unit  string `json:"unit" valid:"alphanum, optional"`
}

type Recommendation struct {
	ObserverID  string   `json:"observerID" valid:"alphanum, required"`
	MinigameID  string   `json:"minigameID" valid:"alphanum, required"`
	Goals       []Metric `json:"goals" valid:"-"`
	Results     []Metric `json:"results" valid:"-"`
	CompletedAt string   `json:"completedAt" valid:"integer, optional"` // timestamp
	Deadline    string   `json:"deadline" valid:"integer, optional"`    // timestamp
	Status      string   `json:"status" valid:"alphanum, optional"`     // "In Progress", "Not Started", "Completed", "Expired"
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

	// TODO: Fill the rest of the data, recommendations, sessions, activites, and so on

	// Everything went ok so we return patient and nil
	return &patient, nil
}
