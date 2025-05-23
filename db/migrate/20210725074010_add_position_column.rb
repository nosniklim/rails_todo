class AddPositionColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :position, :integer
  end

  def change
    add_column :lists, :position, :integer, null: false, default: 0
    add_column :cards, :position, :integer, null: false, default: 0
  end
end
