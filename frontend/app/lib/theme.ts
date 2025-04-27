import { useState, useEffect } from "react";

// テーマタイプの定義
type Theme = "dark" | "light" | "system";

// テーマプロバイダーのために状態を管理する
function useTheme() {
  const [theme, setTheme] = useState<Theme>(() => {
    // ローカルストレージからテーマ設定を取得
    if (typeof window !== "undefined") {
      const savedTheme = localStorage.getItem("theme") as Theme;
      return savedTheme || "system";
    }
    return "system";
  });

  // テーマの切り替え処理
  const setThemeAndStore = (newTheme: Theme) => {
    setTheme(newTheme);
    
    if (typeof window !== "undefined") {
      localStorage.setItem("theme", newTheme);
    }
  };

  // システムの設定に基づいてテーマを適用する
  useEffect(() => {
    const root = window.document.documentElement;
    
    // テーマに基づいてクラスを設定
    if (theme === "system") {
      const systemTheme = window.matchMedia("(prefers-color-scheme: dark)").matches
        ? "dark"
        : "light";
      
      root.classList.remove("light", "dark");
      root.classList.add(systemTheme);
    } else {
      root.classList.remove("light", "dark");
      root.classList.add(theme);
    }
  }, [theme]);

  // システムのテーマ変更を監視
  useEffect(() => {
    if (theme === "system") {
      const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
      
      const handleChange = () => {
        const root = window.document.documentElement;
        const systemTheme = mediaQuery.matches ? "dark" : "light";
        
        root.classList.remove("light", "dark");
        root.classList.add(systemTheme);
      };

      mediaQuery.addEventListener("change", handleChange);
      return () => mediaQuery.removeEventListener("change", handleChange);
    }
  }, [theme]);

  return { theme, setTheme: setThemeAndStore };
}

export { useTheme };
export type { Theme }; 