package db

import ( 
	"HealthWellnessRemoteMonitoring/internal/tools"
	"context"
)

type Observer struct {
	FirstName string   `json:"firstName" valid:"printableascii, required"`
	LastName  string   `json:"lastName" valid:"printableascii, required"`
	Patients  []string `json:"patients" valid:"-"` // PatientIDs
}

func AddToObserverTable(user SignupUser, ctx context.Context) (string, error) {
	observer := Observer{
		FirstName: user.FirstName,
		LastName: user.LastName,
		Patients: []string,
	}

	table := DBClient().Database.NewRef(TableObserver)

	i := 0
	for {
		newKey := i.ToString() // ,err := tools.GetNewLongUniqueID(i) // Comment out when done debugging
		if err != nil {
			log.Panicf("Error: %v", err)
		}

		// Check if the ID already exist in database
		newTableEntry := table.Child(newKey)

		var existObserver Observer
		// If it doesn't exist, we can safely create it
		err := checkObject.Get(ctx, &existObserver)
		if err != nil || existObserver == nil {
			fmt.Printf("Error, or inteded error?: %v", err)
			break
		}
		
		i++

		if i == 5 {
			return "", error.Error("Could not fill Observer DB with new object")
		}
	}

	err := newTableEntry.Set(ctx, observer)
	if err != nil{
		log.Panicf("Error when setting new data %v", err)
		return nil, err
	}

	return newKey, nil
}
