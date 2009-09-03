require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module MarkSelectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Default implementation of {@link org.eclipse.jface.text.IMarkSelection}.
  # 
  # @since 2.0
  class MarkSelection 
    include_class_members MarkSelectionImports
    include IMarkSelection
    
    # The marked document.
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The offset of the mark selection.
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    # The length of the mark selection.
    attr_accessor :f_length
    alias_method :attr_f_length, :f_length
    undef_method :f_length
    alias_method :attr_f_length=, :f_length=
    undef_method :f_length=
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # Creates a MarkSelection.
    # 
    # @param document the marked document
    # @param offset the offset of the mark
    # @param length the length of the mark, may be negative if caret before offset
    def initialize(document, offset, length)
      @f_document = nil
      @f_offset = 0
      @f_length = 0
      @f_document = document
      @f_offset = offset
      @f_length = length
    end
    
    typesig { [] }
    # @see IMarkSelection#getDocument()
    def get_document
      return @f_document
    end
    
    typesig { [] }
    # @see IMarkSelection#getOffset()
    def get_offset
      return @f_offset
    end
    
    typesig { [] }
    # @see IMarkSelection#getLength()
    def get_length
      return @f_length
    end
    
    typesig { [] }
    # @see ISelection#isEmpty()
    def is_empty
      return (@f_length).equal?(0)
    end
    
    private
    alias_method :initialize__mark_selection, :initialize
  end
  
end
