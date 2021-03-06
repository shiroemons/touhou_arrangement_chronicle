require 'rails_helper'

RSpec.describe SongArranger, type: :model do
  describe 'belongs_to' do
    it { is_expected.to belong_to(:song) }
    it { is_expected.to belong_to(:arranger) }
  end
end
