require "rjava"

# Copyright (c) 2006, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
# - fix for bug 187817
module Org::Eclipse::Jface::Viewers
  module ColumnViewerEditorActivationStrategyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
    }
  end
  
  # This class is responsible to determine if a cell selection event is triggers
  # an editor activation. Implementors can extend and overwrite to implement
  # custom editing behavior
  # 
  # @since 3.3
  class ColumnViewerEditorActivationStrategy 
    include_class_members ColumnViewerEditorActivationStrategyImports
    
    attr_accessor :viewer
    alias_method :attr_viewer, :viewer
    undef_method :viewer
    alias_method :attr_viewer=, :viewer=
    undef_method :viewer=
    
    attr_accessor :keyboard_activation_listener
    alias_method :attr_keyboard_activation_listener, :keyboard_activation_listener
    undef_method :keyboard_activation_listener
    alias_method :attr_keyboard_activation_listener=, :keyboard_activation_listener=
    undef_method :keyboard_activation_listener=
    
    typesig { [ColumnViewer] }
    # @param viewer
    # the viewer the editor support is attached to
    def initialize(viewer)
      @viewer = nil
      @keyboard_activation_listener = nil
      @viewer = viewer
    end
    
    typesig { [ColumnViewerEditorActivationEvent] }
    # @param event
    # the event triggering the action
    # @return <code>true</code> if this event should open the editor
    def is_editor_activation_event(event)
      single_select = ((@viewer.get_selection).size).equal?(1)
      is_left_mouse_select = (event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::MOUSE_CLICK_SELECTION) && ((event.attr_source_event).attr_button).equal?(1)
      return single_select && (is_left_mouse_select || (event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::PROGRAMMATIC) || (event.attr_event_type).equal?(ColumnViewerEditorActivationEvent::TRAVERSAL))
    end
    
    typesig { [] }
    # @return the cell holding the current focus
    def get_focus_cell
      return @viewer.get_column_viewer_editor.get_focus_cell
    end
    
    typesig { [] }
    # @return the viewer
    def get_viewer
      return @viewer
    end
    
    typesig { [::Java::Boolean] }
    # Enable activation of cell editors by keyboard
    # 
    # @param enable
    # <code>true</code> to enable
    def set_enable_editor_activation_with_keyboard(enable)
      if (enable)
        if ((@keyboard_activation_listener).nil?)
          @keyboard_activation_listener = Class.new(KeyListener.class == Class ? KeyListener : Object) do
            extend LocalClass
            include_class_members ColumnViewerEditorActivationStrategy
            include KeyListener if KeyListener.class == Module
            
            typesig { [KeyEvent] }
            define_method :key_pressed do |e|
              cell = get_focus_cell
              if (!(cell).nil?)
                self.attr_viewer.trigger_editor_activation_event(self.class::ColumnViewerEditorActivationEvent.new(cell, e))
              end
            end
            
            typesig { [KeyEvent] }
            define_method :key_released do |e|
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
          @viewer.get_control.add_key_listener(@keyboard_activation_listener)
        end
      else
        if (!(@keyboard_activation_listener).nil?)
          @viewer.get_control.remove_key_listener(@keyboard_activation_listener)
          @keyboard_activation_listener = nil
        end
      end
    end
    
    private
    alias_method :initialize__column_viewer_editor_activation_strategy, :initialize
  end
  
end
