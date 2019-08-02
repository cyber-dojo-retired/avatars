require_relative 'avatars_test_base'
require_relative '../src/http_args'
require_relative '../src/http/request_error'

class HttpArgsTest < AvatarsTestBase

  def self.hex_prefix
    'EE7'
  end

  # - - - - - - - - - - - - - - - - -

  test 'e11', 'unknown path raises' do
    error = assert_raises(Http::RequestError) {
      HttpArgs.new.get('xyz')
    }
    assert_equal 'unknown path', error.message
  end

  # - - - - - - - - - - - - - - - - -

  test 'e12', 'sha has no args' do
    name,args = HttpArgs.new.get('/sha')
    assert_equal name, 'sha'
    assert_equal [], args
  end

  test 'e13', 'alive has no args' do
    name,args = HttpArgs.new.get('/alive')
    assert_equal name, 'alive?'
    assert_equal [], args
  end

  test 'e14', 'ready has no args' do
    name,args = HttpArgs.new.get('/ready')
    assert_equal name, 'ready?'
    assert_equal [], args
  end

  test 'e15', 'names has no args' do
    name,args = HttpArgs.new.get('/names')
    assert_equal name, 'names'
    assert_equal [], args
  end

  test 'e16', %w(
  image has one arg in the path (not the body or params)
  so it can be captured in an nginx location ) do
    name,args = HttpArgs.new.get('/image/23')
    assert_equal 'image', name
    assert_equal [23], args
  end

  # - - - - - - - - - - - - - - - - -

  test 'e17', %w( raises if image's id is missing ) do
    error = assert_raises(Http::RequestError) {
      HttpArgs.new.get('/image/')
    }
    assert_equal 'id is missing', error.message
  end

  test 'e18', %w( raises if image's id is malformed ) do
  expected = 'id is malformed'
    error = assert_raises(Http::RequestError) {
      HttpArgs.new.get('/image/one')
    }
    assert_equal expected, error.message
    error = assert_raises(Http::RequestError) {
      HttpArgs.new.get('/image/123')
    }
    assert_equal expected, error.message
    error = assert_raises(Http::RequestError) {
      HttpArgs.new.get('/image/64')
    }
    assert_equal expected, error.message
  end

end
