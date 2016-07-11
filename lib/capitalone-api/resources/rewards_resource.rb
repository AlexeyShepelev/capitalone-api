module CapitalOneAPI
  module RewardsResource

    # @param [Hash] params
    def rewards_authorize_url(params = {})
      "#{base_authorize_url(params)}&scope=openid%20read_rewards_account_info"
    end

    # @param [String] access_token
    def get_rewards_accounts(access_token:)
      get_request("#{@server_url}/rewards/accounts", access_token)
    end

    # @param [String] access_token
    # @param [String] account_id
    def get_rewards_account_details(access_token:, account_id:)
      account_id = CGI.escape(account_id)
      get_request("#{@server_url}/rewards/accounts/#{account_id}", access_token)
    end

  end
end
