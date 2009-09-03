require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Undo
  module DocumentUndoEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Undo
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # Describes document changes initiated by undo or redo.
  # <p>
  # Clients are not supposed to subclass or create instances of this class.
  # </p>
  # 
  # @see IDocumentUndoManager
  # @see IDocumentUndoListener
  # @since 3.2
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class DocumentUndoEvent 
    include_class_members DocumentUndoEventImports
    
    class_module.module_eval {
      # Indicates that the described document event is about to be
      # undone.
      const_set_lazy(:ABOUT_TO_UNDO) { 1 << 0 }
      const_attr_reader  :ABOUT_TO_UNDO
      
      # Indicates that the described document event is about to be
      # redone.
      const_set_lazy(:ABOUT_TO_REDO) { 1 << 1 }
      const_attr_reader  :ABOUT_TO_REDO
      
      # Indicates that the described document event has been undone.
      const_set_lazy(:UNDONE) { 1 << 2 }
      const_attr_reader  :UNDONE
      
      # Indicates that the described document event has been redone.
      const_set_lazy(:REDONE) { 1 << 3 }
      const_attr_reader  :REDONE
      
      # Indicates that the described document event is a compound undo
      # or redo event.
      const_set_lazy(:COMPOUND) { 1 << 4 }
      const_attr_reader  :COMPOUND
    }
    
    # The changed document.
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The document offset where the change begins.
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    # Text inserted into the document.
    attr_accessor :f_text
    alias_method :attr_f_text, :f_text
    undef_method :f_text
    alias_method :attr_f_text=, :f_text=
    undef_method :f_text=
    
    # Text replaced in the document.
    attr_accessor :f_preserved_text
    alias_method :attr_f_preserved_text, :f_preserved_text
    undef_method :f_preserved_text
    alias_method :attr_f_preserved_text=, :f_preserved_text=
    undef_method :f_preserved_text=
    
    # Bit mask of event types describing the event
    attr_accessor :f_event_type
    alias_method :attr_f_event_type, :f_event_type
    undef_method :f_event_type
    alias_method :attr_f_event_type=, :f_event_type=
    undef_method :f_event_type=
    
    # The source that triggered this event or <code>null</code> if unknown.
    attr_accessor :f_source
    alias_method :attr_f_source, :f_source
    undef_method :f_source
    alias_method :attr_f_source=, :f_source=
    undef_method :f_source=
    
    typesig { [IDocument, ::Java::Int, String, String, ::Java::Int, Object] }
    # Creates a new document event.
    # 
    # @param doc the changed document
    # @param offset the offset of the replaced text
    # @param text the substitution text
    # @param preservedText the replaced text
    # @param eventType a bit mask describing the type(s) of event
    # @param source the source that triggered this event or <code>null</code> if unknown
    def initialize(doc, offset, text, preserved_text, event_type, source)
      @f_document = nil
      @f_offset = 0
      @f_text = nil
      @f_preserved_text = nil
      @f_event_type = 0
      @f_source = nil
      Assert.is_not_null(doc)
      Assert.is_true(offset >= 0)
      @f_document = doc
      @f_offset = offset
      @f_text = text
      @f_preserved_text = preserved_text
      @f_event_type = event_type
      @f_source = source
    end
    
    typesig { [] }
    # Returns the changed document.
    # 
    # @return the changed document
    def get_document
      return @f_document
    end
    
    typesig { [] }
    # Returns the offset of the change.
    # 
    # @return the offset of the change
    def get_offset
      return @f_offset
    end
    
    typesig { [] }
    # Returns the text that has been inserted.
    # 
    # @return the text that has been inserted
    def get_text
      return @f_text
    end
    
    typesig { [] }
    # Returns the text that has been replaced.
    # 
    # @return the text that has been replaced
    def get_preserved_text
      return @f_preserved_text
    end
    
    typesig { [] }
    # Returns the type of event that is occurring.
    # 
    # @return the bit mask that indicates the type (or types) of the event
    def get_event_type
      return @f_event_type
    end
    
    typesig { [] }
    # Returns the source that triggered this event.
    # 
    # @return the source that triggered this event.
    def get_source
      return @f_source
    end
    
    typesig { [] }
    # Returns whether the change was a compound change or not.
    # 
    # @return	<code>true</code> if the undo or redo change is a
    # compound change, <code>false</code> if it is not
    def is_compound
      return !((@f_event_type & COMPOUND)).equal?(0)
    end
    
    private
    alias_method :initialize__document_undo_event, :initialize
  end
  
end
