require_relative 'avatars_test_base'

class AliveTest < AvatarsTestBase

  def self.hex_prefix
    '198'
  end

  # - - - - - - - - - - - - - - - - -

  test '93b',
  %w( its alive ) do
    assert avatars.alive?
  end

end
