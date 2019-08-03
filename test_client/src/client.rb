require_relative 'http_json/request_error'
require_relative 'http_json_args'
require 'json'
require 'rack'

class Client

  def initialize(avatars)
    @avatars = avatars
  end

  def call(env)
    request = Rack::Request.new(env)
    path = request.path_info
    name,args = HttpJsonArgs.new.get(path)
    result = @avatars.public_send(name, *args)
    json_response(200, { name => result })
  rescue HttpJson::RequestError => error
    json_response(400, diagnostic(path, body, error))
  rescue Exception => error
    json_response(500, diagnostic(path, body, error))
  end

  private

  def json_response(status, json)
    if status === 200
      body = JSON.fast_generate(json)
    else
      body = JSON.pretty_generate(json)
      $stderr.puts(body)
      $stderr.flush
    end
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
