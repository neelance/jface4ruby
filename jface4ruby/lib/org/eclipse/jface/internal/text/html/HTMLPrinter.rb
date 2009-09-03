require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Html
  module HTMLPrinterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Html
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :Reader
      include_const ::Java::Net, :URL
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt, :SWTError
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # Provides a set of convenience methods for creating HTML pages.
  # <p>
  # Moved into this package from <code>org.eclipse.jface.internal.text.revisions</code>.</p>
  class HTMLPrinter 
    include_class_members HTMLPrinterImports
    
    class_module.module_eval {
      
      def bg_color_rgb
        defined?(@@bg_color_rgb) ? @@bg_color_rgb : @@bg_color_rgb= RGB.new(255, 255, 225)
      end
      alias_method :attr_bg_color_rgb, :bg_color_rgb
      
      def bg_color_rgb=(value)
        @@bg_color_rgb = value
      end
      alias_method :attr_bg_color_rgb=, :bg_color_rgb=
      
      # RGB value of info bg color on WindowsXP
      
      def fg_color_rgb
        defined?(@@fg_color_rgb) ? @@fg_color_rgb : @@fg_color_rgb= RGB.new(0, 0, 0)
      end
      alias_method :attr_fg_color_rgb, :fg_color_rgb
      
      def fg_color_rgb=(value)
        @@fg_color_rgb = value
      end
      alias_method :attr_fg_color_rgb=, :fg_color_rgb=
      
      # See: https://bugs.eclipse.org/bugs/show_bug.cgi?id=155993
      when_class_loaded do
        const_set :UNIT, RJava.cast_to_string(Util.is_mac ? "px" : "pt") # $NON-NLS-1$//$NON-NLS-2$
      end
      
      when_class_loaded do
        display = Display.get_default
        if (!(display).nil? && !display.is_disposed)
          begin
            display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
              extend LocalClass
              include_class_members HTMLPrinter
              include Runnable if Runnable.class == Module
              
              typesig { [] }
              # @see java.lang.Runnable#run()
              define_method :run do
                self.attr_bg_color_rgb = display.get_system_color(SWT::COLOR_INFO_BACKGROUND).get_rgb
                self.attr_fg_color_rgb = display.get_system_color(SWT::COLOR_INFO_FOREGROUND).get_rgb
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          rescue SWTError => err
            # see: https://bugs.eclipse.org/bugs/show_bug.cgi?id=45294
            if (!(err.attr_code).equal?(SWT::ERROR_DEVICE_DISPOSED))
              raise err
            end
          end
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String, ::Java::Char, String] }
      def replace(text, c, s)
        previous = 0
        current = text.index_of(c, previous)
        if ((current).equal?(-1))
          return text
        end
        buffer = StringBuffer.new
        while (current > -1)
          buffer.append(text.substring(previous, current))
          buffer.append(s)
          previous = current + 1
          current = text.index_of(c, previous)
        end
        buffer.append(text.substring(previous))
        return buffer.to_s
      end
      
      typesig { [String] }
      def convert_to_htmlcontent(content)
        content = RJava.cast_to_string(replace(content, Character.new(?&.ord), "&amp;")) # $NON-NLS-1$
        content = RJava.cast_to_string(replace(content, Character.new(?".ord), "&quot;")) # $NON-NLS-1$
        content = RJava.cast_to_string(replace(content, Character.new(?<.ord), "&lt;")) # $NON-NLS-1$
        return replace(content, Character.new(?>.ord), "&gt;") # $NON-NLS-1$
      end
      
      typesig { [Reader] }
      def read(rd)
        buffer = StringBuffer.new
        read_buffer = CharArray.new(2048)
        begin
          n = rd.read(read_buffer)
          while (n > 0)
            buffer.append(read_buffer, 0, n)
            n = rd.read(read_buffer)
          end
          return buffer.to_s
        rescue IOException => x
        end
        return nil
      end
      
      typesig { [StringBuffer, ::Java::Int, RGB, RGB, String] }
      def insert_page_prolog(buffer, position, fg_rgb, bg_rgb, style_sheet)
        if ((fg_rgb).nil?)
          fg_rgb = self.attr_fg_color_rgb
        end
        if ((bg_rgb).nil?)
          bg_rgb = self.attr_bg_color_rgb
        end
        page_prolog = StringBuffer.new(300)
        page_prolog.append("<html>") # $NON-NLS-1$
        append_style_sheet_url(page_prolog, style_sheet)
        append_colors(page_prolog, fg_rgb, bg_rgb)
        buffer.insert(position, page_prolog.to_s)
      end
      
      typesig { [StringBuffer, RGB, RGB] }
      def append_colors(page_prolog, fg_rgb, bg_rgb)
        page_prolog.append("<body text=\"") # $NON-NLS-1$
        append_color(page_prolog, fg_rgb)
        page_prolog.append("\" bgcolor=\"") # $NON-NLS-1$
        append_color(page_prolog, bg_rgb)
        page_prolog.append("\">") # $NON-NLS-1$
      end
      
      typesig { [StringBuffer, RGB] }
      def append_color(buffer, rgb)
        buffer.append(Character.new(?#.ord))
        append_as_hex_string(buffer, rgb.attr_red)
        append_as_hex_string(buffer, rgb.attr_green)
        append_as_hex_string(buffer, rgb.attr_blue)
      end
      
      typesig { [StringBuffer, ::Java::Int] }
      def append_as_hex_string(buffer, int_value)
        hex_value = JavaInteger.to_hex_string(int_value)
        if ((hex_value.length).equal?(1))
          buffer.append(Character.new(?0.ord))
        end
        buffer.append(hex_value)
      end
      
      typesig { [StringBuffer, Array.typed(String)] }
      def insert_styles(buffer, styles)
        if ((styles).nil? || (styles.attr_length).equal?(0))
          return
        end
        style_buf = StringBuffer.new(10 * styles.attr_length)
        i = 0
        while i < styles.attr_length
          style_buf.append(" style=\"") # $NON-NLS-1$
          style_buf.append(styles[i])
          style_buf.append(Character.new(?".ord))
          i += 1
        end
        # Find insertion index
        # a) within existing body tag with trailing space
        index = buffer.index_of("<body ") # $NON-NLS-1$
        if (!(index).equal?(-1))
          buffer.insert(index + 5, style_buf)
          return
        end
        # b) within existing body tag without attributes
        index = buffer.index_of("<body>") # $NON-NLS-1$
        if (!(index).equal?(-1))
          buffer.insert(index + 5, Character.new(?\s.ord))
          buffer.insert(index + 6, style_buf)
          return
        end
      end
      
      typesig { [StringBuffer, String] }
      def append_style_sheet_url(buffer, style_sheet)
        if ((style_sheet).nil?)
          return
        end
        buffer.append("<head><style CHARSET=\"ISO-8859-1\" TYPE=\"text/css\">") # $NON-NLS-1$
        buffer.append(style_sheet)
        buffer.append("</style></head>") # $NON-NLS-1$
      end
      
      typesig { [StringBuffer, URL] }
      def append_style_sheet_url(buffer, style_sheet_url)
        if ((style_sheet_url).nil?)
          return
        end
        buffer.append("<head>") # $NON-NLS-1$
        buffer.append("<LINK REL=\"stylesheet\" HREF= \"") # $NON-NLS-1$
        buffer.append(style_sheet_url)
        buffer.append("\" CHARSET=\"ISO-8859-1\" TYPE=\"text/css\">") # $NON-NLS-1$
        buffer.append("</head>") # $NON-NLS-1$
      end
      
      typesig { [StringBuffer, ::Java::Int] }
      def insert_page_prolog(buffer, position)
        page_prolog = StringBuffer.new(60)
        page_prolog.append("<html>") # $NON-NLS-1$
        append_colors(page_prolog, self.attr_fg_color_rgb, self.attr_bg_color_rgb)
        buffer.insert(position, page_prolog.to_s)
      end
      
      typesig { [StringBuffer, ::Java::Int, URL] }
      def insert_page_prolog(buffer, position, style_sheet_url)
        page_prolog = StringBuffer.new(300)
        page_prolog.append("<html>") # $NON-NLS-1$
        append_style_sheet_url(page_prolog, style_sheet_url)
        append_colors(page_prolog, self.attr_fg_color_rgb, self.attr_bg_color_rgb)
        buffer.insert(position, page_prolog.to_s)
      end
      
      typesig { [StringBuffer, ::Java::Int, String] }
      def insert_page_prolog(buffer, position, style_sheet)
        insert_page_prolog(buffer, position, nil, nil, style_sheet)
      end
      
      typesig { [StringBuffer] }
      def add_page_prolog(buffer)
        insert_page_prolog(buffer, buffer.length)
      end
      
      typesig { [StringBuffer] }
      def add_page_epilog(buffer)
        buffer.append("</font></body></html>") # $NON-NLS-1$
      end
      
      typesig { [StringBuffer] }
      def start_bullet_list(buffer)
        buffer.append("<ul>") # $NON-NLS-1$
      end
      
      typesig { [StringBuffer] }
      def end_bullet_list(buffer)
        buffer.append("</ul>") # $NON-NLS-1$
      end
      
      typesig { [StringBuffer, String] }
      def add_bullet(buffer, bullet)
        if (!(bullet).nil?)
          buffer.append("<li>") # $NON-NLS-1$
          buffer.append(bullet)
          buffer.append("</li>") # $NON-NLS-1$
        end
      end
      
      typesig { [StringBuffer, String] }
      def add_small_header(buffer, header)
        if (!(header).nil?)
          buffer.append("<h5>") # $NON-NLS-1$
          buffer.append(header)
          buffer.append("</h5>") # $NON-NLS-1$
        end
      end
      
      typesig { [StringBuffer, String] }
      def add_paragraph(buffer, paragraph)
        if (!(paragraph).nil?)
          buffer.append("<p>") # $NON-NLS-1$
          buffer.append(paragraph)
        end
      end
      
      typesig { [StringBuffer, Reader] }
      def add_paragraph(buffer, paragraph_reader)
        if (!(paragraph_reader).nil?)
          add_paragraph(buffer, read(paragraph_reader))
        end
      end
      
      typesig { [String, FontData] }
      # Replaces the following style attributes of the font definition of the <code>html</code>
      # element:
      # <ul>
      # <li>font-size</li>
      # <li>font-weight</li>
      # <li>font-style</li>
      # <li>font-family</li>
      # </ul>
      # The font's name is used as font family, a <code>sans-serif</code> default font family is
      # appended for the case that the given font name is not available.
      # <p>
      # If the listed font attributes are not contained in the passed style list, nothing happens.
      # </p>
      # 
      # @param styles CSS style definitions
      # @param fontData the font information to use
      # @return the modified style definitions
      # @since 3.3
      def convert_top_level_font(styles, font_data)
        bold = !((font_data.get_style & SWT::BOLD)).equal?(0)
        italic = !((font_data.get_style & SWT::ITALIC)).equal?(0)
        size = RJava.cast_to_string(JavaInteger.to_s(font_data.get_height)) + UNIT
        family = "'" + RJava.cast_to_string(font_data.get_name) + "',sans-serif" # $NON-NLS-1$ //$NON-NLS-2$
        styles = RJava.cast_to_string(styles.replace_first("(html\\s*\\{.*(?:\\s|;)font-size:\\s*)\\d+pt(\\;?.*\\})", "$1" + size + "$2")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
        styles = RJava.cast_to_string(styles.replace_first("(html\\s*\\{.*(?:\\s|;)font-weight:\\s*)\\w+(\\;?.*\\})", "$1" + RJava.cast_to_string((bold ? "bold" : "normal")) + "$2")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$
        styles = RJava.cast_to_string(styles.replace_first("(html\\s*\\{.*(?:\\s|;)font-style:\\s*)\\w+(\\;?.*\\})", "$1" + RJava.cast_to_string((italic ? "italic" : "normal")) + "$2")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$
        styles = RJava.cast_to_string(styles.replace_first("(html\\s*\\{.*(?:\\s|;)font-family:\\s*).+?(;.*\\})", "$1" + family + "$2")) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
        return styles
      end
    }
    
    private
    alias_method :initialize__htmlprinter, :initialize
  end
  
end
