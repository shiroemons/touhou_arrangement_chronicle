import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from '../schema';

// PostgreSQLへの接続設定
// DATABASE_URLが設定されている場合はそれを使用し、そうでない場合は個別の接続パラメータを使用
const pool = process.env.DATABASE_URL
  ? new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: false,
    })
  : new Pool({
      host: process.env.POSTGRES_HOST || 'localhost',
      port: parseInt(process.env.POSTGRES_PORT || '15432', 10),
      user: process.env.POSTGRES_USER || 'postgres',
      database: process.env.POSTGRES_DB || 'touhou_arrangement_chronicle_development',
      ssl: false,
    });

// Drizzle ORMのインスタンスを作成し、スキーマを関連付け
export const db = drizzle(pool, { schema }); 