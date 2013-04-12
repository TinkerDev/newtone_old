class Artist < ActiveRecord::Base
  attr_accessible :name, :tracks_count
  has_many :tracks
end
