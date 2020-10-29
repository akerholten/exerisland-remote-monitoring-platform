package db

// minigamesList is a list of minigames that has to be manually updated by developers
// when creating new minigames, append to this list and with its settings
var minigamesList = []Minigame{
	Minigame{
		Id:          "someMinigameId",
		Name:        "Some mini game name",
		Description: "This is the description of it",
		Tags: []string{
			"Physical", "Cognitive", "Arms", "Legs",
		},
		AvailableMetrics: []Metric{
			Metric{
				Id:    "Duration",
				Name:  "Duration",
				Value: 0,
				Unit:  "seconds",
			},
			Metric{
				Id:    "Arm_Movement",
				Name:  "Arm movement",
				Value: 0,
				Unit:  "meters",
			},
			Metric{
				Id:    "Leg_Movement",
				Name:  "Leg movement",
				Value: 0,
				Unit:  "meters",
			},
			Metric{
				Id:    "Game_Completion",
				Name:  "Game completion",
				Value: 0,
				Unit:  "true/false",
			},
			Metric{
				Id:    "Score",
				Name:  "Score",
				Value: 0,
				Unit:  "score",
			},
		},
	},
	Minigame{
		Id:          "someMinigameId2",
		Name:        "Some mini game name 2",
		Description: "This is the description of it",
		Tags: []string{
			"Physical", "Cognitive", "Arms", "Legs",
		},
		AvailableMetrics: []Metric{
			Metric{
				Id:    "Duration",
				Name:  "Duration",
				Value: 0,
				Unit:  "seconds",
			},
			Metric{
				Id:    "Arm_Movement",
				Name:  "Arm movement",
				Value: 0,
				Unit:  "meters",
			},
			Metric{
				Id:    "Leg_Movement",
				Name:  "Leg movement",
				Value: 0,
				Unit:  "meters",
			},
			Metric{
				Id:    "Game_Completion",
				Name:  "Game completion",
				Value: 0,
				Unit:  "true/false",
			},
		},
	},
}
