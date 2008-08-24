rules = RuleSet.new

rules.add(:start) {|m|
  m.add :scale
}

rules.add(:scale) {|m|
  m.add :scale, :up => 1, :forward => 1
  m.add :bit
}
rules.add(:scale) {|m|
  m.add :scale, :down => 1, :forward => 2
  m.add :bit, :up => 12
}


rules.add(:bit) {|m|
  m.note!
  m.note! :up  => 3
  m.note! :up  => 5
}

rules.add(:bit) {|m|
  m.note!
  m.note! :up  => 9, :forward => 1
  m.note! :up  => 2, :back => 3
}

cfm = Music.new(:ruleset => rules, 
                :number_generator => L{rand})
cfm.render
cfm.canvas.to_arkx