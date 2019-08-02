# frozen_string_literal: true

require 'json'

class Avatars

  def initialize
    @names = Dir["/app/images/*"].map{ |pathname|
      File.basename(pathname, '.jpg')
    }.sort
  end

  def sha
    json_response('sha', ENV['SHA'])
  end

  def alive?
    json_response('alive?', true)
  end

  def ready?
    json_response('ready?', true)
  end

  def names
    json_response('names', @names)
  end

  #def image(n)
  #  jpg_response(@names[n])
  #end

  private

  def json_response(name, result)
    json = { name => result }
    body = JSON.fast_generate(json)
    [ 200,
      { 'Content-Type' => 'application/json' },
      [ body ]
    ]
  end

=begin
  def jpg_response(name)
    # TODO: cache binread result
    filename = "/app/images/#{name}.jpg"
    [ 200,
      { 'Content-Type' => 'image/jpg' },
      IO.binread(filename)
    ]
  end
=end

end
