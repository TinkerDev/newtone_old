class AddFieldsToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :track_id, :string
    add_column :tracks, :artist, :string
    add_column :tracks, :title, :string
    add_column :tracks, :release, :string
    add_column :tracks, :genre, :string
    add_column :tracks, :version, :string
    add_index :tracks, :artist
    add_index :tracks, :title
  end
end
