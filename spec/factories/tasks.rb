# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  position   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  list_id    :integer          not null
#
# Indexes
#
#  index_tasks_on_list_id  (list_id)
#
# Foreign Keys
#
#  list_id  (list_id => lists.id)
#
FactoryBot.define do
  factory :task do
    name { "Task ##{Faker::Number.decimal_part(digits: 3)}" }
  end
end
