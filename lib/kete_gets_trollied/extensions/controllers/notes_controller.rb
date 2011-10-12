NotesController.class_eval do
  before_filter :authorize_trollied_action
end
