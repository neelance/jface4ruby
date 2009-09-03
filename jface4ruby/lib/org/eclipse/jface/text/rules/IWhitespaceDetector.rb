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
  module IWhitespaceDetectorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
    }
  end
  
  # Defines the interface by which <code>WhitespaceRule</code>
  # determines whether a given character is to be considered
  # whitespace in the current context.
  module IWhitespaceDetector
    include_class_members IWhitespaceDetectorImports
    
    typesig { [::Java::Char] }
    # Returns whether the specified character is whitespace.
    # 
    # @param c the character to be checked
    # @return <code>true</code> if the specified character is a whitespace char
    def is_whitespace(c)
      raise NotImplementedError
    end
  end
  
end
