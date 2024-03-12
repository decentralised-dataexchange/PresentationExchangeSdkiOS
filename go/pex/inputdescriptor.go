package pex

type inputDescriptor struct {
	ID          string      `json:"id"`
	Constraints constraints `json:"constraints"`
}

type constraints struct {
	Fields            []field `json:"fields"`
	LimitedDisclosure string  `json:"limited_disclosure"`
}

type field struct {
	Path     []string    `json:"path"`
	Filter   interface{} `json:"filter"`
	Optional bool        `json:"optional"`
}
