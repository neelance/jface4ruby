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
  module ICellModifierImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # A cell modifier is used to access the data model from a cell
  # editor in an abstract way. It offers methods to:
  # <ul>
  # <li>to check if a a model element's property can be edited or not</li>
  # <li>retrieve a value a model element's property</li>
  # <li>to store a cell editor's value back into the model
  # element's property</li>
  # </ul>
  # <p>
  # This interface should be implemented by classes that wish to
  # act as cell modifiers.
  # </p>
  module ICellModifier
    include_class_members ICellModifierImports
    
    typesig { [Object, String] }
    # Checks whether the given property of the given element can be
    # modified.
    # 
    # @param element the element
    # @param property the property
    # @return <code>true</code> if the property can be modified,
    # and <code>false</code> if it is not modifiable
    def can_modify(element, property)
      raise NotImplementedError
    end
    
    typesig { [Object, String] }
    # Returns the value for the given property of the given element.
    # Returns <code>null</code> if the element does not have the given property.
    # 
    # @param element the element
    # @param property the property
    # @return the property value
    def get_value(element, property)
      raise NotImplementedError
    end
    
    typesig { [Object, String, Object] }
    # Modifies the value for the given property of the given element.
    # Has no effect if the element does not have the given property,
    # or if the property cannot be modified.
    # <p>
    # Note that it is possible for an SWT Item to be passed instead of
    # the model element. To handle this case in a safe way, use:
    # <pre>
    # if (element instanceof Item) {
    # element = ((Item) element).getData();
    # }
    # // modify the element's property here
    # </pre>
    # </p>
    # 
    # @param element the model element or SWT Item (see above)
    # @param property the property
    # @param value the new property value
    # 
    # @see org.eclipse.swt.widgets.Item
    def modify(element, property, value)
      raise NotImplementedError
    end
  end
  
end
