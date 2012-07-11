ApplicationController.class_eval do
  def user_is_trolley_owner_or_appropriate_admin?
    return false unless logged_in?

    if %w(trolleys line_items orders notes).include?(params[:controller])
      if params[:controller] == 'orders' && params[:action] == 'index'
        return at_least_a_moderator?
      else
        owned_by = @trolley || @order || @line_item || @note
        unless owned_by.blank? && params[:controller] == 'line_items' && %w(new index create).include?(params[:action])
          return (at_least_a_moderator? || current_user == owned_by.user)
        end
      end
    end

    true
  end

  def authorize_trollied_action
    return true if user_is_trolley_owner_or_appropriate_admin?
    # otherwise they shouldn't be here
    redirect_to DEFAULT_REDIRECTION_HASH
  end
end

ApplicationController.add_ons_full_width_content_wrapper_controllers += %w(trollies orders)
ApplicationController.add_ons_content_wrapper_end_controllers += %w(trollies orders)
