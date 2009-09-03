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
  module IMinimalMappingImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Projection
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IRegion
    }
  end
  
  # Internal interface for defining the exact subset of
  # {@link org.eclipse.jface.text.projection.ProjectionMapping} that the
  # {@link org.eclipse.jface.text.projection.ProjectionTextStore} is allowed to
  # access.
  # 
  # @since 3.0
  module IMinimalMapping
    include_class_members IMinimalMappingImports
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentInformationMapping#getCoverage()
    def get_coverage
      raise NotImplementedError
    end
    
    typesig { [IRegion] }
    # @see org.eclipse.jface.text.IDocumentInformationMapping#toOriginRegion(IRegion)
    def to_origin_region(region)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocumentInformationMapping#toOriginOffset(int)
    def to_origin_offset(offset)
      raise NotImplementedError
    end
    
    typesig { [IRegion] }
    # @see org.eclipse.jface.text.IDocumentInformationMappingExtension#toExactOriginRegions(IRegion)
    def to_exact_origin_regions(region)
      raise NotImplementedError
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentInformationMappingExtension#getImageLength()
    def get_image_length
      raise NotImplementedError
    end
  end
  
end
