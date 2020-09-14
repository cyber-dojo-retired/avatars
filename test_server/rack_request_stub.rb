# frozen_string_literal: true
require 'ostruct'

class RackRequestStub

  def initialize(path)
    @path = path
  end

  def path_info
    @path
  end

end
