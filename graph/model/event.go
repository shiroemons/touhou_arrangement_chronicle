package model

import (
	"fmt"
	"strings"
)

func ToEventStatus(s string) (EventStatus, error) {
	var e EventStatus = EventStatus(strings.ToUpper(s))
	if !e.IsValid() {
		return "", fmt.Errorf("%s is not a valid EventStatus", s)
	}
	return e, nil
}

func ToEventFormat(s string) (EventFormat, error) {
	var e EventFormat = EventFormat(strings.ToUpper(s))
	if !e.IsValid() {
		return "", fmt.Errorf("%s is not a valid EventFormat", s)
	}
	return e, nil
}
