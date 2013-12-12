require 'test_helper'
require 'favourite_language_guesser'

class FavouriteLanguageGuesserTest < ActiveSupport::TestCase
  def setup
    @lg = FavouriteLanguageGuesser.new
  end

  test "favourite language is the most used language" do
    assert_equal('Ruby', @lg.favourite_language('rubinius'))
  end

  test "favourite language with nonexistent username raises exception" do
    assert_raises(GitHubAPI::UserNotFoundError) do 
      @lg.favourite_language('auserthatdoesnotexist')
    end
  end

  test "used languages raises exception when no repositories updated" do
    assert_raises(FavouriteLanguageGuesser::NoUpdatedRepositoriesWithinTimeframeError) do
      @lg.used_languages('whymirror', 12)
    end
  end

  test "used languages since x months ago" do
    assert_instance_of(Hash, @lg.used_languages('rubinius', 6))
  end  
end
