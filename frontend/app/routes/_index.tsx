import type { LoaderFunction, MetaFunction } from "@remix-run/node";
import { json } from "@remix-run/node";
import { useLoaderData } from "@remix-run/react";
import {
  Box,
  Button,
  HStack,
  Heading,
  Stat,
  Text,
  VStack,
  Wrap,
} from "@yamada-ui/react";
import { countDistinct } from "drizzle-orm";

import { MusicDialog } from "~/components/MusicDialog";
import { db } from "~/services/db.server";
import { albums, artists, circles, songs } from "~/services/schema.server";

export const meta: MetaFunction = () => {
  return [
    { title: "東方編曲録　〜 Arrangement Chronicle" },
    { name: "description", content: "東方Projectの東方アレンジのデータベース" },
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
    <Box
      bgSize="cover"
      bgPosition="center"
      height="100vh"
      display="flex"
      alignItems="center"
      justifyContent="center"
      textAlign="center"
    >
      <VStack spacing="4" maxW="800px">
        <Heading as="h1" size="3xl" textAlign="center">
          東方編曲録 〜 Arrangement Chronicle
        </Heading>
        <Text fontSize="2xl" textAlign="center">
          幻想郷の音楽をここに集めて
        </Text>
        <Text
          fontSize="lg"
          maxW="3xl"
          textAlign="center"
          lineHeight="1.6"
          mt={4}
          px={4}
        >
          東方Projectのファンによる、ファンのためのアレンジ楽曲データベースです。原曲別、サークル別、アーティスト別、イベント別に楽曲を検索でき、原曲の使用状況もグラフで確認できます。
        </Text>
        <Text
          fontSize="lg"
          maxW="3xl"
          textAlign="center"
          lineHeight="1.6"
          mt={4}
          px={4}
        >
          幻想郷の魅力的な音楽の世界をお楽しみください。
        </Text>
        <HStack spacing={4}>
          <Button
            colorScheme="red"
            size="lg"
            boxShadow="lg"
            _hover={{ boxShadow: "xl" }}
          >
            今すぐ検索
          </Button>
          <MusicDialog />
        </HStack>
        <Box mt="8" width="100%">
          <Wrap gap="md">
            <Stat label="楽曲登録数" number={songCount} width="180px" />
            <Stat label="アルバム登録数" number={albumCount} width="180px" />
            <Stat
              label="アーティスト登録数"
              number={artistCount}
              width="180px"
            />
            <Stat label="サークル登録数" number={circleCount} width="180px" />
          </Wrap>
        </Box>
      </VStack>
    </Box>
  );
}
