require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Util
  module PropertyChangeEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Java::Util, :EventObject
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # An event object describing a change to a named property.
  # <p>
  # This concrete class was designed to be instantiated, but may
  # also be subclassed if required.
  # </p>
  # <p>
  # The JFace frameworks contain classes that report property
  # change events for internal state changes that may be of interest
  # to external parties. A special listener interface
  # (<code>IPropertyChangeListener</code>) is defined for this purpose,
  # and a typical class allow listeners to be registered via
  # an <code>addPropertyChangeListener</code> method.
  # </p>
  # 
  # @see IPropertyChangeListener
  class PropertyChangeEvent < PropertyChangeEventImports.const_get :EventObject
    include_class_members PropertyChangeEventImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3256726173533811256 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The name of the changed property.
    attr_accessor :property_name
    alias_method :attr_property_name, :property_name
    undef_method :property_name
    alias_method :attr_property_name=, :property_name=
    undef_method :property_name=
    
    # The old value of the changed property, or <code>null</code> if
    # not known or not relevant.
    attr_accessor :old_value
    alias_method :attr_old_value, :old_value
    undef_method :old_value
    alias_method :attr_old_value=, :old_value=
    undef_method :old_value=
    
    # The new value of the changed property, or <code>null</code> if
    # not known or not relevant.
    attr_accessor :new_value
    alias_method :attr_new_value, :new_value
    undef_method :new_value
    alias_method :attr_new_value=, :new_value=
    undef_method :new_value=
    
    typesig { [Object, String, Object, Object] }
    # Creates a new property change event.
    # 
    # @param source the object whose property has changed
    # @param property the property that has changed (must not be <code>null</code>)
    # @param oldValue the old value of the property, or <code>null</code> if none
    # @param newValue the new value of the property, or <code>null</code> if none
    def initialize(source, property, old_value, new_value)
      @property_name = nil
      @old_value = nil
      @new_value = nil
      super(source)
      Assert.is_not_null(property)
      @property_name = property
      @old_value = old_value
      @new_value = new_value
    end
    
    typesig { [] }
    # Returns the new value of the property.
    # 
    # @return the new value, or <code>null</code> if not known
    # or not relevant (for instance if the property was removed).
    def get_new_value
      return @new_value
    end
    
    typesig { [] }
    # Returns the old value of the property.
    # 
    # @return the old value, or <code>null</code> if not known
    # or not relevant (for instance if the property was just
    # added and there was no old value).
    def get_old_value
      return @old_value
    end
    
    typesig { [] }
    # Returns the name of the property that changed.
    # <p>
    # Warning: there is no guarantee that the property name returned
    # is a constant string.  Callers must compare property names using
    # equals, not ==.
    # </p>
    # 
    # @return the name of the property that changed
    def get_property
      return @property_name
    end
    
    private
    alias_method :initialize__property_change_event, :initialize
  end
  
end
