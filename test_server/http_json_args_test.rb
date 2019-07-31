require_relative 'avatars_test_base'
require_relative '../src/http_json_args'
require_relative '../src/http_json/request_error'

class HttpJsonArgsTest < AvatarsTestBase

  def self.hex_prefix
    'EE7'
  end

  # - - - - - - - - - - - - - - - - -

  test 'A04',
  'ctor raises when its string-arg is invalid json' do
    expected = 'body is not JSON'
    # abc is not a valid top-level json element
    error = assert_raises { HttpJsonArgs.new('abc') }
    assert_equal expected, error.message
    # nil is null in json
    error = assert_raises { HttpJsonArgs.new('{"x":nil}') }
    assert_equal expected, error.message
    # keys have to be strings in json
    error = assert_raises { HttpJsonArgs.new('{42:"answer"}') }
    assert_equal expected, error.message
  end

  # - - - - - - - - - - - - - - - - -

  test 'c89', %w(
  ctor does not raise when body is empty string which is
  useful for kubernetes liveness/readyness probes ) do
    HttpJsonArgs.new('')
  end

  test '691',
  %w( ctor does not raise when string-arg is valid json ) do
    HttpJsonArgs.new('{}')
    HttpJsonArgs.new('{"answer":42}')
  end

  # - - - - - - - - - - - - - - - - -

  test 'e12', 'sha has no args' do
    name,args = HttpJsonArgs.new('{}').get('/sha')
    assert_equal name, 'sha'
    assert_equal [], args
  end

  test 'e13', 'alive has no args' do
    name,args = HttpJsonArgs.new('{}').get('/alive')
    assert_equal name, 'alive?'
    assert_equal [], args
  end

  test 'e14', 'ready has no args' do
    name,args = HttpJsonArgs.new('{}').get('/ready')
    assert_equal name, 'ready?'
    assert_equal [], args
  end

  test 'e15', 'names has no args' do
    name,args = HttpJsonArgs.new('{}').get('/names')
    assert_equal name, 'names'
    assert_equal [], args
  end

end
