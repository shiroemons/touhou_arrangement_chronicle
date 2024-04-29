import { useUser } from "@clerk/remix";

export default function Example() {
  const { isLoaded, isSignedIn, user } = useUser();

  if (!isLoaded || !isSignedIn) {
    return null;
  }

  return (
    <div>
      Hello, {user.firstName} welcome to Clerk
      <p>id: {user.id}</p>
      <p>external id: {user.externalId}</p>
      <p>email: {user.primaryEmailAddress?.emailAddress}</p>
      <p>username: {user.username}</p>
      <p>full name: {user.fullName}</p>
      <p>first name: {user.firstName}</p>
      <p>last name: {user.lastName}</p>
    </div>
  );
}
