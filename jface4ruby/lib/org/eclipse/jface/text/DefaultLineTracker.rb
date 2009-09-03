require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DefaultLineTrackerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Standard implementation of {@link org.eclipse.jface.text.ILineTracker}.
  # <p>
  # The line tracker considers the three common line delimiters which are '\n',
  # '\r', '\r\n'.
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class DefaultLineTracker < DefaultLineTrackerImports.const_get :AbstractLineTracker
    include_class_members DefaultLineTrackerImports
    
    class_module.module_eval {
      # The predefined delimiters of this tracker
      const_set_lazy(:DELIMITERS) { Array.typed(String).new(["\r", "\n", "\r\n"]) }
      const_attr_reader  :DELIMITERS
    }
    
    # $NON-NLS-3$ //$NON-NLS-1$ //$NON-NLS-2$
    # A predefined delimiter information which is always reused as return value
    attr_accessor :f_delimiter_info
    alias_method :attr_f_delimiter_info, :f_delimiter_info
    undef_method :f_delimiter_info
    alias_method :attr_f_delimiter_info=, :f_delimiter_info=
    undef_method :f_delimiter_info=
    
    typesig { [] }
    # Creates a standard line tracker.
    def initialize
      @f_delimiter_info = nil
      super()
      @f_delimiter_info = DelimiterInfo.new
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ILineTracker#getLegalLineDelimiters()
    def get_legal_line_delimiters
      return TextUtilities.copy(DELIMITERS)
    end
    
    typesig { [String, ::Java::Int] }
    # @see org.eclipse.jface.text.AbstractLineTracker#nextDelimiterInfo(java.lang.String, int)
    def next_delimiter_info(text, offset)
      ch = 0
      length_ = text.length
      i = offset
      while i < length_
        ch = text.char_at(i)
        if ((ch).equal?(Character.new(?\r.ord)))
          if (i + 1 < length_)
            if ((text.char_at(i + 1)).equal?(Character.new(?\n.ord)))
              @f_delimiter_info.attr_delimiter = DELIMITERS[2]
              @f_delimiter_info.attr_delimiter_index = i
              @f_delimiter_info.attr_delimiter_length = 2
              return @f_delimiter_info
            end
          end
          @f_delimiter_info.attr_delimiter = DELIMITERS[0]
          @f_delimiter_info.attr_delimiter_index = i
          @f_delimiter_info.attr_delimiter_length = 1
          return @f_delimiter_info
        else
          if ((ch).equal?(Character.new(?\n.ord)))
            @f_delimiter_info.attr_delimiter = DELIMITERS[1]
            @f_delimiter_info.attr_delimiter_index = i
            @f_delimiter_info.attr_delimiter_length = 1
            return @f_delimiter_info
          end
        end
        i += 1
      end
      return nil
    end
    
    private
    alias_method :initialize__default_line_tracker, :initialize
  end
  
end
