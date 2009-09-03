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
  module DefaultIndentLineAutoEditStrategyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # This strategy always copies the indentation of the previous line.
  # <p>
  # This class is not intended to be subclassed.</p>
  # 
  # @since 3.1
  class DefaultIndentLineAutoEditStrategy 
    include_class_members DefaultIndentLineAutoEditStrategyImports
    include IAutoEditStrategy
    
    typesig { [] }
    # Creates a new indent line auto edit strategy which can be installed on
    # text viewers.
    def initialize
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # Returns the first offset greater than <code>offset</code> and smaller than
    # <code>end</code> whose character is not a space or tab character. If no such
    # offset is found, <code>end</code> is returned.
    # 
    # @param document the document to search in
    # @param offset the offset at which searching start
    # @param end the offset at which searching stops
    # @return the offset in the specified range whose character is not a space or tab
    # @exception BadLocationException if position is an invalid range in the given document
    def find_end_of_white_space(document, offset, end_)
      while (offset < end_)
        c = document.get_char(offset)
        if (!(c).equal?(Character.new(?\s.ord)) && !(c).equal?(Character.new(?\t.ord)))
          return offset
        end
        offset += 1
      end
      return end_
    end
    
    typesig { [IDocument, DocumentCommand] }
    # Copies the indentation of the previous line.
    # 
    # @param d the document to work on
    # @param c the command to deal with
    def auto_indent_after_new_line(d, c)
      if ((c.attr_offset).equal?(-1) || (d.get_length).equal?(0))
        return
      end
      begin
        # find start of line
        p = ((c.attr_offset).equal?(d.get_length) ? c.attr_offset - 1 : c.attr_offset)
        info = d.get_line_information_of_offset(p)
        start = info.get_offset
        # find white spaces
        end_ = find_end_of_white_space(d, start, c.attr_offset)
        buf = StringBuffer.new(c.attr_text)
        if (end_ > start)
          # append to input
          buf.append(d.get(start, end_ - start))
        end
        c.attr_text = buf.to_s
      rescue BadLocationException => excp
        # stop work
      end
    end
    
    typesig { [IDocument, DocumentCommand] }
    # @see org.eclipse.jface.text.IAutoEditStrategy#customizeDocumentCommand(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.DocumentCommand)
    def customize_document_command(d, c)
      if ((c.attr_length).equal?(0) && !(c.attr_text).nil? && !(TextUtilities.ends_with(d.get_legal_line_delimiters, c.attr_text)).equal?(-1))
        auto_indent_after_new_line(d, c)
      end
    end
    
    private
    alias_method :initialize__default_indent_line_auto_edit_strategy, :initialize
  end
  
end
