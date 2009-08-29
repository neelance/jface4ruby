require "rjava"

# Copyright (c) 2005, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module AbstractActionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Core::Commands::Common, :EventManager
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
    }
  end
  
  # <p>
  # Some common functionality to share between implementations of
  # <code>IAction</code>. This functionality deals with the property change
  # event mechanism.
  # </p>
  # <p>
  # Clients may neither instantiate nor extend this class.
  # </p>
  # 
  # @since 3.2
  class AbstractAction < AbstractActionImports.const_get :EventManager
    include_class_members AbstractActionImports
    overload_protected {
      include IAction
    }
    
    typesig { [IPropertyChangeListener] }
    def add_property_change_listener(listener)
      add_listener_object(listener)
    end
    
    typesig { [PropertyChangeEvent] }
    # Notifies any property change listeners that a property has changed. Only
    # listeners registered at the time this method is called are notified.
    # 
    # @param event
    # the property change event
    # 
    # @see org.eclipse.jface.util.IPropertyChangeListener#propertyChange(PropertyChangeEvent)
    def fire_property_change(event)
      list = get_listeners
      i = 0
      while i < list.attr_length
        (list[i]).property_change(event)
        (i += 1)
      end
    end
    
    typesig { [String, Object, Object] }
    # Notifies any property change listeners that a property has changed. Only
    # listeners registered at the time this method is called are notified. This
    # method avoids creating an event object if there are no listeners
    # registered, but calls
    # <code>firePropertyChange(PropertyChangeEvent)</code> if there are.
    # 
    # @param propertyName
    # the name of the property that has changed
    # @param oldValue
    # the old value of the property, or <code>null</code> if none
    # @param newValue
    # the new value of the property, or <code>null</code> if none
    # 
    # @see org.eclipse.jface.util.IPropertyChangeListener#propertyChange(PropertyChangeEvent)
    def fire_property_change(property_name, old_value, new_value)
      if (is_listener_attached)
        fire_property_change(PropertyChangeEvent.new(self, property_name, old_value, new_value))
      end
    end
    
    typesig { [IPropertyChangeListener] }
    def remove_property_change_listener(listener)
      remove_listener_object(listener)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__abstract_action, :initialize
  end
  
end
