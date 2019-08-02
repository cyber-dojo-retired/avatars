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
    when '/image' then ['image',[n]]
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

  def n
    checked_arg(:well_formed_n?)
  end

  def well_formed_n?(arg)
    arg.is_a?(Integer) && (0..63).include?(arg)
  end

  # - - - - - - - - - - - - - - - -

  def checked_arg(validator)
    name = caller_locations(1,1)[0].label
    unless @args.has_key?(name)
      raise missing(name)
    end
    arg = @args[name]
    unless self.send(validator, arg)
      raise malformed(name)
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def missing(arg_name)
    request_error("#{arg_name} is missing")
  end

  def malformed(arg_name)
    request_error("#{arg_name} is malformed")
  end

  # - - - - - - - - - - - - - - - -

  def request_error(text)
    # Exception messages use the words 'body' and 'path'
    # to match RackDispatcher's exception keys.
    HttpJson::RequestError.new(text)
  end

end
