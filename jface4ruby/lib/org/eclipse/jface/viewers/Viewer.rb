require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Util, :SafeRunnable
      include_const ::Org::Eclipse::Swt::Events, :HelpEvent
      include_const ::Org::Eclipse::Swt::Events, :HelpListener
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Item
    }
  end
  
  # A viewer is a model-based adapter on a widget.
  # <p>
  # A viewer can be created as an adapter on a pre-existing control (e.g.,
  # creating a <code>ListViewer</code> on an existing <code>List</code> control).
  # All viewers also provide a convenience constructor for creating the control.
  # </p>
  # <p>
  # Implementing a concrete viewer typically involves the following steps:
  # <ul>
  # <li>
  # create SWT controls for viewer (in constructor) (optional)
  # </li>
  # <li>
  # initialize SWT controls from input (inputChanged)
  # </li>
  # <li>
  # define viewer-specific update methods
  # </li>
  # <li>
  # support selections (<code>setSelection</code>, <code>getSelection</code>)
  # </li>
  # </ul>
  # </p>
  class Viewer 
    include_class_members ViewerImports
    include IInputSelectionProvider
    
    # List of selection change listeners (element type: <code>ISelectionChangedListener</code>).
    # 
    # @see #fireSelectionChanged
    attr_accessor :selection_changed_listeners
    alias_method :attr_selection_changed_listeners, :selection_changed_listeners
    undef_method :selection_changed_listeners
    alias_method :attr_selection_changed_listeners=, :selection_changed_listeners=
    undef_method :selection_changed_listeners=
    
    # List of help request listeners (element type: <code>org.eclipse.swt.events.HelpListener</code>).
    # Help request listeners.
    # 
    # @see #handleHelpRequest
    attr_accessor :help_listeners
    alias_method :attr_help_listeners, :help_listeners
    undef_method :help_listeners
    alias_method :attr_help_listeners=, :help_listeners=
    undef_method :help_listeners=
    
    # The names of this viewer's properties.
    # <code>null</code> if this viewer has no properties.
    # 
    # @see #setData
    attr_accessor :keys
    alias_method :attr_keys, :keys
    undef_method :keys
    alias_method :attr_keys=, :keys=
    undef_method :keys=
    
    # The values of this viewer's properties.
    # <code>null</code> if this viewer has no properties.
    # This array parallels the value of the <code>keys</code> field.
    # 
    # @see #setData
    attr_accessor :values
    alias_method :attr_values, :values
    undef_method :values
    alias_method :attr_values=, :values=
    undef_method :values=
    
    # Remembers whether we've hooked the help listener on the control or not.
    attr_accessor :help_hooked
    alias_method :attr_help_hooked, :help_hooked
    undef_method :help_hooked
    alias_method :attr_help_hooked=, :help_hooked=
    undef_method :help_hooked=
    
    # Help listener for the control, created lazily when client's first help listener is added.
    attr_accessor :help_listener
    alias_method :attr_help_listener, :help_listener
    undef_method :help_listener
    alias_method :attr_help_listener=, :help_listener=
    undef_method :help_listener=
    
    class_module.module_eval {
      # Unique key for associating element data with widgets.
      # @see org.eclipse.swt.widgets.Widget#setData(String, Object)
      const_set_lazy(:WIDGET_DATA_KEY) { "org.eclipse.jface.viewers.WIDGET_DATA" }
      const_attr_reader  :WIDGET_DATA_KEY
    }
    
    typesig { [] }
    # $NON-NLS-1$
    # 
    # Creates a new viewer.
    def initialize
      @selection_changed_listeners = ListenerList.new
      @help_listeners = ListenerList.new
      @keys = nil
      @values = nil
      @help_hooked = false
      @help_listener = nil
    end
    
    typesig { [HelpListener] }
    # Adds a listener for help requests in this viewer.
    # Has no effect if an identical listener is already registered.
    # 
    # @param listener a help listener
    def add_help_listener(listener)
      @help_listeners.add(listener)
      if (!@help_hooked)
        control = get_control
        if (!(control).nil? && !control.is_disposed)
          if ((@help_listener).nil?)
            @help_listener = Class.new(HelpListener.class == Class ? HelpListener : Object) do
              extend LocalClass
              include_class_members Viewer
              include HelpListener if HelpListener.class == Module
              
              typesig { [HelpEvent] }
              define_method :help_requested do |event|
                handle_help_request(event)
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
          end
          control.add_help_listener(@help_listener)
          @help_hooked = true
        end
      end
    end
    
    typesig { [ISelectionChangedListener] }
    # (non-Javadoc)
    # Method declared on ISelectionProvider.
    def add_selection_changed_listener(listener)
      @selection_changed_listeners.add(listener)
    end
    
    typesig { [HelpEvent] }
    # Notifies any help listeners that help has been requested.
    # Only listeners registered at the time this method is called are notified.
    # 
    # @param event a help event
    # 
    # @see HelpListener#helpRequested(org.eclipse.swt.events.HelpEvent)
    def fire_help_requested(event)
      listeners = @help_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        (listeners[i]).help_requested(event)
        (i += 1)
      end
    end
    
    typesig { [SelectionChangedEvent] }
    # Notifies any selection changed listeners that the viewer's selection has changed.
    # Only listeners registered at the time this method is called are notified.
    # 
    # @param event a selection changed event
    # 
    # @see ISelectionChangedListener#selectionChanged
    def fire_selection_changed(event)
      listeners = @selection_changed_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        l = listeners[i]
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members Viewer
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.selection_changed(event)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        (i += 1)
      end
    end
    
    typesig { [] }
    # Returns the primary control associated with this viewer.
    # 
    # @return the SWT control which displays this viewer's content
    def get_control
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns the value of the property with the given name,
    # or <code>null</code> if the property is not found.
    # <p>
    # The default implementation performs a (linear) search of
    # an internal table. Overriding this method is generally not
    # required if the number of different keys is small. If a more
    # efficient representation of a viewer's properties is required,
    # override both <code>getData</code> and <code>setData</code>.
    # </p>
    # 
    # @param key the property name
    # @return the property value, or <code>null</code> if
    # the property is not found
    def get_data(key)
      Assert.is_not_null(key)
      if ((@keys).nil?)
        return nil
      end
      i = 0
      while i < @keys.attr_length
        if ((@keys[i] == key))
          return @values[i]
        end
        i += 1
      end
      return nil
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Copy-down of method declared on <code>IInputProvider</code>.
    def get_input
      raise NotImplementedError
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Copy-down of method declared on <code>ISelectionProvider</code>.
    def get_selection
      raise NotImplementedError
    end
    
    typesig { [HelpEvent] }
    # Handles a help request from the underlying SWT control.
    # The default behavior is to fire a help request,
    # with the event's data modified to hold this viewer.
    # @param event the event
    def handle_help_request(event)
      old_data = event.attr_data
      event.attr_data = self
      fire_help_requested(event)
      event.attr_data = old_data
    end
    
    typesig { [Object, Object] }
    # Internal hook method called when the input to this viewer is
    # initially set or subsequently changed.
    # <p>
    # The default implementation does nothing. Subclassers may override
    # this method to do something when a viewer's input is set.
    # A typical use is populate the viewer.
    # </p>
    # 
    # @param input the new input of this viewer, or <code>null</code> if none
    # @param oldInput the old input element or <code>null</code> if there
    # was previously no input
    def input_changed(input, old_input)
    end
    
    typesig { [] }
    # Refreshes this viewer completely with information freshly obtained from this
    # viewer's model.
    def refresh
      raise NotImplementedError
    end
    
    typesig { [HelpListener] }
    # Removes the given help listener from this viewer.
    # Has no affect if an identical listener is not registered.
    # 
    # @param listener a help listener
    def remove_help_listener(listener)
      @help_listeners.remove(listener)
      if ((@help_listeners.size).equal?(0))
        control = get_control
        if (!(control).nil? && !control.is_disposed)
          control.remove_help_listener(@help_listener)
          @help_hooked = false
        end
      end
    end
    
    typesig { [ISelectionChangedListener] }
    # (non-Javadoc)
    # Method declared on ISelectionProvider.
    def remove_selection_changed_listener(listener)
      @selection_changed_listeners.remove(listener)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Scrolls the viewer's control down by one item from the given
    # display-relative coordinates.  Returns the newly revealed Item,
    # or <code>null</code> if no scrolling occurred or if the viewer
    # doesn't represent an item-based widget.
    # 
    # @param x horizontal coordinate
    # @param y vertical coordinate
    # @return the item scrolled down to
    def scroll_down(x, y)
      return nil
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Scrolls the viewer's control up by one item from the given
    # display-relative coordinates.  Returns the newly revealed Item,
    # or <code>null</code> if no scrolling occurred or if the viewer
    # doesn't represent an item-based widget.
    # 
    # @param x horizontal coordinate
    # @param y vertical coordinate
    # @return the item scrolled up to
    def scroll_up(x, y)
      return nil
    end
    
    typesig { [String, Object] }
    # Sets the value of the property with the given name to the
    # given value, or to <code>null</code> if the property is to be
    # removed. If this viewer has such a property, its value is
    # replaced; otherwise a new property is added.
    # <p>
    # The default implementation records properties in an internal
    # table which is searched linearly. Overriding this method is generally not
    # required if the number of different keys is small. If a more
    # efficient representation of a viewer's properties is required,
    # override both <code>getData</code> and <code>setData</code>.
    # </p>
    # 
    # @param key the property name
    # @param value the property value, or <code>null</code> if
    # the property is not found
    def set_data(key, value)
      Assert.is_not_null(key)
      # Remove the key/value pair
      if ((value).nil?)
        if ((@keys).nil?)
          return
        end
        index = 0
        while (index < @keys.attr_length && !(@keys[index] == key))
          index += 1
        end
        if ((index).equal?(@keys.attr_length))
          return
        end
        if ((@keys.attr_length).equal?(1))
          @keys = nil
          @values = nil
        else
          new_keys = Array.typed(String).new(@keys.attr_length - 1) { nil }
          new_values = Array.typed(Object).new(@values.attr_length - 1) { nil }
          System.arraycopy(@keys, 0, new_keys, 0, index)
          System.arraycopy(@keys, index + 1, new_keys, index, new_keys.attr_length - index)
          System.arraycopy(@values, 0, new_values, 0, index)
          System.arraycopy(@values, index + 1, new_values, index, new_values.attr_length - index)
          @keys = new_keys
          @values = new_values
        end
        return
      end
      # Add the key/value pair
      if ((@keys).nil?)
        @keys = Array.typed(String).new([key])
        @values = Array.typed(Object).new([value])
        return
      end
      i = 0
      while i < @keys.attr_length
        if ((@keys[i] == key))
          @values[i] = value
          return
        end
        i += 1
      end
      new_keys = Array.typed(String).new(@keys.attr_length + 1) { nil }
      new_values = Array.typed(Object).new(@values.attr_length + 1) { nil }
      System.arraycopy(@keys, 0, new_keys, 0, @keys.attr_length)
      System.arraycopy(@values, 0, new_values, 0, @values.attr_length)
      new_keys[@keys.attr_length] = key
      new_values[@values.attr_length] = value
      @keys = new_keys
      @values = new_values
    end
    
    typesig { [Object] }
    # Sets or clears the input for this viewer.
    # 
    # @param input the input of this viewer, or <code>null</code> if none
    def set_input(input)
      raise NotImplementedError
    end
    
    typesig { [ISelection] }
    # The viewer implementation of this <code>ISelectionProvider</code>
    # method make the new selection for this viewer without making it visible.
    # <p>
    # This method is equivalent to <code>setSelection(selection,false)</code>.
    # </p>
    # <p>
    # Note that some implementations may not be able to set the selection
    # without also revealing it, for example (as of 3.3) TreeViewer.
    # </p>
    def set_selection(selection)
      set_selection(selection, false)
    end
    
    typesig { [ISelection, ::Java::Boolean] }
    # Sets a new selection for this viewer and optionally makes it visible.
    # <p>
    # Subclasses must implement this method.
    # </p>
    # 
    # @param selection the new selection
    # @param reveal <code>true</code> if the selection is to be made
    # visible, and <code>false</code> otherwise
    def set_selection(selection, reveal)
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__viewer, :initialize
  end
  
end
