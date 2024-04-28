import type { MetaFunction } from "@remix-run/node";
import {
  SignOutButton,
  SignedIn,
  SignedOut,
  UserButton,
} from "@clerk/remix";
import { Link } from "@remix-run/react";
import { getAuth } from "@clerk/remix/ssr.server";
import { LoaderFunction, redirect } from "@remix-run/node";

export const meta: MetaFunction = () => {
  return [
    { title: "New Remix App" },
    { name: "description", content: "Welcome to Remix!" },
  ];
};

export const loader: LoaderFunction = async (args) => {
  const { userId } = await getAuth(args);
  if (!userId) {
    return redirect("/sign-in");
  }
  return {};
}

export default function Index() {
  return (
    <div>
      <h1 className="text-2xl">Index Route</h1>
      <SignedIn>
        <p>You are signed in!</p>
        <div>
          <p>View your profile here 👇</p>
          <UserButton/>
        </div>
        <div>
          <SignOutButton/>
        </div>
      </SignedIn>
      <SignedOut>
        <p>You are signed out</p>
        <div>
          <Link to="/sign-in">Go to Sign in</Link>
        </div>
        <div>
          <Link to="/sign-up">Go to Sign up</Link>
        </div>
      </SignedOut>
    </div>
  );
}
