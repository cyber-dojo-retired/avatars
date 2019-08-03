$stdout.sync = true
$stderr.sync = true

require_relative 'src/avatars_service'
require_relative 'src/client'
require_relative 'src/externals'
require 'rack'

externals = Externals.new
avatars = AvatarsService.new(externals)
run Client.new(avatars)
