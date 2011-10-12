ApplicationHelper.module_eval do
  # in application layout
  # override in your add-on to add to it
  def add_ons_logged_in_user_list
    link_html = link_to_unless_current("Cart",
                                       url_for_trolley(:user => current_user),
                                       { :tabindex => '2', :class => "trolley-button" })

    content_tag('li', link_html)
  end

  # in application layout
  # override in your add-on to add to it
  def add_ons_basket_admin_list
    "| " + link_to_unless_current('orders',
                                  { :controller => :orders,
                                    :action => :index,
                                    :urlified_name => @current_basket.urlified_name},
                                  :tabindex => '2')
  end

  def add_ons_site_admin_list
    "| " + link_to_unless_current('all orders for site',
                                  { :controller => :orders,
                                    :action => :index,
                                    :urlified_name => @site_basket.urlified_name},
                                  :tabindex => '2')
  end

end
