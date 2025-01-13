# code from https://gist.github.com/felginep/087f8e70db8b8e29fea904d464e66d98
# heavily inspired from https://github.com/fastlane/fastlane/blob/master/fastlane/lib/fastlane/actions/set_github_release.rb
module Fastlane
  module Actions
    module SharedValues
      COMMENT_GITHUB_ISSUE_COMMENT_LINK = :COMMENT_GITHUB_ISSUE_COMMENT_LINK
      COMMENT_GITHUB_ISSUE_COMMENT_ID = :COMMENT_GITHUB_ISSUE_COMMENT_ID
      COMMENT_GITHUB_ISSUE_COMMENT_JSON = :COMMENT_GITHUB_ISSUE_COMMENT_JSON
    end

    class CommentGithubIssueAction < Action
      def self.run(params)
        repo_name = params[:repository_name]
        api_token = params[:api_token]
        server_url = params[:server_url]
        issue_number = params[:issue_number]

        payload = {
          'body' => params[:comment]
        }

        GithubApiAction.run(
          server_url: server_url,
          api_token: api_token,
          http_method: 'POST',
          path: "repos/#{repo_name}/issues/#{issue_number}/comments",
          body: payload,
          error_handlers: {
            409 => proc do |result|
              UI.error(result[:body])
              UI.error("Conflict error")
            end,
            404 => proc do |result|
              UI.error(result[:body])
              UI.user_error!("Repository #{repo_name} cannot be found, please double check its name and that you provided a valid API token (GITHUB_API_TOKEN)")
            end,
            401 => proc do |result|
              UI.error(result[:body])
              UI.user_error!("You are not authorized to access #{repo_name}, please make sure you provided a valid API token (GITHUB_API_TOKEN)")
            end,
            '*' => proc do |result|
              UI.error("GitHub responded with #{result[:status]}:#{result[:body]}")
              return nil
            end
          }
        ) do |result|
          json = result[:json]
          comment_id = json['id']
          comment_url = json['html_url']

          UI.success("Successfully created comment for issue #{issue_number} on Github")
          UI.important("See comment at #{comment_url}")

          Actions.lane_context[SharedValues::COMMENT_GITHUB_ISSUE_COMMENT_LINK] = comment_url
          Actions.lane_context[SharedValues::COMMENT_GITHUB_ISSUE_COMMENT_ID] = comment_id
          Actions.lane_context[SharedValues::COMMENT_GITHUB_ISSUE_COMMENT_JSON] = json

          return json || result[:body]
        end

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "This will create a new comment on Github"
      end

      def self.details
        [
          "Creates a new comment on GitHub. You must provide your GitHub Personal token (get one from [https://github.com/settings/tokens/new](https://github.com/settings/tokens/new)), the repository name and issue number.",
          "Out parameters provide the comment's id, which can be used for later editing and the comment link to GitHub."
        ].join("\n")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :repository_name,
                                       env_name: "AD_COMMENT_GITHUB_ISSUE_REPOSITORY_NAME",
                                       description: "The path to your repo, e.g. 'fastlane/fastlane'",
                                       verify_block: proc do |value|
                                         UI.user_error!("Please only pass the path, e.g. 'fastlane/fastlane'") if value.include?("github.com")
                                         UI.user_error!("Please only pass the path, e.g. 'fastlane/fastlane'") if value.split('/').count != 2
                                       end),
          FastlaneCore::ConfigItem.new(key: :server_url,
                                       env_name: "AD_COMMENT_GITHUB_ISSUE_SERVER_URL",
                                       description: "The server url. e.g. 'https://your.internal.github.host/api/v3' (Default: 'https://api.github.com')",
                                       default_value: "https://api.github.com",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Please include the protocol in the server url, e.g. https://your.github.server/api/v3") unless value.include?("//")
                                       end),
          FastlaneCore::ConfigItem.new(key: :api_token,
                                       env_name: "AD_COMMENT_GITHUB_ISSUE_API_TOKEN",
                                       description: "Personal API Token for GitHub - generate one at https://github.com/settings/tokens",
                                       sensitive: true,
                                       code_gen_sensitive: true,
                                       is_string: true,
                                       default_value: ENV["GITHUB_API_TOKEN"],
                                       default_value_dynamic: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :issue_number,
                                       env_name: "AD_COMMENT_GITHUB_ISSUE_ISSUE_NUMBER",
                                       description: "Pass in the issue number",
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :comment,
                                       env_name: "AD_COMMENT_GITHUB_ISSUE_ISSUE_COMMENT",
                                       description: "Pass in the comment",
                                       is_string: true,
                                       optional: false),
        ]
      end

      def self.output
        [
          ['COMMENT_GITHUB_ISSUE_COMMENT_LINK', 'Link to your created comment'],
          ['COMMENT_GITHUB_ISSUE_COMMENT_ID', 'Comment id (useful for subsequent editing)'],
          ['COMMENT_GITHUB_ISSUE_COMMENT_JSON', 'The whole comment JSON object']
        ]
      end

      def self.return_value
        [
          "A hash containing all relevant information of this comment"
        ].join("\n")
      end

      def self.authors
        ["felginep"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end