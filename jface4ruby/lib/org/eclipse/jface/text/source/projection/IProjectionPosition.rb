require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source::Projection
  module IProjectionPositionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source::Projection
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
    }
  end
  
  # An <code>IProjectionPosition</code> is a position that is associated with a
  # <code>ProjectionAnnotation</code> and that is able to compute its collapsed
  # regions. That is, if a <code>Position</code> implements this interface,
  # <code>ProjectionViewer</code> will delegate to the
  # {@link #computeProjectionRegions(IDocument) computeProjectionRegions} method
  # when determining the document regions that should be collapsed for a certain
  # <code>ProjectionAnnotation</code>.
  # 
  # @since 3.1
  module IProjectionPosition
    include_class_members IProjectionPositionImports
    
    typesig { [IDocument] }
    # Returns an array of regions that should be collapsed when the annotation
    # belonging to this position is collapsed. May return null instead of
    # an empty array.
    # 
    # @param document the document that this position is attached to
    # @return the foldable regions for this position
    # @throws BadLocationException if accessing the document fails
    def compute_projection_regions(document)
      raise NotImplementedError
    end
    
    typesig { [IDocument] }
    # Returns the offset of the caption (the anchor region) of this projection
    # position. The returned offset is relative to the receivers offset into
    # the document.
    # 
    # @param document the document that this position is attached to
    # @return the caption offset relative to the position's offset
    # @throws BadLocationException if accessing the document fails
    def compute_caption_offset(document)
      raise NotImplementedError
    end
  end
  
end
