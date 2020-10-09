package tools

import (
	"crypto/sha512"
	"encoding/hex"
	"log"
	"math/rand"
	"time"

	"github.com/segmentio/ksuid"
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

func GetNewLongUniqueID(safetyCount int) (string, error) {
	timeSeed := time.Now()
	timeSeed.Add(time.Duration(safetyCount) * time.Second)
	kId, err := ksuid.NewRandomWithTime(timeSeed) // Weird hack to avoid collissions if sent at same time
	if err != nil {
		return "", err
	}

	return kId.String(), nil
}

// Base 62 ID implementation https://stackoverflow.com/questions/9543715/generating-human-readable-usable-short-but-unique-ids
func GetNewShortUniqueID(length int) string {
	newId := ""

	seed := time.Now().Unix()

	rand.Seed(seed)
	for i := 0; i < length; i++ {
		newId = newId + string([]rune(base62Chars)[rand.Int()%36]) // 36 for only upper-case
	}

	return newId
}
