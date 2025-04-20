import { Authenticator } from "remix-auth";
import { Auth0Strategy } from "remix-auth-auth0";
import { createCookieSessionStorage } from "react-router";

// ユーザータイプの定義
export type User = {
  id: string;
  email: string;
  name: string;
  picture: string;
  accessToken: string;
  refreshToken?: string | null;
};

// セッションストレージの設定
export const sessionStorage = createCookieSessionStorage({
  cookie: {
    name: "__auth_session",
    secrets: [process.env.SESSION_SECRET || "s3cr3t"], // 実際の環境では適切なシークレットに変更してください
    sameSite: "lax",
    path: "/",
    maxAge: 60 * 60 * 24 * 30, // 30日
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
  },
});

// ユーザーセッションのヘルパー関数
export async function getUserSession(request: Request) {
  return sessionStorage.getSession(request.headers.get("cookie"));
}

// セッションへのユーザー情報保存
export async function setUserSession(request: Request, userId: string, userData: any) {
  const session = await getUserSession(request);
  session.set("userId", userId);
  session.set("userData", userData);

  return session;
}

// 認証インスタンスの作成
export const authenticator = new Authenticator<User>();

// セッションからユーザー情報を取得する関数
export async function isAuthenticated(request: Request) {
  const session = await getUserSession(request);
  const userId = session.get("userId");
  const userData = session.get("userData");
  
  if (!userId || !userData) {
    return null;
  }
  
  return userData as User;
}

// Auth0ストラテジーの設定
const auth0Strategy = new Auth0Strategy<User>(
  {
    domain: process.env.AUTH0_DOMAIN || "",
    clientId: process.env.AUTH0_CLIENT_ID || "",
    clientSecret: process.env.AUTH0_CLIENT_SECRET || "",
    redirectURI: process.env.AUTH0_CALLBACK_URL || "http://localhost:3000/auth/auth0/callback",
    scopes: ["openid", "email", "profile", "offline_access"],
  },
  async ({ tokens }) => {
    const userResponse = await fetch(
      `https://${process.env.AUTH0_DOMAIN}/userinfo`,
      {
        headers: {
          Authorization: `Bearer ${tokens.accessToken()}`,
        },
      },
    );

    if (!userResponse.ok) {
      throw new Error("Failed to fetch user data");
    }

    const userData = await userResponse.json();
    
    return {
      id: userData.sub,
      email: userData.email,
      name: userData.name,
      picture: userData.picture,
      accessToken: tokens.accessToken(),
      refreshToken: tokens.refreshToken(),
    };
  }
);

// 認証インスタンスにAuth0ストラテジーを追加
authenticator.use(auth0Strategy);

// ユーザー認証ヘルパー関数
export async function requireUser(request: Request, redirectTo: string = "/login") {
  try {
    // まずセッションから認証済みユーザーを確認
    const sessionUser = await isAuthenticated(request);
    if (sessionUser) {
      return sessionUser;
    }

    const user = await authenticator.authenticate("auth0", request);
    
    if (user) {
      // 認証成功したらセッションを更新
      const session = await setUserSession(request, user.id, user);
      throw new Response(null, {
        status: 302,
        headers: {
          Location: request.url,
          "Set-Cookie": await sessionStorage.commitSession(session),
        },
      });
    }
    
    return user;
  } catch (error) {    
    const url = new URL(request.url);
    const searchParams = new URLSearchParams([["redirectTo", url.pathname]]);
    throw new Response(null, {
      status: 302,
      headers: {
        Location: `${redirectTo}?${searchParams}`,
      },
    });
  }
}