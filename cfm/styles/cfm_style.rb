puts "CFM Style Loaded"

MAJOR = [0,2,4,5,7,9,11,12]

cfm = Music.new
cfm.add_rule Rule.new(:startshape, [
  Shape.new(:up, {:pitch => 0})
])
cfm.add_rule Rule.new(:up, [
  Shape.new(:up, {:beat => 1}),
  Shape.new(:note!)
])
cfm.add_rule Rule.new(:up, [
  Shape.new(:up, {:pitch => -3})
])
# cfm.add_rule Rule.new(:up, [
#   Shape.new(:up, {:pitch => -3})
# ])
cfm.add_rule Rule.new(:chord, [
  Shape.new(:note!),
  #Shape.new(:note!, {:pitch => 4, :beat => 0}),
  #Shape.new(:note!, {:pitch => 9})
])

# possible simpler style definition
# cfm = Music.new
# cfm.add_rule( :startshape, 
#   [:up, {:pitch => 40}]
# )
# cfm.add_rule( :up, 
#   [:up, {:beat => 2}],
#   [:chord]
# )
# cfm.add_rule( :up,
#   [:up, {:pitch => 3}]
# )
# cfm.add_rule( :up,
#   [:up, {:pitch => -3}]
# )
# cfm.add_rule( :chord,
#   [:note!, {:pitch => 1}],
#   [:note!, {:pitch => 4, :beat => 0}],
#   [:note!, {:pitch => 9}]
# )

cfm.render
cfm.canvas.to_arkx
