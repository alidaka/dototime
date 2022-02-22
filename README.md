# dototime
GroupMe bot/Steam API integration

## Configuration
Currently all configuration is managed by environment variables. These are the important keys; details about getting the values are below.

```
export STEAM_KEY=1234ABCD...
export STEAM_ENDPOINT=http://api.steampowered.com
export GROUPME_BOT_ID=1234abcd...
export GROUPME_ENDPOINT=https://api.groupme.com/v3/bots/post
export STEAM_IDS=1234,2345,3456,...
```

Personally I use [`direnv`](http://direnv.net/) to manage environments--the above is a sample `.envrc` file placed in the project root.

### Steam
##### STEAM_KEY
Register and get your own API key from [Steam](https://steamcommunity.com/dev/).

##### STEAM_IDS (optional)
Comma-delimited list of SteamIDs for the bot to follow (e.g., getting online/offline status).

You can get your own SteamID by logging in to Steam in a browser, then going to your profile. The link should look like:
`https://steamcommunity.com/profiles/12345678901234567/`

If your profile is public, <http://localhost:4567/12345678901234567> or <http://doto.lidaka.us/12345678901234567> should show your friend list. From here you can readily get your friends' SteamIDs.

### GroupMe
##### GROUPME_BOT_ID
Sign up for an access token on [GroupMe](https://dev.groupme.com/), then either read the [tutorial](https://dev.groupme.com/tutorials/bots) or directly create your [bot](https://dev.groupme.com/bots). Also I've already created a test bot ID and GroupMe channel--please email me for details if you don't want to create your own just yet.

When creating your bot, the host for your callback URL should be publicly-accessible, with path `/bot/callback`; e.g., <http://example.com/bot/callback>.

## Running
```
bundle install
bundle exec ruby lib/dototime/app.rb
```

Visit <http://localhost:4567> for the web site.

To test the callback locally, simulate posted messages (more fields documented on GroupMe's [tutorial](https://dev.groupme.com/tutorials/bots)):
`curl -X POST -d '{"text":"!help"}' -H 'Content-Type: application/json' http://localhost:4567/bot/callback`
