module TemplateHelper
  def block_link_to(url, html_options = {})
    html_options[:class] = "block-link #{html_options[:class]}"
    link_to(url, html_options) do
      yield      
    end
  end
end