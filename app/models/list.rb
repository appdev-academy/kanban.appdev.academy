# == Schema Information
#
# Table name: lists
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  position   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  board_id   :integer          not null
#
# Indexes
#
#  index_lists_on_board_id  (board_id)
#
# Foreign Keys
#
#  fk_rails_...  (board_id => boards.id)
#
class List < ApplicationRecord
  has_many :tasks, -> { order(:position) }, dependent: :destroy
  belongs_to :board

  def broadcast_updates
    Turbo::StreamsChannel.broadcast_update_to board.lists_channel, target: board.lists_channel, partial: 'lists/lists', locals: { lists: @board.lists }
  end
end
