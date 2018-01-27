include ::OauthTokenVerifier

module OauthTokenVerifier
  RSpec.shared_context "oauth_provider_client" do |provider|
    context "with correct configuration" do
      before do
        OauthTokenVerifier.configure do |config|
          config.enabled_providers = [:vk, :facebook, :google]
        end
      end

      context "with correct access token" do
        it "returns Struct containing user data", :vcr do
          response = verify(provider, token: 'correct_token')
          expect(response).to respond_to(:uid)
          expect(response).to respond_to(:info)
          expect(response).to respond_to(:provider)
        end
      end

      context "with incorrect access token" do
        it "returns error message", :vcr do
          expect{ verify(provider, token: 'incorrect_token') }
          .to raise_error(OauthTokenVerifier::TokenVerifier::TokenCheckError)
        end
      end
    end

    context "without being properly configured" do
      before do
        OauthTokenVerifier.configure do |config|
          config.enabled_providers = []
        end
      end

      it "does not perform any action", :vcr do
        expect{ verify(provider, token: 'correct_token') }
        .to raise_error(OauthTokenVerifier::TokenVerifier::NoProviderFoundError)
      end
    end

  end
end
