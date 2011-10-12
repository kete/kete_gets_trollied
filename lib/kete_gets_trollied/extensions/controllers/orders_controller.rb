OrdersController.class_eval do
  before_filter :authorize_trollied_action

  alias_method :original_default_conditions_hash, :default_conditions_hash
  def default_conditions_hash
    hash = original_default_conditions_hash
    if @current_basket != @site_basket
      hash[:basket_id] = @current_basket.id
    end
    hash
  end

   def set_defaults_for_order_checkout
     return if @order.contact_name.present? && @order.contact_phone.present?

     trolley = @trolley || current_user.trolley
     # opted for two queries rather than one combined query
     # and pulling apart latest values from multiple results
     # WARNING: mysql specific select distinct syntax
     previous_contact_name_order = trolley.orders.find(:first,
                                                       :select => "distinct(contact_name)",
                                                       :order => 'updated_at DESC')

     @order.contact_name ||= previous_contact_name_order.contact_name if previous_contact_name_order.present? && previous_contact_name_order.contact_name.present?

     previous_contact_phone_order = trolley.orders.find(:first,
                                                        :select => "distinct(contact_phone)",
                                                        :order => 'updated_at DESC')

     @order.contact_phone ||= previous_contact_phone_order.contact_phone if previous_contact_phone_order.present? && previous_contact_phone_order.contact_phone.present?
   end

   def number_per_page
     50
   end
end
