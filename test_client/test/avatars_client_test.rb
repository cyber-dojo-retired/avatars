require_relative 'client_test_base'

class AvatarsClientTest < ClientTestBase

  def self.hex_prefix
    '200'
  end

  # - - - - - - - - - - - - - - - - - - - -
  # sha
  # - - - - - - - - - - - - - - - - - - - -

  test '945', 'sha 200' do
    sha = avatars.sha
    assert_equal 40, sha.size, 'sha.size'
    sha.each_char do |ch|
      assert '0123456789abcdef'.include?(ch), ch
    end
  end

  # - - - - - - - - - - - - - - - - - - - -
  # alive?
  # - - - - - - - - - - - - - - - - - - - -

  test '946', 'alive? 200' do
    assert avatars.alive?
  end

  # - - - - - - - - - - - - - - - - - - - -
  # ready?
  # - - - - - - - - - - - - - - - - - - - -

  test '947', 'ready? 200' do
    assert avatars.ready?
  end

  # - - - - - - - - - - - - - - - - - - - -
  # failure cases
  # - - - - - - - - - - - - - - - - - - - -

  test '7C0', %w( calling unknown method raises ) do
    requester = HttpJson::RequestPacker.new(externals.http, 'avatars-server', 5027)
    http = HttpJson::ResponseUnpacker.new(requester, AvatarsException)
    error = assert_raises(AvatarsException) { http.get(:shar, {"x":42}) }
    json = JSON.parse(error.message)
    assert_equal '/shar', json['path']
    assert_equal '{"x":42}', json['body']
    assert_equal 'AvatarsService', json['class']
    assert_equal 'unknown path', json['message']
  end

end
