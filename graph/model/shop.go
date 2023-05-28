package model

import (
	"fmt"
	"strings"
)

func (e Shop) ToString() string {
	return string(e)
}

func ToShop(s string) (Shop, error) {
	var e Shop = Shop(strings.ToUpper(s))
	if !e.IsValid() {
		return "", fmt.Errorf("%s is not a valid Shop", s)
	}
	return e, nil
}
