# each notification expects an order object
module UserOrderNotifications
  unless included_modules.include? UserOrderNotifications
    def self.included(klass)
      klass.send :include, HasTrolleyControllerHelpersOverrides
    end

    def cancelled(order, user, cancelling_user)
      setup_email(user)
      @subject += I18n.t("user_notifier_model.subject_cancelled")
      @body[:order] = order
      @body[:cancelling_user] = cancelling_user
      set_body_url_for(order, user)
    end

    %w(in_process ready user_review).each do |state_name|
      code = lambda { |order, user|
        setup_email(user)
        @subject += I18n.t("user_notifier_model.subject_#{state_name}")
        @body[:order] = order
        set_body_url_for(order, user)
      }

      define_method(state_name, &code)
    end

    def new_note(order, note, user)
      setup_email(user)
      @subject += I18n.t("user_notifier_model.subject_new_note")
      @body[:order] = order
      @body[:note] = note
      set_body_url_for(order, user)
    end

    def set_body_url_for(order, user)
      @body[:url] = url_for(:controller => :orders,
                            :action => :show,
                            :id => order,
                            :urlified_name => order.basket.urlified_name,
                            :host => Kete.site_name)
    end
  end
end
