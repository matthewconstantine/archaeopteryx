module Archaeopteryx
  class CFMGenerator
    include CFM
    def initialize(attributes)
      @mutation = attributes[:mutation]
      @stylefile = attributes[:stylefile]
      reload
    end
    def reload
      @notes = eval(File.read(@stylefile))
    end
    def mutate(measure)
      puts "---------CFM Mutate requested-------------"
      reload
      # if @mutation[measure]
      #   reload # reloading can kill mutations!
      #   @notes.each {|drum| drum.mutate}
      # end
    end
    def notes(beat)
      puts "Beat: #{beat.inspect}"
      puts @notes[beat].inspect
      return @notes[beat] if @notes[beat]
      # @notes.each do |drum|
      #         if drum.play? beat
      #           return drum.note
      #         end
      #       end
      []
    end
  end
end


