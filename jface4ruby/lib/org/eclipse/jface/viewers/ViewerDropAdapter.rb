require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ViewerDropAdapterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt::Dnd, :DND
      include_const ::Org::Eclipse::Swt::Dnd, :DropTargetAdapter
      include_const ::Org::Eclipse::Swt::Dnd, :DropTargetEvent
      include_const ::Org::Eclipse::Swt::Dnd, :TransferData
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Swt::Widgets, :TreeItem
    }
  end
  
  # This adapter class provides generic drag-and-drop support for a viewer.
  # <p>
  # Subclasses must implement the following methods:
  # <ul>
  # <li><code>validateDrop</code> - identifies valid drop targets in viewer</li>
  # <li><code>performDrop</code> - carries out a drop into a viewer</li>
  # </ul>
  # The <code>setFeedbackEnabled</code> method can be called to turn on and off
  # visual insertion feedback (on by default).
  # </p>
  class ViewerDropAdapter < ViewerDropAdapterImports.const_get :DropTargetAdapter
    include_class_members ViewerDropAdapterImports
    
    class_module.module_eval {
      # Constant describing the position of the cursor relative
      # to the target object.  This means the mouse is positioned
      # slightly before the target.
      # @see #getCurrentLocation()
      const_set_lazy(:LOCATION_BEFORE) { 1 }
      const_attr_reader  :LOCATION_BEFORE
      
      # Constant describing the position of the cursor relative
      # to the target object.  This means the mouse is positioned
      # slightly after the target.
      # @see #getCurrentLocation()
      const_set_lazy(:LOCATION_AFTER) { 2 }
      const_attr_reader  :LOCATION_AFTER
      
      # Constant describing the position of the cursor relative
      # to the target object.  This means the mouse is positioned
      # directly on the target.
      # @see #getCurrentLocation()
      const_set_lazy(:LOCATION_ON) { 3 }
      const_attr_reader  :LOCATION_ON
      
      # Constant describing the position of the cursor relative
      # to the target object.  This means the mouse is not positioned
      # over or near any valid target.
      # @see #getCurrentLocation()
      const_set_lazy(:LOCATION_NONE) { 4 }
      const_attr_reader  :LOCATION_NONE
    }
    
    # The viewer to which this drop support has been added.
    attr_accessor :viewer
    alias_method :attr_viewer, :viewer
    undef_method :viewer
    alias_method :attr_viewer=, :viewer=
    undef_method :viewer=
    
    # The current operation.
    attr_accessor :current_operation
    alias_method :attr_current_operation, :current_operation
    undef_method :current_operation
    alias_method :attr_current_operation=, :current_operation=
    undef_method :current_operation=
    
    # The last valid operation.  We need to remember the last good operation
    # in the case where the current operation temporarily is not valid (drag over
    # someplace you can't drop).
    attr_accessor :last_valid_operation
    alias_method :attr_last_valid_operation, :last_valid_operation
    undef_method :last_valid_operation
    alias_method :attr_last_valid_operation=, :last_valid_operation=
    undef_method :last_valid_operation=
    
    # This is used because we allow the operation
    # to be temporarily overridden (for example a move to a copy) for a drop that
    # happens immediately after the operation is overridden.
    attr_accessor :override_operation
    alias_method :attr_override_operation, :override_operation
    undef_method :override_operation
    alias_method :attr_override_operation=, :override_operation=
    undef_method :override_operation=
    
    # The current DropTargetEvent, used only during validateDrop()
    attr_accessor :current_event
    alias_method :attr_current_event, :current_event
    undef_method :current_event
    alias_method :attr_current_event=, :current_event=
    undef_method :current_event=
    
    # The data item currently under the mouse.
    attr_accessor :current_target
    alias_method :attr_current_target, :current_target
    undef_method :current_target
    alias_method :attr_current_target=, :current_target=
    undef_method :current_target=
    
    # Information about the position of the mouse relative to the
    # target (before, on, or after the target.  Location is one of
    # the <code>LOCATION_* </code> constants defined in this type.
    attr_accessor :current_location
    alias_method :attr_current_location, :current_location
    undef_method :current_location
    alias_method :attr_current_location=, :current_location=
    undef_method :current_location=
    
    # A flag that allows adapter users to turn the insertion
    # feedback on or off. Default is <code>true</code>.
    attr_accessor :feedback_enabled
    alias_method :attr_feedback_enabled, :feedback_enabled
    undef_method :feedback_enabled
    alias_method :attr_feedback_enabled=, :feedback_enabled=
    undef_method :feedback_enabled=
    
    # A flag that allows adapter users to turn auto scrolling
    # on or off. Default is <code>true</code>.
    attr_accessor :scroll_enabled
    alias_method :attr_scroll_enabled, :scroll_enabled
    undef_method :scroll_enabled
    alias_method :attr_scroll_enabled=, :scroll_enabled=
    undef_method :scroll_enabled=
    
    # A flag that allows adapter users to turn auto
    # expanding on or off. Default is <code>true</code>.
    attr_accessor :expand_enabled
    alias_method :attr_expand_enabled, :expand_enabled
    undef_method :expand_enabled
    alias_method :attr_expand_enabled=, :expand_enabled=
    undef_method :expand_enabled=
    
    # A flag that allows adapter users to turn selection feedback
    # on or off. Default is <code>true</code>.
    attr_accessor :select_feedback_enabled
    alias_method :attr_select_feedback_enabled, :select_feedback_enabled
    undef_method :select_feedback_enabled
    alias_method :attr_select_feedback_enabled=, :select_feedback_enabled=
    undef_method :select_feedback_enabled=
    
    typesig { [Viewer] }
    # Creates a new drop adapter for the given viewer.
    # 
    # @param viewer the viewer
    def initialize(viewer)
      @viewer = nil
      @current_operation = 0
      @last_valid_operation = 0
      @override_operation = 0
      @current_event = nil
      @current_target = nil
      @current_location = 0
      @feedback_enabled = false
      @scroll_enabled = false
      @expand_enabled = false
      @select_feedback_enabled = false
      super()
      @current_operation = DND::DROP_NONE
      @override_operation = -1
      @feedback_enabled = true
      @scroll_enabled = true
      @expand_enabled = true
      @select_feedback_enabled = true
      @viewer = viewer
    end
    
    typesig { [] }
    # Clears internal state of this drop adapter. This method can be called
    # when no DnD operation is underway, to clear internal state from previous
    # drop operations.
    # 
    # @since 3.5
    def clear_state
      @current_target = nil
    end
    
    typesig { [DropTargetEvent] }
    # Returns the position of the given event's coordinates relative to its target.
    # The position is determined to be before, after, or on the item, based on
    # some threshold value.
    # 
    # @param event the event
    # @return one of the <code>LOCATION_* </code>constants defined in this class
    def determine_location(event)
      if (!(event.attr_item.is_a?(Item)))
        return LOCATION_NONE
      end
      item = event.attr_item
      coordinates = Point.new(event.attr_x, event.attr_y)
      coordinates = @viewer.get_control.to_control(coordinates)
      if (!(item).nil?)
        bounds = get_bounds(item)
        if ((bounds).nil?)
          return LOCATION_NONE
        end
        if ((coordinates.attr_y - bounds.attr_y) < 5)
          return LOCATION_BEFORE
        end
        if ((bounds.attr_y + bounds.attr_height - coordinates.attr_y) < 5)
          return LOCATION_AFTER
        end
      end
      return LOCATION_ON
    end
    
    typesig { [DropTargetEvent] }
    # Returns the target item of the given drop event.
    # 
    # @param event the event
    # @return The target of the drop, may be <code>null</code>.
    def determine_target(event)
      return (event.attr_item).nil? ? nil : event.attr_item.get_data
    end
    
    typesig { [DropTargetEvent] }
    # (non-Javadoc)
    # Method declared on DropTargetAdapter.
    # The mouse has moved over the drop target.  If the
    # target item has changed, notify the action and check
    # that it is still enabled.
    def do_drop_validation(event)
      # always remember what was previously requested, but not if it
      # was overridden
      if (!(event.attr_detail).equal?(DND::DROP_NONE) && (@override_operation).equal?(-1))
        @last_valid_operation = event.attr_detail
      end
      @current_operation = @last_valid_operation
      @current_event = event
      @override_operation = -1
      if (!validate_drop(@current_target, @current_operation, event.attr_current_data_type))
        @current_operation = DND::DROP_NONE
      end
      # give the right feedback for the override
      if (!(@override_operation).equal?(-1))
        event.attr_detail = @override_operation
      else
        event.attr_detail = @current_operation
      end
      @current_event = nil
    end
    
    typesig { [DropTargetEvent] }
    # (non-Javadoc)
    # Method declared on DropTargetAdapter.
    # The drag has entered this widget's region.  See
    # if the drop should be allowed.
    def drag_enter(event)
      @current_target = determine_target(event)
      do_drop_validation(event)
    end
    
    typesig { [DropTargetEvent] }
    # (non-Javadoc)
    # Method declared on DropTargetAdapter.
    # The drop operation has changed, see if the action
    # should still be enabled.
    def drag_operation_changed(event)
      @current_target = determine_target(event)
      do_drop_validation(event)
    end
    
    typesig { [DropTargetEvent] }
    # (non-Javadoc)
    # Method declared on DropTargetAdapter.
    # The mouse has moved over the drop target.  If the
    # target item has changed, notify the action and check
    # that it is still enabled.
    def drag_over(event)
      # use newly revealed item as target if scrolling occurs
      target = determine_target(event)
      # set the location feedback
      old_location = @current_location
      @current_location = determine_location(event)
      set_feedback(event, @current_location)
      # see if anything has really changed before doing validation.
      if (!(target).equal?(@current_target) || !(@current_location).equal?(old_location))
        @current_target = target
        do_drop_validation(event)
      end
    end
    
    typesig { [DropTargetEvent] }
    # (non-Javadoc)
    # Method declared on DropTargetAdapter.
    # The user has dropped something on the desktop viewer.
    def drop(event)
      @current_location = determine_location(event)
      @current_event = event
      if (!(@override_operation).equal?(-1))
        @current_operation = @override_operation
      end
      # perform the drop behavior
      if (!perform_drop(event.attr_data))
        event.attr_detail = DND::DROP_NONE
      end
      # reset for next time
      @current_operation = DND::DROP_NONE
      @current_event = nil
    end
    
    typesig { [DropTargetEvent] }
    # (non-Javadoc)
    # Method declared on DropTargetAdapter.
    # Last chance for the action to disable itself
    def drop_accept(event)
      @current_event = event
      if (!validate_drop(@current_target, event.attr_detail, event.attr_current_data_type))
        @current_operation = event.attr_detail = DND::DROP_NONE
      end
      @current_event = nil
    end
    
    typesig { [Item] }
    # Returns the bounds of the given SWT tree or table item.
    # 
    # @param item the SWT Item
    # @return the bounds, or <code>null</code> if it is not a known type of item
    def get_bounds(item)
      if (item.is_a?(TreeItem))
        return (item).get_bounds
      end
      if (item.is_a?(TableItem))
        return (item).get_bounds(0)
      end
      return nil
    end
    
    typesig { [] }
    # Returns a constant describing the position of the mouse relative to the
    # target (before, on, or after the target.
    # 
    # @return one of the <code>LOCATION_* </code> constants defined in this type
    def get_current_location
      return @current_location
    end
    
    typesig { [] }
    # Returns the current operation.
    # 
    # @return a <code>DROP_*</code> constant from class <code>DND</code>
    # 
    # @see DND#DROP_COPY
    # @see DND#DROP_MOVE
    # @see DND#DROP_LINK
    # @see DND#DROP_NONE
    def get_current_operation
      return @current_operation
    end
    
    typesig { [] }
    # Returns the target object currently under the mouse.
    # 
    # @return the current target object
    def get_current_target
      return @current_target
    end
    
    typesig { [] }
    # Returns the current {@link DropTargetEvent}.
    # 
    # This may be called only inside of the {@link #validateDrop(Object, int, TransferData)}
    # or {@link #performDrop(Object)} methods.
    # @return the DropTargetEvent
    # @since 3.5
    def get_current_event
      Assert.is_true(!(@current_event).nil?)
      return @current_event
    end
    
    typesig { [] }
    # Returns whether visible insertion feedback should be presented to the user.
    # <p>
    # Typical insertion feedback is the horizontal insertion bars that appear
    # between adjacent items while dragging.
    # </p>
    # 
    # @return <code>true</code> if visual feedback is desired, and <code>false</code> if not
    def get_feedback_enabled
      return @feedback_enabled
    end
    
    typesig { [] }
    # Returns the object currently selected by the viewer.
    # 
    # @return the selected object, or <code>null</code> if either no object or
    # multiple objects are selected
    def get_selected_object
      selection = @viewer.get_selection
      if (selection.is_a?(IStructuredSelection) && !selection.is_empty)
        structured = selection
        return structured.get_first_element
      end
      return nil
    end
    
    typesig { [] }
    # @return the viewer to which this drop support has been added.
    def get_viewer
      return @viewer
    end
    
    typesig { [JavaThrowable, DropTargetEvent] }
    # @deprecated this method should not be used. Exception handling has been
    # removed from DropTargetAdapter methods overridden by this class.
    # Handles any exception that occurs during callback, including
    # rethrowing behavior.
    # <p>
    # [Issue: Implementation prints stack trace and eats exception to avoid
    # crashing VA/J.
    # Consider conditionalizing the implementation to do one thing in VAJ
    # and something more reasonable in other operating environments.
    # ]
    # </p>
    # 
    # @param exception the exception
    # @param event the event
    def handle_exception(exception, event)
      # Currently we never rethrow because VA/Java crashes if an SWT
      # callback throws anything. Generally catching Throwable is bad, but in
      # this cases it's better than hanging the image.
      exception.print_stack_trace
      event.attr_detail = DND::DROP_NONE
    end
    
    typesig { [Object] }
    # Performs any work associated with the drop.
    # <p>
    # Subclasses must implement this method to provide drop behavior.
    # </p>
    # 
    # @param data the drop data
    # @return <code>true</code> if the drop was successful, and
    # <code>false</code> otherwise
    def perform_drop(data)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Overrides the current operation for a drop that happens immediately
    # after the current validateDrop.
    # 
    # This maybe called only from within a
    # {@link #validateDrop(Object, int, TransferData)} method
    # 
    # 
    # @param operation
    # the operation to be used for the drop.
    # 
    # @see DND#DROP_COPY
    # @see DND#DROP_MOVE
    # @see DND#DROP_LINK
    # @see DND#DROP_NONE
    # 
    # @since 3.5
    def override_operation(operation)
      @override_operation = operation
    end
    
    typesig { [DropTargetEvent, ::Java::Int] }
    # (non-Javadoc)
    # Method declared on DropTargetAdapter.
    # The mouse has moved over the drop target.  If the
    # target item has changed, notify the action and check
    # that it is still enabled.
    def set_feedback(event, location)
      if (@feedback_enabled)
        case (location)
        when LOCATION_BEFORE
          event.attr_feedback = DND::FEEDBACK_INSERT_BEFORE
        when LOCATION_AFTER
          event.attr_feedback = DND::FEEDBACK_INSERT_AFTER
        when LOCATION_ON
          event.attr_feedback = DND::FEEDBACK_SELECT
        else
          event.attr_feedback = DND::FEEDBACK_SELECT
        end
      end
      # Explicitly inhibit SELECT feedback if desired
      if (!@select_feedback_enabled)
        event.attr_feedback &= ~DND::FEEDBACK_SELECT
      end
      if (@expand_enabled)
        event.attr_feedback |= DND::FEEDBACK_EXPAND
      end
      if (@scroll_enabled)
        event.attr_feedback |= DND::FEEDBACK_SCROLL
      end
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether visible insertion feedback should be presented to the user.
    # <p>
    # Typical insertion feedback is the horizontal insertion bars that appear
    # between adjacent items while dragging.
    # </p>
    # 
    # @param value
    # <code>true</code> if visual feedback is desired, and
    # <code>false</code> if not
    def set_feedback_enabled(value)
      @feedback_enabled = value
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether selection feedback should be provided during dragging.
    # 
    # @param value <code>true</code> if selection feedback is desired, and
    # <code>false</code> if not
    # 
    # @since 3.2
    def set_selection_feedback_enabled(value)
      @select_feedback_enabled = value
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether auto scrolling and expanding should be provided during dragging.
    # 
    # @param value <code>true</code> if scrolling and expanding is desired, and
    # <code>false</code> if not
    # @since 2.0
    def set_scroll_expand_enabled(value)
      @expand_enabled = value
      @scroll_enabled = value
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether auto expanding should be provided during dragging.
    # 
    # @param value <code>true</code> if expanding is desired, and
    # <code>false</code> if not
    # @since 3.4
    def set_expand_enabled(value)
      @expand_enabled = value
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether auto scrolling should be provided during dragging.
    # 
    # @param value <code>true</code> if scrolling is desired, and
    # <code>false</code> if not
    # @since 3.4
    def set_scroll_enabled(value)
      @scroll_enabled = value
    end
    
    typesig { [Object, ::Java::Int, TransferData] }
    # Validates dropping on the given object. This method is called whenever some
    # aspect of the drop operation changes.
    # <p>
    # Subclasses must implement this method to define which drops make sense.
    # </p>
    # 
    # @param target the object that the mouse is currently hovering over, or
    # <code>null</code> if the mouse is hovering over empty space
    # @param operation the current drag operation (copy, move, etc.)
    # @param transferType the current transfer type
    # @return <code>true</code> if the drop is valid, and <code>false</code>
    # otherwise
    def validate_drop(target, operation, transfer_type)
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__viewer_drop_adapter, :initialize
  end
  
end
