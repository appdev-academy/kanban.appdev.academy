require 'rails_helper'

RSpec.describe List, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
    it { is_expected.to belong_to(:board) }
  end
end
