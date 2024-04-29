import { SignedIn, SignedOut, UserButton } from "@clerk/remix";
import { Link } from "@remix-run/react";
import { useLocation } from "@remix-run/react";
import type { JSX } from "react";

export default function Header() {
  const location = useLocation();

  const isAuthPage =
    location.pathname.startsWith("/sign-in") ||
    location.pathname.startsWith("/sign-up");
  let signedOut: JSX.Element | null;
  if (isAuthPage) {
    signedOut = null;
  } else {
    signedOut = (
      <SignedOut>
        <li>
          <Link to="/sign-in" className="btn btn-ghost">
            サインイン
          </Link>
        </li>
        <li>
          <Link to="/sign-up" className="btn btn-primary">
            サインアップ
          </Link>
        </li>
      </SignedOut>
    );
  }

  return (
    <div className="navbar bg-base-100">
      <div className="flex-1">
        <Link to="/" className="btn btn-ghost text-xl">
          東方編曲録
        </Link>
      </div>
      <div className="flex-none">
        <ul className="menu menu-horizontal px-1">
          <SignedIn>
            <li>
              <UserButton />
            </li>
          </SignedIn>
          {signedOut}
        </ul>
      </div>
    </div>
  );
}
