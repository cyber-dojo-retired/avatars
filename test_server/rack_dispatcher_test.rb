require_relative 'test_base'
require_relative 'expected_names'
require_relative 'rack_request_stub'
require_source 'rack_dispatcher'

class RackDispatcherTest < TestBase

  def self.hex_prefix
    '4AF'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # 200
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '131', 'sha 200' do
    assert_200_json('/sha') do |response|
      assert_equal ENV['SHA'], response['sha']
    end
  end

  test '132', 'alive 200' do
    assert_200_json('/alive') do |response|
      assert_equal true, response['alive?']
    end
  end

  test '133', 'ready 200' do
    assert_200_json('/ready') do |response|
      assert_equal true, response['ready?']
    end
  end

  test '134', 'names 200' do
    assert_200_json('/names') do |response|
      assert_equal expected_names, response['names']
    end
  end

  test '135', 'image 200' do
    images = {
      '/image/0'   => { size:38453, type:'jpg' },
      '/image/63'  => { size:41129, type:'jpg' },
      '/image/all' => { size:2050998,type:'png' },
      '/image/all_gray' => { size:546695,type:'png' }
    }
    images.each do |path,prop|
      assert_200_img(prop[:type], path) do |response|
        assert_equal prop[:size], response.bytesize
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # 400
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E2A',
  'dispatch returns 400 when method name is unknown' do
    assert_dispatch_error('/xyz', 400, 'unknown path')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # 500
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  class AvatarsShaRaiser
    def initialize(*args)
      @klass = args[0]
      @message = args[1]
    end
    def sha
      raise @klass, @message
    end
  end

  test 'F1A',
  'dispatch returns 500 status when implementation raises' do
    @avatars = AvatarsShaRaiser.new(ArgumentError, 'wibble')
    assert_dispatch_error('/sha', 500, 'wibble')
  end

  test 'F1B',
  'dispatch returns 500 status when implementation has syntax error' do
    @avatars = AvatarsShaRaiser.new(SyntaxError, 'fubar')
    assert_dispatch_error('/sha', 500, 'fubar')
  end

  private

  include ExpectedNames

  def assert_200_json(path)
    response = rack_call(path)
    assert_equal 200, response[0]
    assert_equal({ 'Content-Type' => 'application/json' }, response[1])
    yield JSON.parse(response[2][0])
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_200_img(type, path)
    response = rack_call(path)
    assert_equal 200, response[0], path
    assert_equal({ 'Content-Type' => "image/#{type}" }, response[1], path)
    body = response[2][0]
    assert body.is_a?(String), path
    assert_equal 'ASCII-8BIT', body.encoding.to_s, path
    yield body
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_dispatch_error(path, status, message)
    @avatars ||= Object.new
    response,stderr = with_captured_stderr { rack_call(path) }
    assert_equal status, response[0], "message:#{message},stderr:#{stderr}"
    assert_equal({ 'Content-Type' => 'application/json' }, response[1])
    assert_json_exception(response[2][0], path, message)
    assert_json_exception(stderr,         path, message)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_json_exception(s, path, message)
    json = JSON.parse!(s)
    exception = json['exception']
    refute_nil exception
    diagnostic = "path:#{__LINE__}"
    assert_equal path, exception['path'], diagnostic
    diagnostic = "exception['class']:#{__LINE__}"
    assert_equal 'AvatarsService', exception['class'], diagnostic
    diagnostic = "exception['message']:#{__LINE__}"
    assert_equal message, exception['message'], diagnostic
    diagnostic = "exception['backtrace'].class.name:#{__LINE__}"
    assert_equal 'Array', exception['backtrace'].class.name, diagnostic
    diagnostic = "exception['backtrace'][0].class.name:#{__LINE__}"
    assert_equal 'String', exception['backtrace'][0].class.name, diagnostic
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def rack_call(path)
    @avatars ||= Avatars.new
    rack = RackDispatcher.new(@avatars)
    rack.call(path, RackRequestStub)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def with_captured_stderr
    old_stderr = $stderr
    $stderr = StringIO.new('', 'w')
    response = yield
    return [ response, $stderr.string ]
  ensure
    $stderr = old_stderr
  end

end
