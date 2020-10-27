package db

type Minigame struct {
	Id               string   `json:"id" valid:"alphanum, required"`
	Name             string   `json:"name" valid:"printableascii, required"`
	Description      string   `json:"description" valid:"printableascii, optional"`
	Tags             []string `json:"tags,omitempty" valid:",optional"`
	AvailableMetrics []Metric `json:"availableMetrics,omitempty" valid:",optional"`
}

func GetMinigames() []Minigame {
	return minigamesList
}

// func GetMinigamesFromDB(ctx context.Context) (*[]Minigame, error) {
// 	// Getting the actual observer entry
// 	var minigames []Minigame
// 	err := DBClient().Database.NewRef(TableMinigames).Get(ctx, &minigames)
// 	if err != nil {
// 		return nil, err
// 	}

// 	// If user did not exist
// 	if len(minigames) < 1 {
// 		return nil, errors.New("Minigames not found") // TODO: possibly notfound error to be logged or something
// 	}

// 	return &minigames, nil
// }

// func FillDbWithMinigamesList(ctx context.Context) error {

// 	minigamesRef := DBClient().Database.NewRef(TableMinigames)

// 	err := minigamesRef.Set(ctx, minigamesList)

// 	// minigamesJson, err := json.Marshal(minigamesList)
// 	if err != nil {
// 		log.Printf("Could not fill up db with minigames, err was: %v", err)
// 		return err
// 	}

// 	// Success
// 	return nil
// }
