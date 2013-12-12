require 'uri'
require 'net/http'
require 'json'

module GitHubAPI
  class GitHubAPIError < StandardError; end

  class UserNotFoundError < GitHubAPIError
    attr_reader :username
    
    def initialize(username)
      @username = username
    end

    def self.not_found?(response)
      response == self.response
    end

    def self.response
      {
        "message" => "Not Found",
        "documentation_url" => "http://developer.github.com/v3"
      }
    end

    def message
      "Couldn't find the user #{@username}."
    end
  end

  class APILimitError < GitHubAPIError
    def self.api_limit?(response)
      if response.is_a?(Hash)
        response['documentation_url'] == self.response['documentation_url']
      end
    end

    def self.response
      {
        "message" => "API rate limit exceeded for...",
        "documentation_url"=>"http://developer.github.com/v3/#rate-limiting"
      }
    end

    def message
      "Exceeded GitHub's API limits."
    end
  end

  class UserHasNoReposError < GitHubAPIError
    attr_reader :username

    def initialize(username)
      @username = username
    end
    def self.no_repos?(response)
      response.is_a?(Array) && response.empty?
    end

    def message
      "The user #{@username} has no repositories."
    end
  end

  def self.get_user_repos(username)
      uri = URI("https://api.github.com/users/#{username}/repos")
      response = JSON.parse(Net::HTTP.get(uri))
      
      raise UserNotFoundError.new(username) if UserNotFoundError.not_found?(response)
      raise APILimitError.new if APILimitError.api_limit?(response)
      raise UserHasNoReposError.new(username) if UserHasNoReposError.no_repos?(response)

      response
    end
end
