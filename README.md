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

### Indexer

```shell
make indexer
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
