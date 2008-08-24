puts "CFM Style Loaded"


rules = RuleSet.new
rules.add(:start) {|m|
  m.matrix :bass_drum,  [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0]
  m.matrix :snare,      [0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
  # m.matrix :tom1,       [0.2, 0.0, 0.3, 0.0, 0.3, 0.1, 0.3, 0.4, 0.0, 0.0, 0.2, 0.0, 0.4, 0.0, 0.0, 0.0]
  # m.matrix :tom2,       [0.3, 0.0, 0.2, 0.6, 0.1, 0.0, 0.4, 0.1, 0.35, 0.15, 0.0, 0.0, 0.2, 0.0, 0.1, 0.0]
  # m.matrix :tom2,       [0.0, 0.0, 0.2, 0.0, 0.4, 0.0, 0.0, 0.0, 0.2, 0.0, 0.3, 0.0, 0.3, 0.1, 0.3, 0.4]
  m.matrix :a,          [0.76, 0.0, 0.23, 0.0, 0.0, 0.0, 0.67, 0.0, 0.15, 0.0, 0.15, 0.0, 0.49, 0.0, 0.15, 0.0]
  m.matrix :b,          [0.75, 0.0, 0.13, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.13, 0.0, 0.23, 0.0, 0.0, 0.35, 0.0]
  m.matrix :high1,      [0.9] * 16
  m.matrix :high2,      [0.65] * 16
  # m.matrix :e,          [0.85, 0.35] * 8
}

                                                
rules.add(:bass_drum) {|m| m.note! :pitch => C2}
rules.add(:snare)     {|m| m.note! :pitch => E2}
rules.add(:tom1)      {|m| m.note! :pitch => B2}
rules.add(:tom2)      {|m| m.note! :pitch => G2}
rules.add(:a)         {|m| m.note! :pitch => E3,  :velocity => 20}
rules.add(:b)         {|m| m.note! :pitch => FS3, :velocity => 40}
rules.add(:high1)     {|m| m.note! :pitch => FS2, :velocity => 10}
rules.add(:high2)     {|m| m.note! :pitch => CS2, :velocity => 10}
rules.add(:e)         {|m| m.note! :pitch => G2}


cfm = Music.new(:ruleset => rules, 
                :number_generator => L{rand})
cfm.render
cfm.canvas.to_arkx

