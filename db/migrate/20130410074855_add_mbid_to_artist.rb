class AddMbidToArtist < ActiveRecord::Migration
  def change
    Artist.destroy_all
    add_column :artists, :mbid, :string
    add_index :artists, :mbid
  end
end
