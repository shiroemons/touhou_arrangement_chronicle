package model

import (
	"fmt"
	"strings"
)

func ToProductType(s string) (ProductType, error) {
	var e ProductType = ProductType(strings.ToUpper(s))
	if !e.IsValid() {
		return "", fmt.Errorf("%s is not a valid ProductType", s)
	}
	return e, nil
}
