$stdout.sync = true
$stderr.sync = true

unless ENV['NO_PROMETHEUS']
  require 'prometheus/middleware/collector'
  require 'prometheus/middleware/exporter'
  use Prometheus::Middleware::Collector
  use Prometheus::Middleware::Exporter
end

require_relative 'source/avatars'
require_relative 'source/rack_dispatcher'
avatars = Avatars.new
dispatcher = RackDispatcher.new(avatars)
run dispatcher
