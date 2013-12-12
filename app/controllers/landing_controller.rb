require 'favourite_language_guesser'

class LandingController < ApplicationController
  def guess
    @lg = FavouriteLanguageGuesser.new
    render(json: 
      {
        favourite: @lg.favourite_language(params[:github_username]),
        username: params[:github_username]
      }
    )
  end
end
