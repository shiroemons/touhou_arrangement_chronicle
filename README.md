# touhou_arrangement_chronicle
東方編曲録　〜 Arrangement Chronicle

## セットアップ

### DBセットアップ

#### 初回のみ

- DB起動
  ```shell
  make db-up
  ```
- 初期設定
  ```shell
  make db-setup
  ```

#### Migration

```shell
make migrate
```

### Seeder

```shell
make seeder
```

### Importer

```shell
make importer
```

## サーバー起動

```shell
make up
```

- 管理画面(Rails)
  - http://localhost:3000/
- Meilisearch
  - http://localhost:17700/

### ログ確認

```shell
make logs
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
