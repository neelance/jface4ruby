require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Projection
  module ProjectionTextStoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Projection
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextStore
      include_const ::Org::Eclipse::Jface::Text, :Region
    }
  end
  
  # A text store representing the projection defined by the given document
  # information mapping.
  # 
  # @since 3.0
  class ProjectionTextStore 
    include_class_members ProjectionTextStoreImports
    include ITextStore
    
    class_module.module_eval {
      # Implementation of {@link IRegion} that can be reused
      # by setting the offset and the length.
      const_set_lazy(:ReusableRegion) { Class.new do
        include_class_members ProjectionTextStore
        include IRegion
        
        attr_accessor :f_offset
        alias_method :attr_f_offset, :f_offset
        undef_method :f_offset
        alias_method :attr_f_offset=, :f_offset=
        undef_method :f_offset=
        
        attr_accessor :f_length
        alias_method :attr_f_length, :f_length
        undef_method :f_length
        alias_method :attr_f_length=, :f_length=
        undef_method :f_length=
        
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
        
        typesig { [::Java::Int, ::Java::Int] }
        # Updates this region.
        # 
        # @param offset the new offset
        # @param length the new length
        def update(offset, length)
          @f_offset = offset
          @f_length = length
        end
        
        typesig { [] }
        def initialize
          @f_offset = 0
          @f_length = 0
        end
        
        private
        alias_method :initialize__reusable_region, :initialize
      end }
    }
    
    # The master document
    attr_accessor :f_master_document
    alias_method :attr_f_master_document, :f_master_document
    undef_method :f_master_document
    alias_method :attr_f_master_document=, :f_master_document=
    undef_method :f_master_document=
    
    # The document information mapping
    attr_accessor :f_mapping
    alias_method :attr_f_mapping, :f_mapping
    undef_method :f_mapping
    alias_method :attr_f_mapping=, :f_mapping=
    undef_method :f_mapping=
    
    # Internal region used for querying the mapping.
    attr_accessor :f_reusable_region
    alias_method :attr_f_reusable_region, :f_reusable_region
    undef_method :f_reusable_region
    alias_method :attr_f_reusable_region=, :f_reusable_region=
    undef_method :f_reusable_region=
    
    typesig { [IDocument, IMinimalMapping] }
    # Creates a new projection text store for the given master document and
    # the given document information mapping.
    # 
    # @param masterDocument the master document
    # @param mapping the document information mapping
    def initialize(master_document, mapping)
      @f_master_document = nil
      @f_mapping = nil
      @f_reusable_region = ReusableRegion.new
      @f_master_document = master_document
      @f_mapping = mapping
    end
    
    typesig { [] }
    def internal_error
      raise IllegalStateException.new
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.ITextStore#set(java.lang.String)
    def set(contents)
      master_region = @f_mapping.get_coverage
      if ((master_region).nil?)
        internal_error
      end
      begin
        @f_master_document.replace(master_region.get_offset, master_region.get_length, contents)
      rescue BadLocationException => e
        internal_error
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @see org.eclipse.jface.text.ITextStore#replace(int, int, java.lang.String)
    def replace(offset, length, text)
      @f_reusable_region.update(offset, length)
      begin
        master_region = @f_mapping.to_origin_region(@f_reusable_region)
        @f_master_document.replace(master_region.get_offset, master_region.get_length, text)
      rescue BadLocationException => e
        internal_error
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextStore#getLength()
    def get_length
      return @f_mapping.get_image_length
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.ITextStore#get(int)
    def get(offset)
      begin
        origin_offset = @f_mapping.to_origin_offset(offset)
        return @f_master_document.get_char(origin_offset)
      rescue BadLocationException => e
        internal_error
      end
      # unreachable
      return RJava.cast_to_char(0)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see ITextStore#get(int, int)
    def get(offset, length)
      begin
        fragments = @f_mapping.to_exact_origin_regions(Region.new(offset, length))
        buffer = StringBuffer.new
        i = 0
        while i < fragments.attr_length
          fragment = fragments[i]
          buffer.append(@f_master_document.get(fragment.get_offset, fragment.get_length))
          i += 1
        end
        return buffer.to_s
      rescue BadLocationException => e
        internal_error
      end
      # unreachable
      return nil
    end
    
    private
    alias_method :initialize__projection_text_store, :initialize
  end
  
end
