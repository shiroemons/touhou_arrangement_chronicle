import { Button, Text, VStack, useDisclosure } from "@yamada-ui/react";
import {
  Dialog,
  DialogBody,
  DialogCloseButton,
  DialogFooter,
  DialogHeader,
  DialogOverlay,
} from "@yamada-ui/react";

export function MusicDialog() {
  const { isOpen, onOpen, onClose } = useDisclosure();

  const handleLinkClick = (url: string) => {
    window.open(url, "_blank");
    onClose();
  };

  return (
    <>
      <Button colorScheme="gray" size="lg" onClick={onOpen}>
        東方アレンジを聴く
      </Button>

      <Dialog isOpen={isOpen} onClose={onClose}>
        <DialogOverlay />
        <DialogHeader>東方アレンジを聴く</DialogHeader>
        <DialogCloseButton />
        <DialogBody>
          <Text>
            ランダムに東方楽曲を再生します。以下のサービスから選択してください。
          </Text>
          <VStack spacing={4} mt={4}>
            <Button
              bg="#1DB954"
              color="white"
              width="100%"
              onClick={() =>
                handleLinkClick("https://random.touhou-search.com/spotify")
              }
            >
              Spotify
            </Button>
            <Button
              bg="#FA2D48"
              color="white"
              width="100%"
              onClick={() =>
                handleLinkClick("https://random.touhou-search.com/apple_music")
              }
            >
              Apple Music
            </Button>
            <Button
              bg="#00C300"
              color="white"
              width="100%"
              onClick={() =>
                handleLinkClick("https://random.touhou-search.com/line_music")
              }
            >
              LINE MUSIC
            </Button>
            <Button
              bg="#FF0000"
              color="white"
              width="100%"
              onClick={() =>
                handleLinkClick(
                  "https://random.touhou-search.com/youtube_music",
                )
              }
            >
              YouTube Music
            </Button>
          </VStack>
        </DialogBody>
        <DialogFooter>
          <Button colorScheme="gray" onClick={onClose}>
            閉じる
          </Button>
        </DialogFooter>
      </Dialog>
    </>
  );
}
