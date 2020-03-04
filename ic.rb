require 'irb'
require_relative 'labs_api'
token = File.open(File.expand_path('~/.secrets/twitter/test.token', __dir__)).read.strip
api = LabsAPI.new(bearer_token: token, debug: true)

binding.irb
