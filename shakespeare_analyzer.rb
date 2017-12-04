require 'faraday'


class Api
  BASE_URL = 'http://www.ibiblio.org/xml/examples/shakespeare/'

  def initialize( play_name='macbeth' )
    @play_name = play_name
  end

  def getPlay()
    response = Faraday.get("#{BASE_URL}#{@play_name}.xml")
  end


end


api_endpoint = Api.new()

p api_endpoint.getPlay()
