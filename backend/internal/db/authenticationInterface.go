package db

type SignupUser struct {
	Email          string `json:"email" valid:"email, required"`
	Password       string `json:"password" valid:"alphanum, required"`
	OrganizationID string `json:"organizationID" valid:"alphanum, optional"`

	// Response string        `json:"captcha" valid:"ascii, required"` // CAPTCHA?
}
