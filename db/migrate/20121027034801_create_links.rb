class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :original_url
      t.string :slug

      t.timestamps
    end
  end
end
