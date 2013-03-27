class MakeDurationBeInt < ActiveRecord::Migration
  def change
    remove_column :tracks, :duration
    add_column :tracks, :duration, :integer
  end
end
