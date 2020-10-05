package main

import (
	"context"
	firebase "firebase.google.com/go"
	"fmt"
	"log"
)

type TestData struct {
	Name    string
	Balance int
}

func main() {
	// Call main functionality, run app from here

	ctx := context.Background()
	fmt.Println("Hello World!")
	// DEBUG STUFF - TODO: remove / move to db.go

	// Set the configuration for your app
	config := &firebase.Config{
		DatabaseURL: "https://vr-health-remotemonitoring.firebaseio.com/",
	}

	app, err := firebase.NewApp(ctx, config)
	if err != nil {
		log.Fatalf("error initializing app: %v\n", err)
	}

	client, err := app.Auth(ctx)
	if err != nil {
		log.Fatalf("error getting Auth client: %v\n", err)
	}

	if client != nil {
		fmt.Println("Client was not nil yay")
	}

	dB, err := app.Database(ctx)
	if err != nil {
		log.Fatalf("error getting dB session: %v\n", err)
	}

	testData := TestData{
		Name:    "TODO-remove",
		Balance: 1337,
	}

	// UPLOAD DATA EXAMPLE
	if err := dB.NewRef("testData/todo-remove").Set(ctx, testData); err != nil {
		log.Fatal(err)
	}

	// RETRIEVE DATA EXAMPLE
	var testDataRetrieve TestData
	if err := dB.NewRef("testData/todo-remove").Get(ctx, &testDataRetrieve); err != nil {
		log.Fatal(err)
	}
	log.Printf("%s has a balance of %d\n", testDataRetrieve.Name, testDataRetrieve.Balance)

	// Get a reference to the database service
	// ctx := context.Background() https://vr-health-remotemonitoring.firebaseio.com/
	// config := &firebase.Config{
	// 	DatabaseURL: "https://database-name.firebaseio.com",
	// }
	// app, err := firebase.NewApp(ctx, config)
	// if err != nil {
	// 	log.Fatal(err)
	// }

	// client, err := app.Database(ctx)
	// if err != nil {
	// 	log.Fatal(err)
	// }

	// acc := Account{
	// 	Name:    "Alice",
	// 	Balance: 1000,
	// }
	// if err := client.NewRef("accounts/alice").Set(ctx, acc); err != nil {
	// 	log.Fatal(err)
	// }
	// END OF DEBUG STUFF - TODO: remove
}
