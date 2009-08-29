require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Provisional::Action
  module ToolBarManager2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Provisional::Action
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Jface::Action, :ToolBarManager
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
    }
  end
  
  # Extends <code>ToolBarManager</code> to implement <code>IToolBarManager2</code>.
  # 
  # <p>
  # <strong>EXPERIMENTAL</strong>. This class or interface has been added as
  # part of a work in progress. There is a guarantee neither that this API will
  # work nor that it will remain the same. Please do not use this API without
  # consulting with the Platform/UI team.
  # </p>
  # 
  # @since 3.2
  class ToolBarManager2 < ToolBarManager2Imports.const_get :ToolBarManager
    include_class_members ToolBarManager2Imports
    overload_protected {
      include IToolBarManager2
    }
    
    # A collection of objects listening to changes to this manager. This
    # collection is <code>null</code> if there are no listeners.
    attr_accessor :listener_list
    alias_method :attr_listener_list, :listener_list
    undef_method :listener_list
    alias_method :attr_listener_list=, :listener_list=
    undef_method :listener_list=
    
    typesig { [] }
    # Creates a new tool bar manager with the default SWT button style. Use the
    # <code>createControl</code> method to create the tool bar control.
    def initialize
      @listener_list = nil
      super()
      @listener_list = nil
    end
    
    typesig { [::Java::Int] }
    # Creates a tool bar manager with the given SWT button style. Use the
    # <code>createControl</code> method to create the tool bar control.
    # 
    # @param style
    # the tool bar item style
    # @see org.eclipse.swt.widgets.ToolBar for valid style bits
    def initialize(style)
      @listener_list = nil
      super(style)
      @listener_list = nil
    end
    
    typesig { [ToolBar] }
    # Creates a tool bar manager for an existing tool bar control. This manager
    # becomes responsible for the control, and will dispose of it when the
    # manager is disposed.
    # 
    # @param toolbar
    # the tool bar control
    def initialize(toolbar)
      @listener_list = nil
      super(toolbar)
      @listener_list = nil
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IToolBarManager2#createControl2(org.eclipse.swt.widgets.Composite)
    def create_control2(parent)
      return create_control(parent)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IToolBarManager2#getControl2()
    def get_control2
      return get_control
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IToolBarManager2#getItemCount()
    def get_item_count
      tool_bar = get_control
      if ((tool_bar).nil? || tool_bar.is_disposed)
        return 0
      end
      return tool_bar.get_item_count
    end
    
    typesig { [IPropertyChangeListener] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IToolBarManager2#addPropertyChangeListener(org.eclipse.jface.util.IPropertyChangeListener)
    def add_property_change_listener(listener)
      if ((@listener_list).nil?)
        @listener_list = ListenerList.new(ListenerList::IDENTITY)
      end
      @listener_list.add(listener)
    end
    
    typesig { [IPropertyChangeListener] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.IToolBarManager2#removePropertyChangeListener(org.eclipse.jface.util.IPropertyChangeListener)
    def remove_property_change_listener(listener)
      if (!(@listener_list).nil?)
        @listener_list.remove(listener)
        if (@listener_list.is_empty)
          @listener_list = nil
        end
      end
    end
    
    typesig { [] }
    # @return the listeners attached to this event manager.
    # The listeners currently attached; may be empty, but never
    # null.
    def get_listeners
      list = @listener_list
      if ((list).nil?)
        return Array.typed(Object).new(0) { nil }
      end
      return list.get_listeners
    end
    
    typesig { [PropertyChangeEvent] }
    # Notifies any property change listeners that a property has changed. Only
    # listeners registered at the time this method is called are notified.
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
    # registered, but calls firePropertyChange(PropertyChangeEvent) if there are.
    def fire_property_change(property_name, old_value, new_value)
      if (!(@listener_list).nil?)
        fire_property_change(PropertyChangeEvent.new(self, property_name, old_value, new_value))
      end
    end
    
    typesig { [ToolBar, ::Java::Int, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.action.ToolBarManager#relayout(org.eclipse.swt.widgets.ToolBar, int, int)
    def relayout(layout_bar, old_count, new_count)
      super(layout_bar, old_count, new_count)
      fire_property_change(PROP_LAYOUT, old_count, new_count)
    end
    
    private
    alias_method :initialize__tool_bar_manager2, :initialize
  end
  
end
