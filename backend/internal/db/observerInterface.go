package db

import (
	"HealthWellnessRemoteMonitoring/internal/tools"
	"context"
	"errors"
	"fmt"
	"log"
)

type Observer struct {
	FirstName string            `json:"firstName" valid:"printableascii, required"`
	LastName  string            `json:"lastName" valid:"printableascii, required"`
	Patients  map[string]string `json:"patients" valid:"-"` // PatientIDs
}

func AddToObserverTable(user SignupUser, ctx context.Context) (string, error) {
	var patients map[string]string
	observer := Observer{
		FirstName: user.FirstName,
		LastName:  user.LastName,
		Patients:  patients,
	}

	table := DBClient().Database.NewRef(TableObserver)

	i := 0
	var newKey string
	var err error
	for {
		newKey, err = tools.GetNewLongUniqueID(i) // Comment out when done debugging
		if err != nil {
			log.Panicf("Error: %v", err)
			return "", err
		}

		// Check if the ID already exist in database
		newTableEntry := table.Child(newKey)

		var existObserver Observer

		err = newTableEntry.Get(ctx, &existObserver)
		if err != nil {
			return "", err
		}

		// If it doesn't exist, we can safely create it so we break loop
		if len(existObserver.FirstName) <= 1 {
			break
		}

		i++

		if i == 5 {
			return "", fmt.Errorf("\nCould not fill Observer DB with new object, looped through %d times\n", i)
		}
	}

	err = table.Child(newKey).Set(ctx, observer)
	if err != nil {
		log.Panicf("Error when setting new data %v", err)
		return "", err
	}

	// Everything went okay
	log.Printf("New observer added at key %s", newKey)
	return newKey, nil
}

func GetObserver(clientCookie CookieData, ctx context.Context) (*Observer, error) {
	user, err := GetUserFromCookie(clientCookie, ctx)
	if err != nil {
		return nil, err
	}

	// Getting the actual observer entry
	var observer Observer
	err = DBClient().Database.NewRef(TableObserver).Child(user.UserID).Get(ctx, &observer)
	if err != nil {
		return nil, err
	}

	// If user did not exist
	if len(observer.FirstName) <= 1 {
		return nil, nil // TODO: possibly notfound error to be logged or something
	}

	return &observer, nil
}

func AddPatientToObserver(clientCookie CookieData, patientId string, ctx context.Context) error {
	observerData, err := GetObserver(clientCookie, ctx)
	if err != nil {
		return err
	}
	if observerData == nil {
		return errors.New("Could not find observer user data")
	}
	for key, obj := range observerData.Patients {
		log.Printf("\nThe patients for this guy: id: %s, value: %s", key, obj)
	}
	// Appending the new object to the array
	// observerData.Patients = append(observerData.Patients, patientId)

	observerPatientsRef := DBClient().Database.NewRef(TableObserver).Child(clientCookie.UserID).Child("patients")

	existingObserverPatients, err := observerPatientsRef.OrderByKey().GetOrdered(ctx)
	if err != nil {
		return err
	}

	for _, r := range existingObserverPatients {
		var id string
		if err := r.Unmarshal(&id); err != nil {
			return err
		}

		if patientId == id {
			return errors.New("User with that ID already exist for this observer")
		}
	}

	_, err = observerPatientsRef.Push(ctx, patientId)
	if err != nil {
		log.Panicf("Error when setting new data %v", err)
		return err
	}

	// everything was successful so we return nil
	return nil
}
