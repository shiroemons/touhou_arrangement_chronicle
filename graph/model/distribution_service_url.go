package model

import (
	"fmt"
	"strings"
)

func ToDistributionService(s string) (DistributionService, error) {
	var e DistributionService = DistributionService(strings.ToUpper(s))
	if !e.IsValid() {
		return "", fmt.Errorf("%s is not a valid DistributionService", s)
	}
	return e, nil
}
