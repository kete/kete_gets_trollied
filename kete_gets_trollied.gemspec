# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kete_gets_trollied/version'

Gem::Specification.new do |spec|
  spec.name          = "kete_gets_trollied"
  spec.version       = KeteGetsTrollied::VERSION
  spec.authors       = ["Walter McGinnis"]
  spec.email         = ["wm@waltermcginnis.com"]
  spec.summary = %Q{Uses the trollied gem for adding item ordering to Kete.}
  spec.description = %Q{Uses the trollied gem for adding item ordering to Kete.}
  spec.homepage = "http://github.com/kete/kete_gets_trollied"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "thoughtbot-shoulda", ">= 0"
  spec.add_dependency "trollied", ">= 0.1.4"
end
