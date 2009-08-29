require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ILabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Graphics, :Image
    }
  end
  
  # Extends <code>IBaseLabelProvider</code> with the methods
  # to provide the text and/or image for the label of a given element.
  # Used by most structured viewers, except table viewers.
  module ILabelProvider
    include_class_members ILabelProviderImports
    include IBaseLabelProvider
    
    typesig { [Object] }
    # Returns the image for the label of the given element.  The image
    # is owned by the label provider and must not be disposed directly.
    # Instead, dispose the label provider when no longer needed.
    # 
    # @param element the element for which to provide the label image
    # @return the image used to label the element, or <code>null</code>
    # if there is no image for the given object
    def get_image(element)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Returns the text for the label of the given element.
    # 
    # @param element the element for which to provide the label text
    # @return the text string used to label the element, or <code>null</code>
    # if there is no text label for the given object
    def get_text(element)
      raise NotImplementedError
    end
  end
  
end
