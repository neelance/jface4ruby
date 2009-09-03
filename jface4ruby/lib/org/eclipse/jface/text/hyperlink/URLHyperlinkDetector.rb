require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Benjamin Muskalla <b.muskalla@gmx.net> - https://bugs.eclipse.org/bugs/show_bug.cgi?id=156433
module Org::Eclipse::Jface::Text::Hyperlink
  module URLHyperlinkDetectorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Hyperlink
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Net, :URL
      include_const ::Java::Util, :StringTokenizer
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :Region
    }
  end
  
  # URL hyperlink detector.
  # 
  # @since 3.1
  class URLHyperlinkDetector < URLHyperlinkDetectorImports.const_get :AbstractHyperlinkDetector
    include_class_members URLHyperlinkDetectorImports
    
    typesig { [] }
    # Creates a new URL hyperlink detector.
    # 
    # @since 3.2
    def initialize
      super()
    end
    
    typesig { [ITextViewer] }
    # Creates a new URL hyperlink detector.
    # 
    # @param textViewer the text viewer in which to detect the hyperlink
    # @deprecated As of 3.2, replaced by {@link URLHyperlinkDetector}
    def initialize(text_viewer)
      super()
    end
    
    typesig { [ITextViewer, IRegion, ::Java::Boolean] }
    # @see org.eclipse.jface.text.hyperlink.IHyperlinkDetector#detectHyperlinks(org.eclipse.jface.text.ITextViewer, org.eclipse.jface.text.IRegion, boolean)
    def detect_hyperlinks(text_viewer, region, can_show_multiple_hyperlinks)
      if ((region).nil? || (text_viewer).nil?)
        return nil
      end
      document = text_viewer.get_document
      offset = region.get_offset
      url_string = nil
      if ((document).nil?)
        return nil
      end
      line_info = nil
      line = nil
      begin
        line_info = document.get_line_information_of_offset(offset)
        line = RJava.cast_to_string(document.get(line_info.get_offset, line_info.get_length))
      rescue BadLocationException => ex
        return nil
      end
      offset_in_line = offset - line_info.get_offset
      start_double_quote = false
      url_offset_in_line = 0
      url_length = 0
      url_separator_offset = line.index_of("://") # $NON-NLS-1$
      while (url_separator_offset >= 0)
        # URL protocol (left to "://")
        url_offset_in_line = url_separator_offset
        ch = 0
        begin
          url_offset_in_line -= 1
          ch = Character.new(?\s.ord)
          if (url_offset_in_line > -1)
            ch = line.char_at(url_offset_in_line)
          end
          start_double_quote = (ch).equal?(Character.new(?".ord))
        end while (Character.is_unicode_identifier_start(ch))
        url_offset_in_line += 1
        # Right to "://"
        tokenizer = StringTokenizer.new(line.substring(url_separator_offset + 3), " \t\n\r\f<>", false) # $NON-NLS-1$
        if (!tokenizer.has_more_tokens)
          return nil
        end
        url_length = tokenizer.next_token.length + 3 + url_separator_offset - url_offset_in_line
        if (offset_in_line >= url_offset_in_line && offset_in_line <= url_offset_in_line + url_length)
          break
        end
        url_separator_offset = line.index_of("://", url_separator_offset + 1) # $NON-NLS-1$
      end
      if (url_separator_offset < 0)
        return nil
      end
      if (start_double_quote)
        end_offset = -1
        next_double_quote = line.index_of(Character.new(?".ord), url_offset_in_line)
        next_whitespace = line.index_of(Character.new(?\s.ord), url_offset_in_line)
        if (!(next_double_quote).equal?(-1) && !(next_whitespace).equal?(-1))
          end_offset = Math.min(next_double_quote, next_whitespace)
        else
          if (!(next_double_quote).equal?(-1))
            end_offset = next_double_quote
          else
            if (!(next_whitespace).equal?(-1))
              end_offset = next_whitespace
            end
          end
        end
        if (!(end_offset).equal?(-1))
          url_length = end_offset - url_offset_in_line
        end
      end
      # Set and validate URL string
      begin
        url_string = RJava.cast_to_string(line.substring(url_offset_in_line, url_offset_in_line + url_length))
        URL.new(url_string)
      rescue MalformedURLException => ex
        url_string = RJava.cast_to_string(nil)
        return nil
      end
      url_region = Region.new(line_info.get_offset + url_offset_in_line, url_length)
      return Array.typed(IHyperlink).new([URLHyperlink.new(url_region, url_string)])
    end
    
    private
    alias_method :initialize__urlhyperlink_detector, :initialize
  end
  
end
