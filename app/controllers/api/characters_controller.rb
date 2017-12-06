require "api_endpoint"
class Api::CharactersController < ApplicationController

  def index
    if params[:play_name]
      @play_name = params[:play_name]
    end
    api_endpoint = nil
    if @play_name
      api_endpoint = ApiEndpoint.new @play_name
    else
      api_endpoint = ApiEndpoint.new
    end
    play_info = nil
    begin
      play_info = api_endpoint.getPlayInfo
    rescue Exception
      return render json: { errors: "XML request timeout"}, status: 404
    end
    sorted_characters = play_info.characters.sort_by{|char| char.line_count}.reverse

    render json: sorted_characters.map{ |char| { name: char.name, line_count: char.line_count } }
  end


  private
  def characters_params
    params.require(:characters).permit(:play_name, :base_url)
  end

end
