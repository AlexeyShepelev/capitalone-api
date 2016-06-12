require 'multi_json'
require_relative 'utils'
require_relative 'resources/rewards_resource'

module CapitalOneAPI
  class Client

    include RewardsResource

    attr_accessor :client_id, :client_secret, :redirect_uri, :server_url,
                  :access_token, :refresh_token

    def initialize(client_id:, client_secret:, redirect_uri:, server_url: CapitalOneAPI::PRODUCTION_SERVER_URL)
      @client_id     = client_id
      @client_secret = client_secret
      @redirect_uri  = redirect_uri
      @server_url    = server_url
    end

    # @param [String] auth_code
    def get_access_tokens(auth_code)

      params = {
        grant_type:    'authorization_code',
        code:          auth_code,
        client_id:     @client_id,
        client_secret: @client_secret,
        redirect_uri:  @redirect_uri
      }

      uri = URI.parse("#{@server_url}/oauth/oauth20/token")
      res = Net::HTTP.post_form(uri, params)

      result = MultiJson.load(res.body)

      @access_token  = result['access_token']
      @refresh_token = result['refresh_token']

      result
    end

    # @param [String] refresh_token
    def refresh_access_token(refresh_token)

      params = {
        grant_type:    'refresh_token',
        refresh_token: refresh_token,
        client_id:     @client_id,
        client_secret: @client_secret
      }

      uri = URI.parse("#{@server_url}/oauth/oauth20/token")
      res = Net::HTTP.post_form(uri, params)

      result = MultiJson.load(res.body)

      @access_token  = result['access_token']
      @refresh_token = result['refresh_token']

      result
    end

    private

    # @param [Hash] params
    def base_authorize_url(params = {})
      url = "#{server_url}/oauth/auz/authorize?redirect_uri=#{redirect_uri}&client_id=#{client_id}" +
            "&response_type=code"
      url = CapitalOneAPI::Utils.set_params_to_url(url: url, params: params) if params.any?
      url
    end

  end
end

