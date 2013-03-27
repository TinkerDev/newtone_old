class AddIndexToTrackId < ActiveRecord::Migration
  def change
    add_index :tracks, :track_id, :unique => true
  end
end
