require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Rules
  module IWordDetectorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
    }
  end
  
  # Defines the interface by which <code>WordRule</code>
  # determines whether a given character is valid as part
  # of a word in the current context.
  module IWordDetector
    include_class_members IWordDetectorImports
    
    typesig { [::Java::Char] }
    # Returns whether the specified character is
    # valid as the first character in a word.
    # 
    # @param c the character to be checked
    # @return <code>true</code> is a valid first character in a word, <code>false</code> otherwise
    def is_word_start(c)
      raise NotImplementedError
    end
    
    typesig { [::Java::Char] }
    # Returns whether the specified character is
    # valid as a subsequent character in a word.
    # 
    # @param c the character to be checked
    # @return <code>true</code> if the character is a valid word part, <code>false</code> otherwise
    def is_word_part(c)
      raise NotImplementedError
    end
  end
  
end
