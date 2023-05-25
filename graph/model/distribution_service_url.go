package model

import (
	"fmt"
	"strings"
)

func (e DistributionService) ToString() string {
	return string(e)
}

func ToDistributionService(s string) (DistributionService, error) {
	var e DistributionService = DistributionService(strings.ToUpper(s))
	if !e.IsValid() {
		return "", fmt.Errorf("%s is not a valid DistributionService", s)
	}
	return e, nil
}
