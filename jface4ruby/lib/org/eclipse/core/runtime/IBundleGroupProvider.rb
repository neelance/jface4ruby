require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module IBundleGroupProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # Bundle group providers define groups of plug-ins which have been installed in
  # the current system.  Typically, a configuration agent (i.e., plug-in installer) will
  # define a bundle group provider so that it can report to the system the list
  # of plug-ins it has installed.
  # @see IBundleGroup
  # @since 3.0
  module IBundleGroupProvider
    include_class_members IBundleGroupProviderImports
    
    typesig { [] }
    # Returns the human-readable name of this bundle group provider.
    # 
    # @return the name of this bundle group provider
    def get_name
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the bundle groups provided by this provider.
    # 
    # @return the bundle groups provided by this provider
    def get_bundle_groups
      raise NotImplementedError
    end
  end
  
end
