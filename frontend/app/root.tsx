import {
  isRouteErrorResponse,
  Links,
  Meta,
  Outlet,
  Scripts,
  ScrollRestoration,
  useLoaderData,
  useLocation,
} from "react-router";
import type { LoaderFunctionArgs } from "react-router";
import { authenticator, isAuthenticated } from "~/services/auth.server";
import { Header } from "./components/layouts/header";
import { Footer } from "./components/layouts/footer";
import { useTheme } from "./lib/theme";

export async function loader({ request }: LoaderFunctionArgs) {
  // ユーザーの認証状態を確認
  try {
    // まずセッションからユーザー情報を取得
    let user = await isAuthenticated(request);
    
    if (user) {
      return { user, isAuthenticated: true };
    }

    try {
      user = await authenticator.authenticate("auth0", request);
      return { user, isAuthenticated: true };
    } catch (authError) { 
      return { user: null, isAuthenticated: false };
    }
  } catch (error) {
    return { user: null, isAuthenticated: false };
  }
}

import type { Route } from "./+types/root";
import "./app.css";

export const links: Route.LinksFunction = () => [
  { rel: "preconnect", href: "https://fonts.googleapis.com" },
  {
    rel: "preconnect",
    href: "https://fonts.gstatic.com",
    crossOrigin: "anonymous",
  },
  {
    rel: "stylesheet",
    href: "https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap",
  },
];

export function Layout({ children }: { children: React.ReactNode }) {
  const { isAuthenticated } = useLoaderData<typeof loader>();
  const location = useLocation();
  const isLoginPage = location.pathname === "/login";
  
  // テーマフックを使用して初期化（テーマの状態は内部で維持）
  useTheme();

  return (
    <html lang="ja">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <Meta />
        <Links />
      </head>
      <body className="min-h-screen flex flex-col">
        <Header />
        <div className="flex-1">
          {children}
        </div>
        <Footer />
        <ScrollRestoration />
        <Scripts />
      </body>
    </html>
  );
}

export default function App() {
  return <Outlet />;
}

export function ErrorBoundary({ error }: Route.ErrorBoundaryProps) {
  let message = "Oops!";
  let details = "An unexpected error occurred.";
  let stack: string | undefined;

  if (isRouteErrorResponse(error)) {
    message = error.status === 404 ? "404" : "Error";
    details =
      error.status === 404
        ? "The requested page could not be found."
        : error.statusText || details;
  } else if (import.meta.env.DEV && error && error instanceof Error) {
    details = error.message;
    stack = error.stack;
  }

  return (
    <main className="pt-16 p-4 container mx-auto">
      <h1>{message}</h1>
      <p>{details}</p>
      {stack && (
        <pre className="w-full p-4 overflow-x-auto">
          <code>{stack}</code>
        </pre>
      )}
    </main>
  );
}