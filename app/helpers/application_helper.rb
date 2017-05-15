module ApplicationHelper
  def cents_to_currency(cents)
    number_to_currency cents / 100, precision: 0
  end

  def css_content
    filenames = %W(application #{controller_name}/#{action_name})
    filenames.map do |filename|
      Rails.application.assets[filename].to_s
    end.join
  end

  def header(text)
    content_for(:title) { text }
    content_tag(:h1, text)
  end

  def retina_image_tag(path, options = {})
    extension   = File.extname(path)
    retina_path = path.sub(/#{extension}\z/, "@2x#{extension}")

    image_tag path, options.merge(srcset: "#{image_path(retina_path)} 2x")
  end

  def title
    parts = [content_for(:title), "Fadeaway"].compact
    parts.join(" &#8212; ").html_safe # rubocop:disable Rails/OutputSafety
  end
end
