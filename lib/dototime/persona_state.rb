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
  end
end
