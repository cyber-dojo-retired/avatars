# frozen_string_literal: true

require_relative 'external_disk_reader'

class Externals

  def disk
    @disk ||= ExternalDiskReader.new
  end

end
