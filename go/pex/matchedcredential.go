package pex

type MatchedPath struct {
	Path  string      `json:"path"`
	Index int         `json:"index"`
	Value interface{} `json:"value"`
}

type MatchedField struct {
	Index int         `json:"index"`
	Path  MatchedPath `json:"path"`
}

type MatchedCredential struct {
	Index  int            `json:"index"`
	Fields []MatchedField `json:"fields"`
}
