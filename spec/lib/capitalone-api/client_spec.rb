require 'capitalone-api'

RSpec.describe CapitalOneAPI::Client do

  it "is initializable" do
    expect {
      described_class.new
    }.to raise_error(ArgumentError)

    @client = described_class.new(client_id: 'enterpriseapi-sb-Vh795odTJsJVpBF0qLmB4Ulc',
                                  client_secret: '48e491c72bc699e25f65f2aeb0024b540b135e2e',
                                  redirect_uri: 'https://example.com')
    expect(@client.client_id).to eq 'enterpriseapi-sb-Vh795odTJsJVpBF0qLmB4Ulc'
    expect(@client.client_secret).to eq '48e491c72bc699e25f65f2aeb0024b540b135e2e'
    expect(@client.redirect_uri).to eq 'https://example.com'
    expect(@client.server_url).to eq 'https://api.capitalone.com'
  end

  describe "rewards API wrapper" do

    before :each do
      @client = described_class.new(client_id:     'enterpriseapi-sb-Vh795odTJsJVpBF0qLmB4Ulc',
                                    client_secret: '48e491c72bc699e25f65f2aeb0024b540b135e2e',
                                    redirect_uri:  'https://example.com',
                                    server_url:    CapitalOneAPI::TEST_SERVER_URL)
    end

    it "returns correct authorize url" do
      expect(@client.rewards_authorize_url).to(
        eq("https://api-sandbox.capitalone.com/oauth/auz/authorize?redirect_uri=" +
           "https://example.com&client_id=enterpriseapi-sb-Vh795odTJsJVpBF0qLmB4Ulc&" +
           "response_type=code&scope=openid%20read_rewards_account_info")
      )
    end

    it "returns correct authorize url with params" do
      expect(@client.rewards_authorize_url(a: 1)).to(
        eq("https://api-sandbox.capitalone.com/oauth/auz/authorize?redirect_uri=" +
           "https://example.com&client_id=enterpriseapi-sb-Vh795odTJsJVpBF0qLmB4Ulc&" +
           "response_type=code&state=%7B%22a%22%3A1%7D&scope=openid%20read_rewards_account_info")
      )
    end

    it "returns correct params from callback url" do
      url = "https://example.com?code=hO-dfD8ECe6qwFpRxA1fsl-zkahO3HxjuVaUiQ&" +
            "state=%7B%22a%22%3A1%7D"
      params = CapitalOneAPI::Utils.get_params_from_url(url)
      expect(params).to eq('a' => 1)
    end

    it "gets access tokens" do
      VCR.use_cassette "get_access_tokens" do
        @result = @client.get_access_tokens('hO-dfD8ECe6qwFpRxA1fsl-zkahO3HxjuVaUiQ')
      end

      expect(@result['access_token']).to eq '0258a7fae03161fd1db4d99c8eebf689608ba057'
      expect(@result['refresh_token']).to eq 'o7Unz4x3tCoaWzZh_MrzoseHfCvtovfn6BgimQADqfQ'
    end

    it "refresh access token" do
      VCR.use_cassette "refresh_access_token" do
        @result = @client.refresh_access_token('X5B-T1hh1xXk5DSfMr_1Q6F-psSsF0l5pMUOmF09IDo')
      end

      expect(@result['access_token']).to eq '8a583e4307bad1513b248273a9183bdd0ce90c06'
      expect(@result['refresh_token']).to eq 'rm_YCV33nVeAkOEoBjUoSU3A8ytP2WpnahQ58fob4Xg'
    end

    it "gets rewards accounts" do
      VCR.use_cassette "get_rewards_accounts" do
        @result = @client.get_rewards_accounts(access_token: '8a583e4307bad1513b248273a9183bdd0ce90c06')
      end
      expect(@result).to(
        eq(
          {
            "rewardsAccounts" =>
              [
                {
                  "rewardsAccountReferenceId" => "+jaR3Du6APE+x4kQue7NB1Z6IEL1OWtPNoA4jkumi8xA/Rv0eY0VcPYd2Kzm5jNPNcfriz1XC0LlPgonb7VWsw==",
                  "accountDisplayName" => "Capital One Visa Platinum Miles *4458",
                  "rewardsCurrency" => "Miles",
                  "productAccountType" => "Credit Card",
                  "creditCardAccount" =>
                    {
                      "issuer" => "Capital One",
                      "product" => "Visa Platinum",
                      "lastFour" => "4458",
                      "network" => "Visa",
                      "isBusinessAccount" => false
                    }
                },
                {
                  "rewardsAccountReferenceId" => "+jaR3Du6APE+x4kQue7NBxknnYAP9j84ThkCoDaEC8ih/lmXpZF3yiGGniuFX/6Di2fn4sgM9jG1zJ3kxZkdUQ==",
                  "accountDisplayName" => "Capital One Visa Platinum Points *6299",
                  "rewardsCurrency" => "Points",
                  "productAccountType" => "Credit Card",
                  "creditCardAccount" =>
                    {
                      "issuer" => "Capital One",
                      "product" => "Visa Platinum",
                      "lastFour" => "6299",
                      "network" => "Visa",
                      "isBusinessAccount" => false
                    }
                },
                {
                  "rewardsAccountReferenceId" => "+jaR3Du6APE+x4kQue7NB9WemMPO70s8mUdjmylIhqXYxjokJ1GgcsoxxpjEV7aPX+TmXSFn6hZY1wC/C6XRSA==",
                  "accountDisplayName" => "Capital One Visa Signature Cash *3668",
                  "rewardsCurrency" => "Cash",
                  "productAccountType" => "Credit Card",
                  "creditCardAccount" =>
                    {
                      "issuer" => "Capital One",
                      "product" => "Visa Signature",
                      "lastFour" => "3668",
                      "network" => "Visa",
                      "isBusinessAccount" => false
                    }
                }
              ]
          }
        )
      )
    end

    it "gets rewards account details" do
      VCR.use_cassette "get_rewards_account_details" do
        @result =
          @client.get_rewards_account_details(access_token: '8a583e4307bad1513b248273a9183bdd0ce90c06',
                                              account_id:   '+jaR3Du6APE+x4kQue7NB1Z6IEL1OWtPNoA4jkumi8xA/Rv0eY0VcPYd2Kzm5jNPNcfriz1XC0LlPgonb7VWsw==')
      end

      expect(@result['accountDisplayName']).to eq 'Capital One Visa Platinum Miles *4458'
      expect(@result['rewardsBalance']).to eq 100930.0
      expect(@result['rewardsCurrency']).to eq 'Miles'
      expect(@result['balanceTimestamp']).to eq '2016-05-02T18:26:53-04:00'
    end

  end
end
