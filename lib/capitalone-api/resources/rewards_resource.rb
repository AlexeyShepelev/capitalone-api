module CapitalOneAPI
  module RewardsResource

    def rewards_authorize_url
      "#{base_authorize_url}%20read_rewards_account_info"
    end

    # @param [String] access_token
    def get_rewards_accounts(access_token:)
      uri = URI.parse("#{@server_url}/rewards/accounts")

      req = Net::HTTP::Get.new(uri)
      req['Accept'] = ['application/json', 'v=1']
      req['Authorization'] = ["Bearer #{access_token}"]

      res =
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(req)
        end

      MultiJson.load(res.body)
    end

    # @param [String] access_token
    # @param [String] account_id
    def get_rewards_account_details(access_token:, account_id:)
      uri = URI.parse("#{@server_url}/rewards/accounts/#{account_id}")

      req = Net::HTTP::Get.new(uri)
      req['Accept'] = ['application/json', 'v=1']
      req['Authorization'] = ["Bearer #{access_token}"]

      res =
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(req)
        end

      MultiJson.load(res.body)
    end

  end
end
