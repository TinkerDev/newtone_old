class MoveArtistToOwnModel < ActiveRecord::Migration
  def change
    Track.destroy_all
    remove_index :tracks, :artist
    remove_column :tracks, :artist
    add_column :tracks, :artist_id, :integer, :null => false
    add_index :tracks, :artist_id
  end
end
