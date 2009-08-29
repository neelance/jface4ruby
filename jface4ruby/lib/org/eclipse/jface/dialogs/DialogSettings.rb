require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module DialogSettingsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStreamReader
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :OutputStreamWriter
      include_const ::Java::Io, :PrintWriter
      include_const ::Java::Io, :Reader
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Java::Io, :Writer
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Javax::Xml::Parsers, :DocumentBuilder
      include_const ::Javax::Xml::Parsers, :DocumentBuilderFactory
      include_const ::Javax::Xml::Parsers, :ParserConfigurationException
      include_const ::Org::Xml::Sax, :InputSource
      include_const ::Org::Xml::Sax, :SAXException
      include_const ::Org::W3c::Dom, :Document
      include_const ::Org::W3c::Dom, :Element
      include_const ::Org::W3c::Dom, :Node
      include_const ::Org::W3c::Dom, :NodeList
    }
  end
  
  # Concrete implementation of a dialog settings (<code>IDialogSettings</code>)
  # using a hash table and XML. The dialog store can be read
  # from and saved to a stream. All keys and values must be strings or array of
  # strings. Primitive types are converted to strings.
  # <p>
  # This class was not designed to be subclassed.
  # 
  # Here is an example of using a DialogSettings:
  # </p>
  # <pre>
  # <code>
  # DialogSettings settings = new DialogSettings("root");
  # settings.put("Boolean1",true);
  # settings.put("Long1",100);
  # settings.put("Array1",new String[]{"aaaa1","bbbb1","cccc1"});
  # DialogSettings section = new DialogSettings("sectionName");
  # settings.addSection(section);
  # section.put("Int2",200);
  # section.put("Float2",1.1);
  # section.put("Array2",new String[]{"aaaa2","bbbb2","cccc2"});
  # settings.save("c:\\temp\\test\\dialog.xml");
  # </code>
  # </pre>
  # @noextend This class is not intended to be subclassed by clients.
  class DialogSettings 
    include_class_members DialogSettingsImports
    include IDialogSettings
    
    # The name of the DialogSettings.
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # A Map of DialogSettings representing each sections in a DialogSettings.
    # It maps the DialogSettings' name to the DialogSettings
    attr_accessor :sections
    alias_method :attr_sections, :sections
    undef_method :sections
    alias_method :attr_sections=, :sections=
    undef_method :sections=
    
    # A Map with all the keys and values of this sections.
    # Either the keys an values are restricted to strings.
    attr_accessor :items
    alias_method :attr_items, :items
    undef_method :items
    alias_method :attr_items=, :items=
    undef_method :items=
    
    # A Map with all the keys mapped to array of strings.
    attr_accessor :array_items
    alias_method :attr_array_items, :array_items
    undef_method :array_items
    alias_method :attr_array_items=, :array_items=
    undef_method :array_items=
    
    class_module.module_eval {
      const_set_lazy(:TAG_SECTION) { "section" }
      const_attr_reader  :TAG_SECTION
      
      # $NON-NLS-1$
      const_set_lazy(:TAG_NAME) { "name" }
      const_attr_reader  :TAG_NAME
      
      # $NON-NLS-1$
      const_set_lazy(:TAG_KEY) { "key" }
      const_attr_reader  :TAG_KEY
      
      # $NON-NLS-1$
      const_set_lazy(:TAG_VALUE) { "value" }
      const_attr_reader  :TAG_VALUE
      
      # $NON-NLS-1$
      const_set_lazy(:TAG_LIST) { "list" }
      const_attr_reader  :TAG_LIST
      
      # $NON-NLS-1$
      const_set_lazy(:TAG_ITEM) { "item" }
      const_attr_reader  :TAG_ITEM
    }
    
    typesig { [String] }
    # $NON-NLS-1$
    # 
    # Create an empty dialog settings which loads and saves its
    # content to a file.
    # Use the methods <code>load(String)</code> and <code>store(String)</code>
    # to load and store this dialog settings.
    # 
    # @param sectionName the name of the section in the settings.
    def initialize(section_name)
      @name = nil
      @sections = nil
      @items = nil
      @array_items = nil
      @name = section_name
      @items = HashMap.new
      @array_items = HashMap.new
      @sections = HashMap.new
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def add_new_section(section_name)
      section = DialogSettings.new(section_name)
      add_section(section)
      return section
    end
    
    typesig { [IDialogSettings] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def add_section(section)
      @sections.put(section.get_name, section)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def get(key)
      return @items.get(key)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def get_array(key)
      return @array_items.get(key)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def get_boolean(key)
      return Boolean.value_of(@items.get(key)).boolean_value
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def get_double(key)
      setting = @items.get(key)
      if ((setting).nil?)
        raise NumberFormatException.new("There is no setting associated with the key \"" + key + "\"") # $NON-NLS-1$ //$NON-NLS-2$
      end
      return Double.new(setting).double_value
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def get_float(key)
      setting = @items.get(key)
      if ((setting).nil?)
        raise NumberFormatException.new("There is no setting associated with the key \"" + key + "\"") # $NON-NLS-1$ //$NON-NLS-2$
      end
      return Float.new(setting).float_value
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def get_int(key)
      setting = @items.get(key)
      if ((setting).nil?)
        # new Integer(null) will throw a NumberFormatException and meet our spec, but this message
        # is clearer.
        raise NumberFormatException.new("There is no setting associated with the key \"" + key + "\"") # $NON-NLS-1$ //$NON-NLS-2$
      end
      return setting.int_value
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def get_long(key)
      setting = @items.get(key)
      if ((setting).nil?)
        # new Long(null) will throw a NumberFormatException and meet our spec, but this message
        # is clearer.
        raise NumberFormatException.new("There is no setting associated with the key \"" + key + "\"") # $NON-NLS-1$ //$NON-NLS-2$
      end
      return Long.new(setting).long_value
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def get_name
      return @name
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def get_section(section_name)
      return @sections.get(section_name)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def get_sections
      values_ = @sections.values
      result = Array.typed(DialogSettings).new(values_.size) { nil }
      values_.to_array(result)
      return result
    end
    
    typesig { [Reader] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def load(r)
      document = nil
      begin
        parser = DocumentBuilderFactory.new_instance.new_document_builder
        # parser.setProcessNamespace(true);
        document = parser.parse(InputSource.new(r))
        # Strip out any comments first
        root = document.get_first_child
        while ((root.get_node_type).equal?(Node::COMMENT_NODE))
          document.remove_child(root)
          root = document.get_first_child
        end
        load(document, root)
      rescue ParserConfigurationException => e
        # ignore
      rescue IOException => e
        # ignore
      rescue SAXException => e
        # ignore
      end
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def load(file_name)
      stream = FileInputStream.new(file_name)
      reader = BufferedReader.new(InputStreamReader.new(stream, "utf-8")) # $NON-NLS-1$
      load(reader)
      reader.close
    end
    
    typesig { [Document, Element] }
    # (non-Javadoc)
    # Load the setting from the <code>document</code>
    def load(document, root)
      @name = RJava.cast_to_string(root.get_attribute(TAG_NAME))
      l = root.get_elements_by_tag_name(TAG_ITEM)
      i = 0
      while i < l.get_length
        n = l.item(i)
        if ((root).equal?(n.get_parent_node))
          key = (l.item(i)).get_attribute(TAG_KEY)
          value = (l.item(i)).get_attribute(TAG_VALUE)
          @items.put(key, value)
        end
        i += 1
      end
      l = root.get_elements_by_tag_name(TAG_LIST)
      i_ = 0
      while i_ < l.get_length
        n = l.item(i_)
        if ((root).equal?(n.get_parent_node))
          child = l.item(i_)
          key = child.get_attribute(TAG_KEY)
          list = child.get_elements_by_tag_name(TAG_ITEM)
          value_list = ArrayList.new
          j = 0
          while j < list.get_length
            node = list.item(j)
            if ((child).equal?(node.get_parent_node))
              value_list.add(node.get_attribute(TAG_VALUE))
            end
            j += 1
          end
          value = Array.typed(String).new(value_list.size) { nil }
          value_list.to_array(value)
          @array_items.put(key, value)
        end
        i_ += 1
      end
      l = root.get_elements_by_tag_name(TAG_SECTION)
      i__ = 0
      while i__ < l.get_length
        n = l.item(i__)
        if ((root).equal?(n.get_parent_node))
          s = DialogSettings.new("NoName") # $NON-NLS-1$
          s.load(document, n)
          add_section(s)
        end
        i__ += 1
      end
    end
    
    typesig { [String, Array.typed(String)] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def put(key, value)
      @array_items.put(key, value)
    end
    
    typesig { [String, ::Java::Double] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def put(key, value)
      put(key, String.value_of(value))
    end
    
    typesig { [String, ::Java::Float] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def put(key, value)
      put(key, String.value_of(value))
    end
    
    typesig { [String, ::Java::Int] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def put(key, value)
      put(key, String.value_of(value))
    end
    
    typesig { [String, ::Java::Long] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def put(key, value)
      put(key, String.value_of(value))
    end
    
    typesig { [String, String] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def put(key, value)
      @items.put(key, value)
    end
    
    typesig { [String, ::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def put(key, value)
      put(key, String.value_of(value))
    end
    
    typesig { [Writer] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def save(writer)
      save(XMLWriter.new(writer))
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IDialogSettings.
    def save(file_name)
      stream = FileOutputStream.new(file_name)
      writer = XMLWriter.new(stream)
      save(writer)
      writer.close
    end
    
    typesig { [XMLWriter] }
    # (non-Javadoc)
    # Save the settings in the <code>document</code>.
    def save(out)
      attributes = HashMap.new(2)
      attributes.put(TAG_NAME, (@name).nil? ? "" : @name) # $NON-NLS-1$
      out.start_tag(TAG_SECTION, attributes)
      attributes.clear
      i = @items.key_set.iterator
      while i.has_next
        key = i.next_
        attributes.put(TAG_KEY, (key).nil? ? "" : key) # $NON-NLS-1$
        string = @items.get(key)
        attributes.put(TAG_VALUE, (string).nil? ? "" : string) # $NON-NLS-1$
        out.print_tag(TAG_ITEM, attributes, true)
      end
      attributes.clear
      i_ = @array_items.key_set.iterator
      while i_.has_next
        key = i_.next_
        attributes.put(TAG_KEY, (key).nil? ? "" : key) # $NON-NLS-1$
        out.start_tag(TAG_LIST, attributes)
        value = @array_items.get(key)
        attributes.clear
        if (!(value).nil?)
          index = 0
          while index < value.attr_length
            string = value[index]
            attributes.put(TAG_VALUE, (string).nil? ? "" : string) # $NON-NLS-1$
            out.print_tag(TAG_ITEM, attributes, true)
            index += 1
          end
        end
        out.end_tag(TAG_LIST)
        attributes.clear
      end
      i__ = @sections.values.iterator
      while i__.has_next
        (i__.next_).save(out)
      end
      out.end_tag(TAG_SECTION)
    end
    
    class_module.module_eval {
      # A simple XML writer.  Using this instead of the javax.xml.transform classes allows
      # compilation against JCL Foundation (bug 80059).
      const_set_lazy(:XMLWriter) { Class.new(PrintWriter) do
        include_class_members DialogSettings
        
        # current number of tabs to use for ident
        attr_accessor :tab
        alias_method :attr_tab, :tab
        undef_method :tab
        alias_method :attr_tab=, :tab=
        undef_method :tab=
        
        class_module.module_eval {
          # the xml header
          const_set_lazy(:XML_VERSION) { "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" }
          const_attr_reader  :XML_VERSION
        }
        
        typesig { [class_self::OutputStream] }
        # $NON-NLS-1$
        # 
        # Create a new XMLWriter
        # @param output the stream to write the output to
        # @throws UnsupportedEncodingException thrown if charset is not supported
        def initialize(output)
          @tab = 0
          super(self.class::OutputStreamWriter.new(output, "UTF8")) # $NON-NLS-1$
          @tab = 0
          println(self.class::XML_VERSION)
        end
        
        typesig { [class_self::Writer] }
        # Create a new XMLWriter
        # @param output the write to used when writing to
        def initialize(output)
          @tab = 0
          super(output)
          @tab = 0
          println(self.class::XML_VERSION)
        end
        
        typesig { [String] }
        # write the intended end tag
        # @param name the name of the tag to end
        def end_tag(name)
          @tab -= 1
          print_tag("/" + name, nil, false) # $NON-NLS-1$
        end
        
        typesig { [] }
        def print_tabulation
          i = 0
          while i < @tab
            PrintWriter.instance_method(:print).bind(self).call(Character.new(?\t.ord))
            i += 1
          end
        end
        
        typesig { [String, class_self::HashMap, ::Java::Boolean] }
        # write the tag to the stream and format it by itending it and add new line after the tag
        # @param name the name of the tag
        # @param parameters map of parameters
        # @param close should the tag be ended automatically (=> empty tag)
        def print_tag(name, parameters, close)
          print_tag(name, parameters, true, true, close)
        end
        
        typesig { [String, class_self::HashMap, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
        def print_tag(name, parameters, should_tab, new_line, close)
          sb = self.class::StringBuffer.new
          sb.append(Character.new(?<.ord))
          sb.append(name)
          if (!(parameters).nil?)
            e = Collections.enumeration(parameters.key_set)
            while e.has_more_elements
              sb.append(" ") # $NON-NLS-1$
              key = e.next_element
              sb.append(key)
              sb.append("=\"") # $NON-NLS-1$
              sb.append(get_escaped(String.value_of(parameters.get(key))))
              sb.append("\"") # $NON-NLS-1$
            end
          end
          if (close)
            sb.append(Character.new(?/.ord))
          end
          sb.append(Character.new(?>.ord))
          if (should_tab)
            print_tabulation
          end
          if (new_line)
            println(sb.to_s)
          else
            print(sb.to_s)
          end
        end
        
        typesig { [String, class_self::HashMap] }
        # start the tag
        # @param name the name of the tag
        # @param parameters map of parameters
        def start_tag(name, parameters)
          start_tag(name, parameters, true)
          @tab += 1
        end
        
        typesig { [String, class_self::HashMap, ::Java::Boolean] }
        def start_tag(name, parameters, new_line)
          print_tag(name, parameters, true, new_line, false)
        end
        
        class_module.module_eval {
          typesig { [class_self::StringBuffer, ::Java::Char] }
          def append_escaped_char(buffer, c)
            replacement = get_replacement(c)
            if (!(replacement).nil?)
              buffer.append(Character.new(?&.ord))
              buffer.append(replacement)
              buffer.append(Character.new(?;.ord))
            else
              buffer.append(c)
            end
          end
          
          typesig { [String] }
          def get_escaped(s)
            result = class_self::StringBuffer.new(s.length + 10)
            i = 0
            while i < s.length
              append_escaped_char(result, s.char_at(i))
              (i += 1)
            end
            return result.to_s
          end
          
          typesig { [::Java::Char] }
          def get_replacement(c)
            # Encode special XML characters into the equivalent character references.
            # The first five are defined by default for all XML documents.
            # The next three (#xD, #xA, #x9) are encoded to avoid them
            # being converted to spaces on deserialization
            case (c)
            # $NON-NLS-1$
            # $NON-NLS-1$
            # $NON-NLS-1$
            # $NON-NLS-1$
            # $NON-NLS-1$
            # $NON-NLS-1$
            # $NON-NLS-1$
            when Character.new(?<.ord)
              return "lt"
            when Character.new(?>.ord)
              return "gt"
            when Character.new(?".ord)
              return "quot"
            when Character.new(?\'.ord)
              return "apos"
            when Character.new(?&.ord)
              return "amp"
            when Character.new(?\r.ord)
              return "#x0D"
            when Character.new(?\n.ord)
              return "#x0A"
            when Character.new(0x0009)
              return "#x09"
            end # $NON-NLS-1$
            return nil
          end
        }
        
        private
        alias_method :initialize__xmlwriter, :initialize
      end }
    }
    
    private
    alias_method :initialize__dialog_settings, :initialize
  end
  
end
