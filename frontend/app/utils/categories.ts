/**
 * お知らせカテゴリーのマッピング定義
 * 
 * admin/app/models/news.rbのCATEGORIESと一致するように定義
 */
export const NEWS_CATEGORY_LABELS: Record<string, string> = {
  "update": "更新情報",
  "maintenance": "メンテナンス情報",
  "event": "イベント情報",
  "other": "その他"
};

/**
 * カテゴリーごとの色の定義
 * key: カテゴリーコード
 * value: テキスト色とバックグラウンド色のクラス名
 */
export const NEWS_CATEGORY_COLORS: Record<string, { bg: string; text: string }> = {
  "update": { bg: "bg-blue-100", text: "text-blue-800" },
  "maintenance": { bg: "bg-amber-100", text: "text-amber-800" },
  "event": { bg: "bg-green-100", text: "text-green-800" },
  "other": { bg: "bg-gray-100", text: "text-gray-800" }
}; 