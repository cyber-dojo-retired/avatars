# frozen_string_literal: true

require_relative 'http_json/request_error'
require 'json'

class HttpJsonArgs

  def initialize(body)
    @args = json_parse(body)
    unless @args.is_a?(Hash)
      raise request_error('body is not JSON Hash')
    end
  rescue JSON::ParserError
    raise request_error('body is not JSON')
  end

  # - - - - - - - - - - - - - - - -

  def get(path)
    case path
    when '/sha'   then ['sha',[]]
    when '/alive' then ['alive?',[]]
    when '/ready' then ['ready?',[]]
    when '/names' then ['names',[]]
    #when '/name'  then ['name',[n]]
    else
      raise request_error('unknown path')
    end
  end

  private

  def json_parse(body)
    if body === ''
      {}
    else
      JSON.parse(body)
    end
  end

  # - - - - - - - - - - - - - - - -

  def request_error(text)
    # Exception messages use the words 'body' and 'path'
    # to match RackDispatcher's exception keys.
    HttpJson::RequestError.new(text)
  end

end
