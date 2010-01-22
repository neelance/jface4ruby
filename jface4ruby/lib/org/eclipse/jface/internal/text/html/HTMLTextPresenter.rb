require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Html
  module HTMLTextPresenterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Html
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :Reader
      include_const ::Java::Io, :StringReader
      include_const ::Java::Util, :Iterator
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Graphics, :Drawable
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Jface::Internal::Text::Link::Contentassist, :LineBreakingReader
      include_const ::Org::Eclipse::Jface::Text, :DefaultInformationControl
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextPresentation
    }
  end
  
  # <p>
  # Moved into this package from <code>org.eclipse.jface.internal.text.revisions</code>.</p>
  class HTMLTextPresenter 
    include_class_members HTMLTextPresenterImports
    include DefaultInformationControl::IInformationPresenter
    include DefaultInformationControl::IInformationPresenterExtension
    
    class_module.module_eval {
      const_set_lazy(:LINE_DELIM) { System.get_property("line.separator", "\n") }
      const_attr_reader  :LINE_DELIM
    }
    
    # $NON-NLS-1$ //$NON-NLS-2$
    attr_accessor :f_counter
    alias_method :attr_f_counter, :f_counter
    undef_method :f_counter
    alias_method :attr_f_counter=, :f_counter=
    undef_method :f_counter=
    
    attr_accessor :f_enforce_upper_line_limit
    alias_method :attr_f_enforce_upper_line_limit, :f_enforce_upper_line_limit
    undef_method :f_enforce_upper_line_limit
    alias_method :attr_f_enforce_upper_line_limit=, :f_enforce_upper_line_limit=
    undef_method :f_enforce_upper_line_limit=
    
    typesig { [::Java::Boolean] }
    def initialize(enforce_upper_line_limit)
      @f_counter = 0
      @f_enforce_upper_line_limit = false
      @f_enforce_upper_line_limit = enforce_upper_line_limit
    end
    
    typesig { [] }
    def initialize
      initialize__htmltext_presenter(true)
    end
    
    typesig { [String, TextPresentation] }
    def create_reader(hover_info, presentation)
      return HTML2TextReader.new(StringReader.new(hover_info), presentation)
    end
    
    typesig { [TextPresentation, ::Java::Int, ::Java::Int] }
    def adapt_text_presentation(presentation, offset, insert_length)
      yours_start = offset
      yours_end = offset + insert_length - 1
      yours_end = Math.max(yours_start, yours_end)
      e = presentation.get_all_style_range_iterator
      while (e.has_next)
        range = e.next_
        my_start = range.attr_start
        my_end = range.attr_start + range.attr_length - 1
        my_end = Math.max(my_start, my_end)
        if (my_end < yours_start)
          next
        end
        if (my_start < yours_start)
          range.attr_length += insert_length
        else
          range.attr_start += insert_length
        end
      end
    end
    
    typesig { [StringBuffer, String, TextPresentation] }
    def append(buffer, string, presentation)
      length_ = string.length
      buffer.append(string)
      if (!(presentation).nil?)
        adapt_text_presentation(presentation, @f_counter, length_)
      end
      @f_counter += length_
    end
    
    typesig { [String] }
    def get_indent(line)
      length_ = line.length
      i = 0
      while (i < length_ && Character.is_whitespace(line.char_at(i)))
        (i += 1)
      end
      return RJava.cast_to_string(((i).equal?(length_) ? line : line.substring(0, i))) + " " # $NON-NLS-1$
    end
    
    typesig { [Display, String, TextPresentation, ::Java::Int, ::Java::Int] }
    # {@inheritDoc}
    # 
    # @see org.eclipse.jface.text.DefaultInformationControl.IInformationPresenter#updatePresentation(org.eclipse.swt.widgets.Display,
    # java.lang.String, org.eclipse.jface.text.TextPresentation, int, int)
    # @deprecated Use {@link #updatePresentation(Drawable, String, TextPresentation, int, int)}
    # instead
    def update_presentation(display, hover_info, presentation, max_width, max_height)
      return update_presentation(display, hover_info, presentation, max_width, max_height)
    end
    
    typesig { [Drawable, String, TextPresentation, ::Java::Int, ::Java::Int] }
    # @see IHoverInformationPresenterExtension#updatePresentation(Drawable drawable, String, TextPresentation, int, int)
    # @since 3.2
    def update_presentation(drawable, hover_info, presentation, max_width, max_height)
      if ((hover_info).nil?)
        return nil
      end
      gc = SwtGC.new(drawable)
      begin
        buffer = StringBuffer.new
        max_number_of_lines = Math.round(max_height / gc.get_font_metrics.get_height)
        @f_counter = 0
        reader = LineBreakingReader.new(create_reader(hover_info, presentation), gc, max_width)
        last_line_formatted = false
        last_line_indent = nil
        line = reader.read_line
        line_formatted = reader.is_formatted_line
        first_line_processed = false
        while (!(line).nil?)
          if (@f_enforce_upper_line_limit && max_number_of_lines <= 0)
            break
          end
          if (first_line_processed)
            if (!last_line_formatted)
              append(buffer, LINE_DELIM, nil)
            else
              append(buffer, LINE_DELIM, presentation)
              if (!(last_line_indent).nil?)
                append(buffer, last_line_indent, presentation)
              end
            end
          end
          append(buffer, line, nil)
          first_line_processed = true
          last_line_formatted = line_formatted
          if (!line_formatted)
            last_line_indent = RJava.cast_to_string(nil)
          else
            if ((last_line_indent).nil?)
              last_line_indent = RJava.cast_to_string(get_indent(line))
            end
          end
          line = RJava.cast_to_string(reader.read_line)
          line_formatted = reader.is_formatted_line
          max_number_of_lines -= 1
        end
        if (!(line).nil?)
          append(buffer, LINE_DELIM, line_formatted ? presentation : nil)
          append(buffer, HTMLMessages.get_string("HTMLTextPresenter.ellipse"), presentation) # $NON-NLS-1$
        end
        return trim(buffer, presentation)
      rescue IOException => e
        # ignore TODO do something else?
        return nil
      ensure
        gc.dispose
      end
    end
    
    typesig { [StringBuffer, TextPresentation] }
    def trim(buffer, presentation)
      length_ = buffer.length
      end_ = length_ - 1
      while (end_ >= 0 && Character.is_whitespace(buffer.char_at(end_)))
        (end_ -= 1)
      end
      if ((end_).equal?(-1))
        return ""
      end # $NON-NLS-1$
      if (end_ < length_ - 1)
        buffer.delete(end_ + 1, length_)
      else
        end_ = length_
      end
      start = 0
      while (start < end_ && Character.is_whitespace(buffer.char_at(start)))
        (start += 1)
      end
      buffer.delete(0, start)
      presentation.set_result_window(Region.new(start, buffer.length))
      return buffer.to_s
    end
    
    private
    alias_method :initialize__htmltext_presenter, :initialize
  end
  
end
