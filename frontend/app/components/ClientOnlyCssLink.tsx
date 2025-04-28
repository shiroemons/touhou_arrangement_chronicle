import { useEffect } from "react";
import appStylesHref from "../app.css?url";

export function ClientOnlyCssLink() {
  useEffect(() => {
    const link = document.createElement("link");
    link.rel = "stylesheet";
    link.href = appStylesHref;
    document.head.appendChild(link);
    return () => {
      document.head.removeChild(link);
    };
  }, []);
  return null;
} 