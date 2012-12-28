class CounterCacheLinkVisits < ActiveRecord::Migration
  def up
    add_column :links, :visits_count, :integer, default: 0
  end

  def down
    remove_column :links, :visits_count
  end
end
