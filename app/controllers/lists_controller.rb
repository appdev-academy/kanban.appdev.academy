class ListsController < ApplicationController
  include UpsertPositions

  before_action :set_board, only: [:new, :create]
  before_action :set_list, only: [:edit, :update, :destroy]

  # @route GET /boards/:board_id/lists/new (new_board_list)
  def new
    @list = @board.lists.build
  end

  # @route GET /lists/:id/edit (edit_list)
  def edit
  end

  # @route POST /boards/:board_id/lists (board_lists)
  def create
    @list = @board.lists.build(list_params.except(:position))
    @list.position = @board.lists.count

    if @list.save
      broadcast_updates_to_board

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update('modal', '') }
        format.html { head :ok }
      end
    else
      render :new
    end
  end

  # @route PATCH /lists/:id (list)
  # @route PUT /lists/:id (list)
  def update
    if @list.update!(list_params.except(:position))
      update_lists_positions(@list, list_params[:position])
      broadcast_updates_to_board

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update('modal', '') }
        format.html { head :ok }
      end
    else
      render :edit
    end
  end

  # @route DELETE /lists/:id (list)
  def destroy
    @list.destroy!
    broadcast_updates_to_board

    head :ok
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

  def broadcast_updates_to_board
    board = @list.board
    Turbo::StreamsChannel.broadcast_update_to board.lists_channel, target: board.lists_channel, partial: 'lists/lists', locals: { board: board }
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
