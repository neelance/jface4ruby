require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module PlatformObjectImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
      include_const ::Org::Eclipse::Core::Internal::Runtime, :AdapterManager
    }
  end
  
  # An abstract superclass implementing the <code>IAdaptable</code>
  # interface. <code>getAdapter</code> invocations are directed
  # to the platform's adapter manager.
  # <p>
  # Note: In situations where it would be awkward to subclass this
  # class, the same affect can be achieved simply by implementing
  # the {@link IAdaptable} interface and explicitly forwarding
  # the <code>getAdapter</code> request to an implementation
  # of the {@link IAdapterManager} service. The method would look like:
  # <pre>
  # public Object getAdapter(Class adapter) {
  # IAdapterManager manager = ...;//lookup the IAdapterManager service
  # return manager.getAdapter(this, adapter);
  # }
  # </pre>
  # </p><p>
  # This class can be used without OSGi running.
  # </p><p>
  # Clients may subclass.
  # </p>
  # 
  # @see IAdapterManager
  # @see IAdaptable
  class PlatformObject 
    include_class_members PlatformObjectImports
    include IAdaptable
    
    typesig { [] }
    # Constructs a new platform object.
    def initialize
    end
    
    typesig { [Class] }
    # Returns an object which is an instance of the given class
    # associated with this object. Returns <code>null</code> if
    # no such object can be found.
    # <p>
    # This implementation of the method declared by <code>IAdaptable</code>
    # passes the request along to the platform's adapter manager; roughly
    # <code>Platform.getAdapterManager().getAdapter(this, adapter)</code>.
    # Subclasses may override this method (however, if they do so, they
    # should invoke the method on their superclass to ensure that the
    # Platform's adapter manager is consulted).
    # </p>
    # 
    # @param adapter the class to adapt to
    # @return the adapted object or <code>null</code>
    # @see IAdaptable#getAdapter(Class)
    def get_adapter(adapter)
      return AdapterManager.get_default.get_adapter(self, adapter)
    end
    
    private
    alias_method :initialize__platform_object, :initialize
  end
  
end
