# frozen_string_literal: true
require_relative 'test_base'

class ShaTest < TestBase

  def self.hex_prefix
    'FB3'
  end

  # - - - - - - - - - - - - - - - - -

  test '191', %w( sha is 40-char commit sha of image ) do
    assert_equal 40, sha.size
    sha.each_char do |ch|
      assert '0123456789abcdef'.include?(ch)
    end
  end

  private

  def sha
    JSON.parse(avatars.sha[2][0])['sha']
  end

end
