require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Link
  module LinkedPositionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Link
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  # A <code>Position</code> on a document that knows which document it is
  # registered with and has a sequence number for tab stops.
  # <p>
  # Clients may extend this class.
  # </p>
  # @since 3.0
  class LinkedPosition < LinkedPositionImports.const_get :Position
    include_class_members LinkedPositionImports
    
    # The document this position belongs to.
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    attr_accessor :f_sequence_number
    alias_method :attr_f_sequence_number, :f_sequence_number
    undef_method :f_sequence_number
    alias_method :attr_f_sequence_number=, :f_sequence_number=
    undef_method :f_sequence_number=
    
    typesig { [IDocument, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Creates a new instance.
    # 
    # @param document the document
    # @param offset the offset of the position
    # @param length the length of the position
    # @param sequence the iteration sequence rank
    def initialize(document, offset, length, sequence)
      @f_document = nil
      @f_sequence_number = 0
      super(offset, length)
      Assert.is_not_null(document)
      @f_document = document
      @f_sequence_number = sequence
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # Creates a new instance. Equivalent to calling
    # <code>LinkedPosition(document, offset, length, LinkedPositionGroup.NO_STOP)</code>
    # 
    # @param document the document
    # @param offset the offset of the position
    # @param length the length of the position
    def initialize(document, offset, length)
      initialize__linked_position(document, offset, length, LinkedPositionGroup::NO_STOP)
    end
    
    typesig { [] }
    # @return Returns the document.
    def get_document
      return @f_document
    end
    
    typesig { [Object] }
    # @see org.eclipse.jface.text.Position#equals(java.lang.Object)
    def ==(other)
      if (other.is_a?(LinkedPosition))
        p = other
        return (p.attr_offset).equal?(self.attr_offset) && (p.attr_length).equal?(self.attr_length) && (p.attr_f_document).equal?(@f_document)
      end
      return false
    end
    
    typesig { [LinkedPosition] }
    # Returns whether this position overlaps with <code>position</code>.
    # 
    # @param position the position to check.
    # @return <code>true</code> if this position overlaps with
    # <code>position</code>,<code>false</code> otherwise
    def overlaps_with(position)
      return (position.get_document).equal?(@f_document) && overlaps_with(position.get_offset, position.get_length)
    end
    
    typesig { [DocumentEvent] }
    # Returns whether this position includes <code>event</code>.
    # 
    # @param event the event to check.
    # @return <code>true</code> if this position includes <code>event</code>,
    # <code>false</code> otherwise
    def includes(event)
      return includes(event.get_document, event.get_offset, event.get_length)
    end
    
    typesig { [LinkedPosition] }
    # Returns whether this position includes <code>position</code>.
    # 
    # @param position the position to check.
    # @return <code>true</code> if this position includes
    # <code>position</code>,<code>false</code> otherwise
    def includes(position)
      return includes(position.get_document, position.get_offset, position.get_length)
    end
    
    typesig { [::Java::Int] }
    # Overrides {@link Position#includes(int)}so every offset is considered
    # included that lies in between the first and last offset of this position,
    # and offsets that are right at the end of the position.
    # 
    # @param pOffset the offset to check
    # @return <code>true</code> if <code>pOffset</code> is in
    # <code>[offset, offset + length]</code>
    def includes(p_offset)
      return self.attr_offset <= p_offset && p_offset <= self.attr_offset + self.attr_length
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # Returns whether this position includes the range given by
    # <code>offset</code> and <code>length</code>. A range is included by
    # a <code>LinkedPosition</code> if {@link #includes(int) includes(offset)}
    # returns true for every offset in the range, including the borders of the
    # range.
    # 
    # @param doc the document that the given range refers to, may be <code>null</code>
    # @param off the offset of the range, referring to <code>document</code>
    # @param len the length of the range
    # @return <code>true</code> if <code>doc</code> is the same document as
    # this position refers to, and if the entire range is included in
    # this position
    def includes(doc, off, len)
      return (doc).equal?(@f_document) && off >= self.attr_offset && len + off <= self.attr_offset + self.attr_length
    end
    
    typesig { [] }
    # Returns the content of this position on the referenced document.
    # 
    # @return the content of the document at this position
    # @throws BadLocationException if the position is not valid
    def get_content
      return @f_document.get(self.attr_offset, self.attr_length)
    end
    
    typesig { [] }
    # Returns the sequence number of this position.
    # 
    # @return the sequence number of this position
    def get_sequence_number
      return @f_sequence_number
    end
    
    typesig { [::Java::Int] }
    # Sets the sequence number of this position.
    # 
    # @param sequence the new sequence number
    def set_sequence_number(sequence)
      @f_sequence_number = sequence
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.Position#hashCode()
    def hash_code
      return @f_document.hash_code | super | @f_sequence_number
    end
    
    private
    alias_method :initialize__linked_position, :initialize
  end
  
end
