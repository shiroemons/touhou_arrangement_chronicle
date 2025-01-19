# テスト用のヘルパーメソッドを追加
module FactoryBot
  module Syntax
    module Methods
      def create_album_with_full_associations
        create(:album, :with_prices, :with_genres, :with_artists) do |album|
          create(:album_disc, :with_songs, album: album)
        end
      end
    end
  end
end
