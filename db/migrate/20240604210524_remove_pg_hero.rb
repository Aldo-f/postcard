class RemovePgHero < ActiveRecord::Migration[7.0]
  def change
    drop_table :pghero_query_stats
    drop_table :pghero_space_stats
  end
end
