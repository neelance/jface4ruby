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
  module ITokenImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
    }
  end
  
  # A token to be returned by a rule.
  module IToken
    include_class_members ITokenImports
    
    typesig { [] }
    # Return whether this token is undefined.
    # 
    # @return <code>true</code>if this token is undefined
    def is_undefined
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return whether this token represents a whitespace.
    # 
    # @return <code>true</code>if this token represents a whitespace
    def is_whitespace
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return whether this token represents End Of File.
    # 
    # @return <code>true</code>if this token represents EOF
    def is_eof
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return whether this token is neither undefined, nor whitespace, nor EOF.
    # 
    # @return <code>true</code>if this token is not undefined, not a whitespace, and not EOF
    def is_other
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return a data attached to this token. The semantics of this data kept undefined by this interface.
    # 
    # @return the data attached to this token.
    def get_data
      raise NotImplementedError
    end
  end
  
end
