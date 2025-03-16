class TasksController < ApplicationController
  before_action :set_list

  # @route PATCH /boards/:board_id/lists/:list_id/tasks/sort (sort_board_list_tasks)
  def sort
    params[:task].each_with_index do |id, index|
      Task.where(id: id).update_all(position: index)
    end
    head :ok
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end
end
