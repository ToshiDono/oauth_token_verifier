# frozen_string_literal: true

module OauthTokenVerifier::Providers
  class Google
    BaseFields = Struct.new(:uid, :provider, :info)
    DataFields = Struct.new(:first_name, :last_name)

    def verify_token(context)
      uri = build_uri(context.token)
      response = check_response(uri)
      parse_response(response)
    end

    private

    def build_uri(token)
      URI::HTTPS.build(host: 'www.googleapis.com',
                       path: '/oauth2/v3/tokeninfo',
                       query: { id_token: token }.to_query)
    end

    def check_response(uri)
      response = JSON.parse(Net::HTTP.get(uri))
      if error = response['error_description']
        raise TokenVerifier::TokenCheckError, error
      else
        response
      end
    end

    def parse_response(data)
      BaseFields.new(
        data['email'],
        'google_oauth2',
        DataFields.new(
          data['given_name'],
          data['family_name']
        )
      )
    end
  end
end
