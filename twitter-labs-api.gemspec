lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twitter_labs_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'twitter_labs_api'
  spec.version       = TwitterLabsAPI::VERSION
  spec.authors       = ['tomholford']
  spec.email         = ['tomholford@users.noreply.github.com']

  spec.summary       = 'A basic implementation of a Twitter Labs API client in Ruby'
  spec.homepage      = 'https://github.com/tomholford/twitter-labs-api'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/tomholford/twitter-labs-api'
  spec.metadata['changelog_uri'] = 'https://github.com/tomholford/twitter-labs-api/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 6', '< 8'
  spec.add_dependency 'httplog', '~> 1.4'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
end
