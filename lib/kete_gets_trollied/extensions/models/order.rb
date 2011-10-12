# kete specific tie-in to trollied order model
Order.class_eval do
  belongs_to :basket
  before_save :set_basket_from_line_item

  # this gives us a settings hash per order
  # that we can use for preferences
  acts_as_configurable

  ### implementing state methods, so far just for notifications
  # corresponding methods for actual delivery are in lib/user_order_notifications.rb
  # these methods are responsible for triggering the deliver and to whom

  # notify the basket moderators that a new order is in_process
  def checkout
    # assumes that an in_process must have at least one line_item
    # and therefore a basket
    raise "An in_process order should have a basket." unless basket

    basket.moderators_or_next_in_line.each do |user|
      UserNotifier.deliver_in_process(self, user)
    end

  end

  # notify the ordering user that their order is ready
  def fulfilled_without_acceptance
    UserNotifier.deliver_ready(self, user)
  end

  # notify the ordering user that their order has been cancelled
  # notify basket moderators that the order has been cancelled
  def cancel(cancelling_user)
    UserNotifier.deliver_cancelled(self, user, cancelling_user) unless user == cancelling_user

    basket.moderators_or_next_in_line.each do |user_in_line|
      UserNotifier.deliver_cancelled(self, user_in_line, cancelling_user) unless user_in_line == cancelling_user
    end
  end

  # notify the ordering user that their order requires user review
  def alter
    UserNotifier.deliver_user_review(self, user)
  end

  # notify staff that user has approved changes and the order is now in process
  def alteration_approve
    UserNotifier.deliver_in_process(self, user)
  end

  alias_method :original_new_note, :new_note

  def new_note(note)
    original_new_note(note)

    if user == note.user
      basket.moderators_or_next_in_line.each do |user_in_line|
        UserNotifier.deliver_new_note(self, note, user_in_line)
      end
    else
      UserNotifier.deliver_new_note(self, note, user)
    end
  end

  def set_basket_from_line_item
    basket ||= line_items.size > 0 ? line_items.first.basket : nil
  end

  # notes, except in the context of checkout_form, are not allowed
  def may_note?
    false
  end

  # TODO: this is archivescentral specific at this point, move to something that can be configured or something
  def validate
    if !new_record? && current?
      errors.add('contact_name', 'Please provide a contact name for your enquiry') unless contact_name.present?
      errors.add('contact_phone', 'Please provide a phone number where we may contact you at about your enquiry') unless contact_phone.present?
    end
  end
end
