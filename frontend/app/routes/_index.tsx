import type { MetaFunction } from "@remix-run/node";
import {
  SignedIn,
  SignedOut,
} from "@clerk/remix";

export const meta: MetaFunction = () => {
  return [
    { title: "New Remix App" },
    { name: "description", content: "Welcome to Remix!" },
  ];
};

export default function Index() {
  return (
    <div>
      <h1 className="text-2xl">Index Route</h1>
      <SignedIn>
        <p>You are signed in!</p>
      </SignedIn>
      <SignedOut>
        <p>You are signed out</p>
      </SignedOut>
    </div>
  );
}
