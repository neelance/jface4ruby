require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module ResourceRegistryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Core::Commands::Common, :EventManager
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
    }
  end
  
  # Abstract base class for various JFace registries.
  # 
  # @since 3.0
  class ResourceRegistry < ResourceRegistryImports.const_get :EventManager
    include_class_members ResourceRegistryImports
    
    typesig { [IPropertyChangeListener] }
    # Adds a property change listener to this registry.
    # 
    # @param listener a property change listener
    def add_listener(listener)
      add_listener_object(listener)
    end
    
    typesig { [] }
    # Disposes all currently allocated resources.
    def clear_caches
      raise NotImplementedError
    end
    
    typesig { [] }
    # @return the set of keys this manager knows about.  This collection
    # should be immutable.
    def get_key_set
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Return whether or not the receiver has a value for the supplied key.
    # 
    # @param key the key
    # @return <code>true</code> if there is a value for this key
    def has_value_for(key)
      raise NotImplementedError
    end
    
    typesig { [String, Object, Object] }
    # Fires a <code>PropertyChangeEvent</code>.
    # 
    # @param name the name of the symbolic value that is changing.
    # @param oldValue the old value.
    # @param newValue the new value.
    def fire_mapping_changed(name, old_value, new_value)
      my_listeners = get_listeners
      if (my_listeners.attr_length > 0)
        event = PropertyChangeEvent.new(self, name, old_value, new_value)
        i = 0
        while i < my_listeners.attr_length
          begin
            (my_listeners[i]).property_change(event)
          rescue JavaException => e
            # TODO: how to log?
          end
          (i += 1)
        end
      end
    end
    
    typesig { [IPropertyChangeListener] }
    # Removes the given listener from this registry. Has no affect if the
    # listener is not registered.
    # 
    # @param listener a property change listener
    def remove_listener(listener)
      remove_listener_object(listener)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__resource_registry, :initialize
  end
  
end
