package model

import (
	"fmt"
)

func (e ProductType) ToString() string {
	return string(e)
}

func ToProductType(s string) (ProductType, error) {
	var e ProductType = ProductType(s)
	if !e.IsValid() {
		return "", fmt.Errorf("%s is not a valid ProductType", s)
	}
	return e, nil
}
