package db

import (
	"HealthWellnessRemoteMonitoring/internal/tools"
	"context"
	"errors"
	"fmt"
	"log"
)

type Observer struct {
	FirstName string   `json:"firstName" valid:"printableascii, optional"`
	LastName  string   `json:"lastName" valid:"printableascii, optional"`
	Patients  []string `json:"patients,omitempty" valid:",optional"` // PatientIDs
}

type GetPatientForm struct {
	ShortID string `json:"shortId" valid:"alphanum, required"`
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

	// If user did not exist, currently also needs to check patients because a bug causes duplicate entries of observers
	// one contains the names, and one contains the patients
	if len(observer.FirstName) <= 1 && len(observer.Patients) <= 0 {
		return nil, nil // TODO: possibly notfound error to be logged or something
	}

	return &observer, nil
}

func GetObserverFromUserID(userID string, ctx context.Context) (*Observer, error) {
	// Getting the actual observer entry
	var observer Observer
	err := DBClient().Database.NewRef(TableObserver).Child(userID).Get(ctx, &observer)
	if err != nil {
		return nil, err
	}

	// If user did not exist, currently also needs to check patients because a bug causes duplicate entries of observers
	// one contains the names, and one contains the patients
	if len(observer.FirstName) <= 1 && len(observer.Patients) <= 0 {
		return nil, nil // TODO: possibly notfound error to be logged or something
	}

	return &observer, nil
}

func AddPatientToObserver(clientCookie CookieData, patientId string, shortId string, ctx context.Context) error {
	// ---- This piece of code has issues, see #138 ----
	// See: https://gitlab.com/akerholten/vr-health-and-wellness-remote-monitoring/-/issues/138

	observerData, err := GetObserver(clientCookie, ctx)
	if err != nil {
		return err
	}
	if observerData == nil {
		return errors.New("Could not find observer user data")
	}

	fmt.Printf("%+v\n", observerData)
	// was for debug
	for key, obj := range observerData.Patients {
		fmt.Printf("\nThe patients for this guy: id: %d, value: %s", key, obj)
	}
	// Appending the new object to the array
	// observerData.Patients = append(observerData.Patients, patientId)
	// ---- End of code with issues ----

	var retrieveId string
	observerPatientRef := DBClient().Database.NewRef(TableObserver).Child(clientCookie.UserID).Child("patients").Child(shortId)
	err = observerPatientRef.Get(ctx, &retrieveId)
	if err != nil {
		return err
	}
	if len(retrieveId) > 1 {
		return errors.New("Patient already added to this observer")
	}

	// existingObserverPatients, err := observerPatientsRef.OrderByKey().GetOrdered(ctx)
	// if err != nil {
	// 	return err
	// }

	// for _, r := range existingObserverPatients {
	// 	var id string
	// 	if err := r.Unmarshal(&id); err != nil {
	// 		return err
	// 	}

	// 	if patientId == id {
	// 		return errors.New("User with that ID already exist for this observer")
	// 	}
	// }

	err = observerPatientRef.Set(ctx, patientId)
	if err != nil {
		log.Panicf("Error when setting new data %v", err)
		return err
	}

	// everything was successful so we return nil
	return nil
}

func AddPatientToObserverWithId(observerID string, patientId string, shortId string, ctx context.Context) error {
	// ---- This piece of code does not work due to issue #138 ----
	// See: https://gitlab.com/akerholten/vr-health-and-wellness-remote-monitoring/-/issues/138

	// observerData, err := GetObserverFromUserID(observerID, ctx)
	// if err != nil {
	// 	return err
	// }

	// if observerData == nil {
	// 	return errors.New("Could not find observer user data")
	// }

	// fmt.Printf("%+v\n", observerData)
	// // was for debug
	// for key, obj := range observerData.Patients {
	// 	log.Printf("\nThe patients for this guy: id: %d, value: %s", key, obj)
	// }

	// ---- End of not working code ----

	var retrieveId string
	observerPatientRef := DBClient().Database.NewRef(TableObserver).Child(observerID).Child("patients").Child(shortId)

	err := observerPatientRef.Get(ctx, &retrieveId)
	if err != nil {
		return err
	}
	if len(retrieveId) > 1 {
		return errors.New("Patient already added to this observer")
	}

	err = observerPatientRef.Set(ctx, patientId)
	if err != nil {
		log.Panicf("Error when setting new data %v", err)
		return err
	}

	// everything was successful so we return nil
	return nil
}

func GetPatients(clientCookie CookieData, ctx context.Context) ([]SimplePatientData, error) {
	var returnPatients []SimplePatientData

	observerPatientsRef := DBClient().Database.NewRef(TableObserver).Child(clientCookie.UserID).Child("patients")

	existingObserverPatients, err := observerPatientsRef.OrderByKey().GetOrdered(ctx)
	if err != nil {
		return returnPatients, err
	}

	// Do the key need to be returned in order to query for this exact patient later on?
	for _, r := range existingObserverPatients {
		var currentPatient SimplePatientData
		var id string

		if err := r.Unmarshal(&id); err != nil {
			return returnPatients, err
		}

		// TODO: Implement a get patient function that also gets all the sessions and recommendations and fills this
		// up for the patient before returned
		err = DBClient().Database.NewRef(TablePatient).Child(id).Get(ctx, &currentPatient)
		if err != nil {
			return returnPatients, err
		}

		if len(currentPatient.Email) < 1 {
			log.Printf("This patient's mail was invalid, meaning the user most likely is invalid, skipping")
			continue
		}

		returnPatients = append(returnPatients, currentPatient)
	}

	// everything was successful so we return nil
	return returnPatients, nil
}

func GetPatientsWithFullData(clientCookie CookieData, ctx context.Context) ([]Patient, error) {
	var returnPatients []Patient

	observerPatientsRef := DBClient().Database.NewRef(TableObserver).Child(clientCookie.UserID).Child("patients")

	existingObserverPatients, err := observerPatientsRef.OrderByKey().GetOrdered(ctx)
	if err != nil {
		return returnPatients, err
	}

	// Do the key need to be returned in order to query for this exact patient later on?
	for _, r := range existingObserverPatients {
		var currentPatient Patient
		var simplePatientData SimplePatientData
		var id string

		if err := r.Unmarshal(&id); err != nil {
			return returnPatients, err
		}

		// TODO: Implement a get patient function that also gets all the sessions and recommendations and fills this
		// up for the patient before returned
		patientInfoRef := DBClient().Database.NewRef(TablePatient).Child(id)
		err = patientInfoRef.Get(ctx, &simplePatientData)
		if err != nil {
			return returnPatients, err
		}

		if len(simplePatientData.Email) < 1 {
			log.Printf("This patient's mail was invalid, meaning the user most likely is invalid, skipping")
			continue
		}

		currentPatient = Patient{
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

		currentPatient.Sessions = *tempSessions

		returnPatients = append(returnPatients, currentPatient)
	}

	// everything was successful so we return nil
	return returnPatients, nil
}

func GetPatientWithShortId(clientCookie CookieData, shortId string, ctx context.Context) (*Patient, error) {
	observerPatientRef := DBClient().Database.NewRef(TableObserver).Child(clientCookie.UserID).Child("patients").Child(shortId)

	var patientId string

	err := observerPatientRef.Get(ctx, &patientId)
	if err != nil {
		return nil, err
	}
	if len(patientId) < 1 {
		return nil, errors.New("Could not find patient")
	}

	patient, err := GetPatientInfoFromId(patientId, ctx)
	if err != nil {
		return nil, err
	}
	if len(patient.Email) < 1 {
		return nil, errors.New("Could not find patient")
	}

	// Everything went ok so we return patient and nil
	return patient, nil
}
