package db

import (
	"HealthWellnessRemoteMonitoring/internal/tools"
	"context"
	"fmt"
	"log"
)

type Observer struct {
	FirstName string   `json:"firstName" valid:"printableascii, required"`
	LastName  string   `json:"lastName" valid:"printableascii, required"`
	Patients  []string `json:"patients" valid:"-"` // PatientIDs
}

func AddToObserverTable(user SignupUser, ctx context.Context) (string, error) {
	var patients []string
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
