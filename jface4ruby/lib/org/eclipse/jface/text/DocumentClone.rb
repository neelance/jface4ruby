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
  module DocumentCloneImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # An {@link org.eclipse.jface.text.IDocument} that is a read-only clone of another document.
  # 
  # @since 3.0
  class DocumentClone < DocumentCloneImports.const_get :AbstractDocument
    include_class_members DocumentCloneImports
    
    class_module.module_eval {
      const_set_lazy(:StringTextStore) { Class.new do
        include_class_members DocumentClone
        include ITextStore
        
        attr_accessor :f_content
        alias_method :attr_f_content, :f_content
        undef_method :f_content
        alias_method :attr_f_content=, :f_content=
        undef_method :f_content=
        
        typesig { [String] }
        # Creates a new string text store with the given content.
        # 
        # @param content the content
        def initialize(content)
          @f_content = nil
          Assert.is_not_null(content)
          @f_content = content
        end
        
        typesig { [::Java::Int] }
        # @see org.eclipse.jface.text.ITextStore#get(int)
        def get(offset)
          return @f_content.char_at(offset)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # @see org.eclipse.jface.text.ITextStore#get(int, int)
        def get(offset, length)
          return @f_content.substring(offset, offset + length)
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.ITextStore#getLength()
        def get_length
          return @f_content.length
        end
        
        typesig { [::Java::Int, ::Java::Int, String] }
        # @see org.eclipse.jface.text.ITextStore#replace(int, int, java.lang.String)
        def replace(offset, length_, text)
        end
        
        typesig { [String] }
        # @see org.eclipse.jface.text.ITextStore#set(java.lang.String)
        def set(text)
        end
        
        private
        alias_method :initialize__string_text_store, :initialize
      end }
    }
    
    typesig { [String, Array.typed(String)] }
    # Creates a new document clone with the given content.
    # 
    # @param content the content
    # @param lineDelimiters the line delimiters
    def initialize(content, line_delimiters)
      super()
      set_text_store(StringTextStore.new(content))
      tracker = ConfigurableLineTracker.new(line_delimiters)
      set_line_tracker(tracker)
      get_tracker.set(content)
      complete_initialization
    end
    
    private
    alias_method :initialize__document_clone, :initialize
  end
  
end
