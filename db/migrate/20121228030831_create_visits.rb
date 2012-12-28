class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :link_id

      t.timestamps
    end
    add_index :visits, :link_id
  end
end
