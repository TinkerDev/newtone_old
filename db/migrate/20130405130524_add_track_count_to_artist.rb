class AddTrackCountToArtist < ActiveRecord::Migration
  def change
    add_column :artists, :tracks_count, :integer, :null => false, :default => 0
    add_index :artists, :tracks_count
  end
end
