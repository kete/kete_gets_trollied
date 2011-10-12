module OrdersHelperOverrides
  unless included_modules.include? OrdersHelperOverrides
    def can_trigger_fulfilled_without_acceptance?
      params[:controller] == 'orders' && at_least_a_moderator?
    end

    def can_trigger_finish?
      params[:controller] == 'orders' && at_least_a_moderator?
    end

    def link_to_orders_for(user)
      options = set_options_from_vars.merge({:user => user})
      link_to(user.trolley_user_display_name, options)
    end

    def link_to_state_unless_current(state, count)
      options = set_options_from_vars.merge({:state => state})
      link_to_unless_current(t("orders.index.#{state}") + show_count_for(count), options)
    end

    def orders_state_headline
      html = super
      if @current_basket != @site_basket
        html += ' ' + t('base.inside') + ' ' + @current_basket.name
      end
      html
    end

    # override ### TODO: this isn't overriding the default method
    def add_ons_logged_in_user_list
      link_html = super

      link_html += link_to_unless_current(t('base.your_cart'),
                                          { :user_id => current_user.id, :controller => :trolleys, :action => :show },
                                          { :tabindex => '2', :class => "trolley-button" })

      content_tag('li', link_html)
    end

    def set_options_from_vars
      options = url_for_options_for_orders_index
      options[:state] = @state if @state
      options[:from] = @from if @from
      options[:until] = @until if @until
      options[:user] = @user if @user
      options
    end

    def url_for_options_for_orders_index
      { :urlified_name => @current_basket.urlified_name,
        :controller => 'orders',
        :action => 'index' }
    end

    def meta_data_for(order)
      html = '<div id="order-meta-data">'
      html += '<h3 id="order-id">' + t('orders.helpers.order_number') + " #{order.id}"
      # TODO: move "order in" to I18n
      html += " ("
      if current_user == order.user && params[:controller] == 'trolleys'
        html += council_full_name_from(order.basket.name)
      else
        html += link_basket_orders(order.basket)
      end
      html += ')</h3>'
      if !order.current? && !(order.contact_name.blank? && order.contact_phone.blank?)
        html += '<h4 id="order-info">'
        html += order.contact_name + ' - ' if order.contact_name
        html += order.contact_phone if order.contact_phone
        html += '</h4>'
      end
      html += '</div>'
    end

    def link_basket_orders(basket)
      options = set_options_from_vars.merge({:urlified_name => basket.urlified_name})
      link_to(council_full_name_from(basket.name), options)
    end
    
    def clear_extra_params
      if @user || @from || @until
        options = set_options_from_vars

        to_be_cleared = [:user, :trolley, :from, :until]

        to_be_cleared.each { |key_sym| options.delete(key_sym) }

        clear_link = link_to(t("orders.helpers.clear_params"), options)

        clear_link = ' [ ' + clear_link + ' ]'
        content_tag('span', clear_link, :class => 'clear-params')
      end
    end

    def button_to_checkout(order)
      order_button_for('checkout', order,
                       { :method => 'get',
                         :target_action => 'checkout_form',
                         :url_for_options => { :urlified_name => @site_basket.urlified_name } })
    end

    def order_checkout_fields(form)
      html = '<div class="form-element">'
      html += "<label for=\"order_contact_name\">#{t('orders.helpers.contact_name')}</label>"
      html += form.text_field(:contact_name, { :tabindex => '1', :label => t('orders.helpers.contact_name')})
      # html += "<div class=\"form-example\">#{t('orders.helpers.contact_name_example')}</div>"
      html += '</div>'
      html += '<div class="form-element">'
      html += "<label for=\"order_contact_phone\">#{t('orders.helpers.contact_phone')}</label>"
      html += form.text_field(:contact_phone, { :tabindex => '1' })
      html += "<div class=\"form-example\">#{t('orders.helpers.contact_phone_example')}</div>"
      html += '</div>'
      html += '<div class="form-element">'
      html += '</div>'
      html
    end

    # order number
    # order user
    # council
    # number of line_items
    # date required by
    def link_to_as_summary_of(order, user = nil)
      link_text = t('orders.helpers.order_number') + " #{order.id}"
      link_text += " - #{user.trolley_user_display_name}" if user.present? && params[:controller] == 'orders'
      link_text += " - #{council_full_name_from(order.basket.name)}"
      link_text += " - (#{order.line_items.size} #{t 'orders.helpers.items'})" if order.line_items.size > 0
      link_text += " - #{order.updated_at.to_s(:db).split(' ')[0]}"

      link_to(link_text, url_for_order(:order => order))
    end

    def sorted_state_names
      [:in_process, :ready, :completed, :cancelled]
    end

    def checkout_form_target_action_url_hash
      {:action => 'checkout', :id => @order, :urlified_name => @site_basket.urlified_name}
    end
  end
end
