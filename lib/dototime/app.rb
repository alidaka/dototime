require 'sinatra/base'
require 'tilt/erb'

require_relative 'steam'
require_relative 'steam_auth'
require_relative 'groupme'

module DotoTime
  class App < Sinatra::Base
    enable :sessions

    get '/' do
      response = groupme.send('trying root again')
      if response.code == 200
        "Pass a Steam ID, like #{url('1234')}"
      else
        status response.code
        body response.message
      end
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

    get '/bot/:message' do
      response = groupme.send(params[:message])
      status response.code
      body response.message
    end

    post '/bot/callback' do
      groupme.send('got callback alright')

      request.body.rewind
      j = JSON.parse(request.body.read)
      groupme.send(j.to_s)

      request.body.rewind
      groupme.callback(JSON.parse(request.body.read))
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

    def groupme
      unless @groupme
        @groupme = GroupMe.new(host: ENV['GROUPME_ENDPOINT'], bot_id: ENV['GROUPME_BOT_ID'])
      end

      @groupme
    end

    run! if app_file == $0
  end
end
