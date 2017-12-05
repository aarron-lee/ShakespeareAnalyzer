require 'play_character'
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
