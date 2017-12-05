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
    characters_names = play_xml.search("SPEAKER").map{ |node| node.inner_text }.uniq
    @characters = []
    characters_names.each do |character_name|
      play_char = PlayCharacter.new(character_name)
      play_char.lines = parseCharacterLines(play_xml, play_char)
      @characters.push(play_char)
    end
  end

  def parseCharacterLines(play_xml, play_char)
    char_name = play_char.name
    character_line_nodes = play_xml.search("SPEAKER[text()=\"#{char_name}\"] ~ LINE")
    character_lines = character_line_nodes.map(&:inner_text)

    return character_lines ? character_lines : []
  end

  def characters
    @characters
  end

end


class Api

  def initialize( play_name='macbeth', base_url=nil )
    @play_name = play_name
    @base_url = base_url ? base_url : 'http://www.ibiblio.org/xml/examples/shakespeare/'
  end

  def getPlayInfo()
    response = Faraday.get("#{@base_url}#{@play_name}.xml")
    @xml_info = Nokogiri::XML.parse(response.body)
    PlayInfo.new( @xml_info )
  end

end


api_endpoint = Api.new()

play_info = api_endpoint.getPlayInfo()

sorted_characters = play_info.characters.sort_by{|char| char.line_count}.reverse
sorted_characters.each do |character|
  puts "#{character.name} - #{character.line_count}"
end













//
