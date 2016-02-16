require 'openid'

module DotoTime
  class SteamAuth
    def self.authenticate(session, realm, return_to)
      unless @consumer
        @consumer = OpenID::Consumer.new(session, nil)
      end

      oid_request = @consumer.begin('http://steamcommunity.com/openid')
      oid_request.redirect_url(realm, return_to)
    end

    def self.receive(parameters, current_url)
      oid_response = @consumer.complete(parameters, current_url)
      case oid_response.status
      when OpenID::Consumer::SUCCESS
        'OID Success!'
      else
        raise Error.new('OID failed :(')
      end
    end
  end
end
