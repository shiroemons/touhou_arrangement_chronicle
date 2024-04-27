# 東方編曲録　〜 Arrangement Chronicle

## セットアップ

```shell
make setup
```

## サーバー起動

```shell
make up
```

- 管理画面(Rails)
  - http://localhost:3000/
- Meilisearch
  - http://localhost:17700/
- フロントエンド
  - http://localhost:5173/

### ログ確認

```shell
make logs
```

#### 個別のログ確認

- 管理画面(Rails)
  ```shell
  make logs admin
  ```
  ```shell
  make logs admin-tailwind
  ```
- Meilisearch
  ```shell
  make logs meilisearch
  ```
- フロントエンド
  ```shell
  make logs frontend
  ```

### Meilisearch

- Meilisearchのvolumeを削除
  ```shell
  docker volume rm touhou_arrangement_chronicle_meili-data
  ```

#### Indexer

- Meilisearchにデータを登録する
```shell
make indexer
```
