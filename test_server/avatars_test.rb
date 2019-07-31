require_relative 'avatars_test_base'
require_relative 'expected_names'

class AvatarsTest < AvatarsTestBase

  def self.hex_prefix
    'FCF'
  end

  test '3DA', 'sha' do
    sha = avatars.sha
    assert sha.is_a?(String)
    assert_equal 40, sha.size
    sha.each_char do |ch|
      assert '0123456789abcdef'.include?(ch), ch
    end
  end

  # - - - - - - - - - - - - - - - - -

  test '3DB', %w( alive? is true ) do
    assert avatars.alive?
  end

  # - - - - - - - - - - - - - - - - -

  test '3DC', %w( ready? is true ) do
    assert avatars.ready?
  end

  # - - - - - - - - - - - - - - - - -

  test '3DD', %w( names ) do
    assert_equal expected_names, avatars.names
  end

  private

  include ExpectedNames
  
end
