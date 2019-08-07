# frozen_string_literal: true

require 'json'

class Avatars

  def initialize
    @sha_response = json_response('sha', ENV['SHA'])
    @alive_response = json_response('alive?', true)
    @ready_response = json_response('ready?', true)
    names = Dir["#{IMAGES_DIR}/*.jpg"].map{ |pathname|
      File.basename(pathname, '.jpg')
    }.sort
    @names_response = json_response('names', names)
    @image_responses = (0..63).map do |n|
      jpg_response(names[n])
    end
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

  def image(n)
    @image_responses[n]
  end

  private

  def json_response(name, result)
    json = { name => result }
    response_200('application/json', JSON.fast_generate(json))
  end

  def jpg_response(name)
    filename = "#{IMAGES_DIR}/#{name}.jpg"
    response_200('image/jpg', IO.binread(filename))
  end

  def response_200(type, body)
    [ 200,
      { 'Content-Type' => type },
      [ body ]
    ]
  end

  IMAGES_DIR = '/app/images'

end
