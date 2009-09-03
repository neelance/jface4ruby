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
  module ICharacterScannerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
    }
  end
  
  # Defines the interface of a character scanner used by rules.
  # Rules may request the next character or ask the character
  # scanner to unread the last read character.
  module ICharacterScanner
    include_class_members ICharacterScannerImports
    
    class_module.module_eval {
      # The value returned when this scanner has read EOF.
      const_set_lazy(:EOF) { -1 }
      const_attr_reader  :EOF
    }
    
    typesig { [] }
    # Provides rules access to the legal line delimiters. The returned
    # object may not be modified by clients.
    # 
    # @return the legal line delimiters
    def get_legal_line_delimiters
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the column of the character scanner.
    # 
    # @return the column of the character scanner
    def get_column
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the next character or EOF if end of file has been reached
    # 
    # @return the next character or EOF
    def read
      raise NotImplementedError
    end
    
    typesig { [] }
    # Rewinds the scanner before the last read character.
    def unread
      raise NotImplementedError
    end
  end
  
end
