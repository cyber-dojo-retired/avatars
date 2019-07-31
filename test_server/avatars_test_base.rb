require_relative 'hex_mini_test'
require_relative '../src/externals'
require_relative '../src/avatars'

class AvatarsTestBase < HexMiniTest

  def initialize(arg)
    super(arg)
  end

  def avatars
    @avatars ||= Avatars.new(externals)
  end

  def externals
    @externals ||= Externals.new
  end

  def disk
    externals.disk
  end

end
