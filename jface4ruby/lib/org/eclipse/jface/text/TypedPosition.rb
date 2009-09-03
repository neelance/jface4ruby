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
  module TypedPositionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Convenience class for positions that have a type, similar to
  # {@link org.eclipse.jface.text.ITypedRegion}.
  # <p>
  # As {@link org.eclipse.jface.text.Position},<code>TypedPosition</code> can
  # not be used as key in hash tables as it overrides <code>equals</code> and
  # <code>hashCode</code> as it would be a value object.
  class TypedPosition < TypedPositionImports.const_get :Position
    include_class_members TypedPositionImports
    
    # The type of the region described by this position
    attr_accessor :f_type
    alias_method :attr_f_type, :f_type
    undef_method :f_type
    alias_method :attr_f_type=, :f_type=
    undef_method :f_type=
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # Creates a position along the given specification.
    # 
    # @param offset the offset of this position
    # @param length the length of this position
    # @param type the content type of this position
    def initialize(offset, length, type)
      @f_type = nil
      super(offset, length)
      @f_type = type
    end
    
    typesig { [ITypedRegion] }
    # Creates a position based on the typed region.
    # 
    # @param region the typed region
    def initialize(region)
      @f_type = nil
      super(region.get_offset, region.get_length)
      @f_type = RJava.cast_to_string(region.get_type)
    end
    
    typesig { [] }
    # Returns the content type of the region.
    # 
    # @return the content type of the region
    def get_type
      return @f_type
    end
    
    typesig { [Object] }
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(o)
      if (o.is_a?(TypedPosition))
        if (super(o))
          p = o
          return ((@f_type).nil? && (p.get_type).nil?) || (@f_type == p.get_type)
        end
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
    alias_method :initialize__typed_position, :initialize
  end
  
end
