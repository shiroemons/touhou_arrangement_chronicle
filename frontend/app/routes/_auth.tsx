import { Outlet } from "@remix-run/react";

export default function Auth() {
  return (
    <div className="h-[calc(100vh-74px)] w-screen flex items-center justify-center">
      <Outlet />
    </div>
  );
}
