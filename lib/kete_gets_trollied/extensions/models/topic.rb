# extensions to the kete topic model
Topic.class_eval do
  # Walter McGinnis, 2011-05-12
  # adding shopping cart functionality
  include GetsTrollied
  set_up_to_get_trollied :described_as => :reference_title_date_range
end
