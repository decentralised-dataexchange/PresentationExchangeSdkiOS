package main

import (
	"encoding/json"
	"fmt"

	"github.com/decentralised-dataexchange/presentation-exchange-sdk-ios/go/pexioswrapper"
)

func main() {
	inputDescriptor := `{"id":"9a18d1b5-13ac-4fbc-8c12-d5916740ce1d","constraints":{"fields":[{"path":["$.type"],"filter":{"type":"array","contains":{"const":"Passport"}}},{"path":["$.name"],"filter":{"type":"string","const":"John"}},{"path":["$.dob"],"filter":{"type":"string","const":"14-Mar-70"}},{"path":["$.address.city"],"filter":{"type":"string","const":"EKM"}}]}}`
	credentials := []string{`{"type":["Passport"],"name":"John","dob":"14-Mar-70","address":{"city":"EKM","state":"Kerala"}}`}

	credentialsBytes, _ := json.Marshal(credentials)

	res := pexioswrapper.MatchCredentials(inputDescriptor, string(credentialsBytes))
	fmt.Printf("Response: %v\n", res)
}
