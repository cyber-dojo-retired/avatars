require_relative 'test_base'

class ReadyTest < TestBase

  def self.hex_prefix
    '0B2'
  end

  # - - - - - - - - - - - - - - - - -

  test '602',
  %w( its ready ) do
    assert ready?
  end

  private

  def ready?
    JSON.parse(avatars.ready?[2][0])['ready?']
  end

end
