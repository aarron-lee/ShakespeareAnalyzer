require 'faraday'
require 'nokogiri'
require 'byebug'

class PlayInfo

  def initialize( play_xml )
    if !play_xml
      return nil
    end
    @characters = play_xml.xpath("//PERSONA").map do |character|
      character.inner_text
    end
    debugger
  end


end


class Api
  BASE_URL = 'http://www.ibiblio.org/xml/examples/shakespeare/'

  def initialize( play_name='macbeth' )
    @play_name = play_name
  end

  def getPlayInfo()
    response = Faraday.get("#{BASE_URL}#{@play_name}.xml")
    @xml_info = Nokogiri::XML.parse(response.body)
    PlayInfo.new( @xml_info )
  end

end


api_endpoint = Api.new()

play_info = api_endpoint.getPlayInfo()
