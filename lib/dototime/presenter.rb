require_relative 'game_time'
module DotoTime
  class Presenter
    def self.game_time_answer(players)
      count = players.count{ |p| p[:in_dota] }
      case GameTime::game_time?(count)
      when :probably_not then 'Probably not.'
      when :maybe then 'Maybe...'
      when :yes then 'GOTO DOTO!'
      end
    end

    def self.game_time_quip(players)
      count = players.count{ |p| p[:in_dota] }
      case GameTime::game_time?(count)
      when :probably_not then '(Probably not doto time)'
      when :maybe then 'Maybe doto\'clock?'
      when :yes then 'GOTO DOTO!'
      end
    end
  end
end
