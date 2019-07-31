# frozen_string_literal: true

class ExternalDiskReader

  def read(pathed_filename)
    File.open(pathed_filename, 'r') { |fd| fd.read }
  end

end
