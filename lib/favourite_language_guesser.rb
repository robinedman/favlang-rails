require 'active_support/time'
require_relative 'github_api'

class FavouriteLanguageGuesser
  class NoUpdatedRepositoriesWithinTimeframeError < StandardError
  end

  # Determines username's favourite language by counting their GitHub
  # repositories within since_months_ago. If no code has been pushed the last 6
  # months we try again without the time limit. 
  def favourite_language(username, since_months_ago = 6)
    begin
      languages = used_languages(username, since_months_ago)
    rescue NoUpdatedRepositoriesWithinTimeframeError
      languages = used_languages(username)
    end
   
   languages.max_by { |language, times_used | times_used }.first
  end

  # username: GitHub username
  # since_months_ago: int representing how far back to take into account 
  def used_languages(username, since_months_ago = nil)
    repos = repos_since(GitHubAPI.get_user_repos(username), since_months_ago)

    repos_by_language = repos.group_by { |repo| repo['language'] }
    Hash[repos_by_language.keys.map { |language| [language, repos_by_language[language].count]}]
  end

  private

  def repos_since(repos, since_months_ago = nil)
    return repos unless since_months_ago

    filtered_repos = repos.reject { |repo| !repo.has_key?('pushed_at') }
                          .reject { |repo| Time.parse(repo['pushed_at']) < since_months_ago.months.ago }
    raise NoUpdatedRepositoriesWithinTimeframeError if filtered_repos.empty?
    filtered_repos
  end
end
