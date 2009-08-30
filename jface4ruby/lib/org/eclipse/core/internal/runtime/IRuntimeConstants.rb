require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module IRuntimeConstantsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
    }
  end
  
  module IRuntimeConstants
    include_class_members IRuntimeConstantsImports
    
    class_module.module_eval {
      # The unique identifier constant (value "<code>org.eclipse.core.runtime</code>")
      # of the Core Runtime (pseudo-) plug-in.
      const_set_lazy(:PI_RUNTIME) { "org.eclipse.core.runtime" }
      const_attr_reader  :PI_RUNTIME
      
      # $NON-NLS-1$
      # 
      # Name of this bundle.
      const_set_lazy(:PI_COMMON) { "org.eclipse.equinox.common" }
      const_attr_reader  :PI_COMMON
      
      # $NON-NLS-1$
      # 
      # Status code constant (value 2) indicating an error occurred while running a plug-in.
      const_set_lazy(:PLUGIN_ERROR) { 2 }
      const_attr_reader  :PLUGIN_ERROR
      
      # Status code constant (value 5) indicating the platform could not write
      # some of its metadata.
      const_set_lazy(:FAILED_WRITE_METADATA) { 5 }
      const_attr_reader  :FAILED_WRITE_METADATA
    }
  end
  
end
