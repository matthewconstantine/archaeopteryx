module CFM
  
  require 'cfm/abs_pitch'
  require 'cfm/scales'
  #require 'pp'
  
  CHROMATIC = (0..11).to_a
  MAJOR = [0,2,4,5,7,9,11]
  
  # The Scale class takes a half-step sequence as an array and
  # extends that array into infinity.
  class Scale
    def initialize(steps)
      @steps = steps
    end
    
    def self.name(name)
      Scale.new(SCALES[name])
    end
    
    def self.mode(i)
      Scale.new(MODES[i%7])
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
      off = tonic % 12
      self[self.index(pitch - off) + interval] + off
    end
  end
  
  
  # The Canvas class is a grid of pitch and beats.
  # Each point on the grid contains a hash of the properties that
  # describe how a note should sound. New hashes are merged with old.
  class Canvas < Hash
    def initialize(default={})
      @default = {
        :duration => 0.1,
        :velocity => 120,
        :channel => 1
      }
    end
    def place_note(context)
      raise ArgumentError, "Context can't be nil" if context.nil?
      beat  = context.delete(:beat)
      pitch = context.delete(:pitch)
      raise ArgumentError, "you tried to place a nil beat" if beat.nil?
      raise ArgumentError, "you tried to place a nil pitch" if pitch.nil?
      puts "[PLACE_NOTE] #{beat} #{pitch}"
      self[beat] ||= {}
      self[beat][pitch] ||= @default.dup
      self[beat][pitch].merge! context
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
  
  class Context < Hash
    def initialize(properties=nil)
      super()
      properties ||= {
        :scale => Scale.new(MAJOR),
        :tonic => 60,
        :pitch => 60,
        :beat  => 1,
        :duration => 0.1,
        :velocity => 120,
        :generations => 30
      }
      update(properties)
    end
    
    def pitch(t)
      return t[:pitch] if t[:pitch]
      return self[:scale].next(self[:tonic], self[:pitch],  t[:up])   if t[:up]
      return self[:scale].next(self[:tonic], self[:pitch], -t[:down]) if t[:down]
      self[:pitch]
    end
    
    def beat(t)
      return t[:beat] if t[:beat]
      return self[:beat]  + t[:forward]      if t[:forward]
      return [self[:beat] - t[:back],0].max  if t[:back]
      self[:beat]
    end

    def velocity(t)
      return t[:velocity] if t[:velocity]
      return [self[:velocity]  + t[:harder], 127].min  if t[:harder]
      return [self[:velocity] - t[:softer],0].max      if t[:softer]
      self[:velocity]
    end
    
    def scale(t)
      #TODO: handle pitches that don't exist in the new scale
      return t[:scale] if t[:scale]
    end
    
    def generations(t)
      return t[:genrations] if t[:generations]
      return self[:generations] - 1 
    end
    
    def transform(t)
      from = self.inspect
      self[:scale] = scale t   if t[:scale]
      self[:tonic] = t[:tonic] if t[:tonic]
      self[:pitch] = pitch t
      self[:beat]  = beat  t
      self[:velocity] = velocity t
      self[:duration] = t[:duration] if t[:duration]
      self[:generations] = generations t
      puts "[TRANSFORM] \n\tfrom: #{from} \n\tto #{self.inspect}\n\tfor: #{t.inspect}"
      self
    end
  end
  
  class Motif
    attr_accessor :name, :context
    def initialize(name, context=nil)
      @name = name
      @context = context.dup unless context.nil?
      @context ||= Context.new
    end
    def self.start
      Motif.new(:start)
    end
  end
  
  class Rule < Struct.new(:closure, :probability)
  end
  
  class RuleSet
    def initialize
      @rules = {}
    end
    
    #todo: probability isn't hooked up yet
    def add(name, probability=0.5, &closure)
      @rules[name] ||= []
      @rules[name] << Rule.new(closure,probability)
    end
    
    def [](name)
      candidates = @rules[name]
      if candidates.nil? then raise "Rule named '#{name}' wasn't found." end
      return candidates.first if candidates.length == 1
      return candidates[rand(candidates.length)]  #TODO need to factor in probability here
    end
  end
  
  # The Music class puts notes on a Canvas and returns
  # the canvas to the style file.
  class Music
    require 'pp'
    attr_accessor :ruleset, :number_generator, :canvas
    def initialize(attributes)
      %w{ruleset number_generator}.each do |attribute|
        eval("@#{attribute} = attributes[:#{attribute}]")
      end
      @canvas ||= Canvas.new
      @motifs = [Motif.start]
    end
    
    def run(motif)
      puts "[RUN] #{motif.name}"
      @context = motif.context
      @ruleset[motif.name].closure.call(self)
    end
    
    # Adds a motif to the list of motifs to be processed
    def add(name, transformation={})
      if @context[:generations] > 0
        @motifs << Motif.new(name, @context.dup.transform(transformation))
      end
    end
    
    def matrix(name, probabilities, transformation={})
      probabilities.each_with_index do |probability, beat|
        add(name, transformation.merge!(:beat => beat+1) ) if @number_generator[] <= probability
      end
    end
    
    def note!(transformation={})
      context = @context.dup.transform(transformation)
      puts "[NOTE] #{context.inspect}"
      @canvas.place_note(context)
    end
    
    def done?
      @motifs.empty?
    end
    
    def render
      until done? do
        motif = @motifs.pop
        rule = run(motif) #run the rule matching this motif
      end
    end
    
  end
  
  
  
end