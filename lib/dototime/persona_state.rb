module DotoTime
  class PersonaState
    def self.from_i(i)
      case i
      when nil then nil
      when 0 then :offline
      when 1 then :online
      when 2 then :busy
      when 3 then :away
      when 4 then :snooze
      when 5 then :looking_to_trade
      when 6 then :looking_to_play
      else raise ArgumentError.new("Invalid PersonaState value '#{i}'")
      end
    end

    def self.state_to_online_precedence(state)
      case state
      when :online           then 0
      when :looking_to_play  then 1
      when :looking_to_trade then 2
      when :busy             then 3
      when :snooze           then 4
      when :away             then 5
      when :offline          then 6
      else 7
      end
    end
  end
end
