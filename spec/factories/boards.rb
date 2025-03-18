# == Schema Information
#
# Table name: boards
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :board do
    name { "Board ##{Faker::Number.decimal_part(digits: 3)}" }
  end
end
