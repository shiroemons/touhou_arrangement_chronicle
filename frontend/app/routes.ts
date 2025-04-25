import { type RouteConfig, index, route } from "@react-router/dev/routes";

export default [
  index("routes/home.tsx"),
  route("login", "routes/login.tsx"),
  route("logout", "routes/logout.tsx"),
  route("auth/auth0", "routes/auth.auth0.tsx"),
  route("auth/auth0/callback", "routes/auth.auth0.callback.tsx"),
  route("songs", "routes/songs.tsx"),
  route("songs/:id", "routes/songs.$id.tsx")
] satisfies RouteConfig;