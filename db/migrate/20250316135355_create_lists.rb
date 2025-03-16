class CreateLists < ActiveRecord::Migration[8.0]
  def change
    create_table :lists do |t|
      t.string :name, null: false
      t.integer :position, null: false
      t.references :board, null: false, foreign_key: true
      t.timestamps
    end
  end
end
