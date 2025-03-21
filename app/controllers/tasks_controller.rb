class TasksController < ApplicationController
  include UpsertPositions

  before_action :set_list, only: :create
  before_action :set_task, only: [:update, :destroy]

  # @route POST /lists/:list_id/tasks (list_tasks)
  def create
  end

  # @route PATCH /tasks/:id (task)
  # @route PUT /tasks/:id (task)
  def update
    @task.update!(task_params.except(:position, :list_id))
    update_tasks_positions(@task, task_params[:position], task_params[:list_id])

    board = @task.list.board
    Turbo::StreamsChannel.broadcast_update_to board.lists_channel, target: board.lists_channel, partial: 'lists/lists', locals: { lists: board.lists }

    head :ok
  end

  # @route DELETE /tasks/:id (task)
  def destroy
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :position, :list_id)
  end

  def update_tasks_positions(current_task, new_position, new_list_id)
    return unless new_position

    source_list = current_task.list
    destination_list = new_list_id ? List.find(new_list_id) : current_task.list
    same_list = source_list.id == destination_list.id

    # Can safely update List for Tasks if it has changed
    current_task.update_columns(list_id: destination_list.id) unless same_list

    # Change positions of Tasks in destination List
    ordered_tasks_ids = destination_list.tasks.order(:position).pluck(:id)
    ordered_tasks_ids.delete(current_task.id)
    ordered_tasks_ids.insert(new_position.to_i, current_task.id)
    ordered_tasks_ids.compact!

    new_positions = ordered_tasks_ids.each_with_index.to_h
    upsert_positions(Task, new_positions)

    return if same_list

    # Change positions of Tasks in original List
    ordered_tasks_ids = source_list.tasks.order(:position).pluck(:id)
    new_positions = ordered_tasks_ids.each_with_index.to_h
    upsert_positions(Task, new_positions)
  end
end
