require 'faraday'
require 'nokogiri'
require 'byebug'


class PlayCharacter

  attr_reader :name
  attr_reader :line_count

  def initialize(character_name="")
    @name = character_name
  end

  def lines=(lines)
    @lines = lines
    @line_count = @lines.count
  end

  def lines
    @lines
  end


end

class PlayInfo

  attr_reader :characters

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

  private
  def parseCharacterLines(play_xml, play_char)
    char_name = play_char.name
    character_line_nodes = play_xml.search("SPEAKER[text()=\"#{char_name}\"] ~ LINE")
    character_lines = character_line_nodes.map(&:inner_text)

    return character_lines ? character_lines : []
  end

end


class Api
  attr_reader :play_name
  attr_reader :base_url
  attr_accessor :xml_info

  def initialize( play_name='macbeth', base_url=nil )
    @play_name = play_name
    @base_url = base_url ? base_url : 'http://www.ibiblio.org/xml/examples/shakespeare/'
  end

  def getPlayInfo()
    if !@xml_info
      conn = Faraday.new( url: "#{@base_url}#{@play_name}.xml")
      response = conn.get do |req|
        req.options.timeout = 5
      end
      @xml_info = Nokogiri::XML.parse(response.body)
    end
    if( @xml_info.search("TITLE").length == 0 )
      raise "Invalid API Endpoint used"
    end
    PlayInfo.new( @xml_info )
  end

end

if $PROGRAM_NAME == __FILE__
  play_name = ARGV[0] ? ARGV[0] : 'macbeth'
  base_url = ARGV[1] ? ARGV[1] : 'http://www.ibiblio.org/xml/examples/shakespeare/'

  api_endpoint = Api.new(play_name, base_url)

  play_info = nil
  begin
    play_info = api_endpoint.getPlayInfo
  rescue Exception
    puts "XML Request timed out, ibiblio might be running slow"
  end
  if play_info
    sorted_characters = play_info.characters.sort_by{|char| char.line_count}.reverse
    sorted_characters.each do |character|
      puts "#{character.name} - #{character.line_count}"
    end
  end
end
