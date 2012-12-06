Charter::Application.config.allowed_tags_in_page_text = %w(h2 h3 p a br)
Charter::Application.config.allowed_tags_in_paragraph_text = %w()

Charter::Application.config.num_formats = { 
  linear: { precision: 2, unit: 'm' },
  area: { precision: 1, unit: 'qm' },
  volume: { precision: 0, unit: 'l' },
  mass: { precision: 3, unit: 't' }
}