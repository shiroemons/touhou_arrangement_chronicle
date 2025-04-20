import { Form, redirect, useLoaderData } from "react-router";
import type { LoaderFunctionArgs } from "react-router";
import { authenticator } from "~/services/auth.server";

export async function loader({ request }: LoaderFunctionArgs) {
  // すでに認証されている場合はリダイレクト
  try {
    const user = await authenticator.authenticate("auth0", request);
    return redirect("/dashboard");
  } catch (error) {
    // 認証されていないので何もしない
  }

  // URLからエラーパラメータを取得
  const url = new URL(request.url);
  const error = url.searchParams.get("error");
  
  return { error };
}

export default function Login() {
  const { error } = useLoaderData<typeof loader>();

  return (
    <div>
      <h1>ログイン</h1>
      {error && <div>{error}</div>}

      <Form method="post" action="/auth/auth0">
        <button type="submit">
          Auth0でログイン
        </button>
      </Form>
    </div>
  );
}