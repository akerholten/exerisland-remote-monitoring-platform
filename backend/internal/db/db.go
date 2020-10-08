package db

import (
	"context"
	"fmt"
	"log"

	firebase "firebase.google.com/go"
	firebaseDB "firebase.google.com/go/db"
)

type DatabaseClient struct {
	Config     *firebase.Config
	AppSession *firebase.App
	Database   *firebaseDB.Client
}

// Singleton setup
var (
	client *DatabaseClient
)

func DBClient() *DatabaseClient {
	if client == nil {
		ctx := context.Background()

		config := InitConfig()

		appSession, err := CreateAppSession(ctx, config)
		if err != nil {
			log.Fatalf("Couldn't get app, error was %v\n", err)
		}

		database, err := CreateDatabaseSession(ctx, appSession)
		if err != nil {
			log.Fatalf("Couldn't get databaseclient, error was %v\n", err)
		}

		client = &DatabaseClient{
			Config:     config,
			AppSession: appSession,
			Database:   database,
		}
	}
	return client
}

func InitConfig() *firebase.Config {
	fmt.Println("Setting up config for firebase...")

	config := &firebase.Config{
		DatabaseURL: "https://vr-health-remotemonitoring.firebaseio.com/", // TODO: move to static global variable?
	}
	return config
}

func CreateAppSession(ctx context.Context, config *firebase.Config) (*firebase.App, error) {
	fmt.Println("Dialing firebase for app session...")

	app, err := firebase.NewApp(ctx, config)
	if err != nil {
		return nil, err
	}

	return app, nil
}

func CreateDatabaseSession(ctx context.Context, app *firebase.App) (*firebaseDB.Client, error) {
	fmt.Println("Dialing firebase for database client session...")

	dB, err := app.Database(ctx)
	if err != nil {
		return nil, err
	}

	return dB, nil
}
