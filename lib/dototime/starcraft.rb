module DotoTime
  class Starcraft
    @@cheats = [ 'show me the money',           'breathe deep',
                 'whats mine is mine',          'medieval man',
                 'modify the phase variance',   'ophelia',
                 'xprotoss#',                   'xterran#',
                 'xzerg#',                      'operation cwal',
                 'the gathering',               'game over man',
                 'there is no cow level',       'power overwhelming',
                 'terran#',                     'protoss#',
                 'zerg#',                       'staying alive',
                 'food for thought',            'something for nothing',
                 'noglues',                     'radio free zerg',
                 'war aint what it used to be', 'black sheep wall' ]

    def self.get_cheat
      cheat = @@cheats[rand(@@cheats.size)]
    end
  end
end
