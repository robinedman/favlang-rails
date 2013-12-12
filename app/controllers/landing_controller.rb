require 'favourite_language_guesser'

class LandingController < ApplicationController
  def guess
    @lg = FavouriteLanguageGuesser.new

    begin
      favourite_language = @lg.favourite_language(params[:github_username])
    rescue GitHubAPI::GitHubAPIError => e
      render(text: e.message, status: 404)
    else
      render(json: 
        {
          favourite: @lg.favourite_language(params[:github_username]),
          username: params[:github_username]
        }
      )
    end
  end
end
