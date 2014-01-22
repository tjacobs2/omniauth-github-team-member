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
        access_token.get("/orgs/RosettaCommons/members/" + raw_info['login']).status == 204
        #$stdout.write "Response: " + is_member.to_s() + "\n"
        #$stdout.write "Status: " + is_member.status.to_s() + "\n"
        #$stdout.write "Header: " + is_member.header.to_s() + "\n"
        
        #organization_members = access_token.get("/orgs/RosettaCommons/members").parsed
        #$stdout.write "LOGIN INFO RAW: " + raw_info['login'] + "\n"
        #$stdout.write "Count: " + organization_members.count.to_s() + "\n"
        #!!organization_members.detect { |member| member['login'] == raw_info['login'] }
        #false
      rescue ::OAuth2::Error
        false
      end
    end
  end
end

OmniAuth.config.add_camelization "githubteammember", "GitHubTeamMember"
