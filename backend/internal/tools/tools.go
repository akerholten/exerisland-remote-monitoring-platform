package tools

import (
	"crypto/sha512"
	"encoding/hex"
	"log"
	"math/rand"
	"time"
)

var (
	base62Chars string = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
)

// ConvertPlainPassword hashes a raw password and returns the hashed password
func ConvertPlainPassword(rawEmail, rawPassword string) string {
	hashedEmail := CreateHash(rawEmail)
	return CreateHash(hashedEmail + rawPassword)
}

// CreateHash creates a new hash string
func CreateHash(key string) string {
	hasher := sha512.New() // TODO: maybe move so that new is only called once
	_, err := hasher.Write([]byte(key))
	if err != nil {
		log.Panicf("Error writing hash, %v", err)
	}
	return hex.EncodeToString(hasher.Sum(nil))
}

func GetNewLongUniqueID() string {

	return "Not implemented"
}

// Base 62 ID implementation https://stackoverflow.com/questions/9543715/generating-human-readable-usable-short-but-unique-ids
func GetNewShortUniqueID(length int) string {
	newId := ""

	seed := time.Now().Unix()

	rand.Seed(seed)
	for i := 0; i < length; i++ {
		newId = newId + string([]rune(base62Chars)[rand.Int()%len(base62Chars)])
	}

	return newId
}
