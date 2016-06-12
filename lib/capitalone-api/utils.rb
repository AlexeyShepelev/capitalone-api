require 'cgi'
require 'json'

module CapitalOneAPI
  module Utils

    class << self

      # @param [String] url
      # @param [Hash] params
      def set_params_to_url(url:, params:)
        "#{url}&state=#{CGI.escape(params.to_json)}"
      end

      # @param [String] url
      def get_params_from_url(url)
        params = CGI::parse(url)['state'][0]
        JSON.parse(CGI.unescape(params))
      end

    end

  end
end
