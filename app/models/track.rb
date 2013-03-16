class Track < ActiveRecord::Base
  attr_accessible :track_file
  mount_uploader :track_file, TrackUploader
end
