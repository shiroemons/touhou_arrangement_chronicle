# frozen_string_literal: true

require_relative "../importers/albums_importer"

namespace :import do
  desc "Import albums from JSON file"
  task :albums, [ :json_path ] => :environment do |_, args|
    json_path = args[:json_path] || "tmp/albums.json"

    begin
      puts "Importing albums from #{json_path}..."
      AlbumsImporter.import(json_path)
      puts "Import completed successfully!"
    rescue => e
      puts "Error during import: #{e.message}"
      puts e.backtrace
      raise e
    end
  end
end
