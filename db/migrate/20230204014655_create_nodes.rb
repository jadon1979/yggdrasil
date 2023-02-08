class CreateNodes < ActiveRecord::Migration[7.0]
  def change
    create_table :nodes do |t|
      t.integer :node_id, index: true, null: false
      t.integer :parent_id, index: true
      t.timestamps
    end
  end
end
