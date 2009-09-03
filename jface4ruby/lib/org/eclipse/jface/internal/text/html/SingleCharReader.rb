require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Html
  module SingleCharReaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Html
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :Reader
    }
  end
  
  # <p>
  # Moved into this package from <code>org.eclipse.jface.internal.text.revisions</code>.</p>
  class SingleCharReader < SingleCharReaderImports.const_get :Reader
    include_class_members SingleCharReaderImports
    
    typesig { [] }
    # @see Reader#read()
    def read
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
    # @see Reader#read(char[],int,int)
    def read(cbuf, off, len)
      end_ = off + len
      i = off
      while i < end_
        ch = read
        if ((ch).equal?(-1))
          if ((i).equal?(off))
            return -1
          end
          return i - off
        end
        cbuf[i] = RJava.cast_to_char(ch)
        i += 1
      end
      return len
    end
    
    typesig { [] }
    # @see Reader#ready()
    def ready
      return true
    end
    
    typesig { [] }
    # Returns the readable content as string.
    # @return the readable content as string
    # @exception IOException in case reading fails
    def get_string
      buf = StringBuffer.new
      ch = 0
      while (!((ch = read)).equal?(-1))
        buf.append(RJava.cast_to_char(ch))
      end
      return buf.to_s
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__single_char_reader, :initialize
  end
  
end
