Gem::Specification.new do |gem|
  gem.name    = 'autolink'
  gem.version = "0.0.2"

  gem.author, gem.email = 'Burke Libbey', "burke@burkelibbey.org"
  gem.homepage = "http://github.com/burke/autolink"

  gem.summary = "Automatically generate nested paths in Rails 2.3 according to your application's setup"
  gem.description = "By setting a default lineage in each model, and using these monkeypatches to Rails, the url helpers are able to generate complex urls from a single ActiveRecord::Base object. Works in 2.3.8, probably other 2.3 railses."

  gem.required_ruby_version = '>= 1.8.7'

  gem.has_rdoc = false

  gem.files = Dir.glob("{lib,spec}/**/*") + %w(LICENSE README.rdoc Rakefile autolink.gemspec)

end


