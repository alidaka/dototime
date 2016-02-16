require 'sinatra/base'
require 'tilt/erb'

require_relative 'steam'
require_relative 'steam_auth'

module DotoTime
  class App < Sinatra::Base
    enable :sessions

    get '/' do
      "Pass a Steam ID, like #{url('1234')}"
    end

    get %r{/(\d+)} do |id|
      friend_ids = steam.get_friends(id).each_with_object([]) do |friend, memo|
        memo << friend[:id]
      end

      players = steam.get_player_infos(friend_ids)
                  .sort_by{ |p| p[:id]}
                  .sort_by{ |p| p[:state]}

      erb :index, locals: { players: players }
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
        @steam = Steam.new(host: ENV['STEAM_ENDPOINT'], api_key: ENV['STEAM_KEY'])
      end

      @steam
    end

    run! if app_file == $0
  end
end
