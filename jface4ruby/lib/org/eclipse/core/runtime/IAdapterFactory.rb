require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module IAdapterFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # An adapter factory defines behavioral extensions for
  # one or more classes that implements the <code>IAdaptable</code>
  # interface. Adapter factories are registered with an
  # adapter manager.
  # <p>
  # This interface can be used without OSGi running.
  # </p><p>
  # Clients may implement this interface.
  # </p>
  # @see IAdapterManager
  # @see IAdaptable
  module IAdapterFactory
    include_class_members IAdapterFactoryImports
    
    typesig { [Object, Class] }
    # Returns an object which is an instance of the given class
    # associated with the given object. Returns <code>null</code> if
    # no such object can be found.
    # 
    # @param adaptableObject the adaptable object being queried
    # (usually an instance of <code>IAdaptable</code>)
    # @param adapterType the type of adapter to look up
    # @return a object castable to the given adapter type,
    # or <code>null</code> if this adapter factory
    # does not have an adapter of the given type for the
    # given object
    def get_adapter(adaptable_object, adapter_type)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the collection of adapter types handled by this
    # factory.
    # <p>
    # This method is generally used by an adapter manager
    # to discover which adapter types are supported, in advance
    # of dispatching any actual <code>getAdapter</code> requests.
    # </p>
    # 
    # @return the collection of adapter types
    def get_adapter_list
      raise NotImplementedError
    end
  end
  
end
