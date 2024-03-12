package pex

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

// Test function for MatchCredentials() function
func TestMatchCredentials(tt *testing.T) {
	// Test cases
	cases := []struct {
		name                string
		inputDescriptorJson string
		credentials         []string
	}{
		{
			"valid input descriptor with 4 fields, 1 path each, 1 filter each and 1 matching credential",
			`{"id":"9a18d1b5-13ac-4fbc-8c12-d5916740ce1d","constraints":{"fields":[{"path":["$.type"],"filter":{"type":"array","contains":{"const":"Passport"}}},{"path":["$.name"],"filter":{"type":"string","const":"John"}},{"path":["$.dob"],"filter":{"type":"string","const":"14-Mar-70"}},{"path":["$.address.city"],"filter":{"type":"string","const":"EKM"}}]}}`,
			[]string{`{"type":["Passport"],"name":"John","dob":"14-Mar-70","address":{"city":"EKM","state":"Kerala"}}`},
		},
		{
			"valid input descriptor with 1 field, 1 path each, 0 filter and and 1 matching credential",
			`{"id":"9a18d1b5-13ac-4fbc-8c12-d5916740ce1d","constraints":{"fields":[{"path":["$.address.city"]}]}}`,
			[]string{`{"type":["Passport"],"name":"John","dob":"14-Mar-70","address":{"city":"EKM","state":"Kerala"}}`},
		},
		{
			"valid input descriptor with 1 field, 1 path each, 1 filter and and 2 matching credential",
			`{"id":"9a18d1b5-13ac-4fbc-8c12-d5916740ce1d","constraints":{"fields":[{"path":["$.address.city"]}]}}`,
			[]string{
				`{"type":["Passport"],"name":"John","dob":"14-Mar-70","address":{"city":"EKM","state":"Kerala"}}`,
				`{"type":["Passport"],"name":"Alice","dob":"14-Mar-80","address":{"city":"Stockholm","state":"Stockholm"}}`,
			},
		},
	}

	tt.Run(cases[0].name, func(t *testing.T) {
		o, err := MatchCredentials(cases[0].inputDescriptorJson, cases[0].credentials)
		assert.Nil(t, err)
		assert.Equal(t, 1, len(o))
		assert.Equal(t, 4, len(o[0].Fields))
	})

	tt.Run(cases[1].name, func(t *testing.T) {
		o, err := MatchCredentials(cases[1].inputDescriptorJson, cases[1].credentials)
		assert.Nil(t, err)
		assert.Equal(t, 1, len(o))
		assert.Equal(t, 1, len(o[0].Fields))
		assert.Equal(t, "$.address.city", o[0].Fields[0].Path.Path)
		assert.Equal(t, "EKM", o[0].Fields[0].Path.Value)
	})

	tt.Run(cases[2].name, func(t *testing.T) {
		o, err := MatchCredentials(cases[2].inputDescriptorJson, cases[2].credentials)
		assert.Nil(t, err)
		assert.Equal(t, 2, len(o))
		assert.Equal(t, 1, len(o[0].Fields))
		assert.Equal(t, "$.address.city", o[0].Fields[0].Path.Path)
		assert.Equal(t, "EKM", o[0].Fields[0].Path.Value)

		assert.Equal(t, 1, len(o[1].Fields))
		assert.Equal(t, "$.address.city", o[1].Fields[0].Path.Path)
		assert.Equal(t, "Stockholm", o[1].Fields[0].Path.Value)
	})
}
