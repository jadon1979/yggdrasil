class CreateBirds < ActiveRecord::Migration[7.0]
  def change
    create_table :birds do |t|
      t.integer :node_id, index: true
      t.timestamps
    end

    add_foreign_key :birds, :nodes, column: :node_id
  end
end
