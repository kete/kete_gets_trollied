# kete specific tie-in to trollied line item model
LineItem.class_eval do
  delegate :basket, :to => :purchasable_item
end
