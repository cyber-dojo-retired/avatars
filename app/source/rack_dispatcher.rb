# frozen_string_literal: true
require_relative 'http/request_error'
require_relative 'http_args'
require 'json'
require 'rack'

class RackDispatcher

  def initialize(avatars)
    @avatars = avatars
  end

  def call(env, request_class = Rack::Request)
    request = request_class.new(env)
    path = request.path_info
    name,args = HttpArgs.new.get(path)
    @avatars.public_send(name, *args)
  rescue Http::RequestError => error
    json_error_response(400, path, error)
  rescue Exception => error
    json_error_response(500, path, error)
  end

  private

  def json_error_response(status, path, error)
    json = diagnostic(path, error)
    body = JSON.pretty_generate(json)
    $stderr.puts(body)
    $stderr.flush
    [ status,
      { 'Content-Type' => 'application/json' },
      [ body ]
    ]
  end

  # - - - - - - - - - - - - - - - -

  def diagnostic(path, error)
    { 'exception' => {
        'path' => path,
        'class' => 'AvatarsService',
        'message' => error.message,
        'backtrace' => error.backtrace
      }
    }
  end

end
