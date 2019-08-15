require_relative 'test_base'
require_relative 'expected_names'

class NamesTest < TestBase

  def self.hex_prefix
    'FCF'
  end

  # - - - - - - - - - - - - - - - - -

  test '3DD', %w( names ) do
    assert_equal expected_names, names
  end

  private

  include ExpectedNames

  def names
    JSON.parse(avatars.names[2][0])['names']
  end

end
