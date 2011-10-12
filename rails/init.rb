require 'trollied'
require 'kete_gets_trollied'

config.to_prepare do
  # In development/production, we want to only setup stuff if IS_CONFIGURED is true
  # In test mode however, we always want to have it, since IS_CONFIGURED won't be true
  # at this stage, but it will be changed to true after Rails initializes.
  if (IS_CONFIGURED || Rails.env.test?)
    # no duplicate view files at this time, so no need for engine's views to take precedence
    # if that changes in the future, see kete_translatable_content/rails/init.rb for how it is done

    # load our locales
    I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '../config/locales/*.{rb,yml}') ]

    # override some controllers and helpers to be kete gets trollied aware
    exts = File.join(File.dirname(__FILE__), '../lib/kete_gets_trollied/extensions/{controllers,helpers}/*')
    # use Kernel.load here so that changes to the extensions are reloaded on each request in development
    Dir[exts].each { |ext_path| Kernel.load(ext_path) }

    # models we extend
    Kete.extensions[:blocks] ||= Hash.new
    Dir[ File.join(File.dirname(__FILE__), '../lib/kete_gets_trollied/extensions/models/*') ].each do |ext_path|
      key = File.basename(ext_path, '.rb').to_sym
      Kete.extensions[:blocks][key] ||= Array.new
      Kete.extensions[:blocks][key] << Proc.new { Kernel.load(ext_path) }
    end
  end
end
