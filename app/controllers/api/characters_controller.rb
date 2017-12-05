class Api::CharactersController < ApplicationController

  def index
    render :json "it's working"
  end


  private
  def characters_params
    params.require(:characters).permit(:play_name, :base_url)
  end

end
