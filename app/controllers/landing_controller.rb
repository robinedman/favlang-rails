require 'favourite_language_guesser'

class LandingController < ApplicationController
  def new
    @lg = FavouriteLanguageGuesser.new
    @favourite_language = @lg.favourite_language('robinedman')
    logger.info("Fav lang is: #{@favourite_language}")
  end

  def guess

  end
end
