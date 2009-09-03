require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Rules
  module TokenImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Standard implementation of <code>IToken</code>.
  class Token 
    include_class_members TokenImports
    include IToken
    
    class_module.module_eval {
      # Internal token type: Undefined
      const_set_lazy(:T_UNDEFINED) { 0 }
      const_attr_reader  :T_UNDEFINED
      
      # Internal token type: EOF
      const_set_lazy(:T_EOF) { 1 }
      const_attr_reader  :T_EOF
      
      # Internal token type: Whitespace
      const_set_lazy(:T_WHITESPACE) { 2 }
      const_attr_reader  :T_WHITESPACE
      
      # Internal token type: Others
      const_set_lazy(:T_OTHER) { 3 }
      const_attr_reader  :T_OTHER
      
      # Standard token: Undefined.
      const_set_lazy(:UNDEFINED) { Token.new(T_UNDEFINED) }
      const_attr_reader  :UNDEFINED
      
      # Standard token: End Of File.
      const_set_lazy(:EOF) { Token.new(T_EOF) }
      const_attr_reader  :EOF
      
      # Standard token: Whitespace.
      const_set_lazy(:WHITESPACE) { Token.new(T_WHITESPACE) }
      const_attr_reader  :WHITESPACE
      
      # Standard token: Neither {@link #UNDEFINED}, {@link #WHITESPACE}, nor {@link #EOF}.
      # @deprecated will be removed
      const_set_lazy(:OTHER) { Token.new(T_OTHER) }
      const_attr_reader  :OTHER
    }
    
    # The type of this token
    attr_accessor :f_type
    alias_method :attr_f_type, :f_type
    undef_method :f_type
    alias_method :attr_f_type=, :f_type=
    undef_method :f_type=
    
    # The data associated with this token
    attr_accessor :f_data
    alias_method :attr_f_data, :f_data
    undef_method :f_data
    alias_method :attr_f_data=, :f_data=
    undef_method :f_data=
    
    typesig { [::Java::Int] }
    # Creates a new token according to the given specification which does not
    # have any data attached to it.
    # 
    # @param type the type of the token
    # @since 2.0
    def initialize(type)
      @f_type = 0
      @f_data = nil
      @f_type = type
      @f_data = nil
    end
    
    typesig { [Object] }
    # Creates a new token which represents neither undefined, whitespace, nor EOF.
    # The newly created token has the given data attached to it.
    # 
    # @param data the data attached to the newly created token
    def initialize(data)
      @f_type = 0
      @f_data = nil
      @f_type = T_OTHER
      @f_data = data
    end
    
    typesig { [Object] }
    # Re-initializes the data of this token. The token may not represent
    # undefined, whitespace, or EOF.
    # 
    # @param data to be attached to the token
    # @since 2.0
    def set_data(data)
      Assert.is_true(is_other)
      @f_data = data
    end
    
    typesig { [] }
    # @see IToken#getData()
    def get_data
      return @f_data
    end
    
    typesig { [] }
    # @see IToken#isOther()
    def is_other
      return ((@f_type).equal?(T_OTHER))
    end
    
    typesig { [] }
    # @see IToken#isEOF()
    def is_eof
      return ((@f_type).equal?(T_EOF))
    end
    
    typesig { [] }
    # @see IToken#isWhitespace()
    def is_whitespace
      return ((@f_type).equal?(T_WHITESPACE))
    end
    
    typesig { [] }
    # @see IToken#isUndefined()
    def is_undefined
      return ((@f_type).equal?(T_UNDEFINED))
    end
    
    private
    alias_method :initialize__token, :initialize
  end
  
end
