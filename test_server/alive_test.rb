require_relative 'test_base'

class AliveTest < TestBase

  def self.hex_prefix
    '198'
  end

  # - - - - - - - - - - - - - - - - -

  test '93b',
  %w( its alive ) do
    assert alive?
  end

  private

  def alive?
    JSON.parse(avatars.alive?[2][0])['alive?']
  end

end
