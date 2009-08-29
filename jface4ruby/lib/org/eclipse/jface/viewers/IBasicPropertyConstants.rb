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
  module IBasicPropertyConstantsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # $NON-NLS-1$
  # 
  # Predefined property names used for elements displayed in viewers.
  # 
  # @see StructuredViewer#update(Object, String[])
  # @see StructuredViewer#update(Object[], String[])
  # @see IBaseLabelProvider#isLabelProperty
  # @see ViewerComparator#isSorterProperty
  # @see ViewerFilter#isFilterProperty
  module IBasicPropertyConstants
    include_class_members IBasicPropertyConstantsImports
    
    class_module.module_eval {
      # Property name constant (value <code>"org.eclipse.jface.text"</code>)
      # for an element's label text.
      # 
      # @see org.eclipse.jface.viewers.ILabelProvider#getText
      const_set_lazy(:P_TEXT) { "org.eclipse.jface.text" }
      const_attr_reader  :P_TEXT
      
      # $NON-NLS-1$
      # 
      # Property name constant (value <code>"org.eclipse.jface.image"</code>)
      # for an element's label image.
      # 
      # @see org.eclipse.jface.viewers.ILabelProvider#getImage
      const_set_lazy(:P_IMAGE) { "org.eclipse.jface.image" }
      const_attr_reader  :P_IMAGE
      
      # $NON-NLS-1$
      # 
      # Property name constant (value <code>"org.eclipse.jface.children"</code>)
      # for an element's children.
      const_set_lazy(:P_CHILDREN) { "org.eclipse.jface.children" }
      const_attr_reader  :P_CHILDREN
      
      # $NON-NLS-1$
      # 
      # Property name constant (value <code>"org.eclipse.jface.parent"</code>)
      # for an element's parent object.
      const_set_lazy(:P_PARENT) { "org.eclipse.jface.parent" }
      const_attr_reader  :P_PARENT
    }
  end
  
end
