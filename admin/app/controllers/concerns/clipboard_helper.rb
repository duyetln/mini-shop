module ClipboardHelper
  def clipboard
    session[:clipboard] ||= {}
  end

  [
    :pricepoints,
    :discounts,
    :prices,
    :physical_items,
    :digital_items,
    :bundles
  ].each do |resource|
    define_method "clipboard_#{resource}" do
      session[resource] ||= []
    end
  end
end
