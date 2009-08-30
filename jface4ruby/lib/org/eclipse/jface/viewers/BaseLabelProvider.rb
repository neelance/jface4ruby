require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module BaseLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Commands::Common, :EventManager
      include_const ::Org::Eclipse::Jface::Util, :SafeRunnable
    }
  end
  
  # BaseLabelProvider is a default concrete implementation of
  # {@link IBaseLabelProvider}
  # 
  # @since 3.3
  class BaseLabelProvider < BaseLabelProviderImports.const_get :EventManager
    include_class_members BaseLabelProviderImports
    overload_protected {
      include IBaseLabelProvider
    }
    
    typesig { [ILabelProviderListener] }
    # (non-Javadoc)
    # Method declared on IBaseLabelProvider.
    def add_listener(listener)
      add_listener_object(listener)
    end
    
    typesig { [] }
    # The <code>BaseLabelProvider</code> implementation of this
    # <code>IBaseLabelProvider</code> method clears its internal listener list.
    # Subclasses may extend but should call the super implementation.
    def dispose
      clear_listeners
    end
    
    typesig { [Object, String] }
    # The <code>BaseLabelProvider</code> implementation of this
    # <code>IBaseLabelProvider</code> method returns <code>true</code>. Subclasses may
    # override.
    def is_label_property(element, property)
      return true
    end
    
    typesig { [ILabelProviderListener] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IBaseLabelProvider#removeListener(org.eclipse.jface.viewers.ILabelProviderListener)
    def remove_listener(listener)
      remove_listener_object(listener)
    end
    
    typesig { [LabelProviderChangedEvent] }
    # Fires a label provider changed event to all registered listeners Only
    # listeners registered at the time this method is called are notified.
    # 
    # @param event
    # a label provider changed event
    # 
    # @see ILabelProviderListener#labelProviderChanged
    def fire_label_provider_changed(event)
      listeners = get_listeners
      i = 0
      while i < listeners.attr_length
        l = listeners[i]
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members BaseLabelProvider
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.label_provider_changed(event)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        (i += 1)
      end
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__base_label_provider, :initialize
  end
  
end
