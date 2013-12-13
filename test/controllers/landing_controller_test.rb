require 'test_helper'

class LandingControllerTest < ActionController::TestCase
  def test_default_route_serves_page
    get :new

    assert_response(:success)
    assert(@response.body.include?('Favourite Language Guesser'))
  end

  def test_get_favourite_language
    get_user_favourite 'rubinius'
    answer = JSON.parse(@response.body)

    assert_equal('Ruby', answer['favourite'])
  end

  def test_nonexistent_username_returns_error_code
    get_user_favourite 'auserthatdoesnotexist'

    refute_equal(200, @response.status)
  end

  private

  def get_user_favourite(username)
    get :guess, {github_username: username}
  end
end
