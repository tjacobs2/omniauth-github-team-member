require 'omniauth-github'

module OmniAuth
  module Strategies
    class GitHubTeamMember < OmniAuth::Strategies::GitHub
      credentials do
        { 'organization_member?' => github_organization_member? }
      end

      def github_team_member?(id)
        team_members = access_token.get("/teams/#{id}/members").parsed
        !!team_members.detect { |member| member['login'] == raw_info['login'] }
      rescue ::OAuth2::Error
        false
      end

      def team_id
        ENV["GITHUB_TEAM_ID"]
      end

      def github_organization_member?
		  #I should probably use this instead GET /orgs/:org/members/:user and check for a 204 status
        organization_members = access_token.get("/orgs/RosettaCommons/members").parsed
        !!organization_members.detect { |member| member['login'] == raw_info['login'] }
      rescue ::OAuth2::Error
        false
      end
    end
  end
end

OmniAuth.config.add_camelization "githubteammember", "GitHubTeamMember"
