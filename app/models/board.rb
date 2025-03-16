# == Schema Information
#
# Table name: boards
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Board < ApplicationRecord
  after_create_commit  -> { broadcast_update_to 'boards', target: 'boards', partial: 'boards/list', locals: { boards: Board.ordered } }
  after_update_commit  -> { broadcast_update_to 'boards', target: 'boards', partial: 'boards/list', locals: { boards: Board.ordered } }
  after_destroy_commit -> { broadcast_update_to 'boards', target: 'boards', partial: 'boards/list', locals: { boards: Board.ordered } }

  scope :ordered, -> { order(:name) }
end
