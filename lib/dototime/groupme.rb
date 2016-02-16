require 'net/http'
require 'json'

require_relative 'starcraft'
require_relative 'steam'

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

    def callback(data, steam)
      case data['text'].strip.downcase
      when '!starcraft' then
        send Starcraft.get_cheat
      when '!roll' then
        send r(100)
      when /^!roll (\d+)/ then
        send r($1.to_i)
      when '!flip' then
        send flip
      when '!ping' then
        send generate_player_statuses(steam)
      else
      end
    end

    def aggregate_statuses(players)
      { dota: players.count{ |p| p[:in_dota] },
        online: players.count{ |p| p[:state] != :offline },
        monitored: players.size }
    end

    def generate_player_statuses(steam)
      statuses = aggregate_statuses(steam.get_player_infos)
      "#{statuses[:dota]} players in Dota 2\n#{statuses[:online]} players online-ish\n#{statuses[:monitored]} players pinged"
    end

    def r(max)
      unless max.integer? && max > 0
        raise ArgumentError("expected positive integer; got #{max}")
      end

      rand(1..max).to_s
    end

    def flip
      r(2) == '2' ? 'heads' : 'tails'
    end
  end
end
