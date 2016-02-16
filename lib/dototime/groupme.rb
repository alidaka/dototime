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
      p '-------------------------- callback(data)'
      p data.to_s
      p '--------------------------'
      $stdout.flush
      case data['text'].strip
      when '!starcraft' then
        send 'power overwhelming'
      when /^!echo (.*)/ then
        send "#{$1}"
      else
      end
    end
  end
end
