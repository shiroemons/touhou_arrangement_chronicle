package server

import (
	"fmt"
	"net/url"
	"strings"

	"github.com/gin-contrib/cors"

	"github.com/shiroemons/touhou_arrangement_chronicle/internal/config"
)

func customCorsConfig(cfg config.Config) cors.Config {
	return cors.Config{
		AllowOrigins:     allowOrigins(cfg),
		AllowCredentials: true,
		AllowMethods: []string{
			"GET",
			"POST",
			"OPTIONS",
		},
		AllowHeaders: []string{
			"Access-Control-Allow-Credentials",
			"Access-Control-Allow-Headers",
			"Content-Type",
			"Content-Length",
			"Accept-Encoding",
			"Authorization",
		},
	}
}

func allowOrigins(cfg config.Config) []string {
	if cfg.Env == "dev" && cfg.AllowOrigins == "" {
		return []string{"http://localhost:" + cfg.Port}
	}

	var allows []string
	origins := strings.Split(cfg.AllowOrigins, ",")
	for _, origin := range origins {
		u, err := url.Parse(origin)
		if err != nil {
			continue
		}
		if u.Scheme != "" && u.Host != "" {
			fullHostname := fmt.Sprintf("%s://%s", u.Scheme, u.Host)
			allows = append(allows, fullHostname)
		}
	}

	return allows
}
