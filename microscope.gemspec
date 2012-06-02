# -*- encoding: utf-8 -*-
require File.expand_path('../lib/microscope/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors               = ["Jan Szumiec"]
  gem.email                 = ["jan.szumiec@gmail.com"]
  gem.description           = %q{A tk-based smalltalk-style class and method browser.}
  gem.summary               = %q{A tk-based smalltalk-style class and method browser.}
  gem.homepage              = ""

  gem.files                 = `git ls-files`.split($\)
  gem.executables           = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files            = gem.files.grep(%r{^(test|spec|features)/})
  gem.name                  = "microscope"
  gem.require_paths         = ["lib"]
  gem.version               = Microscope::VERSION
  gem.license               = 'MIT'
  gem.required_ruby_version = '>= 1.9.3'

  gem.add_dependency('method_source')
end
