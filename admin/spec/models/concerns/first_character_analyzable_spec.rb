require 'rails_helper'

RSpec.describe FirstCharacterAnalyzable do
  let(:test_class) do
    Class.new do
      include FirstCharacterAnalyzable
      attr_accessor :name

      def initialize(name)
        @name = name
      end
    end
  end

  describe '#first_character_type' do
    subject { test_class.new(name).first_character_type }

    context '半角数字で始まる場合' do
      let(:name) { '1test' }
      it { is_expected.to eq 'number' }
    end

    context '全角数字で始まる場合' do
      let(:name) { '１test' }
      it { is_expected.to eq 'number' }
    end

    # その他の既存のケースもテストに追加することをお勧めします
    # 例：ひらがな、カタカナ、漢字、アルファベットなど
  end
end
