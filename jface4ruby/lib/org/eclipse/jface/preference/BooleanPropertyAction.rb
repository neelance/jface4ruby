require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module BooleanPropertyActionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Jface::Action, :Action
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
    }
  end
  
  # The BooleanPropertyAction is an action that set the values of a
  # boolean property in the preference store.
  class BooleanPropertyAction < BooleanPropertyActionImports.const_get :Action
    include_class_members BooleanPropertyActionImports
    
    attr_accessor :preference_store
    alias_method :attr_preference_store, :preference_store
    undef_method :preference_store
    alias_method :attr_preference_store=, :preference_store=
    undef_method :preference_store=
    
    attr_accessor :property
    alias_method :attr_property, :property
    undef_method :property
    alias_method :attr_property=, :property=
    undef_method :property=
    
    typesig { [String, IPreferenceStore, String] }
    # Create a new instance of the receiver.
    # @param title The displayable name of the action.
    # @param preferenceStore The preference store to propogate changes to
    # @param property The property that is being updated
    # @throws IllegalArgumentException Thrown if preferenceStore or
    # property are <code>null</code>.
    def initialize(title, preference_store, property)
      @preference_store = nil
      @property = nil
      super(title, AS_CHECK_BOX)
      if ((preference_store).nil? || (property).nil?)
        raise IllegalArgumentException.new
      end
      @preference_store = preference_store
      @property = property
      final_proprety = property
      preference_store.add_property_change_listener(Class.new(IPropertyChangeListener.class == Class ? IPropertyChangeListener : Object) do
        extend LocalClass
        include_class_members BooleanPropertyAction
        include IPropertyChangeListener if IPropertyChangeListener.class == Module
        
        typesig { [PropertyChangeEvent] }
        define_method :property_change do |event|
          if ((final_proprety == event.get_property))
            set_checked((Boolean::TRUE == event.get_new_value))
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      set_checked(preference_store.get_boolean(property))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IAction#run()
    def run
      @preference_store.set_value(@property, is_checked)
    end
    
    private
    alias_method :initialize__boolean_property_action, :initialize
  end
  
end
