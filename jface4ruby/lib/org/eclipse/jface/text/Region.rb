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
  module RegionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # The default implementation of the {@link org.eclipse.jface.text.IRegion} interface.
  class Region 
    include_class_members RegionImports
    include IRegion
    
    # The region offset
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    # The region length
    attr_accessor :f_length
    alias_method :attr_f_length, :f_length
    undef_method :f_length
    alias_method :attr_f_length=, :f_length=
    undef_method :f_length=
    
    typesig { [::Java::Int, ::Java::Int] }
    # Create a new region.
    # 
    # @param offset the offset of the region
    # @param length the length of the region
    def initialize(offset, length)
      @f_offset = 0
      @f_length = 0
      @f_offset = offset
      @f_length = length
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IRegion#getLength()
    def get_length
      return @f_length
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IRegion#getOffset()
    def get_offset
      return @f_offset
    end
    
    typesig { [Object] }
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(o)
      if (o.is_a?(IRegion))
        r = o
        return (r.get_offset).equal?(@f_offset) && (r.get_length).equal?(@f_length)
      end
      return false
    end
    
    typesig { [] }
    # @see java.lang.Object#hashCode()
    def hash_code
      return (@f_offset << 24) | (@f_length << 16)
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    def to_s
      return "offset: " + RJava.cast_to_string(@f_offset) + ", length: " + RJava.cast_to_string(@f_length) # $NON-NLS-1$ //$NON-NLS-2$;
    end
    
    private
    alias_method :initialize__region, :initialize
  end
  
end
