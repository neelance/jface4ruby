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
  module IDocumentInformationMappingImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # A <code>IDocumentInformationMapping</code>  represents a mapping between the coordinates of two
  # <code>IDocument</code> objects: the original and the image. The document information mapping
  # can translate document information such as line numbers or character ranges given for the original into
  # the corresponding information of the image and vice versa.
  # 
  # In order to provided backward compatibility for clients of <code>IDocumentInformationMapping</code>, extension
  # interfaces are used to provide a means of evolution. The following extension interfaces
  # exist:
  # <ul>
  # <li> {@link org.eclipse.jface.text.IDocumentInformationMappingExtension} since version 3.0 extending the
  # degree of detail of the mapping information.</li>
  # <li> {@link org.eclipse.jface.text.IDocumentInformationMappingExtension2} since version 3.1, adding lenient
  # image region computation.</li>
  # </ul>
  # 
  # @since 2.1
  module IDocumentInformationMapping
    include_class_members IDocumentInformationMappingImports
    
    typesig { [] }
    # Returns the minimal region of the original document that completely comprises all of the image document
    # or <code>null</code> if there is no such region.
    # 
    # @return the minimal region of the original document comprising the image document or <code>null</code>
    def get_coverage
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the offset in the original document that corresponds to the given offset in the image document
    # or <code>-1</code> if there is no such offset
    # 
    # @param imageOffset the offset in the image document
    # @return the corresponding offset in the original document or <code>-1</code>
    # @throws BadLocationException if <code>imageOffset</code> is not a valid offset in the image document
    def to_origin_offset(image_offset)
      raise NotImplementedError
    end
    
    typesig { [IRegion] }
    # Returns the minimal region of the original document that completely comprises the given region of the
    # image document or <code>null</code> if there is no such region.
    # 
    # @param imageRegion the region of the image document
    # @return the minimal region of the original document comprising the given region of the image document or <code>null</code>
    # @throws BadLocationException if <code>imageRegion</code> is not a valid region of the image document
    def to_origin_region(image_region)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the range of lines of the original document that corresponds to the given line of the image document or
    # <code>null</code> if there are no such lines.
    # 
    # @param imageLine the line of the image document
    # @return the corresponding lines of the original document or <code>null</code>
    # @throws BadLocationException if <code>imageLine</code> is not a valid line number in the image document
    def to_origin_lines(image_line)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the line of the original document that corresponds to the given line of the image document or
    # <code>-1</code> if there is no such line.
    # 
    # @param imageLine the line of the image document
    # @return the corresponding line of the original document or <code>-1</code>
    # @throws BadLocationException if <code>imageLine</code> is not a valid line number in the image document
    def to_origin_line(image_line)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the offset in the image document that corresponds to the given offset in the original document
    # or <code>-1</code> if there is no such offset
    # 
    # @param originOffset the offset in the original document
    # @return the corresponding offset in the image document or <code>-1</code>
    # @throws BadLocationException if <code>originOffset</code> is not a valid offset in the original document
    def to_image_offset(origin_offset)
      raise NotImplementedError
    end
    
    typesig { [IRegion] }
    # Returns the minimal region of the image document that completely comprises the given region of the
    # original document or <code>null</code> if there is no such region.
    # 
    # @param originRegion the region of the original document
    # @return the minimal region of the image document comprising the given region of the original document or <code>null</code>
    # @throws BadLocationException if <code>originRegion</code> is not a valid region of the original document
    def to_image_region(origin_region)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the line of the image document that corresponds to the given line of the original document or
    # <code>-1</code> if there is no such line.
    # 
    # @param originLine the line of the original document
    # @return the corresponding line of the image document or <code>-1</code>
    # @throws BadLocationException if <code>originLine</code> is not a valid line number in the original document
    def to_image_line(origin_line)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the line of the image document whose corresponding line in the original document
    # is closest to the given line in the original document.
    # 
    # @param originLine the line in the original document
    # @return the line in the image document that corresponds best to the given line in the original document
    # @throws BadLocationException if <code>originLine</code>is not a valid line in the original document
    def to_closest_image_line(origin_line)
      raise NotImplementedError
    end
  end
  
end
