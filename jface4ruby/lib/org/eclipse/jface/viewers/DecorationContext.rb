require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module DecorationContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
    }
  end
  
  # A concrete implementation of the {@link IDecorationContext} interface,
  # suitable for instantiating.
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # @since 3.2
  class DecorationContext 
    include_class_members DecorationContextImports
    include IDecorationContext
    
    class_module.module_eval {
      # Constant that defines a default decoration context that has
      # no context ids associated with it.
      const_set_lazy(:DEFAULT_CONTEXT) { DecorationContext.new }
      const_attr_reader  :DEFAULT_CONTEXT
    }
    
    attr_accessor :properties
    alias_method :attr_properties, :properties
    undef_method :properties
    alias_method :attr_properties=, :properties=
    undef_method :properties=
    
    typesig { [] }
    # Create a decoration context.
    def initialize
      @properties = HashMap.new
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IDecorationContext#getProperty(java.lang.String)
    def get_property(property)
      return @properties.get(property)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IDecorationContext#getProperties()
    def get_properties
      return @properties.key_set.to_array(Array.typed(String).new(@properties.size) { nil })
    end
    
    typesig { [String, Object] }
    # Set the given property to the given value. Setting the value of
    # a property to <code>null</code> removes the property from
    # the context.
    # @param property the property
    # @param value the value of the property or <code>null</code>
    # if the property is to be removed.
    def put_property(property, value)
      if ((value).nil?)
        @properties.remove(property)
      else
        @properties.put(property, value)
      end
    end
    
    private
    alias_method :initialize__decoration_context, :initialize
  end
  
end
