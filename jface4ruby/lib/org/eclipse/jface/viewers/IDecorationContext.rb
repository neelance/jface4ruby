require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module IDecorationContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # A decoration context provides additional information to
  # a label decorator.
  # <p>
  # This interface is not intended to be implemented by clients
  # 
  # @see LabelDecorator
  # 
  # @since 3.2
  module IDecorationContext
    include_class_members IDecorationContextImports
    
    typesig { [String] }
    # Get the value of the given property or <code>null</code>
    # if the property does not exist in this context.
    # @param property the property
    # @return the value of the given property or <code>null</code>
    def get_property(property)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Return the properties that exist in this context
    # (i.e. the set of properties that have values associated
    # with them.
    # @return the properties that exist in this context
    def get_properties
      raise NotImplementedError
    end
  end
  
end
