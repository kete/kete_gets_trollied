Trolley.class_eval do
  alias_method :original_correct_order, :correct_order

  def correct_order(purchasable_item)
    correct_orders = orders.with_state_current.select { |o| o.basket == purchasable_item.basket }
    order = correct_orders.last
    order = orders.create!(:basket => purchasable_item.basket) unless order.present?
    order
  end
end
