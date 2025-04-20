import type { LoaderFunctionArgs } from "react-router";
import { redirect } from "react-router";
import { authenticator, sessionStorage, setUserSession } from "~/services/auth.server";

export async function loader({ request }: LoaderFunctionArgs) {
  // URLパラメータを抽出
  const url = new URL(request.url);
  const code = url.searchParams.get("code");
  const state = url.searchParams.get("state");
  
  try {
    const user = await authenticator.authenticate("auth0", request);
    const session = await setUserSession(request, user.id, user);
    return redirect("/", {
      headers: {
        "Set-Cookie": await sessionStorage.commitSession(session)
      }
    });
  } catch (error) {
    console.error("Authentication error:", error);    

    return redirect("/login?error=auth_failed");
  }
}