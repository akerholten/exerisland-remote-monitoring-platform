package constants

import "time"

var (
	PatientShortIDLength int    = 6
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
	WebsiteDomain = "rehab-monitoring.com"
)

// ADMIN consts
const (
	// AdminUserID
	AdminUserID = "1jeFtbh6k1HxAPDgHT95ymzWhNa" //"1jeFtUuzcCnHqk5iB3ikzrreLv9" // TODO: Add this after creating an admin user
)
