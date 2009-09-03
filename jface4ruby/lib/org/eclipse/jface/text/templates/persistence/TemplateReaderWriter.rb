require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Templates::Persistence
  module TemplateReaderWriterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates::Persistence
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :Reader
      include_const ::Java::Io, :Writer
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :JavaSet
      include_const ::Javax::Xml::Parsers, :DocumentBuilder
      include_const ::Javax::Xml::Parsers, :DocumentBuilderFactory
      include_const ::Javax::Xml::Parsers, :ParserConfigurationException
      include_const ::Javax::Xml::Transform, :OutputKeys
      include_const ::Javax::Xml::Transform, :Transformer
      include_const ::Javax::Xml::Transform, :TransformerException
      include_const ::Javax::Xml::Transform, :TransformerFactory
      include_const ::Javax::Xml::Transform::Dom, :DOMSource
      include_const ::Javax::Xml::Transform::Stream, :StreamResult
      include_const ::Org::Xml::Sax, :InputSource
      include_const ::Org::Xml::Sax, :SAXException
      include_const ::Org::W3c::Dom, :Attr
      include_const ::Org::W3c::Dom, :Document
      include_const ::Org::W3c::Dom, :NamedNodeMap
      include_const ::Org::W3c::Dom, :Node
      include_const ::Org::W3c::Dom, :NodeList
      include_const ::Org::W3c::Dom, :Text
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text::Templates, :Template
    }
  end
  
  # Serializes templates as character or byte stream and reads the same format
  # back.
  # <p>
  # Clients may instantiate this class, it is not intended to be
  # subclassed.</p>
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class TemplateReaderWriter 
    include_class_members TemplateReaderWriterImports
    
    class_module.module_eval {
      const_set_lazy(:TEMPLATE_ROOT) { "templates" }
      const_attr_reader  :TEMPLATE_ROOT
      
      # $NON-NLS-1$
      const_set_lazy(:TEMPLATE_ELEMENT) { "template" }
      const_attr_reader  :TEMPLATE_ELEMENT
      
      # $NON-NLS-1$
      const_set_lazy(:NAME_ATTRIBUTE) { "name" }
      const_attr_reader  :NAME_ATTRIBUTE
      
      # $NON-NLS-1$
      const_set_lazy(:ID_ATTRIBUTE) { "id" }
      const_attr_reader  :ID_ATTRIBUTE
      
      # $NON-NLS-1$
      const_set_lazy(:DESCRIPTION_ATTRIBUTE) { "description" }
      const_attr_reader  :DESCRIPTION_ATTRIBUTE
      
      # $NON-NLS-1$
      const_set_lazy(:CONTEXT_ATTRIBUTE) { "context" }
      const_attr_reader  :CONTEXT_ATTRIBUTE
      
      # $NON-NLS-1$
      const_set_lazy(:ENABLED_ATTRIBUTE) { "enabled" }
      const_attr_reader  :ENABLED_ATTRIBUTE
      
      # $NON-NLS-1$
      const_set_lazy(:DELETED_ATTRIBUTE) { "deleted" }
      const_attr_reader  :DELETED_ATTRIBUTE
      
      # $NON-NLS-1$
      # 
      # @since 3.1
      const_set_lazy(:AUTO_INSERTABLE_ATTRIBUTE) { "autoinsert" }
      const_attr_reader  :AUTO_INSERTABLE_ATTRIBUTE
    }
    
    typesig { [] }
    # $NON-NLS-1$
    # 
    # Create a new instance.
    def initialize
    end
    
    typesig { [Reader] }
    # Reads templates from a reader and returns them. The reader must present
    # a serialized form as produced by the <code>save</code> method.
    # 
    # @param reader the reader to read templates from
    # @return the read templates, encapsulated in instances of <code>TemplatePersistenceData</code>
    # @throws IOException if reading from the stream fails
    def read(reader)
      return read(reader, nil)
    end
    
    typesig { [Reader, String] }
    # Reads the template with identifier <code>id</code> from a reader and
    # returns it. The reader must present a serialized form as produced by the
    # <code>save</code> method.
    # 
    # @param reader the reader to read templates from
    # @param id the id of the template to return
    # @return the read template, encapsulated in an instances of
    # <code>TemplatePersistenceData</code>
    # @throws IOException if reading from the stream fails
    # @since 3.1
    def read_single(reader, id)
      datas = read(InputSource.new(reader), nil, id)
      if (datas.attr_length > 0)
        return datas[0]
      end
      return nil
    end
    
    typesig { [Reader, ResourceBundle] }
    # Reads templates from a stream and adds them to the templates.
    # 
    # @param reader the reader to read templates from
    # @param bundle a resource bundle to use for translating the read templates, or <code>null</code> if no translation should occur
    # @return the read templates, encapsulated in instances of <code>TemplatePersistenceData</code>
    # @throws IOException if reading from the stream fails
    def read(reader, bundle)
      return read(InputSource.new(reader), bundle, nil)
    end
    
    typesig { [InputStream, ResourceBundle] }
    # Reads templates from a stream and adds them to the templates.
    # 
    # @param stream the byte stream to read templates from
    # @param bundle a resource bundle to use for translating the read templates, or <code>null</code> if no translation should occur
    # @return the read templates, encapsulated in instances of <code>TemplatePersistenceData</code>
    # @throws IOException if reading from the stream fails
    def read(stream, bundle)
      return read(InputSource.new(stream), bundle, nil)
    end
    
    typesig { [InputSource, ResourceBundle, String] }
    # Reads templates from an <code>InputSource</code> and adds them to the templates.
    # 
    # @param source the input source
    # @param bundle a resource bundle to use for translating the read templates, or <code>null</code> if no translation should occur
    # @param singleId the template id to extract, or <code>null</code> to read in all templates
    # @return the read templates, encapsulated in instances of <code>TemplatePersistenceData</code>
    # @throws IOException if reading from the stream fails
    def read(source, bundle, single_id)
      begin
        templates = ArrayList.new
        ids = HashSet.new
        factory = DocumentBuilderFactory.new_instance
        parser = factory.new_document_builder
        document = parser.parse(source)
        elements = document.get_elements_by_tag_name(TEMPLATE_ELEMENT)
        count = elements.get_length
        i = 0
        while !(i).equal?(count)
          node = elements.item(i)
          attributes = node.get_attributes
          if ((attributes).nil?)
            i += 1
            next
          end
          id = get_string_value(attributes, ID_ATTRIBUTE, nil)
          if (!(id).nil? && ids.contains(id))
            raise IOException.new(TemplatePersistenceMessages.get_string("TemplateReaderWriter.duplicate.id"))
          end # $NON-NLS-1$
          if (!(single_id).nil? && !(single_id == id))
            i += 1
            next
          end
          deleted = get_boolean_value(attributes, DELETED_ATTRIBUTE, false)
          name = get_string_value(attributes, NAME_ATTRIBUTE)
          name = RJava.cast_to_string(translate_string(name, bundle))
          description = get_string_value(attributes, DESCRIPTION_ATTRIBUTE, "") # $NON-NLS-1$
          description = RJava.cast_to_string(translate_string(description, bundle))
          context = get_string_value(attributes, CONTEXT_ATTRIBUTE)
          if ((name).nil? || (context).nil?)
            raise IOException.new(TemplatePersistenceMessages.get_string("TemplateReaderWriter.error.missing_attribute"))
          end # $NON-NLS-1$
          enabled = get_boolean_value(attributes, ENABLED_ATTRIBUTE, true)
          auto_insertable = get_boolean_value(attributes, AUTO_INSERTABLE_ATTRIBUTE, true)
          buffer = StringBuffer.new
          children = node.get_child_nodes
          j = 0
          while !(j).equal?(children.get_length)
            value = children.item(j).get_node_value
            if (!(value).nil?)
              buffer.append(value)
            end
            j += 1
          end
          pattern = buffer.to_s
          pattern = RJava.cast_to_string(translate_string(pattern, bundle))
          template = Template.new(name, description, context, pattern, auto_insertable)
          data = TemplatePersistenceData.new(template, enabled, id)
          data.set_deleted(deleted)
          templates.add(data)
          if (!(single_id).nil? && (single_id == id))
            break
          end
          i += 1
        end
        return templates.to_array(Array.typed(TemplatePersistenceData).new(templates.size) { nil })
      rescue ParserConfigurationException => e
        Assert.is_true(false)
      rescue SAXException => e
        t = e.get_cause
        if (t.is_a?(IOException))
          raise t
        else
          if (!(t).nil?)
            raise IOException.new(t.get_message)
          else
            raise IOException.new(e.get_message)
          end
        end
      end
      return nil # dummy
    end
    
    typesig { [Array.typed(TemplatePersistenceData), OutputStream] }
    # Saves the templates as XML, encoded as UTF-8 onto the given byte stream.
    # 
    # @param templates the templates to save
    # @param stream the byte output to write the templates to in XML
    # @throws IOException if writing the templates fails
    def save(templates, stream)
      save(templates, StreamResult.new(stream))
    end
    
    typesig { [Array.typed(TemplatePersistenceData), Writer] }
    # Saves the templates as XML.
    # 
    # @param templates the templates to save
    # @param writer the writer to write the templates to in XML
    # @throws IOException if writing the templates fails
    def save(templates, writer)
      save(templates, StreamResult.new(writer))
    end
    
    typesig { [Array.typed(TemplatePersistenceData), StreamResult] }
    # Saves the templates as XML.
    # 
    # @param templates the templates to save
    # @param result the stream result to write to
    # @throws IOException if writing the templates fails
    def save(templates, result)
      begin
        factory = DocumentBuilderFactory.new_instance
        builder = factory.new_document_builder
        document = builder.new_document
        root = document.create_element(TEMPLATE_ROOT)
        document.append_child(root)
        i = 0
        while i < templates.attr_length
          data = templates[i]
          template = data.get_template
          node = document.create_element(TEMPLATE_ELEMENT)
          root.append_child(node)
          attributes = node.get_attributes
          id = data.get_id
          if (!(id).nil?)
            id_attr = document.create_attribute(ID_ATTRIBUTE)
            id_attr.set_value(id)
            attributes.set_named_item(id_attr)
          end
          if (!(template).nil?)
            name = document.create_attribute(NAME_ATTRIBUTE)
            name.set_value(template.get_name)
            attributes.set_named_item(name)
          end
          if (!(template).nil?)
            description = document.create_attribute(DESCRIPTION_ATTRIBUTE)
            description.set_value(template.get_description)
            attributes.set_named_item(description)
          end
          if (!(template).nil?)
            context = document.create_attribute(CONTEXT_ATTRIBUTE)
            context.set_value(template.get_context_type_id)
            attributes.set_named_item(context)
          end
          enabled = document.create_attribute(ENABLED_ATTRIBUTE)
          enabled.set_value(data.is_enabled ? Boolean.to_s(true) : Boolean.to_s(false))
          attributes.set_named_item(enabled)
          deleted = document.create_attribute(DELETED_ATTRIBUTE)
          deleted.set_value(data.is_deleted ? Boolean.to_s(true) : Boolean.to_s(false))
          attributes.set_named_item(deleted)
          if (!(template).nil?)
            auto_insertable = document.create_attribute(AUTO_INSERTABLE_ATTRIBUTE)
            auto_insertable.set_value(template.is_auto_insertable ? Boolean.to_s(true) : Boolean.to_s(false))
            attributes.set_named_item(auto_insertable)
          end
          if (!(template).nil?)
            pattern = document.create_text_node(template.get_pattern)
            node.append_child(pattern)
          end
          i += 1
        end
        transformer = TransformerFactory.new_instance.new_transformer
        transformer.set_output_property(OutputKeys::METHOD, "xml") # $NON-NLS-1$
        transformer.set_output_property(OutputKeys::ENCODING, "UTF-8") # $NON-NLS-1$
        source = DOMSource.new(document)
        transformer.transform(source, result)
      rescue ParserConfigurationException => e
        Assert.is_true(false)
      rescue TransformerException => e
        if (e.get_exception.is_a?(IOException))
          raise e.get_exception
        end
        Assert.is_true(false)
      end
    end
    
    typesig { [NamedNodeMap, String, ::Java::Boolean] }
    def get_boolean_value(attributes, attribute, default_value)
      enabled_node = attributes.get_named_item(attribute)
      if ((enabled_node).nil?)
        return default_value
      else
        if ((enabled_node.get_node_value == Boolean.to_s(true)))
          return true
        else
          if ((enabled_node.get_node_value == Boolean.to_s(false)))
            return false
          else
            raise SAXException.new(TemplatePersistenceMessages.get_string("TemplateReaderWriter.error.illegal_boolean_attribute"))
          end
        end
      end # $NON-NLS-1$
    end
    
    typesig { [NamedNodeMap, String] }
    def get_string_value(attributes, name)
      val = get_string_value(attributes, name, nil)
      if ((val).nil?)
        raise SAXException.new(TemplatePersistenceMessages.get_string("TemplateReaderWriter.error.missing_attribute"))
      end # $NON-NLS-1$
      return val
    end
    
    typesig { [NamedNodeMap, String, String] }
    def get_string_value(attributes, name, default_value)
      node = attributes.get_named_item(name)
      return (node).nil? ? default_value : node.get_node_value
    end
    
    typesig { [String, ResourceBundle] }
    def translate_string(str, bundle)
      if ((bundle).nil?)
        return str
      end
      idx = str.index_of(Character.new(?%.ord))
      if ((idx).equal?(-1))
        return str
      end
      buf = StringBuffer.new
      k = 0
      while (!(idx).equal?(-1))
        buf.append(str.substring(k, idx))
        k = idx + 1
        while k < str.length && !Character.is_whitespace(str.char_at(k))
          k += 1
        end
        key = str.substring(idx + 1, k)
        buf.append(get_bundle_string(key, bundle))
        idx = str.index_of(Character.new(?%.ord), k)
      end
      buf.append(str.substring(k))
      return buf.to_s
    end
    
    typesig { [String, ResourceBundle] }
    def get_bundle_string(key, bundle)
      if (!(bundle).nil?)
        begin
          return bundle.get_string(key)
        rescue MissingResourceException => e
          return RJava.cast_to_string(Character.new(?!.ord)) + key + RJava.cast_to_string(Character.new(?!.ord))
        end
      end
      return TemplatePersistenceMessages.get_string(key) # default messages
    end
    
    private
    alias_method :initialize__template_reader_writer, :initialize
  end
  
end
