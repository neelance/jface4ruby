require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Edits
  module UndoCollectorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
    }
  end
  
  class UndoCollector 
    include_class_members UndoCollectorImports
    include IDocumentListener
    
    attr_accessor :undo
    alias_method :attr_undo, :undo
    undef_method :undo
    alias_method :attr_undo=, :undo=
    undef_method :undo=
    
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    attr_accessor :f_length
    alias_method :attr_f_length, :f_length
    undef_method :f_length
    alias_method :attr_f_length=, :f_length=
    undef_method :f_length=
    
    # @since 3.1
    attr_accessor :f_last_current_text
    alias_method :attr_f_last_current_text, :f_last_current_text
    undef_method :f_last_current_text
    alias_method :attr_f_last_current_text=, :f_last_current_text=
    undef_method :f_last_current_text=
    
    typesig { [TextEdit] }
    def initialize(root)
      @undo = nil
      @f_offset = 0
      @f_length = 0
      @f_last_current_text = nil
      @f_offset = root.get_offset
      @f_length = root.get_length
    end
    
    typesig { [IDocument] }
    def connect(document)
      document.add_document_listener(self)
      @undo = UndoEdit.new
    end
    
    typesig { [IDocument] }
    def disconnect(document)
      if (!(@undo).nil?)
        document.remove_document_listener(self)
        @undo.define_region(@f_offset, @f_length)
      end
    end
    
    typesig { [DocumentEvent] }
    def document_changed(event)
      @f_length += get_delta(event)
    end
    
    class_module.module_eval {
      typesig { [DocumentEvent] }
      def get_delta(event)
        text = event.get_text
        return (text).nil? ? -event.get_length : (text.length - event.get_length)
      end
    }
    
    typesig { [DocumentEvent] }
    def document_about_to_be_changed(event)
      offset = event.get_offset
      current_length = event.get_length
      current_text = nil
      begin
        current_text = RJava.cast_to_string(event.get_document.get(offset, current_length))
      rescue BadLocationException => cannot_happen
        Assert.is_true(false, "Can't happen") # $NON-NLS-1$
      end
      # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=93634
      # If the same string is replaced on many documents (e.g. rename
      # package), the size of the undo can be reduced by using the same
      # String instance in all edits, instead of using the unique String
      # returned from IDocument.get(int, int).
      if (!(@f_last_current_text).nil? && (@f_last_current_text == current_text))
        current_text = @f_last_current_text
      else
        @f_last_current_text = current_text
      end
      new_text = event.get_text
      @undo.add(ReplaceEdit.new(offset, !(new_text).nil? ? new_text.length : 0, current_text))
    end
    
    private
    alias_method :initialize__undo_collector, :initialize
  end
  
end
