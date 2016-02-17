require 'sinatra/base'
require 'tilt/erb'

require_relative 'steam'
require_relative 'steam_auth'
require_relative 'groupme'
require_relative 'presenter'

module DotoTime
  class App < Sinatra::Base
    enable :sessions

    get '/' do
      players = sort_players(steam.get_default_player_infos)
      erb :index, locals: { players: players, game_time_string: Presenter::game_time_answer(players) }
    end

    get %r{/(\d+)} do |id|
      friend_ids = steam.get_friends(id).each_with_object([]) do |friend, memo|
        memo << friend[:id]
      end

      players = sort_players(ids_to_players(friend_ids))
      erb :index, locals: { players: players, game_time_string: Presenter::game_time_answer(players) }
    end

    get '/bot/avatar' do
      send_file File.join(settings.public_folder, 'rattletrap.jpg')
    end

    get '/bot/:message' do
      response = groupme.send(params[:message])
      status response.code
      body response.message
    end

    post '/bot/callback' do
      request.body.rewind
      response = groupme.callback(JSON.parse(request.body.read), steam)
      if response
        status response.code
        body response.message
      else
        status 500
        body 'unknown failure'
      end
    end

    #get '/auth' do
      #redirect SteamAuth::authenticate(session, url('/'), url('/auth_reception'))
    #end

    #get '/auth_reception' do
      #SteamAuth::receive(params, request.url)
    #end

    private
    def steam
      unless @steam
        ids = ENV['STEAM_IDS'].split(',')
        @steam = Steam.new(host: ENV['STEAM_ENDPOINT'], api_key: ENV['STEAM_KEY'], ids: ids)
      end

      @steam
    end

    def groupme
      unless @groupme
        @groupme = GroupMe.new(host: ENV['GROUPME_ENDPOINT'], bot_id: ENV['GROUPME_BOT_ID'])
      end

      @groupme
    end

    def ids_to_players(ids)
      ids.empty? ? [] : players = steam.get_player_infos(ids)
    end

    def sort_players(players)
      players.sort_by{ |p| p[:id]}.sort_by{ |p| state_sort_value(p) }
    end

    def state_sort_value(player)
      if player[:in_dota]
        -2
      elsif player[:game_name]
        -1
      else
        PersonaState::state_to_online_precedence(player[:state])
      end
    end

    run! if app_file == $0
  end
end
