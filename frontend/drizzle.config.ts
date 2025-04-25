import type { Config } from 'drizzle-kit';

export default {
  schema: './app/schema/index.ts',
  out: './drizzle',
  dialect: 'postgresql',
  dbCredentials: {
    host: process.env.POSTGRES_HOST || 'localhost',
    port: parseInt(process.env.POSTGRES_PORT || '15432', 10),
    user: process.env.POSTGRES_USER || 'postgres',
    database: process.env.POSTGRES_DB || 'touhou_arrangement_chronicle_development',
    ssl: false,
  },
  // 既存のテーブルからスキーマを生成するための設定
  introspect: {
    casing: 'preserve',
  },
  // マイグレーションは使用しない
  verbose: true,
  strict: true,
} satisfies Config; 