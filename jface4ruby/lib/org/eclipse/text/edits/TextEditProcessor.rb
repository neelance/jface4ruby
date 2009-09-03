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
  module TextEditProcessorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # A <code>TextEditProcessor</code> manages a set of edits and applies
  # them as a whole to an <code>IDocument</code>.
  # <p>
  # This class isn't intended to be subclassed.</p>
  # 
  # @see org.eclipse.text.edits.TextEdit#apply(IDocument)
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class TextEditProcessor 
    include_class_members TextEditProcessorImports
    
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    attr_accessor :f_root
    alias_method :attr_f_root, :f_root
    undef_method :f_root
    alias_method :attr_f_root=, :f_root=
    undef_method :f_root=
    
    attr_accessor :f_style
    alias_method :attr_f_style, :f_style
    undef_method :f_style
    alias_method :attr_f_style=, :f_style=
    undef_method :f_style=
    
    attr_accessor :f_checked
    alias_method :attr_f_checked, :f_checked
    undef_method :f_checked
    alias_method :attr_f_checked=, :f_checked=
    undef_method :f_checked=
    
    attr_accessor :f_exception
    alias_method :attr_f_exception, :f_exception
    undef_method :f_exception
    alias_method :attr_f_exception=, :f_exception=
    undef_method :f_exception=
    
    attr_accessor :f_source_edits
    alias_method :attr_f_source_edits, :f_source_edits
    undef_method :f_source_edits
    alias_method :attr_f_source_edits=, :f_source_edits=
    undef_method :f_source_edits=
    
    typesig { [IDocument, TextEdit, ::Java::Int] }
    # Constructs a new edit processor for the given
    # document.
    # 
    # @param document the document to manipulate
    # @param root the root of the text edit tree describing
    # the modifications. By passing a text edit a a text edit
    # processor the ownership of the edit is transfered to the
    # text edit processors. Clients must not modify the edit
    # (e.g adding new children) any longer.
    # 
    # @param style {@link TextEdit#NONE}, {@link TextEdit#CREATE_UNDO} or {@link TextEdit#UPDATE_REGIONS})
    def initialize(document, root, style)
      initialize__text_edit_processor(document, root, style, false)
    end
    
    typesig { [IDocument, TextEdit, ::Java::Int, ::Java::Boolean] }
    def initialize(document, root, style, secondary)
      @f_document = nil
      @f_root = nil
      @f_style = 0
      @f_checked = false
      @f_exception = nil
      @f_source_edits = nil
      Assert.is_not_null(document)
      Assert.is_not_null(root)
      @f_document = document
      @f_root = root
      if (@f_root.is_a?(MultiTextEdit))
        (@f_root).define_region(0)
      end
      @f_style = style
      if (secondary)
        @f_checked = true
        @f_source_edits = ArrayList.new
      end
    end
    
    class_module.module_eval {
      typesig { [IDocument, TextEdit, ::Java::Int] }
      # Creates a special internal processor used to during source computation inside
      # move source and copy source edits
      # 
      # @param document the document to be manipulated
      # @param root the edit tree
      # @param style {@link TextEdit#NONE}, {@link TextEdit#CREATE_UNDO} or {@link TextEdit#UPDATE_REGIONS})
      # @return a secondary text edit processor
      # @since 3.1
      def create_source_computation_processor(document, root, style)
        return TextEditProcessor.new(document, root, style, true)
      end
    }
    
    typesig { [] }
    # Returns the document to be manipulated.
    # 
    # @return the document
    def get_document
      return @f_document
    end
    
    typesig { [] }
    # Returns the edit processor's root edit.
    # 
    # @return the processor's root edit
    def get_root
      return @f_root
    end
    
    typesig { [] }
    # Returns the style bits of the text edit processor
    # 
    # @return the style bits
    # @see TextEdit#CREATE_UNDO
    # @see TextEdit#UPDATE_REGIONS
    def get_style
      return @f_style
    end
    
    typesig { [] }
    # Checks if the processor can execute all its edits.
    # 
    # @return <code>true</code> if the edits can be executed. Return  <code>false
    # </code>otherwise. One major reason why edits cannot be executed are wrong
    # offset or length values of edits. Calling perform in this case will very
    # likely end in a <code>BadLocationException</code>.
    def can_perform_edits
      begin
        @f_root.dispatch_check_integrity(self)
        @f_checked = true
      rescue MalformedTreeException => e
        @f_exception = e
        return false
      end
      return true
    end
    
    typesig { [] }
    # Executes the text edits.
    # 
    # @return an object representing the undo of the executed edits
    # @exception MalformedTreeException is thrown if the edit tree isn't
    # in a valid state. This exception is thrown before any edit is executed.
    # So the document is still in its original state.
    # @exception BadLocationException is thrown if one of the edits in the
    # tree can't be executed. The state of the document is undefined if this
    # exception is thrown.
    def perform_edits
      if (!@f_checked)
        @f_root.dispatch_check_integrity(self)
      else
        if (!(@f_exception).nil?)
          raise @f_exception
        end
      end
      return @f_root.dispatch_perform_edits(self)
    end
    
    typesig { [TextEdit] }
    # Tells whether this processor considers the given edit.
    # <p>
    # Note that this class isn't intended to be subclassed.
    # </p>
    # 
    # @param edit the text edit
    # @return <code>true</code> if this processor considers the given edit
    def consider_edit(edit)
      return true
    end
    
    typesig { [] }
    # ---- checking --------------------------------------------------------------------
    def check_integrity_do
      @f_source_edits = ArrayList.new
      @f_root.traverse_consistency_check(self, @f_document, @f_source_edits)
      if (@f_root.get_exclusive_end > @f_document.get_length)
        raise MalformedTreeException.new(nil, @f_root, TextEditMessages.get_string("TextEditProcessor.invalid_length"))
      end # $NON-NLS-1$
    end
    
    typesig { [] }
    def check_integrity_undo
      if (@f_root.get_exclusive_end > @f_document.get_length)
        raise MalformedTreeException.new(nil, @f_root, TextEditMessages.get_string("TextEditProcessor.invalid_length"))
      end # $NON-NLS-1$
    end
    
    typesig { [] }
    # ---- execution --------------------------------------------------------------------
    def execute_do
      collector = UndoCollector.new(@f_root)
      begin
        if (create_undo)
          collector.connect(@f_document)
        end
        compute_sources
        @f_root.traverse_document_updating(self, @f_document)
        if (update_regions)
          @f_root.traverse_region_updating(self, @f_document, 0, false)
        end
      ensure
        collector.disconnect(@f_document)
      end
      return collector.attr_undo
    end
    
    typesig { [] }
    def compute_sources
      iter = @f_source_edits.iterator
      while iter.has_next
        list = iter.next_
        if (!(list).nil?)
          edits = list.iterator
          while edits.has_next
            edit = edits.next_
            edit.traverse_source_computation(self, @f_document)
          end
        end
      end
    end
    
    typesig { [] }
    def execute_undo
      collector = UndoCollector.new(@f_root)
      begin
        if (create_undo)
          collector.connect(@f_document)
        end
        edits = @f_root.get_children
        i = edits.attr_length - 1
        while i >= 0
          edits[i].perform_document_updating(@f_document)
          i -= 1
        end
      ensure
        collector.disconnect(@f_document)
      end
      return collector.attr_undo
    end
    
    typesig { [] }
    def create_undo
      return !((@f_style & TextEdit::CREATE_UNDO)).equal?(0)
    end
    
    typesig { [] }
    def update_regions
      return !((@f_style & TextEdit::UPDATE_REGIONS)).equal?(0)
    end
    
    private
    alias_method :initialize__text_edit_processor, :initialize
  end
  
end
