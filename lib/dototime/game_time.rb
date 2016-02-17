module DotoTime
  class GameTime
    def self.game_time?(count)
      if count < 2
        :probably_not
      elsif count < 4
        :maybe
      else
        :yes
      end
    end
  end
end
