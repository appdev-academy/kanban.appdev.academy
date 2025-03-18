class TasksController < ApplicationController
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
    new_position = new_position.presence ? new_position.to_i : nil
    new_list_id = new_list_id.presence ? new_list_id.to_i : nil
    return unless new_position

    source_list = current_task.list
    destination_list = new_list_id ? List.find(new_list_id) : current_task.list
    same_list = source_list.id == destination_list.id
    current_task.update_columns(list_id: destination_list.id) unless same_list

    ordered_tasks_ids = destination_list.tasks.order(:position).pluck(:id)

    # Reposition current List
    ordered_tasks_ids.delete(current_task.id)
    ordered_tasks_ids.insert(new_position, current_task.id)
    ordered_tasks_ids.compact!

    new_positions = ordered_tasks_ids.each_with_index.to_h

    sql = <<-SQL
      UPDATE tasks
      SET position = CASE id
        #{new_positions.map { |id, position| "WHEN #{id} THEN #{position}" }.join("\n")}
      END
      WHERE id IN (#{new_positions.keys.join(",")})
    SQL

    ActiveRecord::Base.connection.execute(sql)

    return if same_list

    ordered_tasks_ids = source_list.tasks.order(:position).pluck(:id)
    new_positions = ordered_tasks_ids.each_with_index.to_h

    sql = <<-SQL
      UPDATE tasks
      SET position = CASE id
        #{new_positions.map { |id, position| "WHEN #{id} THEN #{position}" }.join("\n")}
      END
      WHERE id IN (#{new_positions.keys.join(",")})
    SQL

    ActiveRecord::Base.connection.execute(sql)
  end
end
