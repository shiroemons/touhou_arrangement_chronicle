package model

import (
	"fmt"
	"strings"
)

func ToTagType(s string) (TagType, error) {
	var e TagType = TagType(strings.ToUpper(s))
	if !e.IsValid() {
		return "", fmt.Errorf("%s is not a valid TagType", s)
	}
	return e, nil
}
