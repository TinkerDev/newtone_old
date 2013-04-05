ActiveAdmin.register Artist do
  index do
    column :name
    column :tracks_count
    default_actions
  end
end
