package config

import (
	"log"

	"github.com/caarlos0/env/v8"
)

type Config struct {
	Env          string `env:"ENV" envDefault:"dev"`
	Port         string `env:"PORT" envDefault:"8080"`
	ConnectURL   string `env:"CONNECT_URL"`
	AllowOrigins string `env:"ALLOW_ORIGINS"`
}

func Provider() Config {
	cfg := &Config{}
	if err := env.Parse(cfg); err != nil {
		log.Fatalln(err)
	}
	return *cfg
}
