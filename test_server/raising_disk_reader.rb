
class RaisingDiskReader

  attr_reader :pathed_filename

  def reader(pathed_filename)
    @pathed_filename = pathed_filename
    raise 'raising'
  end

end
