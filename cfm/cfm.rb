module CFM
  
  require 'cfm/cfm_generator'
  #require 'pp'
  
  CHROMATIC = (0..11).to_a
  MAJOR = [0,2,4,5,7,9,11]
  
  class Scale
    def initialize(steps)
      @steps = steps
    end

    # returns the number of half-steps from zero for any degree of a scale
    def [](degree)
      @steps[degree % @steps.length] + (12*(degree/@steps.length)) 
    end

    # finds the interval for any pitch in a scale
    # or nil if the pitch doesn't exist in a scale
    def index(pitch)
      i = base_index(pitch)
      return nil if i.nil?
      i + (@steps.length*(pitch/12)) # => 6, 6, 43, 43, 43
    end

    def base_index(pitch)  #probably needs a different name
      @steps.index(pitch % 12)
    end

    # for a scale begining on tonic return the pitch of the next interval 
    def next(tonic, pitch, interval=1)
      puts "#{tonic} #{pitch} #{interval}"
      off = tonic % 12
      self[self.index(pitch - off) + interval] + off
    end
  end
  
  
  class Shape
    attr_accessor :name, :state, :transform
    def initialize(name, transform={}, state=nil)
      @transform = transform.dup
      @name = name
      @state = state.dup unless state.nil?
      @state ||= {
        :pitch => 55, #C4 #aside form pitch and beat (possibly), these are the start_shape defaults.
        :beat => 1,
        :tonic => 60, #C4    
        :velocity => 120,
        :scale => Scale.new(MAJOR)
      }
      self.transform!
    end

    
    def pitch(v, scale)
      l = scale.length
      puts("pitch: #{state[:pitch]} v: #{v}")
      state[:pitch] = state[:pitch] + (scale[v%l] + scale.last*(v/l))
    end
    
    def transform! # this is ugly. where's ruby's += operator?
      puts @name
      puts "transform: #{@transform.inspect}"
      begin
        @state[:pitch] = @state[:scale].next(@state[:tonic],@state[:pitch])
        #@state[:pitch] = @state[:pitch] + (@transform[:pitch]||0)
        @state[:beat]  = @state[:beat]  + (@transform[:beat]||0)
        @state[:velocity] = [@state[:velocity] + (@transform[:velocity]||0) ,0].max
      rescue => e
        raise e
        #raise "Transform failed for: #{self.inspect}"
      end
    end
    
    def terminate?
      state[:beat] > 16 or 
      state[:beat] < 0 or
      state[:pitch] > 180 or 
      state[:pitch] < 20
    end
    
    def inspect
      "#{name.inspect} - state: #{state.inspect} transform: #{transform.inspect}"
    end
  end
  
  
  class Rule < Struct.new(:name, :shapes)
  end

  class Canvas < Hash
    def initialize(default={})
      @default = {
        :duration => 0.1,
        :velocity => 120,
        :channel => 1
      }
    end
    def place_note(beat,pitch,state = {})
      raise ArgumentError, "you tried to place a nil beat" if beat.nil?
      raise ArgumentError, "you tried to place a nil pitch" if pitch.nil?
      puts "  [PLACE_NOTE] #{pitch}"
      self[beat] ||= {}
      self[beat][pitch] ||= @default.dup
      self[beat][pitch].merge! state
    end
    def to_arkx
      notes = {}
      self.each do |i,beat|
        notes[i] ||= []
        beat.each do |j, note|
          notes[i] << Note.create(:channel => note[:channel],
                                  :number => j,
                                  :duration => note[:duration],
                                  :velocity => note[:velocity] )
        end
      end
      puts notes.inspect
      notes
    end
  end
  
  class Music
    
    attr_accessor :canvas
    
    def initialize
      @limiter = 200  #basic recursion safety net for now.
      @todo = [Shape.new(:startshape, {})]
      @rules = {} #hash of rules keyed by shape name
      @canvas = Canvas.new
      @notes = {} #hash of arrays keyed by beat (allows for negative beats for now)
    end
    
    def add_rule(rule)
      @rules[rule.name] ||= []
      @rules[rule.name] << rule
    end
    
    # alternate for simpler style declaration
    # def add_rule(name, *shape_args)
    #   shapes = []
    #   shape_args.map {|arg| shapes << Shape.new(*arg)}
    #   rule = Rule.new(name, shapes)
    #   @rules[rule.name] ||= []
    #   @rules[rule.name] << rule
    # end
    
    def lookup_rule(name)
      rule = @rules[name]
      if rule.nil? then raise "Rule named '#{name.inspect}' not found." end
      return rule.first if rule.length == 1
      return rule[rand(rule.length)]
    end
    
    def done?
      @limiter = @limiter - 1
      @todo.empty? or @limiter.zero?
    end
    
    
    # 1: Take a shape off the @todo
    # 2: Find the rule for that shape
    # 3: Place a note on the grid if it's named :note!
    # 4: Place each shape mentioned in the rule on the @todo
    def render
      until done? do
        start_shape = @todo.pop   #1
        rule = lookup_rule(start_shape.name)  #2
        rule.shapes.each do |shape|
          if shape.name == :note!  #3
            note = Shape.new(shape.name, shape.transform, start_shape.state)
            puts "   [Note!] #{shape.inspect} "
            @canvas.place_note(note.state[:beat], note.state[:pitch], note.state)
          else #4
            next_shape = Shape.new(shape.name, shape.transform, start_shape.state)
            @todo.push next_shape unless next_shape.terminate?
            #puts @todo.last.inspect
          end
        end
      end
    end
    
    
  end
end