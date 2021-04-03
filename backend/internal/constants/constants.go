package constants

import "time"

var (
	PatientShortIDLength int    = 3
	ObserverType         string = "observer"
	PatientType          string = "patient"
)

// COOKIE Const // TODO: possibly move to another package for cookie management, or just a new file
const (
	// CookieName ...
	CookieName = "HealthWellnessMonitoring"
	// CookieExpiration ...
	CookieExpiration = time.Hour * 24 * 7

	// WebsiteDomain
	WebsiteDomain = "exerisland.com"
)

// ADMIN consts
const (
	// AdminUserID
	AdminUserID = "1qZ7tjPEqF6MlOMxot2bqVltuxq" // "1jeFtbh6k1HxAPDgHT95ymzWhNa" // TODO: Add this after creating an admin user
)
