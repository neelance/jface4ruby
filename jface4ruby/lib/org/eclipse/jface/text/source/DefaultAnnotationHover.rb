require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module DefaultAnnotationHoverImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text::Source::Projection, :AnnotationBag
    }
  end
  
  # Standard implementation of {@link org.eclipse.jface.text.source.IAnnotationHover}.
  # 
  # @since 3.2
  class DefaultAnnotationHover 
    include_class_members DefaultAnnotationHoverImports
    include IAnnotationHover
    
    # Tells whether the line number should be shown when no annotation is found
    # under the cursor.
    # 
    # @since 3.4
    attr_accessor :f_show_line_number
    alias_method :attr_f_show_line_number, :f_show_line_number
    undef_method :f_show_line_number
    alias_method :attr_f_show_line_number=, :f_show_line_number=
    undef_method :f_show_line_number=
    
    typesig { [] }
    # Creates a new default annotation hover.
    # 
    # @since 3.4
    def initialize
      initialize__default_annotation_hover(false)
    end
    
    typesig { [::Java::Boolean] }
    # Creates a new default annotation hover.
    # 
    # @param showLineNumber <code>true</code> if the line number should be shown when no annotation is found
    # @since 3.4
    def initialize(show_line_number)
      @f_show_line_number = false
      @f_show_line_number = show_line_number
    end
    
    typesig { [ISourceViewer, ::Java::Int] }
    # @see org.eclipse.jface.text.source.IAnnotationHover#getHoverInfo(org.eclipse.jface.text.source.ISourceViewer, int)
    def get_hover_info(source_viewer, line_number)
      java_annotations = get_annotations_for_line(source_viewer, line_number)
      if (!(java_annotations).nil?)
        if ((java_annotations.size).equal?(1))
          # optimization
          annotation = java_annotations.get(0)
          message = annotation.get_text
          if (!(message).nil? && message.trim.length > 0)
            return format_single_message(message)
          end
        else
          messages = ArrayList.new
          e = java_annotations.iterator
          while (e.has_next)
            annotation = e.next_
            message = annotation.get_text
            if (!(message).nil? && message.trim.length > 0)
              messages.add(message.trim)
            end
          end
          if ((messages.size).equal?(1))
            return format_single_message(messages.get(0))
          end
          if (messages.size > 1)
            return format_multiple_messages(messages)
          end
        end
      end
      if (@f_show_line_number && line_number > -1)
        return JFaceTextMessages.get_formatted_string("DefaultAnnotationHover.lineNumber", Array.typed(String).new([JavaInteger.to_s(line_number + 1)]))
      end # $NON-NLS-1$
      return nil
    end
    
    typesig { [Annotation] }
    # Tells whether the annotation should be included in
    # the computation.
    # 
    # @param annotation the annotation to test
    # @return <code>true</code> if the annotation is included in the computation
    def is_included(annotation)
      return true
    end
    
    typesig { [String] }
    # Hook method to format the given single message.
    # <p>
    # Subclasses can change this to create a different
    # format like HTML.
    # </p>
    # 
    # @param message the message to format
    # @return the formatted message
    def format_single_message(message)
      return message
    end
    
    typesig { [JavaList] }
    # Hook method to formats the given messages.
    # <p>
    # Subclasses can change this to create a different
    # format like HTML.
    # </p>
    # 
    # @param messages the messages to format
    # @return the formatted message
    def format_multiple_messages(messages)
      buffer = StringBuffer.new
      buffer.append(JFaceTextMessages.get_string("DefaultAnnotationHover.multipleMarkers")) # $NON-NLS-1$
      e = messages.iterator
      while (e.has_next)
        buffer.append(Character.new(?\n.ord))
        list_item_text = e.next_
        buffer.append(JFaceTextMessages.get_formatted_string("DefaultAnnotationHover.listItem", Array.typed(String).new([list_item_text]))) # $NON-NLS-1$
      end
      return buffer.to_s
    end
    
    typesig { [Position, IDocument, ::Java::Int] }
    def is_ruler_line(position, document, line)
      if (position.get_offset > -1 && position.get_length > -1)
        begin
          return (line).equal?(document.get_line_of_offset(position.get_offset))
        rescue BadLocationException => x
        end
      end
      return false
    end
    
    typesig { [ISourceViewer] }
    def get_annotation_model(viewer)
      if (viewer.is_a?(ISourceViewerExtension2))
        extension = viewer
        return extension.get_visual_annotation_model
      end
      return viewer.get_annotation_model
    end
    
    typesig { [Map, Position, String] }
    def is_duplicate_annotation(messages_at_position, position, message)
      if (messages_at_position.contains_key(position))
        value = messages_at_position.get(position)
        if ((message == value))
          return true
        end
        if (value.is_a?(JavaList))
          messages = value
          if (messages.contains(message))
            return true
          end
          messages.add(message)
        else
          messages = ArrayList.new
          messages.add(value)
          messages.add(message)
          messages_at_position.put(position, messages)
        end
      else
        messages_at_position.put(position, message)
      end
      return false
    end
    
    typesig { [Annotation, Position, HashMap] }
    def include_annotation(annotation, position, messages_at_position)
      if (!is_included(annotation))
        return false
      end
      text = annotation.get_text
      return (!(text).nil? && !is_duplicate_annotation(messages_at_position, position, text))
    end
    
    typesig { [ISourceViewer, ::Java::Int] }
    def get_annotations_for_line(viewer, line)
      model = get_annotation_model(viewer)
      if ((model).nil?)
        return nil
      end
      document = viewer.get_document
      java_annotations = ArrayList.new
      messages_at_position = HashMap.new
      iterator_ = model.get_annotation_iterator
      while (iterator_.has_next)
        annotation = iterator_.next_
        position = model.get_position(annotation)
        if ((position).nil?)
          next
        end
        if (!is_ruler_line(position, document, line))
          next
        end
        if (annotation.is_a?(AnnotationBag))
          bag = annotation
          e = bag.iterator
          while (e.has_next)
            annotation = e.next_
            position = model.get_position(annotation)
            if (!(position).nil? && include_annotation(annotation, position, messages_at_position))
              java_annotations.add(annotation)
            end
          end
          next
        end
        if (include_annotation(annotation, position, messages_at_position))
          java_annotations.add(annotation)
        end
      end
      return java_annotations
    end
    
    private
    alias_method :initialize__default_annotation_hover, :initialize
  end
  
end
