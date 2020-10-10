package db

import (
	"HealthWellnessRemoteMonitoring/internal/tools"
	"context"
	"errors"
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

type LoginForm struct {
	Email    string `json:"email" valid:"email, required"`
	Password string `json:"password" valid:"alphanum, required"`
}

// AddToUserTable adds the user to logon_user table which is used for logging in
func AddToUserTable(user SignupUser, ctx context.Context) error {
	userLogon := User_Logon{
		Email:          user.Email,
		Password:       user.Password,
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

// AuthenticateUser verifies that the user exists in the database logon entry with
// email and password, and then it returns the ID of that user, returns error if something went wrong
func AuthenticateUser(form LoginForm, ctx context.Context) (bool, string, error) {

	table := DBClient().Database.NewRef(TableUser)

	results, err := table.OrderByKey().GetOrdered(ctx)
	if err != nil {
		return false, "", err
	}

	for _, r := range results {
		var userEntry User_Logon
		if err := r.Unmarshal(&userEntry); err != nil {
			return false, "", err
		}

		// If there is a match entry, authentication is successfull
		if form.Email == userEntry.Email && form.Password == userEntry.Password {
			return true, r.Key(), nil
		}
	}

	// TODO: return this error here, or is that kind of wrong?
	// As this will be sent many times when people type wrong password etc
	return false, "", errors.New("User not found")
}

func IsExistingUser(email string, ctx context.Context) (bool, error) {
	table := DBClient().Database.NewRef(TableUser)

	results, err := table.OrderByKey().GetOrdered(ctx)
	if err != nil {
		return false, err
	}

	for _, r := range results {
		var userEntry User_Logon
		if err := r.Unmarshal(&userEntry); err != nil {
			return false, err
		}

		// If there is a match entry, user exists
		if email == userEntry.Email {
			return true, nil
		}
	}

	return false, nil
}

func GetUser(id string, ctx context.Context) (*User_Logon, error) {
	var user User_Logon

	err := DBClient().Database.NewRef(TableUser).Get(ctx, &user)
	if err != nil {
		return nil, err
	}

	// If user did not exist
	if len(user.Email) <= 1 {
		return nil, nil
	}

	return &user, nil
}
