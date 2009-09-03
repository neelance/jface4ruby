require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module IDocumentInformationMappingExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension to {@link org.eclipse.jface.text.IDocumentInformationMapping}.
  # <p>
  # Extends the information available in the mapping by providing explicit access
  # to the isomorphic portion of the basically homomorphic information mapping.
  # 
  # @see org.eclipse.jface.text.IDocumentInformationMapping
  # @since 3.0
  module IDocumentInformationMappingExtension
    include_class_members IDocumentInformationMappingExtensionImports
    
    typesig { [IRegion] }
    # Adheres to
    # <code>originRegion=toOriginRegion(toExactImageRegion(originRegion))</code>,
    # if <code>toExactImageRegion(originRegion) != null</code>. Returns
    # <code>null</code> if there is no image for the given origin region.
    # 
    # @param originRegion the origin region
    # @return the exact image region or <code>null</code>
    # @throws BadLocationException if origin region is not a valid region in
    # the origin document
    def to_exact_image_region(origin_region)
      raise NotImplementedError
    end
    
    typesig { [IRegion] }
    # Returns the segments of the image document that exactly correspond to the
    # given region of the original document. Returns <code>null</code> if
    # there are no such image regions.
    # 
    # @param originRegion the region in the origin document
    # @return the segments in the image document or <code>null</code>
    # @throws BadLocationException in case the given origin region is not valid
    # in the original document
    def to_exact_image_regions(origin_region)
      raise NotImplementedError
    end
    
    typesig { [IRegion] }
    # Returns the fragments of the original document that exactly correspond to
    # the given region of the image document.
    # 
    # @param imageRegion the region in the image document
    # @return the fragments in the origin document
    # @throws BadLocationException in case the given image region is not valid
    # in the image document
    def to_exact_origin_regions(image_region)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the length of the image document.
    # 
    # @return the length of the image document
    def get_image_length
      raise NotImplementedError
    end
    
    typesig { [IRegion] }
    # Returns the maximal sub-regions of the given origin region which are
    # completely covered. I.e. each offset in a sub-region has a corresponding
    # image offset. Returns <code>null</code> if there are no such
    # sub-regions.
    # 
    # @param originRegion the region in the origin document
    # @return the sub-regions with complete coverage or <code>null</code>
    # @throws BadLocationException in case the given origin region is not valid
    # in the original document
    def get_exact_coverage(origin_region)
      raise NotImplementedError
    end
  end
  
end
