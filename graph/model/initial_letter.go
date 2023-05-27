package model

import (
	"fmt"
	"strings"
)

func (e InitialLetterType) ToString() string {
	return string(e)
}

func ToInitialLetterType(s string) (InitialLetterType, error) {
	var e InitialLetterType = InitialLetterType(strings.ToUpper(s))
	if !e.IsValid() {
		return "", fmt.Errorf("%s is not a valid InitialLetterType", s)
	}
	return e, nil
}
