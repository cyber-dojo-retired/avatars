# frozen_string_literal: true
require_relative 'test_base'
require_relative 'expected_names'

class NameTest < TestBase

  def self.hex_prefix
    'FDF'
  end

  # - - - - - - - - - - - - - - - - -

  test '2DD', %w( individual name ) do
    assert_equal expected_names[0], get_name(0)
    assert_equal expected_names[27], get_name(27)
    assert_equal expected_names[63], get_name(63)
  end

  private

  include ExpectedNames

  def get_name(n)
    # Can't call this name(n) as it clashes with method
    # called name in TestBase
    JSON.parse(avatars.name(n)[2][0])['name']
  end

end
