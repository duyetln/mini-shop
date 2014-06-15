module SlimHelpers
  def render(name, options = {}, &block)
    Slim::Template.new("#{name}.slim", options).render(self, &block)
  end

  def include_js(path)
    "<script type='text/javascript' src='#{path}'></script>"
  end

  def include_css(path)
    "<link rel='stylesheet' type='text/css' href='#{path}'>"
  end

  def embed_scss(path)
    "<style type='text/css'>#{Sass::Engine.new(File.read(path), syntax: :scss, style: :compressed).render}</style>"
  end

  def number_with_currency(amount, currency)
    "#{currency.sign}#{sprintf('%.2f', amount)}"
  end
end
