package db

// minigamesList is a list of minigames that has to be manually updated by developers
// when creating new minigames, append to this list and with its settings
var minigamesList = []Minigame{
	Minigame{
		Id:          "Platform_Minigame",
		Name:        "Platform Minigame",
		Description: "Placed on a platform, the player is presented with objects approaching them, some have to be dodged, and some gives the player points when reaching them.",
		Tags: []string{
			"Physical", "Cognitive", "Arms", "Hand-eye coordination",
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
				Id:    "Obstacle_Not_Dodged",
				Name:  "Obstacles not dodged",
				Value: 0,
				Unit:  "not dodged",
			},
			Metric{
				Id:    "Hittable_Hits",
				Name:  "Hittable hits",
				Value: 0,
				Unit:  "hits",
			},
			Metric{
				Id:    "Calories_Burned",
				Name:  "Calories burned",
				Value: 0,
				Unit:  "calories",
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
		Id:          "ReactionTimeTrainer_Minigame",
		Name:        "Reaction Time Trainer",
		Description: "Based on BATAK reaction time trainer for football-keepers, the reaction time trainer minigame focuses on providing a series of water bubbles that the player should hit when they light up and make a noise.",
		Tags: []string{
			"Physical", "Cognitive", "Arms", "Hand-eye coordination", "Hearing", "Sound",
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
				Id:    "WaterBubbles_Hit",
				Name:  "Water bubbles hit",
				Value: 0,
				Unit:  "hits",
			},
			Metric{
				Id:    "Score",
				Name:  "Score",
				Value: 0,
				Unit:  "score",
			},
			Metric{
				Id:    "Calories_Burned",
				Name:  "Calories burned",
				Value: 0,
				Unit:  "calories",
			},
			Metric{
				Id:    "Average_ReactionTime",
				Name:  "Average reaction time",
				Value: 0,
				Unit:  "ms",
			},
		},
	},
	Minigame{
		Id:          "DroneShooter_Minigame",
		Name:        "Drone Shooter",
		Description: "The player is presented with a range of drones flying around, the drones has to be shot down and their bullets must be dodged.",
		Tags: []string{
			"Physical", "Cognitive", "Arms", "Hand-eye coordination",
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
				Id:    "Drones_Hit",
				Name:  "Drones hit",
				Value: 0,
				Unit:  "hits",
			},
			Metric{
				Id:    "Score",
				Name:  "Score",
				Value: 0,
				Unit:  "score",
			},
			Metric{
				Id:    "Calories_Burned",
				Name:  "Calories burned",
				Value: 0,
				Unit:  "calories",
			},
		},
	},
}
