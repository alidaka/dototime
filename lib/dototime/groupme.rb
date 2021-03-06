require 'net/http'
require 'json'

require_relative 'starcraft'
require_relative 'steam'
require_relative 'presenter'

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
      when '!help' then
        send help_message
      when '!starcraft' then
        send Starcraft.get_cheat
      when '!roll' then
        send r(100)
      when /^!roll (\d+)/ then
        max = $1.to_i
        send(r(max) + (max == 2 ? ' (have you tried "!flip"?)' : ''))
      when '!flip' then
        send flip
      when '!ping' then
        send player_statuses(steam)
      else
      end
    end

    private
    def help_message
      %q(!help
!ping
!roll
!roll #
!flip
!starcraft)
    end

    def aggregate_statuses(players)
      { dota: players.count{ |p| p[:in_dota] },
        online: players.count{ |p| p[:state] != :offline },
        monitored: players.size }
    end

    def player_statuses(steam)
      players = steam.get_default_player_infos
      statuses = aggregate_statuses(players)
      message =  "#{statuses[:dota]} players in Dota 2\n"
      message << "#{statuses[:online]} players online-ish\n"
      message << "#{statuses[:monitored]} players pinged\n"
      message << "#{Presenter::game_time_quip(players)}"
      message
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
