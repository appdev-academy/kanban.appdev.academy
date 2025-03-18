class ListsController < ApplicationController
  include UpsertPositions

  before_action :set_board, only: :create
  before_action :set_list, only: [:update, :destroy]

  # @route POST /boards/:board_id/lists (board_lists)
  def create
  end

  # @route PATCH /lists/:id (list)
  # @route PUT /lists/:id (list)
  def update
    @list.update!(list_params.except(:position))
    update_lists_positions(@list, list_params[:position])

    head :ok
  end

  # @route DELETE /lists/:id (list)
  def destroy
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :position)
  end

  def update_lists_positions(current_list, new_position)
    return unless new_position

    # Reposition current List
    ordered_lists_ids = current_list.board.lists.order(:position).pluck(:id)
    ordered_lists_ids.delete(current_list.id)
    ordered_lists_ids.insert(new_position.to_i, current_list.id)
    ordered_lists_ids.compact!

    new_positions = ordered_lists_ids.each_with_index.to_h
    upsert_positions(List, new_positions)
  end
end
