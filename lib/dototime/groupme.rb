require 'net/http'
require 'json'

module DotoTime
  class GroupMe
    def initialize(host:, bot_id:)
      @host = host
      @bot_id = bot_id
    end

    def send(message)
      uri = URI(@host)
      request = Net::HTTP::Post.new(
        uri.request_uri,
        initheader = {'Content-Type' =>'application/json'}
      )
      request.body = { "bot_id" => @bot_id, "text" => message }.to_json

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.request(request)
    end

    def callback(data)
      case data['text'].strip
      when '!starcraft' then
        send 'power overwhelming'
      when /^!echo (.*)/ then
        send "#{$1}"
      when '!roll' then
        send r(100)
      when /^!roll (\d+)/ then
        send r($1)
      when '!flip' then
        send (r(2) == 2)
      when '!ping' then
      else
      end
    end

    def r(max)
      unless max.integer? && max > 0
        raise ArgumentError("expected positive integer; got #{max}")
      end

      rand(1..max)
    end
  end
end
