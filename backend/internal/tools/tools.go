package tools

import (
	"crypto/sha512"
	"encoding/hex"
	"log"
)

// ConvertPlainPassword hashes a raw password and returns the hashed password
func ConvertPlainPassword(rawEmail, rawPassword string) string {
	hashedEmail := CreateHash(rawEmail)
	return CreateHash(hashedEmail + rawPassword)
}

// CreateHash creates a new hash string
func CreateHash(key string) string {
	hasher := sha512.New() // TODO: maybe move so that new is only called once
	err := hasher.Write([]byte(key))
	if err != nil {
		log.Panicf("Error writing hash, %v", err)
	}
	return hex.EncodeToString(hasher.Sum(nil))
}
