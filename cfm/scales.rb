module CFM
  # grabbed from:
  # GPL licensed by unknown
  # http://search.cpan.org/src/BDAGLISH/Music-Scales-0.07/lib/Music/Scales.pm
  
  SCALES = {
   :ionian             => [0,2,4,5,7,9,11],	              
   :dorian             => [0,2,3,5,7,9,10],	              
   :phrygian           => [0,1,3,5,7,8,10],	              
   :lydian             => [0,2,4,6,7,9,11],	              
   :mixolydian         => [0,2,4,5,7,9,10],	              
   :aeolian            => [0,2,3,5,7,8,10],	              
   :locrian            => [0,1,3,5,6,8,10],	              
   :harmonic_minor     => [0,2,3,5,7,8,11],	              
   :melodic_minor      => [0,2,3,5,7,9,11],	              
   :blues              => [0,3,5,6,7,10],		              
   :pentatonic         => [0,2,4,7,9],		                
   :chromatic          => [0,1,2,3,4,5,6,7,8,9,10,11],    
   :diminished         => [0,2,3,5,6,8,9,11],	            
   :whole              => [0,2,4,6,8,10],		              
   :augmented          => [0,3,4,7,8,11],		              
   :hungarian_minor    => [0,2,3,6,7,8,11],	              
   :dimished_arpeggio  => [0,3,6,9],			                
   :augmented_arpeggio => [0,4,8],			                  
   :neapolitan_minor   => [0,1,3,5,7,8,11],	              
   :neapolitan_major   => [0,1,3,5,7,9,11],	              
   :todi               => [0,1,3,6,7,8,11],	              
   :marva              => [0,1,4,6,7,9,11],	              
   :persian            => [0,1,4,5,6,8,11],	              
   :oriental           => [0,1,4,5,6,9,10],	              
   :romanian           => [0,2,3,6,7,9,10],	              
   :pelog              => [0,1,3,7,10],		                
   :iwato              => [0,1,5,6,10],		                
   :hirajoshi          => [0,2,3,7,8],		                
   :egyptian           => [0,2,5,7,10],		                
   :pentatonic_minor   => [0,3,5,7,10]
  }              
  
  MODES = [
    CFM::SCALES[:ionian    ],
    CFM::SCALES[:dorian    ],
    CFM::SCALES[:phrygian  ],
    CFM::SCALES[:lydian    ],
    CFM::SCALES[:mixolydian],
    CFM::SCALES[:aeolian   ],
    CFM::SCALES[:locrian   ]
  ]
  
end