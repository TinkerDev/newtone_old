ActiveAdmin.register Track do
  index do
    column :artist
    column :title
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :track_file
      f.input :artist
      f.input :title
      f.input :release
      f.input :genre
    end

    f.buttons
  end

end
