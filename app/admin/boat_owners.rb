ActiveAdmin.register BoatOwner do
  menu parent: I18n.t("boat_data")

  filter :name

  index do
    column :name
    column(:is_self) do |o|
      status_tag (o.is_self ? "ja" : "nein"),
        (o.is_self ? :ok : :error)
    end
    default_actions
  end

  show do |o|
    attributes_table do
      row :name
      row(:is_self) do
        status_tag (o.is_self ? "ja" : "nein"),
          (o.is_self ? :ok : :error)
      end
    end
  end

  form do |f|
    f.inputs :name, :is_self
    f.actions
  end
end
