# frozen_string_literal: true

class Avatars

  def initialize
    @names = Dir["/app/images/*"].map{ |pathname|
      File.basename(pathname, '.jpg')
    }.sort
  end

  def sha
    ENV['SHA']
  end

  def alive?
    true
  end

  def ready?
    true
  end

  def names
    @names
  end

end
