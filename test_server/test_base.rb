require_relative 'hex_mini_test'
require_relative '../src/avatars'

class TestBase < HexMiniTest

  def initialize(arg)
    super(arg)
  end

  def avatars
    @avatars ||= Avatars.new
  end

end
