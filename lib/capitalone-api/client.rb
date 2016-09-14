require 'logger'
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
      @logger        = Logger.new("#{Bundler.root}/log/capitalone_api.log")
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

      result = post_request("#{@server_url}/oauth/oauth20/token", params)

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

      result = post_request("#{@server_url}/oauth/oauth20/token", params)

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

    # @param [String] url
    # @param [Hash] params
    def post_request(url, params)
      @logger.info("URL:#{url}; params:#{params}")

      uri = URI.parse(url)

      req = Net::HTTP::Post.new(uri)
      req.set_form_data(params)

      res =
        Net::HTTP.start(uri.hostname, uri.port, ssl_options) do |http|
          http.request(req)
        end

      @logger.info("URL:#{url}; response:#{res.body}")

      MultiJson.load(res.body)
    end

    # @param [String] url
    # @param [String] access_token
    def get_request(url, access_token)
      @logger.info("URL:#{url}; access_token:#{access_token}")

      uri = URI.parse(url)

      req = Net::HTTP::Get.new(uri)
      req['Accept'] = ['application/json', 'v=1']
      req['Authorization'] = ["Bearer #{access_token}"]

      res =
        Net::HTTP.start(uri.hostname, uri.port, ssl_options) do |http|
          http.request(req)
        end

      @logger.info("URL:#{url}; response:#{res.body}")

      MultiJson.load(res.body)
    end

    def ssl_options
      { use_ssl: true, ssl_version: 'TLSv1_2' }
    end

  end
end

