# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


board_number = (Board.maximum(:id) || 0) + 1
board = Board.create!(name: "Board ##{board_number}")

5.times do |list_index|
  list = board.lists.create!(name: "List ##{list_index+1}", position: list_index)

  8.times do |task_index|
    list.tasks.create!(name: "Task ##{list_index+1}.#{task_index+1}", position: task_index)
  end
end
