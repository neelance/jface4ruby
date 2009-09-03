require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Revisions
  module LineIndexOutOfBoundsExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Revisions
    }
  end
  
  # Thrown to indicate that an attempt to create or modify a {@link Range} failed because it would
  # have resulted in an illegal range. A range is illegal if its length is &lt;= 0 or if its start
  # line is &lt; 0.
  # 
  # @since 3.2
  class LineIndexOutOfBoundsException < LineIndexOutOfBoundsExceptionImports.const_get :IndexOutOfBoundsException
    include_class_members LineIndexOutOfBoundsExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 1 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Constructs an <code>LineIndexOutOfBoundsException</code> with no detail message.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Constructs an <code>LineIndexOutOfBoundsException</code> with the specified detail message.
    # 
    # @param s the detail message.
    def initialize(s)
      super(s)
    end
    
    typesig { [::Java::Int] }
    # Constructs a new <code>LineIndexOutOfBoundsException</code>
    # object with an argument indicating the illegal index.
    # 
    # @param index the illegal index.
    def initialize(index)
      super("Line index out of range: " + RJava.cast_to_string(index)) # $NON-NLS-1$
    end
    
    private
    alias_method :initialize__line_index_out_of_bounds_exception, :initialize
  end
  
end
