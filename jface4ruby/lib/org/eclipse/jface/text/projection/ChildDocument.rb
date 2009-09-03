require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Projection
  module ChildDocumentImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Projection
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  # Implementation of a child document based on
  # {@link org.eclipse.jface.text.projection.ProjectionDocument}. This class
  # exists for compatibility reasons.
  # <p>
  # Internal class. This class is not intended to be used by clients.</p>
  # 
  # @since 3.0
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class ChildDocument < ChildDocumentImports.const_get :ProjectionDocument
    include_class_members ChildDocumentImports
    
    class_module.module_eval {
      # Position reflecting a visible region. The exclusive end offset of the position
      # is considered being overlapping with the visible region.
      const_set_lazy(:VisibleRegion) { Class.new(Position) do
        include_class_members ChildDocument
        
        typesig { [::Java::Int, ::Java::Int] }
        # Creates a new visible region.
        # 
        # @param regionOffset the offset of the region
        # @param regionLength the length of the region
        def initialize(region_offset, region_length)
          super(region_offset, region_length)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # If <code>regionOffset</code> is the end of the visible region and the <code>regionLength == 0</code>,
        # the <code>regionOffset</code> is considered overlapping with the visible region.
        # 
        # @see org.eclipse.jface.text.Position#overlapsWith(int, int)
        def overlaps_with(region_offset, region_length)
          appending = ((region_offset).equal?(self.attr_offset + self.attr_length)) && (region_length).equal?(0)
          return appending || super(region_offset, region_length)
        end
        
        private
        alias_method :initialize__visible_region, :initialize
      end }
    }
    
    typesig { [IDocument] }
    # Creates a new child document.
    # 
    # @param masterDocument @inheritDoc
    def initialize(master_document)
      super(master_document)
    end
    
    typesig { [] }
    # Returns the parent document of this child document.
    # 
    # @return the parent document of this child document
    # @see ProjectionDocument#getMasterDocument()
    def get_parent_document
      return get_master_document
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the parent document range covered by this child document to the
    # given range.
    # 
    # @param offset the offset of the range
    # @param length the length of the range
    # @throws BadLocationException if the given range is not valid
    def set_parent_document_range(offset, length)
      replace_master_document_ranges(offset, length)
    end
    
    typesig { [] }
    # Returns the parent document range of this child document.
    # 
    # @return the parent document range of this child document
    def get_parent_document_range
      coverage = get_document_information_mapping.get_coverage
      return VisibleRegion.new(coverage.get_offset, coverage.get_length)
    end
    
    private
    alias_method :initialize__child_document, :initialize
  end
  
end
