package db

import (
	"HealthWellnessRemoteMonitoring/internal/tools"
	"context"
	"fmt"
	"log"
)

type SignupUser struct {
	// ID       string `json:"_id,omitempty" valid:"-"`
	Email          string `json:"email" valid:"email, required"`
	FirstName      string `json:"firstName" valid:"printableascii, required"`
	LastName       string `json:"lastName" valid:"printableascii, required"`
	Password       string `json:"password" valid:"alphanum, required"`
	UserType       string `json:"userType" valid:"alphanum, required"`
	OrganizationID string `json:"organizationID" valid:"alphanum, optional"`
	UserID         string `json:"userID" valid:"alphanum, optional"`

	// Response string        `json:"captcha" valid:"ascii, required"` // CAPTCHA?
}

type User_Logon struct {
	Email          string `json:"email" valid:"email, required"`
	Password       string `json:"password" valid:"alphanum, required"`
	UserType       string `json:"userType" valid:"alphanum, required"`
	OrganizationID string `json:"organizationID" valid:"alphanum, optional"`
	UserID         string `json:"userID" valid:"alphanum, optional"`
}

func AddToUserTable(user SignupUser, ctx context.Context) error {
	userLogon := User_Logon{
		Email:          user.Email,
		Password:       tools.ConvertPlainPassword(user.Email, user.Password),
		UserType:       user.UserType,
		OrganizationID: user.OrganizationID,
		UserID:         user.UserID,
	}

	table := DBClient().Database.NewRef(TableUser)

	i := 0
	var newKey string
	var err error
	for {
		newKey, err = tools.GetNewLongUniqueID(i) // Comment out when done debugging
		if err != nil {
			log.Panicf("Error: %v", err)
			return err
		}

		// Check if the ID already exist in database
		newTableEntry := table.Child(newKey)

		var existsObject User_Logon

		err = newTableEntry.Get(ctx, &existsObject)
		if err != nil {
			return err
		}

		// If it doesn't exist, we can safely create it so we break loop
		if len(existsObject.Email) <= 1 {
			break
		}

		i++

		if i == 5 {
			return fmt.Errorf("\nCould not fill logon_user DB with new object, looped through %d times\n", i)
		}
	}

	err = table.Child(newKey).Set(ctx, userLogon)
	if err != nil {
		log.Panicf("Error when setting new data %v", err)
		return err
	}

	// Everything went okay, so we return nil
	log.Printf("New logon_user added at key %s", newKey)
	return nil
}
