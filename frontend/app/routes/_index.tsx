import { SignedIn, SignedOut } from "@clerk/remix";
import type { LoaderFunction, MetaFunction } from "@remix-run/node";
import { json } from "@remix-run/node";
import { useLoaderData } from "@remix-run/react";
import { countDistinct } from "drizzle-orm";
import Stat from "~/components/Stat";
import { db } from "~/services/db.server";
import { albums, artists, circles, songs } from "~/services/schema.server";

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
  const albumCount = await db
    .select({ value: countDistinct(albums.id) })
    .from(albums);
  const artistCount = await db
    .select({ value: countDistinct(artists.id) })
    .from(artists);
  const circleCount = await db
    .select({ value: countDistinct(circles.id) })
    .from(circles);

  return json<LoaderData>({
    songCount: songCount[0].value,
    albumCount: albumCount[0].value,
    artistCount: artistCount[0].value,
    circleCount: circleCount[0].value,
  });
};

type LoaderData = {
  songCount: number;
  albumCount: number;
  artistCount: number;
  circleCount: number;
};

export default function Index() {
  const { songCount, albumCount, artistCount, circleCount } =
    useLoaderData() as LoaderData;

  return (
    <div>
      <h1 className="text-2xl">Index Route</h1>
      <Stat
        songCount={songCount || 0}
        albumCount={albumCount || 0}
        artistCount={artistCount || 0}
        circleCount={circleCount || 0}
      />
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
