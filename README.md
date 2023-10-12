# touhou_arrangement_chronicle
東方編曲録　〜 Arrangement Chronicle

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
