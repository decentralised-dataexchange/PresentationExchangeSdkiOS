package pex

import (
	"encoding/json"

	"github.com/ohler55/ojg/jp"
	"github.com/ohler55/ojg/oj"
	"github.com/santhosh-tekuri/jsonschema/v5"
)

func applyJsonPath(inputJsonString string, path string) (results []any, err error) {
	// Parse input JSON string
	parsedInput, err := oj.ParseString(inputJsonString)
	if err != nil {
		return nil, err
	}
	// Parse JSON path string
	parsedJsonPath, err := jp.ParseString(path)
	if err != nil {
		return nil, err
	}
	// Apply JSON path on input and get the matches
	matches := parsedJsonPath.Get(parsedInput)
	return matches, nil
}

func validateJsonSchema(inputJsonString interface{}, schema string) error {
	// Compile and parse JSON schema
	sch, err := jsonschema.CompileString("schema.json", schema)
	if err != nil {
		return err
	}
	// Validate JSON schema against the input JSON string
	if err = sch.Validate(inputJsonString); err != nil {
		return err
	}
	return nil
}

func MatchCredentials(inputDescriptorJson string, credentials []string) ([]MatchedCredential, error) {
	// Deserialise input descriptor json string
	var descriptor inputDescriptor
	err := json.Unmarshal([]byte(inputDescriptorJson), &descriptor)
	if err != nil {
		return []MatchedCredential{}, err
	}

	// To store the matched credentials
	matches := make([]MatchedCredential, 0)

	// Iterate through each credential
	for credentialIndex, credential := range credentials {

		// Assume credential matches until proven otherwise
		credentialMatched := true
		var matchedFields []MatchedField

		// Iterate through fields specified in the constraints
		for fieldIndex, field := range descriptor.Constraints.Fields {

			// Assume field matches until proven otherwise
			fieldMatched := false

			// Iterate through JSON paths for the current field
			for pathIndex, path := range field.Path {

				// Apply JSON path on the credential
				pathMatches, err := applyJsonPath(credential, path)

				// FIXME: Handle multiple path matches
				if len(pathMatches) > 0 && err == nil {
					if field.Filter != nil {
						filterBytes, err := json.Marshal(field.Filter)
						if err != nil {
							// Continue to next path, since filter has failed to serialise
							continue
						}

						// Validate the matched JSON against the field's filter
						if err := validateJsonSchema(pathMatches[0], string(filterBytes)); err != nil {
							// Field doesn't match since validation failed
							fieldMatched = false
							break
						}
					}

					// Add the matched field to the list
					fieldMatched = true
					matchedFields = append(matchedFields, MatchedField{
						Index: fieldIndex,
						Path: MatchedPath{
							Path:  path,
							Index: pathIndex,
							Value: pathMatches[0],
						},
					})
				}
			}

			if !fieldMatched {
				// If any one field didn't match then move to next credential
				credentialMatched = false
				break
			}
		}
		if credentialMatched {
			// All fields matched, then credential is matched
			matches = append(matches, MatchedCredential{
				Index:  credentialIndex,
				Fields: matchedFields,
			})
		}
	}

	// Return the list of matched credentials
	return matches, err
}
