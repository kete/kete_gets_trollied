module LineItemsHelperOverrides
  unless included_modules.include? LineItemsHelperOverrides
    def link_to_purchasable_in(line_item)
      item = line_item.purchasable_item
      link_to item.description_for_purchasing, :controller => zoom_class_controller(item.class.name),
      :urlified_name => item.basket.urlified_name,
      :action => :show, :id => item
    end
  end
end
