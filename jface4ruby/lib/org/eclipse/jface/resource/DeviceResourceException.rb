require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module DeviceResourceExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
    }
  end
  
  # Thrown when allocation of an SWT device resource fails
  # 
  # @since 3.1
  class DeviceResourceException < DeviceResourceExceptionImports.const_get :RuntimeException
    include_class_members DeviceResourceExceptionImports
    
    attr_accessor :cause
    alias_method :attr_cause, :cause
    undef_method :cause
    alias_method :attr_cause=, :cause=
    undef_method :cause=
    
    class_module.module_eval {
      # All serializable objects should have a stable serialVersionUID
      const_set_lazy(:SerialVersionUID) { 11454598756198 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [DeviceResourceDescriptor, JavaThrowable] }
    # Creates a DeviceResourceException indicating an error attempting to
    # create a resource and an embedded low-level exception describing the cause
    # 
    # @param missingResource
    # @param cause cause of the exception (or null if none)
    def initialize(missing_resource, cause)
      @cause = nil
      super("Unable to create resource " + RJava.cast_to_string(missing_resource.to_s)) # $NON-NLS-1$
      # don't pass the cause to super, to allow compilation against JCL Foundation (bug 80059)
      @cause = cause
    end
    
    typesig { [DeviceResourceDescriptor] }
    # Creates a DeviceResourceException indicating an error attempting to
    # create a resource
    # 
    # @param missingResource
    def initialize(missing_resource)
      initialize__device_resource_exception(missing_resource, nil)
    end
    
    typesig { [] }
    # Returns the cause of this throwable or <code>null</code> if the
    # cause is nonexistent or unknown.
    # 
    # @return the cause or <code>null</code>
    # @since 3.1
    def get_cause
      return @cause
    end
    
    private
    alias_method :initialize__device_resource_exception, :initialize
  end
  
end
