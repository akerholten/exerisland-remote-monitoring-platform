package main

import (
	"HealthWellnessRemoteMonitoring/internal/db"
	"context"
	"fmt"
	"log"
	"strconv"
	"time"
)

func DebugFunctionality(ctx context.Context) {
	// JSON-serializable test data
	type TestData struct {
		Name    string `json:"name,omitempty"`
		Balance int    `json:"balance,omitempty"`
	}

	testData := TestData{
		Name:    "TODO-remove",
		Balance: 1235,
	}

	// UPLOAD DATA EXAMPLE
	if err := db.DBClient().Database.NewRef("testData/todo-remove"+strconv.Itoa(time.Now().Second())).Set(ctx, testData); err != nil {
		log.Fatal(err)
	}

	// RETRIEVE DATA EXAMPLE
	var testDataRetrieve TestData
	if err := db.DBClient().Database.NewRef("testData/todo-remove").Get(ctx, &testDataRetrieve); err != nil {
		log.Fatal(err)
	}
	log.Printf("%s has a balance of %d\n", testDataRetrieve.Name, testDataRetrieve.Balance)

	// Retrieve array data example
	q := db.DBClient().Database.NewRef("testData").OrderByKey()
	result, err := q.GetOrdered(ctx)
	if err != nil {
		log.Fatal(err)
	}

	for _, child := range result {
		var dataRetrieved TestData

		if err := child.Unmarshal(&dataRetrieved); err != nil {
			log.Fatal(err)
		}
		log.Printf("key: %s name: %s has a balance of %d\n", child.Key(), dataRetrieved.Name, dataRetrieved.Balance)
	}

	// Second retrieve array example ordering by sub child data // this requires database rules to comply
	ref := db.DBClient().Database.NewRef("testData")

	results, err := ref.OrderByChild("balance").GetOrdered(ctx)
	if err != nil {
		log.Fatalln("Error querying database:", err)
	}
	for _, r := range results {
		var testRetrievedData TestData
		if err := r.Unmarshal(&testRetrievedData); err != nil {
			log.Fatalln("Error unmarshaling result:", err)
		}
		fmt.Printf("%s was %d balance and was named %s\n", r.Key(), testRetrievedData.Balance, testRetrievedData.Name)
	}
}
