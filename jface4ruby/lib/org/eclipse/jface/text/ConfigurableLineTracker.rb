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
  module ConfigurableLineTrackerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Standard implementation of a generic
  # {@link org.eclipse.jface.text.ILineTracker}.
  # <p>
  # The line tracker can be configured with the set of legal line delimiters.
  # Line delimiters are unconstrained. The line delimiters are used to compute
  # the tracker's line structure. In the case of overlapping line delimiters, the
  # longest line delimiter is given precedence of the shorter ones.
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class ConfigurableLineTracker < ConfigurableLineTrackerImports.const_get :AbstractLineTracker
    include_class_members ConfigurableLineTrackerImports
    
    # The strings which are considered being the line delimiter
    attr_accessor :f_delimiters
    alias_method :attr_f_delimiters, :f_delimiters
    undef_method :f_delimiters
    alias_method :attr_f_delimiters=, :f_delimiters=
    undef_method :f_delimiters=
    
    # A predefined delimiter information which is always reused as return value
    attr_accessor :f_delimiter_info
    alias_method :attr_f_delimiter_info, :f_delimiter_info
    undef_method :f_delimiter_info
    alias_method :attr_f_delimiter_info=, :f_delimiter_info=
    undef_method :f_delimiter_info=
    
    typesig { [Array.typed(String)] }
    # Creates a standard line tracker for the given line delimiters.
    # 
    # @param legalLineDelimiters the tracker's legal line delimiters,
    # may not be <code>null</code> and must be longer than 0
    def initialize(legal_line_delimiters)
      @f_delimiters = nil
      @f_delimiter_info = nil
      super()
      @f_delimiter_info = DelimiterInfo.new
      Assert.is_true(!(legal_line_delimiters).nil? && legal_line_delimiters.attr_length > 0)
      @f_delimiters = TextUtilities.copy(legal_line_delimiters)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ILineTracker#getLegalLineDelimiters()
    def get_legal_line_delimiters
      return TextUtilities.copy(@f_delimiters)
    end
    
    typesig { [String, ::Java::Int] }
    # @see org.eclipse.jface.text.AbstractLineTracker#nextDelimiterInfo(java.lang.String, int)
    def next_delimiter_info(text, offset)
      if (@f_delimiters.attr_length > 1)
        info = TextUtilities.index_of(@f_delimiters, text, offset)
        if ((info[0]).equal?(-1))
          return nil
        end
        @f_delimiter_info.attr_delimiter_index = info[0]
        @f_delimiter_info.attr_delimiter = @f_delimiters[info[1]]
      else
        index = text.index_of(@f_delimiters[0], offset)
        if ((index).equal?(-1))
          return nil
        end
        @f_delimiter_info.attr_delimiter_index = index
        @f_delimiter_info.attr_delimiter = @f_delimiters[0]
      end
      @f_delimiter_info.attr_delimiter_length = @f_delimiter_info.attr_delimiter.length
      return @f_delimiter_info
    end
    
    private
    alias_method :initialize__configurable_line_tracker, :initialize
  end
  
end
