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
  module IDocumentInformationMappingExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension to {@link org.eclipse.jface.text.IDocumentInformationMapping}.
  # <p>
  # Extends the information available in the mapping by providing access
  # to the closest image region of an origin region.
  # </p>
  # 
  # @see org.eclipse.jface.text.IDocumentInformationMapping
  # @since 3.1
  module IDocumentInformationMappingExtension2
    include_class_members IDocumentInformationMappingExtension2Imports
    
    typesig { [IRegion] }
    # Returns the minimal region of the image document that completely
    # comprises the given region of the original document. The difference to
    # {@link IDocumentInformationMapping#toImageRegion(IRegion)} is that this
    # method will always return an image region for a valid origin region. If
    # <code>originRegion</code> has no corresponding image region, the
    # zero-length region at the offset between its surrounding fragments is
    # returned.
    # 
    # @param originRegion the region of the original document
    # @return the minimal region of the image document comprising the given
    # region of the original document
    # @throws BadLocationException if <code>originRegion</code> is not a
    # valid region of the original document
    def to_closest_image_region(origin_region)
      raise NotImplementedError
    end
  end
  
end
