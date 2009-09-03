require "rjava"

# Copyright (c) 2009 Avaloq Evolution AG and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Tom Eicher (Avaloq Evolution AG) - initial API and implementation
module Org::Eclipse::Jface::Text
  module BlockTextSelectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Internal::Text, :SelectionProcessor
    }
  end
  
  # Standard implementation of {@link org.eclipse.jface.text.IBlockTextSelection}.
  # 
  # @since 3.5
  class BlockTextSelection < BlockTextSelectionImports.const_get :TextSelection
    include_class_members BlockTextSelectionImports
    overload_protected {
      include IBlockTextSelection
    }
    
    # The start line.
    attr_accessor :f_start_line
    alias_method :attr_f_start_line, :f_start_line
    undef_method :f_start_line
    alias_method :attr_f_start_line=, :f_start_line=
    undef_method :f_start_line=
    
    # The start column.
    attr_accessor :f_start_column
    alias_method :attr_f_start_column, :f_start_column
    undef_method :f_start_column
    alias_method :attr_f_start_column=, :f_start_column=
    undef_method :f_start_column=
    
    # The end line.
    attr_accessor :f_end_line
    alias_method :attr_f_end_line, :f_end_line
    undef_method :f_end_line
    alias_method :attr_f_end_line=, :f_end_line=
    undef_method :f_end_line=
    
    # The end column.
    attr_accessor :f_end_column
    alias_method :attr_f_end_column, :f_end_column
    undef_method :f_end_column
    alias_method :attr_f_end_column=, :f_end_column=
    undef_method :f_end_column=
    
    # The tabulator width used to compute visual columns from character offsets.
    attr_accessor :f_tab_width
    alias_method :attr_f_tab_width, :f_tab_width
    undef_method :f_tab_width
    alias_method :attr_f_tab_width=, :f_tab_width=
    undef_method :f_tab_width=
    
    typesig { [IDocument, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Creates a column selection for the given lines and columns.
    # 
    # @param document the document that this selection refers to
    # @param startLine the start line
    # @param startColumn the possibly virtual start column, measured in characters from the start
    # of <code>startLine</code>
    # @param endLine the inclusive end line
    # @param endColumn the exclusive and possibly virtual end column, measured in characters from
    # the start of <code>endLine</code>
    # @param tabWidth the tabulator width used to compute the visual offsets from character offsets
    def initialize(document, start_line, start_column, end_line, end_column, tab_width)
      @f_start_line = 0
      @f_start_column = 0
      @f_end_line = 0
      @f_end_column = 0
      @f_tab_width = 0
      super(document, compute_offset(document, start_line, start_column), compute_offset(document, end_line, end_column) - compute_offset(document, start_line, start_column))
      Assert.is_legal(start_line >= 0)
      Assert.is_legal(start_column >= 0)
      Assert.is_legal(end_line >= start_line)
      Assert.is_legal(end_column >= 0)
      Assert.is_legal(tab_width >= 0)
      @f_start_line = start_line
      @f_start_column = start_column
      @f_end_line = end_line
      @f_end_column = end_column
      @f_tab_width = tab_width > 0 ? tab_width : 8 # seems to be the default when StyledText.getTabs returns 0
    end
    
    class_module.module_eval {
      typesig { [IDocument, ::Java::Int, ::Java::Int] }
      # Returns the document offset for a given tuple of line and column count. If the column count
      # points beyond the end of the line, the end of the line is returned (virtual location). If the
      # line points beyond the number of lines, the end of the document is returned; if the line is
      # &lt; zero, 0 is returned.
      # 
      # @param document the document to get line information from
      # @param line the line in the document, may be greater than the line count
      # @param column the offset in the given line, may be greater than the line length
      # @return the document offset corresponding to the line and column counts
      def compute_offset(document, line, column)
        begin
          line_info = document.get_line_information(line)
          offset_in_line = Math.min(column, line_info.get_length)
          return line_info.get_offset + offset_in_line
        rescue BadLocationException => x
          if (line < 0)
            return 0
          end
          return document.get_length
        end
      end
    }
    
    typesig { [] }
    # @see org.eclipse.jface.text.TextSelection#getStartLine()
    def get_start_line
      return @f_start_line
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IColumnTextSelection#getStartColumn()
    def get_start_column
      return @f_start_column
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.TextSelection#getEndLine()
    def get_end_line
      return @f_end_line
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IColumnTextSelection#getEndColumn()
    def get_end_column
      return @f_end_column
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.TextSelection#getText()
    def get_text
      document = get_document
      if (!(document).nil?)
        begin
          return SelectionProcessor.new(document, @f_tab_width).get_text(self)
        rescue BadLocationException => x
          # ignore and default to super implementation
        end
      end
      return super
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.TextSelection#hashCode()
    def hash_code
      prime = 31
      result = super
      result = prime * result + @f_end_column
      result = prime * result + @f_end_line
      result = prime * result + @f_start_column
      result = prime * result + @f_start_line
      return result
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.TextSelection#equals(java.lang.Object)
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!super(obj))
        return false
      end
      other = obj
      if (!(@f_end_column).equal?(other.attr_f_end_column))
        return false
      end
      if (!(@f_end_line).equal?(other.attr_f_end_line))
        return false
      end
      if (!(@f_start_column).equal?(other.attr_f_start_column))
        return false
      end
      if (!(@f_start_line).equal?(other.attr_f_start_line))
        return false
      end
      return true
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IColumnTextSelection#getRegions()
    def get_regions
      document = get_document
      if (!(document).nil?)
        begin
          return SelectionProcessor.new(document, @f_tab_width).get_ranges(self)
        rescue BadLocationException => x
          # default to single region behavior
        end
      end
      return Array.typed(IRegion).new([Region.new(get_offset, get_length)])
    end
    
    private
    alias_method :initialize__block_text_selection, :initialize
  end
  
end
