namespace :meilisearch do
  desc "Reindex all songs"
  task reindex_songs: :environment do
    puts "Reindexing songs..."
    Song.reindex!
    puts "Done!"
  end
end
