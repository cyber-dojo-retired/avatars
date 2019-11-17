$stdout.sync = true
$stderr.sync = true

require 'rack'
use Rack::Deflater, if: ->(_, _, _, body) { body.any? && body[0].length > 512 }

unless ENV['NO_PROMETHEUS']
  require 'prometheus/middleware/collector'
  require 'prometheus/middleware/exporter'
  # Don't use default metrics prefix of 'http_server'
  # See https://github.com/prometheus/client_ruby/blob/master/lib/prometheus/middleware/collector.rb#L25
  use(Prometheus::Middleware::Collector, { metrics_prefix:'avatar' })
  use(Prometheus::Middleware::Exporter)
end

require_relative 'src/avatars'
require_relative 'src/rack_dispatcher'
avatars = Avatars.new
dispatcher = RackDispatcher.new(avatars)
run dispatcher
