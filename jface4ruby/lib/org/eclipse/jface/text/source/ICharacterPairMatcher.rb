require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module ICharacterPairMatcherImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
    }
  end
  
  # A character pair matcher finds to a character at a certain document offset
  # the matching peer character. It is the matchers responsibility to define the
  # concepts of "matching" and "peer". The matching process starts at a given
  # offset. Starting of this offset, the matcher chooses a character close to
  # this offset. The anchor defines whether the chosen character is left or right
  # of the initial offset. The matcher then searches for the matching peer
  # character of the chosen character and if it finds one, delivers the minimal
  # region of the document that contains both characters.
  # 
  # @since 2.1
  module ICharacterPairMatcher
    include_class_members ICharacterPairMatcherImports
    
    class_module.module_eval {
      # Indicates the anchor value "right".
      const_set_lazy(:RIGHT) { 0 }
      const_attr_reader  :RIGHT
      
      # Indicates the anchor value "left".
      const_set_lazy(:LEFT) { 1 }
      const_attr_reader  :LEFT
    }
    
    typesig { [] }
    # Disposes this pair matcher.
    def dispose
      raise NotImplementedError
    end
    
    typesig { [] }
    # Clears this pair matcher. I.e. the matcher throws away all state it might
    # remember and prepares itself for a new call of the <code>match</code>
    # method.
    def clear
      raise NotImplementedError
    end
    
    typesig { [IDocument, ::Java::Int] }
    # Starting at the given offset, the matcher chooses a character close to this offset.
    # The matcher then searches for the matching peer character of the chosen character
    # and if it finds one, returns the minimal region of the document that contains both characters.
    # It returns <code>null</code> if there is no peer character.
    # 
    # @param iDocument the document to work on
    # @param i the start offset
    # @return the minimal region containing the peer characters
    def match(i_document, i)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the anchor for the region of the matching peer characters. The anchor
    # says whether the character that has been chosen to search for its peer character
    # has been left or right of the initial offset.
    # 
    # @return <code>RIGHT</code> or <code>LEFT</code>
    def get_anchor
      raise NotImplementedError
    end
  end
  
end
