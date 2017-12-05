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
