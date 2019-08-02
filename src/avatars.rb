# frozen_string_literal: true

require 'json'

class Avatars

  def initialize
    @sha_response = json_response('sha', ENV['SHA'])
    @alive_response = json_response('alive?', true)
    @ready_response = json_response('ready?', true)
    @names_response = json_response('names', 
      Dir["/app/images/*"].map{ |pathname|
        File.basename(pathname, '.jpg')
      }.sort
    )
  end

  def sha
    @sha_response
  end

  def alive?
    @alive_response
  end

  def ready?
    @ready_response
  end

  def names
    @names_response
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
      [ IO.binread(filename) ]s
    ]
  end
=end

end
