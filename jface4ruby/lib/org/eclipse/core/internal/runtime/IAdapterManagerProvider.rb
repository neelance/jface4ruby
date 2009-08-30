require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Internal::Runtime
  module IAdapterManagerProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
    }
  end
  
  # The callback interface for the elements desiring to lazily supply
  # information to the adapter manager.
  # 
  # @since org.eclipse.core.runtime 3.2
  module IAdapterManagerProvider
    include_class_members IAdapterManagerProviderImports
    
    typesig { [AdapterManager] }
    # Add factories. The method called before the AdapterManager starts
    # using factories.
    # 
    # @param adapterManager the adapter manager that is about to be used
    # @return <code>true</code> if factories were added; <code>false</code>
    # if no factories were added in this method call.
    def add_factories(adapter_manager)
      raise NotImplementedError
    end
  end
  
end
