require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module TabsToSpacesConverterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Auto edit strategy that converts tabs into spaces.
  # <p>
  # Clients usually instantiate and configure this class but
  # can also extend it in their own subclass.
  # </p>
  # 
  # @since 3.3
  class TabsToSpacesConverter 
    include_class_members TabsToSpacesConverterImports
    include IAutoEditStrategy
    
    attr_accessor :f_tab_ratio
    alias_method :attr_f_tab_ratio, :f_tab_ratio
    undef_method :f_tab_ratio
    alias_method :attr_f_tab_ratio=, :f_tab_ratio=
    undef_method :f_tab_ratio=
    
    attr_accessor :f_line_tracker
    alias_method :attr_f_line_tracker, :f_line_tracker
    undef_method :f_line_tracker
    alias_method :attr_f_line_tracker=, :f_line_tracker=
    undef_method :f_line_tracker=
    
    typesig { [::Java::Int] }
    def set_number_of_spaces_per_tab(ratio)
      @f_tab_ratio = ratio
    end
    
    typesig { [ILineTracker] }
    def set_line_tracker(line_tracker)
      @f_line_tracker = line_tracker
    end
    
    typesig { [StringBuffer, ::Java::Int] }
    def insert_tab_string(buffer, offset_in_line)
      if ((@f_tab_ratio).equal?(0))
        return 0
      end
      remainder = offset_in_line % @f_tab_ratio
      remainder = @f_tab_ratio - remainder
      i = 0
      while i < remainder
        buffer.append(Character.new(?\s.ord))
        i += 1
      end
      return remainder
    end
    
    typesig { [IDocument, DocumentCommand] }
    def customize_document_command(document, command)
      text = command.attr_text
      if ((text).nil?)
        return
      end
      index = text.index_of(Character.new(?\t.ord))
      if (index > -1)
        buffer = StringBuffer.new
        @f_line_tracker.set(command.attr_text)
        lines = @f_line_tracker.get_number_of_lines
        begin
          i = 0
          while i < lines
            offset = @f_line_tracker.get_line_offset(i)
            end_offset = offset + @f_line_tracker.get_line_length(i)
            line = text.substring(offset, end_offset)
            position = 0
            if ((i).equal?(0))
              first_line = document.get_line_information_of_offset(command.attr_offset)
              position = command.attr_offset - first_line.get_offset
            end
            length_ = line.length
            j = 0
            while j < length_
              c = line.char_at(j)
              if ((c).equal?(Character.new(?\t.ord)))
                position += insert_tab_string(buffer, position)
              else
                buffer.append(c)
                (position += 1)
              end
              j += 1
            end
            i += 1
          end
          command.attr_text = buffer.to_s
        rescue BadLocationException => x
        end
      end
    end
    
    typesig { [] }
    def initialize
      @f_tab_ratio = 0
      @f_line_tracker = nil
    end
    
    private
    alias_method :initialize__tabs_to_spaces_converter, :initialize
  end
  
end
