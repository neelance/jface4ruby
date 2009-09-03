require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module LineImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Describes a line as a particular number of characters beginning at
  # a particular offset, consisting of a particular number of characters,
  # and being closed with a particular line delimiter.
  class Line 
    include_class_members LineImports
    include IRegion
    
    # The offset of the line
    attr_accessor :offset
    alias_method :attr_offset, :offset
    undef_method :offset
    alias_method :attr_offset=, :offset=
    undef_method :offset=
    
    # The length of the line
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    # The delimiter of this line
    attr_accessor :delimiter
    alias_method :attr_delimiter, :delimiter
    undef_method :delimiter
    alias_method :attr_delimiter=, :delimiter=
    undef_method :delimiter=
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # Creates a new Line.
    # 
    # @param offset the offset of the line
    # @param end the last including character offset of the line
    # @param delimiter the line's delimiter
    def initialize(offset, end_, delimiter)
      @offset = 0
      @length = 0
      @delimiter = nil
      @offset = offset
      @length = (end_ - offset) + 1
      @delimiter = delimiter
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Creates a new Line.
    # 
    # @param offset the offset of the line
    # @param length the length of the line
    def initialize(offset, length)
      @offset = 0
      @length = 0
      @delimiter = nil
      @offset = offset
      @length = length
      @delimiter = nil
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IRegion#getOffset()
    def get_offset
      return @offset
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IRegion#getLength()
    def get_length
      return @length
    end
    
    private
    alias_method :initialize__line, :initialize
  end
  
end
