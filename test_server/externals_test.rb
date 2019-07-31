require_relative 'avatars_test_base'

class ExternalsTest < AvatarsTestBase

  def self.hex_prefix
    '7A9'
  end

  # - - - - - - - - - - - - - - - - -

  test '1B1',
  'default disk is ExternalDiskReader' do
    assert_equal ExternalDiskReader, disk.class
  end

end
