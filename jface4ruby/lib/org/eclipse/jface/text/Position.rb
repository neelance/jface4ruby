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
  module PositionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Positions describe text ranges of a document. Positions are adapted to
  # changes applied to that document. The text range is specified by an offset
  # and a length. Positions can be marked as deleted. Deleted positions are
  # considered to no longer represent a valid text range in the managing
  # document.
  # <p>
  # Positions attached to documents are usually updated by position updaters.
  # Because position updaters are freely definable and because of the frequency
  # in which they are used, the fields of a position are made publicly
  # accessible. Clients other than position updaters are not allowed to access
  # these public fields.
  # </p>
  # <p>
  # Positions cannot be used as keys in hash tables as they override
  # <code>equals</code> and <code>hashCode</code> as they would be value
  # objects.
  # </p>
  # 
  # @see org.eclipse.jface.text.IDocument
  class Position 
    include_class_members PositionImports
    
    # The offset of the position
    attr_accessor :offset
    alias_method :attr_offset, :offset
    undef_method :offset
    alias_method :attr_offset=, :offset=
    undef_method :offset=
    
    # The length of the position
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    # Indicates whether the position has been deleted
    attr_accessor :is_deleted
    alias_method :attr_is_deleted, :is_deleted
    undef_method :is_deleted
    alias_method :attr_is_deleted=, :is_deleted=
    undef_method :is_deleted=
    
    typesig { [::Java::Int] }
    # Creates a new position with the given offset and length 0.
    # 
    # @param offset the position offset, must be >= 0
    def initialize(offset)
      initialize__position(offset, 0)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Creates a new position with the given offset and length.
    # 
    # @param offset the position offset, must be >= 0
    # @param length the position length, must be >= 0
    def initialize(offset, length)
      @offset = 0
      @length = 0
      @is_deleted = false
      Assert.is_true(offset >= 0)
      Assert.is_true(length >= 0)
      @offset = offset
      @length = length
    end
    
    typesig { [] }
    # Creates a new, not initialized position.
    def initialize
      @offset = 0
      @length = 0
      @is_deleted = false
    end
    
    typesig { [] }
    # @see java.lang.Object#hashCode()
    def hash_code
      deleted = @is_deleted ? 0 : 1
      return (@offset << 24) | (@length << 16) | deleted
    end
    
    typesig { [] }
    # Marks this position as deleted.
    def delete
      @is_deleted = true
    end
    
    typesig { [] }
    # Marks this position as not deleted.
    # 
    # @since 2.0
    def undelete
      @is_deleted = false
    end
    
    typesig { [Object] }
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(other)
      if (other.is_a?(Position))
        rp = other
        return ((rp.attr_offset).equal?(@offset)) && ((rp.attr_length).equal?(@length))
      end
      return super(other)
    end
    
    typesig { [] }
    # Returns the length of this position.
    # 
    # @return the length of this position
    def get_length
      return @length
    end
    
    typesig { [] }
    # Returns the offset of this position.
    # 
    # @return the offset of this position
    def get_offset
      return @offset
    end
    
    typesig { [::Java::Int] }
    # Checks whether the given index is inside
    # of this position's text range.
    # 
    # @param index the index to check
    # @return <code>true</code> if <code>index</code> is inside of this position
    def includes(index)
      if (@is_deleted)
        return false
      end
      return (@offset <= index) && (index < @offset + @length)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Checks whether the intersection of the given text range
    # and the text range represented by this position is empty
    # or not.
    # 
    # @param rangeOffset the offset of the range to check
    # @param rangeLength the length of the range to check
    # @return <code>true</code> if intersection is not empty
    def overlaps_with(range_offset, range_length)
      if (@is_deleted)
        return false
      end
      end_ = range_offset + range_length
      this_end = @offset + @length
      if (range_length > 0)
        if (@length > 0)
          return @offset < end_ && range_offset < this_end
        end
        return range_offset <= @offset && @offset < end_
      end
      if (@length > 0)
        return @offset <= range_offset && range_offset < this_end
      end
      return (@offset).equal?(range_offset)
    end
    
    typesig { [] }
    # Returns whether this position has been deleted or not.
    # 
    # @return <code>true</code> if position has been deleted
    def is_deleted
      return @is_deleted
    end
    
    typesig { [::Java::Int] }
    # Changes the length of this position to the given length.
    # 
    # @param length the new length of this position
    def set_length(length)
      Assert.is_true(length >= 0)
      @length = length
    end
    
    typesig { [::Java::Int] }
    # Changes the offset of this position to the given offset.
    # 
    # @param offset the new offset of this position
    def set_offset(offset)
      Assert.is_true(offset >= 0)
      @offset = offset
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    # @since 3.5
    def to_s
      position = "offset: " + RJava.cast_to_string(@offset) + ", length: " + RJava.cast_to_string(@length) # $NON-NLS-1$//$NON-NLS-2$
      return @is_deleted ? position + " (deleted)" : position # $NON-NLS-1$
    end
    
    private
    alias_method :initialize__position, :initialize
  end
  
end
