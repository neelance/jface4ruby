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
  module TypedRegionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Default implementation of {@link org.eclipse.jface.text.ITypedRegion}. A
  # <code>TypedRegion</code> is a value object.
  class TypedRegion < TypedRegionImports.const_get :Region
    include_class_members TypedRegionImports
    overload_protected {
      include ITypedRegion
    }
    
    # The region's type
    attr_accessor :f_type
    alias_method :attr_f_type, :f_type
    undef_method :f_type
    alias_method :attr_f_type=, :f_type=
    undef_method :f_type=
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # Creates a typed region based on the given specification.
    # 
    # @param offset the region's offset
    # @param length the region's length
    # @param type the region's type
    def initialize(offset, length, type)
      @f_type = nil
      super(offset, length)
      @f_type = type
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITypedRegion#getType()
    def get_type
      return @f_type
    end
    
    typesig { [Object] }
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(o)
      if (o.is_a?(TypedRegion))
        r = o
        return super(r) && (((@f_type).nil? && (r.get_type).nil?) || (@f_type == r.get_type))
      end
      return false
    end
    
    typesig { [] }
    # @see java.lang.Object#hashCode()
    def hash_code
      type = (@f_type).nil? ? 0 : @f_type.hash_code
      return super | type
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.Region#toString()
    # @since 3.5
    def to_s
      return @f_type + " - " + RJava.cast_to_string(super) # $NON-NLS-1$
    end
    
    private
    alias_method :initialize__typed_region, :initialize
  end
  
end
