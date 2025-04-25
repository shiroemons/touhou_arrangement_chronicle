# Welcome to React Router!

A modern, production-ready template for building full-stack React applications using React Router.

[![Open in StackBlitz](https://developer.stackblitz.com/img/open_in_stackblitz.svg)](https://stackblitz.com/github/remix-run/react-router-templates/tree/main/default)

## Features

- 🚀 Server-side rendering
- ⚡️ Hot Module Replacement (HMR)
- 📦 Asset bundling and optimization
- 🔄 Data loading and mutations
- 🔒 TypeScript by default
- 🎉 TailwindCSS for styling
- 📖 [React Router docs](https://reactrouter.com/)

## Getting Started

### Installation

Install the dependencies:

```bash
npm install
```

### Development

Start the development server with HMR:

```bash
npm run dev
```

Your application will be available at `http://localhost:5173`.

## Building for Production

Create a production build:

```bash
npm run build
```

## Deployment

### Docker Deployment

To build and run using Docker:

```bash
docker build -t my-app .

# Run the container
docker run -p 3000:3000 my-app
```

The containerized application can be deployed to any platform that supports Docker, including:

- AWS ECS
- Google Cloud Run
- Azure Container Apps
- Digital Ocean App Platform
- Fly.io
- Railway

### DIY Deployment

If you're familiar with deploying Node applications, the built-in app server is production-ready.

Make sure to deploy the output of `npm run build`

```
├── package.json
├── package-lock.json (or pnpm-lock.yaml, or bun.lockb)
├── build/
│   ├── client/    # Static assets
│   └── server/    # Server-side code
```

## Styling

This template comes with [Tailwind CSS](https://tailwindcss.com/) already configured for a simple default starting experience. You can use whatever CSS framework you prefer.

## Drizzle ORMを使用したデータベース接続

フロントエンドからPostgreSQLデータベースに接続するために、Drizzle ORMを使用しています。

### セットアップ済みのファイル

- `app/schema/index.ts` - PostgreSQLのテーブル定義
- `app/services/db.server.ts` - データベース接続設定
- `drizzle.config.ts` - Drizzle ORMの設定ファイル

### 設定について

PostgreSQL接続には以下の環境変数を使用します（すべてオプション、デフォルト値あり）：

- `POSTGRES_HOST` - ホスト名（デフォルト: localhost）
- `POSTGRES_PORT` - ポート番号（デフォルト: 15432）
- `POSTGRES_USER` - ユーザー名（デフォルト: postgres）
- `POSTGRES_PASSWORD` - パスワード（デフォルト: 空文字）
- `POSTGRES_DB` - データベース名（デフォルト: touhou_arrangement_chronicle_development）

## データベーススキーマの更新方法

### 重要: フロントエンドからのマイグレーションについて

**フロントエンドからはデータベースマイグレーションを実行しません。** マイグレーションはバックエンド（Rails）側で管理されます。フロントエンド側では既存のデータベーススキーマを参照するためのTypeScript定義のみを生成・使用します。

### 既存DBのテーブル情報を取得する方法

Drizzle ORMは`drizzle-kit`を使って既存のデータベースからテーブル情報を取得（イントロスペクション）し、SQLファイルを生成できます。

```bash
# 既存のデータベースからスキーマを取得してSQLファイルを生成
npx drizzle-kit introspect:pg

# 特定の接続情報を指定する場合
npx drizzle-kit introspect:pg --connectionString "postgresql://username:password@host:port/database"
```

これにより`frontend/drizzle`ディレクトリに`0000_chubby_tombstone.sql`のようなSQLファイルが生成されます。**このファイルは参照用であり、編集しないでください。**

### SQLファイルからTypeScriptスキーマ定義を生成する

生成されたSQLファイルからTypeScriptのスキーマ定義を作成するには以下のコマンドを実行します：

```bash
# SQLファイルからTypeScriptスキーマを生成
npx drizzle-kit generate:pg
```

これで`app/schema`ディレクトリにTypeScriptの型定義が生成され、アプリケーションで型安全にデータベースにアクセスできるようになります。

### スキーマの更新手順

データベーススキーマが変更された場合は、以下の手順で型定義を更新します：

1. バックエンド側でマイグレーションが実行されたことを確認
2. `npx drizzle-kit introspect:pg`を実行して最新のスキーマ情報を取得
3. `npx drizzle-kit generate:pg`を実行してTypeScript定義を更新

**注意:** フロントエンドからはデータベース構造を変更せず、常に最新のスキーマに合わせた型定義の更新のみを行います。

---

Built with ❤️ using React Router.
