class ListsController < ApplicationController
  before_action :set_board

  # @route PATCH /boards/:board_id/lists/sort (sort_board_lists)
  def sort
    params[:list].each_with_index do |id, index|
      List.where(id: id).update_all(position: index)
    end
    head :ok
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end
end
