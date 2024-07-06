import type { LoaderFunction } from "@remix-run/node";
import type { LinksFunction } from "@remix-run/node";
import {
  Links,
  Meta,
  Outlet,
  Scripts,
  ScrollRestoration,
} from "@remix-run/react";
// @ts-ignore
import { ColorModeScript, UIProvider, defaultConfig } from "@yamada-ui/react";

import { jaJP } from "@clerk/localizations";
import { ClerkApp } from "@clerk/remix";
// Import rootAuthLoader
import { rootAuthLoader } from "@clerk/remix/ssr.server";

import Header from "~/components/Header";
import tailwindStylesheet from "~/styles/tailwind.css?url";

export const links: LinksFunction = () => [
  { rel: "stylesheet", href: tailwindStylesheet },
];

// Export as the root route loader
export const loader: LoaderFunction = (args) => rootAuthLoader(args);

export function Layout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <Meta />
        <Links />
      </head>
      <body>
        <ColorModeScript initialColorMode={defaultConfig.initialColorMode} />
        <UIProvider>{children}</UIProvider>
        <ScrollRestoration />
        <Scripts />
      </body>
    </html>
  );
}

export function App() {
  return (
    <>
      <Header />
      <Outlet />
    </>
  );
}

export default ClerkApp(App, { localization: jaJP });
