require 'kete_gets_trollied'

# extend routes for translations of kete content
ActionController::Routing::Routes.draw do |map|
  # Walter McGinnis, 2011-05-12
  # adding shopping chart functionality
  # WARNING user just for show at the moment
  map.resources :user, :path_prefix => ':urlified_name' do |user|
    user.resource :trolley, :only => :show do |trolley|
      trolley.resources :orders, :shallow => true
    end
  end

  map.resources :topics, :path_prefix => ':urlified_name', :only => [:index], :has_many => :line_items

  if Object.const_defined?(:Order)
    members = Order.workflow_event_names.inject(Hash.new) do |hash, event_name|
      hash[event_name.to_sym] = :post
      hash
    end

    members[:checkout_form] = :get

    map.resources :orders, :path_prefix => ':urlified_name', :member => members, :except => [:new, :create], :has_many => :line_items
  end
end
