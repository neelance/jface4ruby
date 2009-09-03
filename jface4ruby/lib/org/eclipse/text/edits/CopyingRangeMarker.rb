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
  module CopyingRangeMarkerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # A <code>CopyingRangeMarker</code> can be used to track positions when executing
  # text edits. Additionally a copying range marker stores a local copy of the
  # text it captures when it gets executed.
  # 
  # @since 3.0
  class CopyingRangeMarker < CopyingRangeMarkerImports.const_get :TextEdit
    include_class_members CopyingRangeMarkerImports
    
    attr_accessor :f_text
    alias_method :attr_f_text, :f_text
    undef_method :f_text
    alias_method :attr_f_text=, :f_text=
    undef_method :f_text=
    
    typesig { [::Java::Int, ::Java::Int] }
    # Creates a new <tt>CopyRangeMarker</tt> for the given
    # offset and length.
    # 
    # @param offset the marker's offset
    # @param length the marker's length
    def initialize(offset, length)
      @f_text = nil
      super(offset, length)
    end
    
    typesig { [CopyingRangeMarker] }
    # Copy constructor
    def initialize(other)
      @f_text = nil
      super(other)
      @f_text = RJava.cast_to_string(other.attr_f_text)
    end
    
    typesig { [] }
    # @see TextEdit#doCopy
    def do_copy
      return CopyingRangeMarker.new(self)
    end
    
    typesig { [TextEditVisitor] }
    # @see TextEdit#accept0
    def accept0(visitor)
      visit_children = visitor.visit(self)
      if (visit_children)
        accept_children(visitor)
      end
    end
    
    typesig { [IDocument] }
    # @see TextEdit#performDocumentUpdating
    def perform_document_updating(document)
      @f_text = RJava.cast_to_string(document.get(get_offset, get_length))
      self.attr_f_delta = 0
      return self.attr_f_delta
    end
    
    typesig { [] }
    # @see TextEdit#deleteChildren
    def delete_children
      return false
    end
    
    private
    alias_method :initialize__copying_range_marker, :initialize
  end
  
end
