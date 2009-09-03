require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Edits
  module MultiTextEditImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
    }
  end
  
  # A multi-text edit can be used to aggregate several edits into
  # one edit. The edit itself doesn't modify a document.
  # <p>
  # Clients are allowed to implement subclasses of a multi-text
  # edit.Subclasses must implement <code>doCopy()</code> to ensure
  # the a copy of the right type is created. Not implementing
  # <code>doCopy()</code> in subclasses will result in an assertion
  # failure during copying.
  # 
  # @since 3.0
  class MultiTextEdit < MultiTextEditImports.const_get :TextEdit
    include_class_members MultiTextEditImports
    
    attr_accessor :f_defined
    alias_method :attr_f_defined, :f_defined
    undef_method :f_defined
    alias_method :attr_f_defined=, :f_defined=
    undef_method :f_defined=
    
    typesig { [] }
    # Creates a new <code>MultiTextEdit</code>. The range
    # of the edit is determined by the range of its children.
    # 
    # Adding this edit to a parent edit sets its range to the
    # range covered by its children. If the edit doesn't have
    # any children its offset is set to the parent's offset
    # and its length is set to 0.
    def initialize
      @f_defined = false
      super(0, JavaInteger::MAX_VALUE)
      @f_defined = false
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Creates a new </code>MultiTextEdit</code> for the given
    # range. Adding a child to this edit which isn't covered
    # by the given range will result in an exception.
    # 
    # @param offset the edit's offset
    # @param length the edit's length.
    # @see TextEdit#addChild(TextEdit)
    # @see TextEdit#addChildren(TextEdit[])
    def initialize(offset, length)
      @f_defined = false
      super(offset, length)
      @f_defined = true
    end
    
    typesig { [MultiTextEdit] }
    # Copy constructor.
    def initialize(other)
      @f_defined = false
      super(other)
    end
    
    typesig { [] }
    # Checks the edit's integrity.
    # <p>
    # Note that this method <b>should only be called</b> by the edit
    # framework and not by normal clients.</p>
    # <p>
    # This default implementation does nothing. Subclasses may override
    # if needed.</p>
    # 
    # @exception MalformedTreeException if the edit isn't in a valid state
    # and can therefore not be executed
    def check_integrity
      # does nothing
    end
    
    typesig { [] }
    # {@inheritDoc}
    def is_defined
      if (@f_defined)
        return true
      end
      return has_children
    end
    
    typesig { [] }
    # {@inheritDoc}
    def get_offset
      if (@f_defined)
        return super
      end
      # <TextEdit>
      children = internal_get_children
      if ((children).nil? || (children.size).equal?(0))
        return 0
      end
      # the children are already sorted
      return (children.get(0)).get_offset
    end
    
    typesig { [] }
    # {@inheritDoc}
    def get_length
      if (@f_defined)
        return super
      end
      # <TextEdit>
      children = internal_get_children
      if ((children).nil? || (children.size).equal?(0))
        return 0
      end
      # the children are already sorted
      first = children.get(0)
      last = children.get(children.size - 1)
      return last.get_offset - first.get_offset + last.get_length
    end
    
    typesig { [TextEdit] }
    # {@inheritDoc}
    def covers(other)
      if (@f_defined)
        return super(other)
      end
      # an undefined multiple text edit covers everything
      return true
    end
    
    typesig { [] }
    # @see org.eclipse.text.edits.TextEdit#canZeroLengthCover()
    def can_zero_length_cover
      return true
    end
    
    typesig { [] }
    # @see TextEdit#copy
    def do_copy
      Assert.is_true((MultiTextEdit).equal?(get_class), "Subclasses must reimplement copy0") # $NON-NLS-1$
      return MultiTextEdit.new(self)
    end
    
    typesig { [TextEditVisitor] }
    # @see TextEdit#accept0
    def accept0(visitor)
      visit_children = visitor.visit(self)
      if (visit_children)
        accept_children(visitor)
      end
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.text.edits.TextEdit#adjustOffset(int)
    # @since 3.1
    def adjust_offset(delta)
      if (@f_defined)
        super(delta)
      end
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.text.edits.TextEdit#adjustLength(int)
    # @since 3.1
    def adjust_length(delta)
      if (@f_defined)
        super(delta)
      end
    end
    
    typesig { [TextEditProcessor, IDocument] }
    # @see TextEdit#performConsistencyCheck
    def perform_consistency_check(processor, document)
      check_integrity
    end
    
    typesig { [IDocument] }
    # @see TextEdit#performDocumentUpdating
    def perform_document_updating(document)
      self.attr_f_delta = 0
      return self.attr_f_delta
    end
    
    typesig { [] }
    # @see TextEdit#deleteChildren
    def delete_children
      return false
    end
    
    typesig { [TextEdit] }
    def about_to_be_added(parent)
      define_region(parent.get_offset)
    end
    
    typesig { [::Java::Int] }
    def define_region(parent_offset)
      if (@f_defined)
        return
      end
      if (has_children)
        region = get_coverage(get_children)
        internal_set_offset(region.get_offset)
        internal_set_length(region.get_length)
      else
        internal_set_offset(parent_offset)
        internal_set_length(0)
      end
      @f_defined = true
    end
    
    typesig { [StringBuffer, ::Java::Int] }
    # @see org.eclipse.text.edits.TextEdit#internalToString(java.lang.StringBuffer, int)
    # @since 3.3
    def internal_to_string(buffer, indent)
      super(buffer, indent)
      if (!@f_defined)
        buffer.append(" [undefined]")
      end # $NON-NLS-1$
    end
    
    private
    alias_method :initialize__multi_text_edit, :initialize
  end
  
end
