$stdout.sync = true
$stderr.sync = true

require 'rack'
use Rack::Deflater, if: ->(_, _, _, body) { body.any? && body[0].length > 512 }

unless ENV['NO_PROMETHEUS']
  require 'prometheus/middleware/exporter'
  use Prometheus::Middleware::Exporter
end

require_relative 'source/avatars'
require_relative 'source/rack_dispatcher'
avatars = Avatars.new
dispatcher = RackDispatcher.new(avatars)
run dispatcher
