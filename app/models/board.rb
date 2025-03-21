# == Schema Information
#
# Table name: boards
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Board < ApplicationRecord
  after_create_commit :broadcast_updates
  after_update_commit :broadcast_updates
  after_destroy_commit :broadcast_updates

  scope :ordered, -> { order(:name) }

  has_many :lists, -> { order(:position) }, dependent: :destroy

  def lists_channel
    "boards_#{id}_lists"
  end

  private

  def broadcast_updates
    broadcast_update_to 'boards', target: 'boards', partial: 'boards/list', locals: { boards: Board.ordered }
  end
end
