package db

import "log"

type Patient struct {
	FirstName       string           `json:"firstName" valid:"printableascii, required"`
	LastName        string           `json:"lastName" valid:"printableascii, required"`
	Sessions        []Session        `json:"sessions" valid:"-"`
	Recommendations []Recommendation `json:"sessions" valid:"-"`
	shortID         string           `json:"shortID" valid:"alphanum, optional"`
}

type Session struct {
	Duration   int        `json:"duration" valid:"integer, optional"`  // time thing?
	CreatedAt  string     `json:"createdAt" valid:"integer, optional"` // timestamp
	Activities []Activity `json:"activities" valid:"-"`
}

type Activity struct {
	MinigameID string   `json:"minigameID" valid:"alphanum, required"`
	Metrics    []Metric `json:"goals" valid:"-"`
}

type Metric struct {
	Name  string `json:"firstName" valid:"alphanum, required"`
	Value string `json:"firstName" valid:"alphanum, required"`
	Unit  string `json:"firstName" valid:"alphanum, optional"`
}

type Recommendation struct {
	ObserverID  string   `json:"observerID" valid:"alphanum, required"`
	MinigameID  string   `json:"minigameID" valid:"alphanum, required"`
	Goals       []Metric `json:"goals" valid:"-"`
	Results     []Metric `json:"results" valid:"-"`
	CompletedAt string   `json:"completedAt" valid:"integer, optional"` // timestamp
	Deadline    string   `json:"deadline" valid:"integer, optional"`    // timestamp
	Status      string   `json:"deadline" valid:"alphanum, optional"`   // "In Progress", "Not Started", "Completed", "Expired"
}

func AddToPatientTable(user SignupUser) (string, error) {

	// TODO: Implement similarly to observerInterface adding to observertable
	// But also add other stuff here, like the shortID
	log.Printf("Method not implemented yet, user was: %s\n", user.Email)

	return "", nil
}
