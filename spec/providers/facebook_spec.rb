require 'spec_helper'
require "shared_examples/oauth_provider_client"

RSpec.describe 'OauthTokenVerifier::Providers::Facebook' do
  describe '#verify_token' do
    it_behaves_like "oauth_provider_client", :facebook
  end
end
