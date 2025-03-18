require 'rails_helper'

RSpec.describe Board, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:lists).dependent(:destroy) }
  end
end
