require_relative 'hex_mini_test'

def require_source(s)
  require_relative "../source/#{s}"
end

require_source 'avatars'

class TestBase < HexMiniTest

  def initialize(arg)
    super(arg)
  end

  def avatars
    @avatars ||= Avatars.new
  end

end
