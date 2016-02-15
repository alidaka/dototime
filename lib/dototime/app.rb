require 'sinatra/base'
require 'tilt/erb'

require_relative 'steam'

module DotoTime
  class App < Sinatra::Base
    #set :sessions, true

    get '/:id' do
      steam = Steam.new(host: ENV['STEAM_ENDPOINT'], api_key: ENV['STEAM_KEY'])

      friend_ids = steam.get_friends(params['id']).each_with_object([]) do |friend, memo|
        memo << friend[:id]
      end

      players = steam.get_player_infos(friend_ids).sort_by{ |p| p[:id]}.sort_by{ |p| p[:state]}

      erb :index, locals: { players: players }
    end

    run! if app_file == $0
  end
end
