require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DefaultDocumentAdapterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :TextChangeListener
      include_const ::Org::Eclipse::Swt::Custom, :TextChangedEvent
      include_const ::Org::Eclipse::Swt::Custom, :TextChangingEvent
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Default implementation of {@link org.eclipse.jface.text.IDocumentAdapter}.
  # <p>
  # <strong>Note:</strong> This adapter does not work if the widget auto-wraps the text.
  # </p>
  class DefaultDocumentAdapter 
    include_class_members DefaultDocumentAdapterImports
    include IDocumentAdapter
    include IDocumentListener
    include IDocumentAdapterExtension
    
    # The adapted document.
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The document clone for the non-forwarding case.
    attr_accessor :f_document_clone
    alias_method :attr_f_document_clone, :f_document_clone
    undef_method :f_document_clone
    alias_method :attr_f_document_clone=, :f_document_clone=
    undef_method :f_document_clone=
    
    # The original content
    attr_accessor :f_original_content
    alias_method :attr_f_original_content, :f_original_content
    undef_method :f_original_content
    alias_method :attr_f_original_content=, :f_original_content=
    undef_method :f_original_content=
    
    # The original line delimiters
    attr_accessor :f_original_line_delimiters
    alias_method :attr_f_original_line_delimiters, :f_original_line_delimiters
    undef_method :f_original_line_delimiters
    alias_method :attr_f_original_line_delimiters=, :f_original_line_delimiters=
    undef_method :f_original_line_delimiters=
    
    # The registered text change listeners
    attr_accessor :f_text_change_listeners
    alias_method :attr_f_text_change_listeners, :f_text_change_listeners
    undef_method :f_text_change_listeners
    alias_method :attr_f_text_change_listeners=, :f_text_change_listeners=
    undef_method :f_text_change_listeners=
    
    # The remembered document event
    # @since 2.0
    attr_accessor :f_event
    alias_method :attr_f_event, :f_event
    undef_method :f_event
    alias_method :attr_f_event=, :f_event=
    undef_method :f_event=
    
    # The line delimiter
    attr_accessor :f_line_delimiter
    alias_method :attr_f_line_delimiter, :f_line_delimiter
    undef_method :f_line_delimiter
    alias_method :attr_f_line_delimiter=, :f_line_delimiter=
    undef_method :f_line_delimiter=
    
    # Indicates whether this adapter is forwarding document changes
    # @since 2.0
    attr_accessor :f_is_forwarding
    alias_method :attr_f_is_forwarding, :f_is_forwarding
    undef_method :f_is_forwarding
    alias_method :attr_f_is_forwarding=, :f_is_forwarding=
    undef_method :f_is_forwarding=
    
    # Length of document at receipt of <code>documentAboutToBeChanged</code>
    # @since 2.1
    attr_accessor :f_remembered_length_of_document
    alias_method :attr_f_remembered_length_of_document, :f_remembered_length_of_document
    undef_method :f_remembered_length_of_document
    alias_method :attr_f_remembered_length_of_document=, :f_remembered_length_of_document=
    undef_method :f_remembered_length_of_document=
    
    # Length of first document line at receipt of <code>documentAboutToBeChanged</code>
    # @since 2.1
    attr_accessor :f_remembered_length_of_first_line
    alias_method :attr_f_remembered_length_of_first_line, :f_remembered_length_of_first_line
    undef_method :f_remembered_length_of_first_line
    alias_method :attr_f_remembered_length_of_first_line=, :f_remembered_length_of_first_line=
    undef_method :f_remembered_length_of_first_line=
    
    # The data of the event at receipt of <code>documentAboutToBeChanged</code>
    # @since 2.1
    attr_accessor :f_original_event
    alias_method :attr_f_original_event, :f_original_event
    undef_method :f_original_event
    alias_method :attr_f_original_event=, :f_original_event=
    undef_method :f_original_event=
    
    typesig { [] }
    # Creates a new document adapter which is initially not connected to
    # any document.
    def initialize
      @f_document = nil
      @f_document_clone = nil
      @f_original_content = nil
      @f_original_line_delimiters = nil
      @f_text_change_listeners = ArrayList.new(1)
      @f_event = nil
      @f_line_delimiter = nil
      @f_is_forwarding = true
      @f_remembered_length_of_document = 0
      @f_remembered_length_of_first_line = 0
      @f_original_event = DocumentEvent.new
    end
    
    typesig { [IDocument] }
    # Sets the given document as the document to be adapted.
    # 
    # @param document the document to be adapted or <code>null</code> if there is no document
    def set_document(document)
      if (!(@f_document).nil?)
        @f_document.remove_prenotified_document_listener(self)
      end
      @f_document = document
      @f_line_delimiter = RJava.cast_to_string(nil)
      if (!@f_is_forwarding)
        @f_document_clone = nil
        if (!(@f_document).nil?)
          @f_original_content = RJava.cast_to_string(@f_document.get)
          @f_original_line_delimiters = @f_document.get_legal_line_delimiters
        else
          @f_original_content = RJava.cast_to_string(nil)
          @f_original_line_delimiters = nil
        end
      end
      if (!(@f_document).nil?)
        @f_document.add_prenotified_document_listener(self)
      end
    end
    
    typesig { [TextChangeListener] }
    # @see StyledTextContent#addTextChangeListener(TextChangeListener)
    def add_text_change_listener(listener)
      Assert.is_not_null(listener)
      if (!@f_text_change_listeners.contains(listener))
        @f_text_change_listeners.add(listener)
      end
    end
    
    typesig { [TextChangeListener] }
    # @see StyledTextContent#removeTextChangeListener(TextChangeListener)
    def remove_text_change_listener(listener)
      Assert.is_not_null(listener)
      @f_text_change_listeners.remove(listener)
    end
    
    typesig { [IDocument] }
    # Tries to repair the line information.
    # 
    # @param document the document
    # @see IRepairableDocument#repairLineInformation()
    # @since 3.0
    def repair_line_information(document)
      if (document.is_a?(IRepairableDocument))
        repairable = document
        repairable.repair_line_information
      end
    end
    
    typesig { [IDocument, ::Java::Int] }
    # Returns the line for the given line number.
    # 
    # @param document the document
    # @param line the line number
    # @return the content of the line of the given number in the given document
    # @throws BadLocationException if the line number is invalid for the adapted document
    # @since 3.0
    def do_get_line(document, line)
      r = document.get_line_information(line)
      return document.get(r.get_offset, r.get_length)
    end
    
    typesig { [] }
    def get_document_for_read
      if (!@f_is_forwarding)
        if ((@f_document_clone).nil?)
          content = (@f_original_content).nil? ? "" : @f_original_content # $NON-NLS-1$
          delims = (@f_original_line_delimiters).nil? ? DefaultLineTracker::DELIMITERS : @f_original_line_delimiters
          @f_document_clone = DocumentClone.new(content, delims)
        end
        return @f_document_clone
      end
      return @f_document
    end
    
    typesig { [::Java::Int] }
    # @see StyledTextContent#getLine(int)
    def get_line(line)
      document = get_document_for_read
      begin
        return do_get_line(document, line)
      rescue BadLocationException => x
        repair_line_information(document)
        begin
          return do_get_line(document, line)
        rescue BadLocationException => x2
        end
      end
      SWT.error(SWT::ERROR_INVALID_ARGUMENT)
      return nil
    end
    
    typesig { [::Java::Int] }
    # @see StyledTextContent#getLineAtOffset(int)
    def get_line_at_offset(offset)
      document = get_document_for_read
      begin
        return document.get_line_of_offset(offset)
      rescue BadLocationException => x
        repair_line_information(document)
        begin
          return document.get_line_of_offset(offset)
        rescue BadLocationException => x2
        end
      end
      SWT.error(SWT::ERROR_INVALID_ARGUMENT)
      return -1
    end
    
    typesig { [] }
    # @see StyledTextContent#getLineCount()
    def get_line_count
      return get_document_for_read.get_number_of_lines
    end
    
    typesig { [::Java::Int] }
    # @see StyledTextContent#getOffsetAtLine(int)
    def get_offset_at_line(line)
      document = get_document_for_read
      begin
        return document.get_line_offset(line)
      rescue BadLocationException => x
        repair_line_information(document)
        begin
          return document.get_line_offset(line)
        rescue BadLocationException => x2
        end
      end
      SWT.error(SWT::ERROR_INVALID_ARGUMENT)
      return -1
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see StyledTextContent#getTextRange(int, int)
    def get_text_range(offset, length)
      begin
        return get_document_for_read.get(offset, length)
      rescue BadLocationException => x
        SWT.error(SWT::ERROR_INVALID_ARGUMENT)
        return nil
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @see StyledTextContent#replaceTextRange(int, int, String)
    def replace_text_range(pos, length, text)
      begin
        @f_document.replace(pos, length, text)
      rescue BadLocationException => x
        SWT.error(SWT::ERROR_INVALID_ARGUMENT)
      end
    end
    
    typesig { [String] }
    # @see StyledTextContent#setText(String)
    def set_text(text)
      @f_document.set(text)
    end
    
    typesig { [] }
    # @see StyledTextContent#getCharCount()
    def get_char_count
      return get_document_for_read.get_length
    end
    
    typesig { [] }
    # @see StyledTextContent#getLineDelimiter()
    def get_line_delimiter
      if ((@f_line_delimiter).nil?)
        @f_line_delimiter = RJava.cast_to_string(TextUtilities.get_default_line_delimiter(@f_document))
      end
      return @f_line_delimiter
    end
    
    typesig { [DocumentEvent] }
    # @see IDocumentListener#documentChanged(DocumentEvent)
    def document_changed(event)
      # check whether the given event is the one which was remembered
      if ((@f_event).nil? || !(event).equal?(@f_event))
        return
      end
      if (is_patched_event(event) || ((event.get_offset).equal?(0) && (event.get_length).equal?(@f_remembered_length_of_document)))
        @f_line_delimiter = RJava.cast_to_string(nil)
        fire_text_set
      else
        if (event.get_offset < @f_remembered_length_of_first_line)
          @f_line_delimiter = RJava.cast_to_string(nil)
        end
        fire_text_changed
      end
    end
    
    typesig { [DocumentEvent] }
    # @see IDocumentListener#documentAboutToBeChanged(DocumentEvent)
    def document_about_to_be_changed(event)
      @f_remembered_length_of_document = @f_document.get_length
      begin
        @f_remembered_length_of_first_line = @f_document.get_line_length(0)
      rescue BadLocationException => e
        @f_remembered_length_of_first_line = -1
      end
      @f_event = event
      remember_event_data(@f_event)
      fire_text_changing
    end
    
    typesig { [DocumentEvent] }
    # Checks whether this event has been changed between <code>documentAboutToBeChanged</code> and
    # <code>documentChanged</code>.
    # 
    # @param event the event to be checked
    # @return <code>true</code> if the event has been changed, <code>false</code> otherwise
    def is_patched_event(event)
      return !(@f_original_event.attr_f_offset).equal?(event.attr_f_offset) || !(@f_original_event.attr_f_length).equal?(event.attr_f_length) || !(@f_original_event.attr_f_text).equal?(event.attr_f_text)
    end
    
    typesig { [DocumentEvent] }
    # Makes a copy of the given event and remembers it.
    # 
    # @param event the event to be copied
    def remember_event_data(event)
      @f_original_event.attr_f_offset = event.attr_f_offset
      @f_original_event.attr_f_length = event.attr_f_length
      @f_original_event.attr_f_text = event.attr_f_text
    end
    
    typesig { [] }
    # Sends a text changed event to all registered listeners.
    def fire_text_changed
      if (!@f_is_forwarding)
        return
      end
      event = TextChangedEvent.new(self)
      if (!(@f_text_change_listeners).nil? && @f_text_change_listeners.size > 0)
        e = ArrayList.new(@f_text_change_listeners).iterator
        while (e.has_next)
          (e.next_).text_changed(event)
        end
      end
    end
    
    typesig { [] }
    # Sends a text set event to all registered listeners.
    def fire_text_set
      if (!@f_is_forwarding)
        return
      end
      event = TextChangedEvent.new(self)
      if (!(@f_text_change_listeners).nil? && @f_text_change_listeners.size > 0)
        e = ArrayList.new(@f_text_change_listeners).iterator
        while (e.has_next)
          (e.next_).text_set(event)
        end
      end
    end
    
    typesig { [] }
    # Sends the text changing event to all registered listeners.
    def fire_text_changing
      if (!@f_is_forwarding)
        return
      end
      begin
        document = @f_event.get_document
        if ((document).nil?)
          return
        end
        event = TextChangingEvent.new(self)
        event.attr_start = @f_event.attr_f_offset
        event.attr_replace_char_count = @f_event.attr_f_length
        event.attr_replace_line_count = document.get_number_of_lines(@f_event.attr_f_offset, @f_event.attr_f_length) - 1
        event.attr_new_text = @f_event.attr_f_text
        event.attr_new_char_count = ((@f_event.attr_f_text).nil? ? 0 : @f_event.attr_f_text.length)
        event.attr_new_line_count = ((@f_event.attr_f_text).nil? ? 0 : document.compute_number_of_lines(@f_event.attr_f_text))
        if (!(@f_text_change_listeners).nil? && @f_text_change_listeners.size > 0)
          e = ArrayList.new(@f_text_change_listeners).iterator
          while (e.has_next)
            (e.next_).text_changing(event)
          end
        end
      rescue BadLocationException => e
      end
    end
    
    typesig { [] }
    # @see IDocumentAdapterExtension#resumeForwardingDocumentChanges()
    # @since 2.0
    def resume_forwarding_document_changes
      @f_is_forwarding = true
      @f_document_clone = nil
      @f_original_content = RJava.cast_to_string(nil)
      @f_original_line_delimiters = nil
      fire_text_set
    end
    
    typesig { [] }
    # @see IDocumentAdapterExtension#stopForwardingDocumentChanges()
    # @since 2.0
    def stop_forwarding_document_changes
      @f_document_clone = nil
      @f_original_content = RJava.cast_to_string(@f_document.get)
      @f_original_line_delimiters = @f_document.get_legal_line_delimiters
      @f_is_forwarding = false
    end
    
    private
    alias_method :initialize__default_document_adapter, :initialize
  end
  
end
