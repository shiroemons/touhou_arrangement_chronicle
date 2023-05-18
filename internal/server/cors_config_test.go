package server

import (
	"reflect"
	"testing"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/config"
)

func TestArrowOrigins(t *testing.T) {
	type args struct {
		cnf config.Config
	}
	tests := []struct {
		name string
		args args
		want []string
	}{
		{name: "dev", args: args{cnf: config.Config{Env: "dev", AllowOrigins: "", Port: "8080"}}, want: []string{"http://localhost:8080"}},
		{name: "stg", args: args{cnf: config.Config{Env: "stg", AllowOrigins: "http://localhost:8080,https://example.com"}}, want: []string{"http://localhost:8080", "https://example.com"}},
		{name: "prod", args: args{cnf: config.Config{Env: "prod", AllowOrigins: "https://example.com"}}, want: []string{"https://example.com"}},
		{name: "blank", args: args{cnf: config.Config{Env: "prod", AllowOrigins: ""}}, want: []string(nil)},
		{name: "unsupported", args: args{cnf: config.Config{Env: "prod", AllowOrigins: "example.com"}}, want: []string(nil)},
	}
	for _, tt := range tests {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()
			got := allowOrigins(tt.args.cnf)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("allowOrigins() = %v, want %v", got, tt.want)
			}
		})
	}
}
