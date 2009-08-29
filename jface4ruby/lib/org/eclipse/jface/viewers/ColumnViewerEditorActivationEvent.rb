require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ColumnViewerEditorActivationEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :EventObject
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :TraverseEvent
    }
  end
  
  # This event is passed on when a cell-editor is going to be activated
  # 
  # @since 3.3
  class ColumnViewerEditorActivationEvent < ColumnViewerEditorActivationEventImports.const_get :EventObject
    include_class_members ColumnViewerEditorActivationEventImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 1 }
      const_attr_reader  :SerialVersionUID
      
      # if a key is pressed on a selected cell
      const_set_lazy(:KEY_PRESSED) { 1 }
      const_attr_reader  :KEY_PRESSED
      
      # if a cell is selected using a single click of the mouse
      const_set_lazy(:MOUSE_CLICK_SELECTION) { 2 }
      const_attr_reader  :MOUSE_CLICK_SELECTION
      
      # if a cell is selected using double clicking of the mouse
      const_set_lazy(:MOUSE_DOUBLE_CLICK_SELECTION) { 3 }
      const_attr_reader  :MOUSE_DOUBLE_CLICK_SELECTION
      
      # if a cell is activated using code like e.g
      # {@link ColumnViewer#editElement(Object, int)}
      const_set_lazy(:PROGRAMMATIC) { 4 }
      const_attr_reader  :PROGRAMMATIC
      
      # is a cell is activated by traversing
      const_set_lazy(:TRAVERSAL) { 5 }
      const_attr_reader  :TRAVERSAL
    }
    
    # the original event triggered
    attr_accessor :source_event
    alias_method :attr_source_event, :source_event
    undef_method :source_event
    alias_method :attr_source_event=, :source_event=
    undef_method :source_event=
    
    # The time the event is triggered
    attr_accessor :time
    alias_method :attr_time, :time
    undef_method :time
    alias_method :attr_time=, :time=
    undef_method :time=
    
    # The event type triggered:
    # <ul>
    # <li>{@link #KEY_PRESSED} if a key is pressed on a selected cell</li>
    # <li>{@link #MOUSE_CLICK_SELECTION} if a cell is selected using a single
    # click of the mouse</li>
    # <li>{@link #MOUSE_DOUBLE_CLICK_SELECTION} if a cell is selected using
    # double clicking of the mouse</li>
    # </ul>
    attr_accessor :event_type
    alias_method :attr_event_type, :event_type
    undef_method :event_type
    alias_method :attr_event_type=, :event_type=
    undef_method :event_type=
    
    # <b>Only set for {@link #KEY_PRESSED}</b>
    attr_accessor :key_code
    alias_method :attr_key_code, :key_code
    undef_method :key_code
    alias_method :attr_key_code=, :key_code=
    undef_method :key_code=
    
    # <b>Only set for {@link #KEY_PRESSED}</b>
    attr_accessor :character
    alias_method :attr_character, :character
    undef_method :character
    alias_method :attr_character=, :character=
    undef_method :character=
    
    # The statemask
    attr_accessor :state_mask
    alias_method :attr_state_mask, :state_mask
    undef_method :state_mask
    alias_method :attr_state_mask=, :state_mask=
    undef_method :state_mask=
    
    # Cancel the event (=> editor is not activated)
    attr_accessor :cancel
    alias_method :attr_cancel, :cancel
    undef_method :cancel
    alias_method :attr_cancel=, :cancel=
    undef_method :cancel=
    
    typesig { [ViewerCell] }
    # This constructor can be used when no event exists. The type set is
    # {@link #PROGRAMMATIC}
    # 
    # @param cell
    # the cell
    def initialize(cell)
      @source_event = nil
      @time = 0
      @event_type = 0
      @key_code = 0
      @character = 0
      @state_mask = 0
      @cancel = false
      super(cell)
      @cancel = false
      @event_type = PROGRAMMATIC
    end
    
    typesig { [ViewerCell, MouseEvent] }
    # This constructor is used for all types of mouse events. Currently the
    # type is can be {@link #MOUSE_CLICK_SELECTION} and
    # {@link #MOUSE_DOUBLE_CLICK_SELECTION}
    # 
    # @param cell
    # the cell source of the event
    # @param event
    # the event
    def initialize(cell, event)
      @source_event = nil
      @time = 0
      @event_type = 0
      @key_code = 0
      @character = 0
      @state_mask = 0
      @cancel = false
      super(cell)
      @cancel = false
      if (event.attr_count >= 2)
        @event_type = MOUSE_DOUBLE_CLICK_SELECTION
      else
        @event_type = MOUSE_CLICK_SELECTION
      end
      @source_event = event
      @time = event.attr_time
    end
    
    typesig { [ViewerCell, KeyEvent] }
    # @param cell
    # the cell source of the event
    # @param event
    # the event
    def initialize(cell, event)
      @source_event = nil
      @time = 0
      @event_type = 0
      @key_code = 0
      @character = 0
      @state_mask = 0
      @cancel = false
      super(cell)
      @cancel = false
      @event_type = KEY_PRESSED
      @source_event = event
      @time = event.attr_time
      @key_code = event.attr_key_code
      @character = event.attr_character
      @state_mask = event.attr_state_mask
    end
    
    typesig { [ViewerCell, TraverseEvent] }
    # This constructor is used to mark the activation triggered by a traversal
    # 
    # @param cell
    # the cell source of the event
    # @param event
    # the event
    def initialize(cell, event)
      @source_event = nil
      @time = 0
      @event_type = 0
      @key_code = 0
      @character = 0
      @state_mask = 0
      @cancel = false
      super(cell)
      @cancel = false
      @event_type = TRAVERSAL
      @source_event = event
    end
    
    private
    alias_method :initialize__column_viewer_editor_activation_event, :initialize
  end
  
end
