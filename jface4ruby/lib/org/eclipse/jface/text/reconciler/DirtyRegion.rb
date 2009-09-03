require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Reconciler
  module DirtyRegionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Reconciler
      include_const ::Org::Eclipse::Jface::Text, :ITypedRegion
    }
  end
  
  # A dirty region describes a document range which has been changed.
  class DirtyRegion 
    include_class_members DirtyRegionImports
    include ITypedRegion
    
    class_module.module_eval {
      # Identifies an insert operation.
      const_set_lazy(:INSERT) { "__insert" }
      const_attr_reader  :INSERT
      
      # $NON-NLS-1$
      # 
      # Identifies a remove operation.
      const_set_lazy(:REMOVE) { "__remove" }
      const_attr_reader  :REMOVE
    }
    
    # $NON-NLS-1$
    # The region's offset.
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    # The region's length.
    attr_accessor :f_length
    alias_method :attr_f_length, :f_length
    undef_method :f_length
    alias_method :attr_f_length=, :f_length=
    undef_method :f_length=
    
    # Indicates the type of the applied change.
    attr_accessor :f_type
    alias_method :attr_f_type, :f_type
    undef_method :f_type
    alias_method :attr_f_type=, :f_type=
    undef_method :f_type=
    
    # The text which has been inserted.
    attr_accessor :f_text
    alias_method :attr_f_text, :f_text
    undef_method :f_text
    alias_method :attr_f_text=, :f_text=
    undef_method :f_text=
    
    typesig { [::Java::Int, ::Java::Int, String, String] }
    # Creates a new dirty region.
    # 
    # @param offset the offset within the document where the change occurred
    # @param length the length of the text within the document that changed
    # @param type the type of change that this region represents: {@link #INSERT} {@link #REMOVE}
    # @param text the substitution text
    def initialize(offset, length, type, text)
      @f_offset = 0
      @f_length = 0
      @f_type = nil
      @f_text = nil
      @f_offset = offset
      @f_length = length
      @f_type = RJava.cast_to_string(normalize_type_value(type))
      @f_text = text
    end
    
    typesig { [String] }
    # Computes the normalized type value to ensure that the implementation can use object identity rather
    # than equality.
    # 
    # @param type the type value
    # @return the normalized type value or <code>null</code>
    # @since 3.1
    def normalize_type_value(type)
      if ((INSERT == type))
        return INSERT
      end
      if ((REMOVE == type))
        return REMOVE
      end
      return nil
    end
    
    typesig { [] }
    # @see ITypedRegion#getOffset()
    def get_offset
      return @f_offset
    end
    
    typesig { [] }
    # @see ITypedRegion#getLength()
    def get_length
      return @f_length
    end
    
    typesig { [] }
    # @see ITypedRegion#getType
    def get_type
      return @f_type
    end
    
    typesig { [] }
    # Returns the text that changed as part of the region change.
    # 
    # @return the changed text
    def get_text
      return @f_text
    end
    
    typesig { [DirtyRegion] }
    # Modify the receiver so that it encompasses the region specified by the dirty region.
    # 
    # @param dr the dirty region with which to merge
    def merge_with(dr)
      start = Math.min(@f_offset, dr.attr_f_offset)
      end_ = Math.max(@f_offset + @f_length, dr.attr_f_offset + dr.attr_f_length)
      @f_offset = start
      @f_length = end_ - start
      @f_text = RJava.cast_to_string(((dr.attr_f_text).nil? ? @f_text : ((@f_text).nil?) ? dr.attr_f_text : @f_text + RJava.cast_to_string(dr.attr_f_text)))
    end
    
    private
    alias_method :initialize__dirty_region, :initialize
  end
  
end
