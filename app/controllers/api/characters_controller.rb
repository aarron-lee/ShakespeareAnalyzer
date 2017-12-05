require "api_endpoint"
class Api::CharactersController < ApplicationController

  def index
    api_endpoint = ApiEndpoint.new()

    play_info = api_endpoint.getPlayInfo()

    sorted_characters = play_info.characters.sort_by{|char| char.line_count}.reverse

    render json: sorted_characters.map{ |char| {name: char.name, line_count: char.line_count }}
  end


  private
  def characters_params
    params.require(:characters).permit(:play_name, :base_url)
  end

end
