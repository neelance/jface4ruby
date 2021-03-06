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
  module ITypedRegionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Describes a region of an indexed text store such as a document or a string.
  # The region consists of offset, length, and type. The region type is defined
  # as a string.
  # <p>
  # A typed region can, e.g., be used to described document partitions.</p>
  # <p>
  # Clients may implement this interface or use the standard implementation
  # {@link org.eclipse.jface.text.TypedRegion}.</p>
  module ITypedRegion
    include_class_members ITypedRegionImports
    include IRegion
    
    typesig { [] }
    # Returns the content type of the region.
    # 
    # @return the content type of the region
    def get_type
      raise NotImplementedError
    end
  end
  
end
