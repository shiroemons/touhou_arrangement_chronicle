import type { Config } from 'drizzle-kit';
import { parse } from 'pg-connection-string';

// DATABASE_URLがある場合はそれをパースして使用
const connectionConfig = process.env.DATABASE_URL
  ? parse(process.env.DATABASE_URL)
  : null;

export default {
  schema: './app/schema/index.ts',
  out: './drizzle',
  dialect: 'postgresql',
  dbCredentials: connectionConfig
    ? {
        host: connectionConfig.host || 'localhost',
        port: connectionConfig.port ? parseInt(connectionConfig.port) : 15432,
        user: connectionConfig.user || 'postgres',
        database: connectionConfig.database || 'touhou_arrangement_chronicle_development',
        ssl: false,
      }
    : {
        host: process.env.POSTGRES_HOST || 'postgres17',
        port: parseInt(process.env.POSTGRES_PORT || '5432', 10),
        user: process.env.POSTGRES_USER || 'postgres',
        database: 'touhou_arrangement_chronicle_development',
        ssl: false,
      },
  // 既存のテーブルからスキーマを生成するための設定
  // PostgreSQL関数（gen_random_uuid()など）を使用する場合は、
  // schema/index.tsで import { sql } from 'drizzle-orm'; を使って
  // .default(sql`gen_random_uuid()`) のように記述する必要があります
  introspect: {
    casing: 'preserve',
  },
  // マイグレーションは使用しない
  verbose: true,
  strict: true,
} satisfies Config; 