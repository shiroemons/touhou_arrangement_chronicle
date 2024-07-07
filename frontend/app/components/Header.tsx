import { SignedIn, SignedOut, UserButton } from "@clerk/remix";
import { Link } from "@remix-run/react";
import { useLocation } from "@remix-run/react";
import { Moon, Sun } from "@yamada-ui/lucide";
import {
  Box,
  Button,
  Flex,
  IconButton,
  List,
  ListItem,
  Spacer,
  useColorMode,
} from "@yamada-ui/react";
import type { JSX } from "react";

export default function Header() {
  const location = useLocation();
  const { colorMode, toggleColorMode } = useColorMode();

  const isAuthPage =
    location.pathname.startsWith("/sign-in") ||
    location.pathname.startsWith("/sign-up");
  let signedOut: JSX.Element | null;
  if (isAuthPage) {
    signedOut = null;
  } else {
    signedOut = (
      <SignedOut>
        <Flex alignItems="center" gap={4}>
          <ListItem>
            <Button colorScheme="secondary" variant="ghost">
              <Link to="/sign-in">サインイン</Link>
            </Button>
          </ListItem>
          <ListItem>
            <Button colorScheme="primary">
              <Link to="/sign-up">サインアップ</Link>
            </Button>
          </ListItem>
        </Flex>
      </SignedOut>
    );
  }

  return (
    <Box className="navbar bg-base-100" padding={4}>
      <Flex alignItems="center">
        <Box>
          <Link to="/" className="btn btn-ghost text-xl">
            東方編曲録
          </Link>
        </Box>
        <Spacer />
        <Flex alignItems="center" gap={4}>
          <IconButton
            icon={colorMode === "light" ? <Moon /> : <Sun />}
            aria-label="Toggle dark mode"
            variant="primary"
            onClick={toggleColorMode}
          />
          <List
            styleType="none"
            display="flex"
            alignItems="center"
            px={1}
            gap={4}
          >
            <SignedIn>
              <ListItem>
                <UserButton />
              </ListItem>
            </SignedIn>
            {signedOut}
          </List>
        </Flex>
      </Flex>
    </Box>
  );
}
