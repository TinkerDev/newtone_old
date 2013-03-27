ActiveAdmin.register Track do
  index do
    column :artist
    column :title
    column :release
    column :genre
    column :duration do |track|
      minutes = track.duration / 60
      seconds = track.duration % 60
      format("%02d:%02d", minutes, seconds)
    end
    column :version
    default_actions
  end
end
