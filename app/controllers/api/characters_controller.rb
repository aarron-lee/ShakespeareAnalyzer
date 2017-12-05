class Api::CharactersController < ApplicationController

  def index

  end


  private
  def characters_params
    params.require(:characters).permit(:play_name, :base_url)
  end

end
