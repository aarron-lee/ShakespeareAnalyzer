require 'faraday'
require 'nokogiri'
require 'byebug'


class PlayCharacter

  def initialize(character_name="")
    @name = character_name
  end

  def lines=(lines)
    @lines = lines
    @line_count = @lines.count
  end

  def name
    @name
  end

  def line_count
    @line_count
  end

  def lines
    @lines
  end


end

class PlayInfo

  def initialize( play_xml )
    if !play_xml
      return nil
    end
    @characters = play_xml.xpath("//PERSONA").map do |character|
      play_char = PlayCharacter.new(character.inner_text)
      play_char.lines = parseCharacterLines(play_xml, play_char)
      play_char
    end
  end

  def parseCharacterLines(play_xml, play_char)
    char_name = play_char.name.gsub(/[!@%&, ."]/, '')
    character_line_nodes = play_xml.search("SPEAKER[text()=#{char_name}] ~ LINE")
    character_lines = character_line_nodes.map(&:inner_text)

    return character_lines ? character_lines : []
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















//
