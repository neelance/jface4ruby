require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DocumentEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Specification of changes applied to documents. All changes are represented as
  # replace commands, i.e. specifying a document range whose text gets replaced
  # with different text. In addition to this information, the event also contains
  # the changed document.
  # 
  # @see org.eclipse.jface.text.IDocument
  class DocumentEvent 
    include_class_members DocumentEventImports
    
    class_module.module_eval {
      # Debug option for asserting that text is not null.
      # If the <code>org.eclipse.text/debug/DocumentEvent/assertTextNotNull</code>
      # system property is <code>true</code>
      # 
      # @since 3.3
      const_set_lazy(:ASSERT_TEXT_NOT_NULL) { Boolean.get_boolean("org.eclipse.text/debug/DocumentEvent/assertTextNotNull") }
      const_attr_reader  :ASSERT_TEXT_NOT_NULL
    }
    
    # $NON-NLS-1$
    # The changed document
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The document offset
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    # Length of the replaced document text
    attr_accessor :f_length
    alias_method :attr_f_length, :f_length
    undef_method :f_length
    alias_method :attr_f_length=, :f_length=
    undef_method :f_length=
    
    # Text inserted into the document
    attr_accessor :f_text
    alias_method :attr_f_text, :f_text
    undef_method :f_text
    alias_method :attr_f_text=, :f_text=
    undef_method :f_text=
    
    # $NON-NLS-1$
    # 
    # The modification stamp of the document when firing this event.
    # @since 3.1 and public since 3.3
    attr_accessor :f_modification_stamp
    alias_method :attr_f_modification_stamp, :f_modification_stamp
    undef_method :f_modification_stamp
    alias_method :attr_f_modification_stamp=, :f_modification_stamp=
    undef_method :f_modification_stamp=
    
    typesig { [IDocument, ::Java::Int, ::Java::Int, String] }
    # Creates a new document event.
    # 
    # @param doc the changed document
    # @param offset the offset of the replaced text
    # @param length the length of the replaced text
    # @param text the substitution text
    def initialize(doc, offset, length, text)
      @f_document = nil
      @f_offset = 0
      @f_length = 0
      @f_text = ""
      @f_modification_stamp = 0
      Assert.is_not_null(doc)
      Assert.is_true(offset >= 0)
      Assert.is_true(length >= 0)
      if (ASSERT_TEXT_NOT_NULL)
        Assert.is_not_null(text)
      end
      @f_document = doc
      @f_offset = offset
      @f_length = length
      @f_text = text
      if (@f_document.is_a?(IDocumentExtension4))
        @f_modification_stamp = (@f_document).get_modification_stamp
      else
        @f_modification_stamp = IDocumentExtension4::UNKNOWN_MODIFICATION_STAMP
      end
    end
    
    typesig { [] }
    # Creates a new, not initialized document event.
    def initialize
      @f_document = nil
      @f_offset = 0
      @f_length = 0
      @f_text = ""
      @f_modification_stamp = 0
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
    # Returns the length of the replaced text.
    # 
    # @return the length of the replaced text
    def get_length
      return @f_length
    end
    
    typesig { [] }
    # Returns the text that has been inserted.
    # 
    # @return the text that has been inserted
    def get_text
      return @f_text
    end
    
    typesig { [] }
    # Returns the document's modification stamp at the
    # time when this event was sent.
    # 
    # @return the modification stamp or {@link IDocumentExtension4#UNKNOWN_MODIFICATION_STAMP}.
    # @see IDocumentExtension4#getModificationStamp()
    # @since 3.1
    def get_modification_stamp
      return @f_modification_stamp
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    # @since 3.4
    def to_s
      buffer = StringBuffer.new
      buffer.append("offset: ") # $NON-NLS-1$
      buffer.append(@f_offset)
      buffer.append(", length: ") # $NON-NLS-1$
      buffer.append(@f_length)
      buffer.append(", timestamp: ") # $NON-NLS-1$
      buffer.append(@f_modification_stamp)
      buffer.append("\ntext:>") # $NON-NLS-1$
      buffer.append(@f_text)
      buffer.append("<\n") # $NON-NLS-1$
      return buffer.to_s
    end
    
    private
    alias_method :initialize__document_event, :initialize
  end
  
end
