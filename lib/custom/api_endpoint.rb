require 'play_info'

class ApiEndpoint
  attr_reader :play_name
  attr_reader :base_url
  attr_accessor :xml_info

  def initialize( play_name='macbeth', base_url=nil )
    @play_name = play_name
    @base_url = base_url ? base_url : 'http://www.ibiblio.org/xml/examples/shakespeare/'
  end

  def getPlayInfo()
    if !@xml_info
      response = Faraday.get("#{@base_url}#{@play_name}.xml")
      @xml_info = Nokogiri::XML.parse(response.body)
    end
    if( @xml_info.search("TITLE").length == 0 )
      raise "Invalid API Endpoint used"
    end
    PlayInfo.new( @xml_info )
  end

end
