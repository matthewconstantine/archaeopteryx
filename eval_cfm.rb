require 'lib/archaeopteryx'
require 'cfm/cfm'
require 'cfm/cfm_generator'
stylefile = ARGV.shift || "cfm/styles/sample.rb"
Arkx.new(:clock => Clock.new(120),
         :measures => 2,
         :logging => true,
         :evil_timer_offset_wtf => 0.2,
         :generator => CFMGenerator.new(
                                        :stylefile => stylefile,
                                        #:stylefile => "cfm/styles/cfm_style.rb",
                                        :mutation => L{|measure| 0 == (measure - 1) % 16}) ).go
