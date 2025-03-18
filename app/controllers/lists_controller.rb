class ListsController < ApplicationController
  before_action :set_board, only: :create
  before_action :set_list, only: [:update, :destroy]

  # @route POST /boards/:board_id/lists (board_lists)
  def create
  end

  # @route PATCH /lists/:id (list)
  # @route PUT /lists/:id (list)
  def update
    @list.update!(list_params.except(:position))
    update_lists_positions(@list, list_params[:position].to_i) if list_params[:position].presence

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
    ordered_lists_ids = current_list.board.lists.order(:position).pluck(:id)

    # Normalize :new_position
    lists_count = ordered_lists_ids.length
    new_position = 0 if new_position < 0
    new_position = (lists_count - 1) if new_position >= lists_count

    # Reposition current List
    ordered_lists_ids.delete(current_list.id)
    ordered_lists_ids.insert(new_position, current_list.id)

    new_positions = ordered_lists_ids.each_with_index.to_h

    sql = <<-SQL
      UPDATE lists
      SET position = CASE id
        #{new_positions.map { |id, position| "WHEN #{id} THEN #{position}" }.join("\n")}
      END
      WHERE id IN (#{new_positions.keys.join(",")})
    SQL

    ActiveRecord::Base.connection.execute(sql)
  end
end
