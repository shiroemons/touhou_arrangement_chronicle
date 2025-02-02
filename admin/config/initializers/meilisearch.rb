MeiliSearch::Rails.configuration = {
  meilisearch_url: ENV.fetch("MEILI_HOST", "http://localhost:7700"),
  meilisearch_api_key: ENV.fetch("MEILI_MASTER_KEY", "masterKey")
}
