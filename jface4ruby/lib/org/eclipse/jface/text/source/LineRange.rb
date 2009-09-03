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
  module LineRangeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
    }
  end
  
  # Default implementation of {@link ILineRange}.
  # 
  # @since 3.0
  class LineRange 
    include_class_members LineRangeImports
    include ILineRange
    
    attr_accessor :f_start_line
    alias_method :attr_f_start_line, :f_start_line
    undef_method :f_start_line
    alias_method :attr_f_start_line=, :f_start_line=
    undef_method :f_start_line=
    
    attr_accessor :f_number_of_lines
    alias_method :attr_f_number_of_lines, :f_number_of_lines
    undef_method :f_number_of_lines
    alias_method :attr_f_number_of_lines=, :f_number_of_lines=
    undef_method :f_number_of_lines=
    
    typesig { [::Java::Int, ::Java::Int] }
    # Creates a new line range with the given specification.
    # 
    # @param startLine the start line
    # @param numberOfLines the number of lines
    def initialize(start_line, number_of_lines)
      @f_start_line = 0
      @f_number_of_lines = 0
      @f_start_line = start_line
      @f_number_of_lines = number_of_lines
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.ILineRange#getStartLine()
    def get_start_line
      return @f_start_line
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.ILineRange#getNumberOfLines()
    def get_number_of_lines
      return @f_number_of_lines
    end
    
    private
    alias_method :initialize__line_range, :initialize
  end
  
end
