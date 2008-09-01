# CFM Music
# Matt Constantine
#
# This is a sample ruleset that plays the blues scale.

rules = RuleSet.new

rules.add(:start) {|m|
  m.add :scale, :scale => Scale.name(:blues)
}

rules.add(:scale) {|m|
  m.add :scale, :up => 1, :forward => 1
  m.note!
}


cfm = Music.new(:ruleset => rules, 
                :number_generator => L{rand})
cfm.render
cfm.canvas.to_arkx