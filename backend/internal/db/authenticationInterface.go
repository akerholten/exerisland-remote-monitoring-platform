package db

import "context"

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
		Email: user.FirstName,
		Password: user.LastName,
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
