require "rjava"

# Copyright (c) 2004, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module IFilterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # Interface for filters. Can accept or reject items.
  # 
  # @since 3.1
  module IFilter
    include_class_members IFilterImports
    
    typesig { [Object] }
    # Determines if the given object passes this filter.
    # 
    # @param toTest object to compare against the filter
    # 
    # @return <code>true</code> if the object is accepted by the filter.
    def select(to_test)
      raise NotImplementedError
    end
  end
  
end
