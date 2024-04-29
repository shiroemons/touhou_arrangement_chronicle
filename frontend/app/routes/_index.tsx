import { SignedIn, SignedOut } from "@clerk/remix";
import type { LoaderFunction, MetaFunction } from "@remix-run/node";
import { json } from "@remix-run/node";
import { useLoaderData } from "@remix-run/react";
import { countDistinct } from "drizzle-orm";
import { db } from "~/services/db.server";
import { songs } from "~/services/schema.server";

export const meta: MetaFunction = () => {
  return [
    { title: "New Remix App" },
    { name: "description", content: "Welcome to Remix!" },
  ];
};

export const loader: LoaderFunction = async () => {
  const songCount = await db
    .select({ value: countDistinct(songs.id) })
    .from(songs);

  return json<LoaderData>({
    songCount: songCount[0].value,
  });
};

type LoaderData = {
  songCount: number;
};

export default function Index() {
  const { songCount } = useLoaderData() as LoaderData;

  return (
    <div>
      <h1 className="text-2xl">Index Route</h1>
      <p>There are {songCount} song(s) in the database</p>
      <SignedIn>
        <p>You are signed in!</p>
      </SignedIn>
      <SignedOut>
        <p>You are signed out</p>
      </SignedOut>
    </div>
  );
}
