# CFM Music
# Matt Constantine
#
# This is a sample ruleset for the CFM music generator.

rules = RuleSet.new

# All RuleSets start with rule named :start.
# This one says to add :pick_a_mode to the motif stack with a
# context that begins on pitch C3.
rules.add(:start) {|m|
  m.add :pick_a_mode, :pitch => C3
}

# pick_a_mode randomly selects a modal scale.
# see http://en.wikipedia.org/wiki/Properties_of_musical_modes for music geekery
rules.add(:pick_a_mode) {|m|
  m.add :random_walk, :scale => Scale.mode(rand(6))
  #m.add :random_walk, :scale => Scale.name(:blues)
}

# define the first version of random_walk
# this adds a recursive motif to the stack that transforms up in pitch
# and forward in time.
# Also adds :bit which we'll define later 
rules.add(:random_walk) {|m|
  m.add :random_walk, :up => 1, :forward => 2
  m.add :bit
}

# Define the second version of random_walk that transforms down in pitch
# Now, each time we call random_walk, we get a 50/50 chance this
# version will run.
rules.add(:random_walk) {|m|
  m.add :random_walk, :down => 2, :forward => 2
  m.add :bit, :up => 12
}

# We could have just called m.note! above, but let's spice it up a bit.
# This gives us a basic chord in whatever scale we happen to be in.
rules.add(:bit) {|m|
  m.note!
  m.note! :up  => 3
  m.note! :up  => 5
}

# And for some low-level variation, lets sometimes do this.
# The :foward and :back keep this from being a static chord. Instead
# this version will arpegiate a bit.
rules.add(:bit) {|m|
  m.note! :duration => 0.3
  m.note! :up  => 1, :forward => 2
  m.note! :up  => 3, :back => 1
}

cfm = Music.new(:ruleset => rules, 
                :number_generator => L{rand})
cfm.render
cfm.canvas.to_arkx