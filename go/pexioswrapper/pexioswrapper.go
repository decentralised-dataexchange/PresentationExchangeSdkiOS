package pexioswrapper

import (
	"encoding/json"

	"github.com/decentralised-dataexchange/presentation-exchange-sdk-ios/go/pex"
)

type response struct {
	MatchedCredentials interface{}
	Err                string
}

func MatchCredentials(inputDescriptorJson string, credentials string) string {
	// Deserialise string to []string
	var credentialsArray []string
	err := json.Unmarshal([]byte(credentials), &credentialsArray)
	if err != nil {
		res, _ := json.Marshal(response{Err: err.Error()})
		return string(res)
	}

	// Match credentials against the input descriptor
	matchedCredentials, err := pex.MatchCredentials(inputDescriptorJson, credentialsArray)
	if err != nil {
		res, _ := json.Marshal(response{Err: err.Error()})
		return string(res)
	}

	resBytes, _ := json.Marshal(response{MatchedCredentials: matchedCredentials})
	return string(resBytes)
}
