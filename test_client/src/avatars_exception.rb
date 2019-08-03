require_relative 'http_json/service_exception'

class AvatarsException < HttpJson::ServiceException

  def initialize(message)
    super
  end

end
