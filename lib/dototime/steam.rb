require 'net/http'
require 'json'

require_relative 'persona_state'

module DotoTime
  class Steam
    @@game_names = nil

    def initialize(host:, api_key:, ids:)
      @host = host
      @api_key = api_key
      @ids = ids

      initialize_game_names
    end

    def get_player_info(player_id)
      get_player_infos([player_id])
    end

    def get_default_player_infos
      get_player_infos(@ids)
    end

    def get_player_infos(player_ids)
      path = '/ISteamUser/GetPlayerSummaries/v0002/'
      ids = player_ids.inject {|memo, id| memo + ',' + id}
      params = { steamids: ids }

      result = get_json(path, params)
      extract_players(result['response']['players'])
    end

    def get_friends(player_id)
      path = '/ISteamUser/GetFriendList/v0001/'
      params = { steamid: player_id }

      result = get_json(path, params)
      friendslist = result['friendslist']
      friendslist ? extract_players(friendslist['friends']) : []
    end

    private
    def initialize_game_names
      unless @@game_names
        result = get_json('/ISteamApps/GetAppList/v2/')
        @@game_names = result['applist']['apps'].each_with_object({}) do |app, memo|
          memo[app['appid']] = app['name']
        end
      end
    end

    def extract_players(players_json)
      players_json.each_with_object([]) do |player, memo|
        memo << extract_player(player)
      end
    end

    def extract_player(player_json)
      game_id = player_json['gameid'].to_i
      game_name = @@game_names[game_id]

      { id: player_json['steamid'],
        name: player_json['personaname'],
        state: PersonaState.from_i(player_json['personastate']),
        game_id: game_id,
        game_name: game_name,
        in_dota: game_name && game_name.downcase.include?('dota 2') }
    end

    def get(path, params = {})
      params[:key] = @api_key
      uri = URI(@host)
      uri.path = path
      uri.query = URI.encode_www_form(params)
      Net::HTTP.get(uri)
    end

    def get_json(path, params = {})
      JSON.parse(get(path, params))
    end
  end
end
