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
- `app/services/songs.server.ts` - 曲情報を取得するサービス
- `drizzle.config.ts` - Drizzle ORMの設定ファイル

### 設定について

PostgreSQL接続には以下の環境変数を使用します（すべてオプション、デフォルト値あり）：

- `POSTGRES_HOST` - ホスト名（デフォルト: postgres17）
- `POSTGRES_PORT` - ポート番号（デフォルト: 5432）  
- `POSTGRES_USER` - ユーザー名（デフォルト: postgres）
- `POSTGRES_PASSWORD` - パスワード（デフォルト: 空文字）
- `POSTGRES_DB` - データベース名（デフォルト: touhou_arrangement_chronicle_development）

### 使用方法

データベースからデータを取得するには以下のようにします：

```typescript
import { db } from '../services/db.server';
import { songs } from '../schema';

// 曲一覧を取得する例
const songList = await db.select().from(songs).limit(10);
```

より詳しい使い方は `app/services/songs.server.ts` を参照してください。

---

Built with ❤️ using React Router.
