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
)
