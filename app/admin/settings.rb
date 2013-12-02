ActiveAdmin.register Setting do
  config.filters = false
  config.sort_order = 'key_asc'

  actions :all, except: [:destroy]

  index do
    column(:key) { |s| I18n.t("activerecord.models.setting.#{s.key}") }
    column :value
    default_actions
  end

  show title: :key do |s|
    attributes_table do
      row(:key) { |s| I18n.t("activerecord.models.setting.#{s.key}") }
      row :value
    end
  end

  form do |f|
    f.inputs do
      f.input :key, input_html: { disabled: true }
      f.input :value
    end
    f.actions
  end
end
