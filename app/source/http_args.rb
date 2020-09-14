# frozen_string_literal: true
require_relative 'http/request_error'

class HttpArgs

  def get(path)
    case path[1..-1]
    when 'sha'         then ['sha',[]]
    when 'alive'       then ['alive?',[]]
    when 'ready'       then ['ready?',[]]
    when 'names'       then ['names',[]]
    when /name\/(.*)/  then ['name',[id($1)]]
    when /image\/(.*)/ then ['image',[id($1)]]
    else
      raise request_error('unknown path')
    end
  end

  private

  def id(s)
    if s === 'all'
      return :all
    end
    if s === ''
      raise missing('id')
    end
    unless is_int?(s)
      raise malformed('id')
    end
    arg = s.to_i
    unless (0..63).include?(arg)
      raise malformed('id')
    end
    arg
  end

  # - - - - - - - - - - - - - - - -

  def is_int?(s)
    s =~ /^[0-9]{1,2}$/
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
    # Exception messages use the word 'path'
    # to match RackDispatcher's exception keys.
    Http::RequestError.new(text)
  end

end
