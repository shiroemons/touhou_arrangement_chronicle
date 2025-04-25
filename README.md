# touhou_arrangement_chronicle

## Drizzleを使用したデータベーススキーマの更新

フロントエンドでDrizzle ORMを使用してデータベーススキーマを更新するには、以下のコマンドを使用します：

### データベーススキーマの解析

既存のデータベースからスキーマ定義を解析するには、以下のコマンドを使用します：

```bash
make drizzle-introspect
```

このコマンドは、PostgreSQLデータベースからスキーマを解析し、`frontend/drizzle/schema.ts`と`frontend/drizzle/relations.ts`ファイルを更新します。また、PostgreSQL関数（gen_random_uuid()など）を自動的に修正します。

### スキーマの取得

データベースからスキーマ定義を取得するには、以下のコマンドを使用します：

```bash
make drizzle-pull
```

このコマンドは、PostgreSQLデータベースからスキーマを取得し、SQLファイルとともにDrizzleのスキーマ定義を更新します。また、PostgreSQL関数（gen_random_uuid()など）を自動的に修正します。

### スキーマの手動修正

通常は自動的に修正されますが、必要に応じて手動でスキーマ修正を実行できます：

```bash
make drizzle-fix-schema
```

このコマンドは、`gen_random_uuid()`関数の呼び出しを`sql`タグ付きテンプレートリテラル（`sql\`gen_random_uuid()\``）に変換します。

### 注意事項

- スキーマの更新は、`frontend/app/schema/index.ts`ファイルを基に行われます
- データベース接続設定は`frontend/drizzle.config.ts`で管理されています
- PostgreSQLのgen_random_uuid()などの関数を使用する場合は、スキーマ定義で次のように記述する必要があります：

```typescript
// sqlタグ付きテンプレートリテラルを使用
import { sql } from 'drizzle-orm';

// 正しい使用法
slug: text('slug').default(sql`gen_random_uuid()`).notNull(),

// 誤った使用法（エラーになります）
slug: text('slug').default(gen_random_uuid()).notNull(),
```