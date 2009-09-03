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
  module HTML2TextReaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Html
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :PushbackReader
      include_const ::Java::Io, :Reader
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Jface::Text, :TextPresentation
    }
  end
  
  # Reads the text contents from a reader of HTML contents and translates
  # the tags or cut them out.
  # <p>
  # Moved into this package from <code>org.eclipse.jface.internal.text.revisions</code>.</p>
  class HTML2TextReader < HTML2TextReaderImports.const_get :SubstitutionTextReader
    include_class_members HTML2TextReaderImports
    
    class_module.module_eval {
      const_set_lazy(:EMPTY_STRING) { "" }
      const_attr_reader  :EMPTY_STRING
      
      when_class_loaded do
        const_set :FgTags, HashSet.new
        FgTags.add("b") # $NON-NLS-1$
        FgTags.add("br") # $NON-NLS-1$
        FgTags.add("br/") # $NON-NLS-1$
        FgTags.add("div") # $NON-NLS-1$
        FgTags.add("h1") # $NON-NLS-1$
        FgTags.add("h2") # $NON-NLS-1$
        FgTags.add("h3") # $NON-NLS-1$
        FgTags.add("h4") # $NON-NLS-1$
        FgTags.add("h5") # $NON-NLS-1$
        FgTags.add("p") # $NON-NLS-1$
        FgTags.add("dl") # $NON-NLS-1$
        FgTags.add("dt") # $NON-NLS-1$
        FgTags.add("dd") # $NON-NLS-1$
        FgTags.add("li") # $NON-NLS-1$
        FgTags.add("ul") # $NON-NLS-1$
        FgTags.add("pre") # $NON-NLS-1$
        FgTags.add("head") # $NON-NLS-1$
        const_set :FgEntityLookup, HashMap.new(7)
        FgEntityLookup.put("lt", "<") # $NON-NLS-1$ //$NON-NLS-2$
        FgEntityLookup.put("gt", ">") # $NON-NLS-1$ //$NON-NLS-2$
        FgEntityLookup.put("nbsp", " ") # $NON-NLS-1$ //$NON-NLS-2$
        FgEntityLookup.put("amp", "&") # $NON-NLS-1$ //$NON-NLS-2$
        FgEntityLookup.put("circ", "^") # $NON-NLS-1$ //$NON-NLS-2$
        FgEntityLookup.put("tilde", "~") # $NON-NLS-2$ //$NON-NLS-1$
        FgEntityLookup.put("quot", "\"") # $NON-NLS-1$ //$NON-NLS-2$
      end
    }
    
    attr_accessor :f_counter
    alias_method :attr_f_counter, :f_counter
    undef_method :f_counter
    alias_method :attr_f_counter=, :f_counter=
    undef_method :f_counter=
    
    attr_accessor :f_text_presentation
    alias_method :attr_f_text_presentation, :f_text_presentation
    undef_method :f_text_presentation
    alias_method :attr_f_text_presentation=, :f_text_presentation=
    undef_method :f_text_presentation=
    
    attr_accessor :f_bold
    alias_method :attr_f_bold, :f_bold
    undef_method :f_bold
    alias_method :attr_f_bold=, :f_bold=
    undef_method :f_bold=
    
    attr_accessor :f_start_offset
    alias_method :attr_f_start_offset, :f_start_offset
    undef_method :f_start_offset
    alias_method :attr_f_start_offset=, :f_start_offset=
    undef_method :f_start_offset=
    
    attr_accessor :f_in_paragraph
    alias_method :attr_f_in_paragraph, :f_in_paragraph
    undef_method :f_in_paragraph
    alias_method :attr_f_in_paragraph=, :f_in_paragraph=
    undef_method :f_in_paragraph=
    
    attr_accessor :f_is_preformatted_text
    alias_method :attr_f_is_preformatted_text, :f_is_preformatted_text
    undef_method :f_is_preformatted_text
    alias_method :attr_f_is_preformatted_text=, :f_is_preformatted_text=
    undef_method :f_is_preformatted_text=
    
    attr_accessor :f_ignore
    alias_method :attr_f_ignore, :f_ignore
    undef_method :f_ignore
    alias_method :attr_f_ignore=, :f_ignore=
    undef_method :f_ignore=
    
    attr_accessor :f_header_detected
    alias_method :attr_f_header_detected, :f_header_detected
    undef_method :f_header_detected
    alias_method :attr_f_header_detected=, :f_header_detected=
    undef_method :f_header_detected=
    
    typesig { [Reader, TextPresentation] }
    # Transforms the HTML text from the reader to formatted text.
    # 
    # @param reader the reader
    # @param presentation If not <code>null</code>, formattings will be applied to
    # the presentation.
    def initialize(reader, presentation)
      @f_counter = 0
      @f_text_presentation = nil
      @f_bold = 0
      @f_start_offset = 0
      @f_in_paragraph = false
      @f_is_preformatted_text = false
      @f_ignore = false
      @f_header_detected = false
      super(PushbackReader.new(reader))
      @f_counter = 0
      @f_bold = 0
      @f_start_offset = -1
      @f_in_paragraph = false
      @f_is_preformatted_text = false
      @f_ignore = false
      @f_header_detected = false
      @f_text_presentation = presentation
    end
    
    typesig { [] }
    def read
      c = super
      if (!(c).equal?(-1))
        (@f_counter += 1)
      end
      return c
    end
    
    typesig { [] }
    def start_bold
      if ((@f_bold).equal?(0))
        @f_start_offset = @f_counter
      end
      (@f_bold += 1)
    end
    
    typesig { [] }
    def start_preformatted_text
      @f_is_preformatted_text = true
      set_skip_whitespace(false)
    end
    
    typesig { [] }
    def stop_preformatted_text
      @f_is_preformatted_text = false
      set_skip_whitespace(true)
    end
    
    typesig { [] }
    def stop_bold
      (@f_bold -= 1)
      if ((@f_bold).equal?(0))
        if (!(@f_text_presentation).nil?)
          @f_text_presentation.add_style_range(StyleRange.new(@f_start_offset, @f_counter - @f_start_offset, nil, nil, SWT::BOLD))
        end
        @f_start_offset = -1
      end
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jdt.internal.ui.text.SubstitutionTextReader#computeSubstitution(int)
    def compute_substitution(c)
      if ((c).equal?(Character.new(?<.ord)))
        return process_htmltag
      else
        if (@f_ignore)
          return EMPTY_STRING
        else
          if ((c).equal?(Character.new(?&.ord)))
            return process_entity
          else
            if (@f_is_preformatted_text)
              return process_preformatted_text(c)
            end
          end
        end
      end
      return nil
    end
    
    typesig { [String] }
    def html2_text(html)
      if ((html).nil? || (html.length).equal?(0))
        return EMPTY_STRING
      end
      html = RJava.cast_to_string(html.to_lower_case)
      tag = html
      if ((Character.new(?/.ord)).equal?(tag.char_at(0)))
        tag = RJava.cast_to_string(tag.substring(1))
      end
      if (!FgTags.contains(tag))
        return EMPTY_STRING
      end
      if (("pre" == html))
        # $NON-NLS-1$
        start_preformatted_text
        return EMPTY_STRING
      end
      if (("/pre" == html))
        # $NON-NLS-1$
        stop_preformatted_text
        return EMPTY_STRING
      end
      if (@f_is_preformatted_text)
        return EMPTY_STRING
      end
      if (("b" == html))
        # $NON-NLS-1$
        start_bold
        return EMPTY_STRING
      end
      if ((html.length > 1 && (html.char_at(0)).equal?(Character.new(?h.ord)) && Character.is_digit(html.char_at(1))) || ("dt" == html))
        # $NON-NLS-1$
        start_bold
        return EMPTY_STRING
      end
      if (("dl" == html))
        # $NON-NLS-1$
        return LINE_DELIM
      end
      if (("dd" == html))
        # $NON-NLS-1$
        return "\t"
      end # $NON-NLS-1$
      if (("li" == html))
        # $NON-NLS-1$
        # FIXME: this hard-coded prefix does not work for RTL languages, see https://bugs.eclipse.org/bugs/show_bug.cgi?id=91682
        return LINE_DELIM + HTMLMessages.get_string("HTML2TextReader.listItemPrefix")
      end # $NON-NLS-1$
      if (("/b" == html))
        # $NON-NLS-1$
        stop_bold
        return EMPTY_STRING
      end
      if (("p" == html))
        # $NON-NLS-1$
        @f_in_paragraph = true
        return LINE_DELIM
      end
      if (("br" == html) || ("br/" == html) || ("div" == html))
        # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
        return LINE_DELIM
      end
      if (("/p" == html))
        # $NON-NLS-1$
        in_paragraph = @f_in_paragraph
        @f_in_paragraph = false
        return in_paragraph ? EMPTY_STRING : LINE_DELIM
      end
      if ((html.starts_with("/h") && html.length > 2 && Character.is_digit(html.char_at(2))) || ("/dt" == html))
        # $NON-NLS-1$ //$NON-NLS-2$
        stop_bold
        return LINE_DELIM
      end
      if (("/dd" == html))
        # $NON-NLS-1$
        return LINE_DELIM
      end
      if (("head" == html) && !@f_header_detected)
        # $NON-NLS-1$
        @f_header_detected = true
        @f_ignore = true
        return EMPTY_STRING
      end
      if (("/head" == html) && @f_header_detected && @f_ignore)
        # $NON-NLS-1$
        @f_ignore = false
        return EMPTY_STRING
      end
      return EMPTY_STRING
    end
    
    typesig { [] }
    # A '<' has been read. Process a html tag
    def process_htmltag
      buf = StringBuffer.new
      ch = 0
      begin
        ch = next_char
        while (!(ch).equal?(-1) && !(ch).equal?(Character.new(?>.ord)))
          buf.append(Character.to_lower_case(RJava.cast_to_char(ch)))
          ch = next_char
          if ((ch).equal?(Character.new(?".ord)))
            buf.append(Character.to_lower_case(RJava.cast_to_char(ch)))
            ch = next_char
            while (!(ch).equal?(-1) && !(ch).equal?(Character.new(?".ord)))
              buf.append(Character.to_lower_case(RJava.cast_to_char(ch)))
              ch = next_char
            end
          end
          if ((ch).equal?(Character.new(?<.ord)) && !is_in_comment(buf))
            unread(ch)
            return Character.new(?<.ord) + buf.to_s
          end
        end
        if ((ch).equal?(-1))
          return nil
        end
        if (!is_in_comment(buf) || is_comment_end(buf))
          break
        end
        # unfinished comment
        buf.append(RJava.cast_to_char(ch))
      end while (true)
      return html2_text(buf.to_s)
    end
    
    class_module.module_eval {
      typesig { [StringBuffer] }
      def is_in_comment(buf)
        return buf.length >= 3 && ("!--" == buf.substring(0, 3)) # $NON-NLS-1$
      end
      
      typesig { [StringBuffer] }
      def is_comment_end(buf)
        tag_len = buf.length
        return tag_len >= 5 && ("--" == buf.substring(tag_len - 2)) # $NON-NLS-1$
      end
    }
    
    typesig { [::Java::Int] }
    def process_preformatted_text(c)
      if ((c).equal?(Character.new(?\r.ord)) || (c).equal?(Character.new(?\n.ord)))
        @f_counter += 1
      end
      return nil
    end
    
    typesig { [::Java::Int] }
    def unread(ch)
      (get_reader).unread(ch)
    end
    
    typesig { [String] }
    def entity2_text(symbol)
      if (symbol.length > 1 && (symbol.char_at(0)).equal?(Character.new(?#.ord)))
        ch = 0
        begin
          if ((symbol.char_at(1)).equal?(Character.new(?x.ord)))
            ch = JavaInteger.parse_int(symbol.substring(2), 16)
          else
            ch = JavaInteger.parse_int(symbol.substring(1), 10)
          end
          return EMPTY_STRING + RJava.cast_to_string(RJava.cast_to_char(ch))
        rescue NumberFormatException => e
        end
      else
        str = FgEntityLookup.get(symbol)
        if (!(str).nil?)
          return str
        end
      end
      return "&" + symbol # not found //$NON-NLS-1$
    end
    
    typesig { [] }
    # A '&' has been read. Process a entity
    def process_entity
      buf = StringBuffer.new
      ch = next_char
      while (Character.is_letter_or_digit(RJava.cast_to_char(ch)) || (ch).equal?(Character.new(?#.ord)))
        buf.append(RJava.cast_to_char(ch))
        ch = next_char
      end
      if ((ch).equal?(Character.new(?;.ord)))
        return entity2_text(buf.to_s)
      end
      buf.insert(0, Character.new(?&.ord))
      if (!(ch).equal?(-1))
        buf.append(RJava.cast_to_char(ch))
      end
      return buf.to_s
    end
    
    private
    alias_method :initialize__html2text_reader, :initialize
  end
  
end
