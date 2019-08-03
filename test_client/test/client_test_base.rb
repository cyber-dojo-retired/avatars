require_relative 'hex_mini_test'
require_relative '../src/externals'
require_relative '../src/avatars_service'

class ClientTestBase < HexMiniTest

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def avatars
    @avatars ||= AvatarsService.new(externals)
  end

end
