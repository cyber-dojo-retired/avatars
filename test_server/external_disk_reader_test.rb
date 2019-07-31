require_relative 'avatars_test_base'

class ExternalDiskReaderTest < AvatarsTestBase

  def self.hex_prefix
    'FDF'
  end

  test 'D4C',
  'what gets written gets read back' do
    Dir.mktmpdir('file_writer') do |tmp_dir|
      pathed_filename = tmp_dir + '/limerick.txt'
      content = 'the boy stood on the burning deck'
      File.open(pathed_filename, 'w') { |fd| fd.write(content) }
      assert_equal content, disk.read(pathed_filename)
    end
  end

end
