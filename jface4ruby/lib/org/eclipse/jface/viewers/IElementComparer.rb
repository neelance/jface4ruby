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
  module IElementComparerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # This interface is used to compare elements in a viewer for equality,
  # and to provide the hash code for an element.
  # This allows the client of the viewer to specify different equality criteria
  # and a different hash code implementation than the
  # <code>equals</code> and <code>hashCode</code> implementations of the
  # elements themselves.
  # 
  # @see StructuredViewer#setComparer
  module IElementComparer
    include_class_members IElementComparerImports
    
    typesig { [Object, Object] }
    # Compares two elements for equality
    # 
    # @param a the first element
    # @param b the second element
    # @return whether a is equal to b
    def ==(a, b)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Returns the hash code for the given element.
    # @param element the element the hash code is calculated for
    # 
    # @return the hash code for the given element
    def hash_code(element)
      raise NotImplementedError
    end
  end
  
end
