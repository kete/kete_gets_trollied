require 'kete_url_for'
module HasTrolleyControllerHelpersOverrides
  def self.included(klass)
    klass.send :include, UrlFor
    klass.send :include, KeteUrlFor
  end
  
  module UrlFor
    # expects user in options or @user or trolley being set
    # unless @purchasable_item is present
    # WARNING: in the case of @purchasable_item
    # this method name breaks the principle of least surprise
    # maybe alter trollied gem in future to come right
    def url_for_trolley(options = { })
      return url_for_dc_identifier(@purchasable_item) if @purchasable_item && params[:action] == 'create'

      user = options.delete(:user)
      trolley = options[:trolley] || @trolley || user.trolley

      if trolley.blank?
        user = @user
      else
        user = trolley.user
      end

      options[:user_id] = user.id
      options[:controller] = 'trolleys'
      options[:action] = 'show'
      options[:urlified_name] = Basket.site_basket.urlified_name

      url = url_for(options) # .split(".%23%")[0]
    end

    # expects order
    # either as instance variables or in options
    def url_for_order(options = { })
      trolley = options.delete(:trolley) || @trolley
      trolley = @order.trolley if @order

      order = options.delete(:order) || @order || trolley.selected_order
      
      options[:id] = order
      options[:controller] = 'orders'
      options[:action] = 'show'
      options[:urlified_name] = Basket.site_basket.urlified_name

      url_for options
    end

  end
end
