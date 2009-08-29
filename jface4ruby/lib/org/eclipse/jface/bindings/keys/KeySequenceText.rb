require "rjava"

# Copyright (c) 2004, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys
  module KeySequenceTextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :TreeSet
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :ModifyEvent
      include_const ::Org::Eclipse::Swt::Events, :ModifyListener
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Text
    }
  end
  
  # <p>
  # A wrapper around the SWT text widget that traps literal key presses and
  # converts them into key sequences for display. There are two types of key
  # strokes that are displayed: complete and incomplete. A complete key stroke is
  # one with a natural key, while an incomplete one has no natural key.
  # Incomplete key strokes are only displayed until they are made complete or
  # their component key presses are released.
  # </p>
  # 
  # @since 3.1
  class KeySequenceText 
    include_class_members KeySequenceTextImports
    
    class_module.module_eval {
      # A key listener that traps incoming events and displays them in the
      # wrapped text field. It has no effect on traversal operations.
      const_set_lazy(:KeyTrapListener) { Class.new do
        extend LocalClass
        include_class_members KeySequenceText
        include Listener
        
        # The index at which insertion should occur. This is used if there is a
        # replacement occurring in the middle of the stroke, and the first key
        # stroke was incomplete.
        attr_accessor :insertion_index
        alias_method :attr_insertion_index, :insertion_index
        undef_method :insertion_index
        alias_method :attr_insertion_index=, :insertion_index=
        undef_method :insertion_index=
        
        typesig { [] }
        # Resets the insertion index to point nowhere. In other words, it is
        # set to <code>-1</code>.
        def clear_insertion_index
          @insertion_index = -1
        end
        
        typesig { [Array.typed(class_self::KeyStroke)] }
        # Deletes the current selection. If there is no selection, then it
        # deletes the last key stroke.
        # 
        # @param keyStrokes
        # The key strokes from which to delete. This list must not
        # be <code>null</code>, and must represent a valid key
        # sequence.
        # @return An array of keystrokes minus the keystrokes that were
        # deleted.
        def delete_key_stroke(key_strokes)
          clear_insertion_index
          if (has_selection)
            # Delete the current selection -- disallowing incomplete
            # strokes in the middle of the sequence.
            deleted_key_strokes = Array.typed(Array.typed(self.class::KeyStroke)).new(1) { nil }
            delete_selection(key_strokes, false, deleted_key_strokes)
            return deleted_key_strokes[0]
          end
          # Remove the last key stroke.
          if (key_strokes.attr_length > 0)
            new_key_strokes_length = key_strokes.attr_length - 1
            new_key_strokes = Array.typed(self.class::KeyStroke).new(new_key_strokes_length) { nil }
            System.arraycopy(key_strokes, 0, new_key_strokes, 0, new_key_strokes_length)
            return new_key_strokes
          end
          return key_strokes
        end
        
        typesig { [class_self::Event] }
        # Handles the key pressed and released events on the wrapped text
        # widget. This makes sure to either add the pressed key to the
        # temporary key stroke, or complete the current temporary key stroke
        # and prompt for the next. In the case of a key release, this makes
        # sure that the temporary stroke is correctly displayed --
        # corresponding with modifier keys that may have been released.
        # 
        # @param event
        # The triggering event; must not be <code>null</code>.
        def handle_event(event)
          key_strokes = get_key_sequence.get_key_strokes
          # Dispatch the event to the correct handler.
          if ((event.attr_type).equal?(SWT::KeyDown))
            key_strokes = handle_key_down(event, key_strokes)
          else
            if ((event.attr_type).equal?(SWT::KeyUp))
              key_strokes = handle_key_up(event, key_strokes)
            end
          end
          # Update the underlying widget.
          set_key_sequence(KeySequence.get_instance(key_strokes))
          # Prevent the event from reaching the widget.
          event.attr_doit = false
        end
        
        typesig { [class_self::Event, Array.typed(class_self::KeyStroke)] }
        # Handles the case where the key event is an <code>SWT.KeyDown</code>
        # event. This either causes a deletion (if it is an unmodified
        # backspace key stroke), or an insertion (if it is any other key).
        # 
        # @param event
        # The trigger key down event; must not be <code>null</code>.
        # @param keyStrokes
        # The current list of key strokes. This valud must not be
        # <code>null</code>, and it must represent a valid key
        # sequence.
        def handle_key_down(event, key_strokes)
          # Is it an unmodified backspace character?
          if (((event.attr_character).equal?(SWT::BS) || (event.attr_character).equal?(SWT::DEL)) && ((event.attr_state_mask).equal?(0)))
            return delete_key_stroke(key_strokes)
          end
          return insert_key_stroke(event, key_strokes)
        end
        
        typesig { [class_self::Event, Array.typed(class_self::KeyStroke)] }
        # Handles the case where the key event is an <code>SWT.KeyUp</code>
        # event. This resets the insertion index. If there is an incomplete
        # stroke, then that incomplete stroke is modified to match the keys
        # that are still held. If no keys are held, then the incomplete stroke
        # is removed.
        # 
        # @param event
        # The triggering event; must not be <code>null</code>
        # @param keyStrokes
        # The key strokes that are part of the current key sequence;
        # these key strokes are guaranteed to represent a valid key
        # sequence. This value must not be <code>null</code>.
        def handle_key_up(event, key_strokes)
          if (has_incomplete_stroke)
            # Figure out the SWT integer representation of the remaining
            # values.
            mock_event = self.class::Event.new
            if (!((event.attr_key_code & SWT::MODIFIER_MASK)).equal?(0))
              # This key up is a modifier key being released.
              mock_event.attr_state_mask = event.attr_state_mask - event.attr_key_code
            else
              # This key up is the other end of a key down that was
              # trapped by the operating system or window manager.
              mock_event.attr_state_mask = event.attr_state_mask
            end
            # Get a reasonable facsimile of the stroke that is still
            # pressed.
            key = SWTKeySupport.convert_event_to_unmodified_accelerator(mock_event)
            remaining_stroke = SWTKeySupport.convert_accelerator_to_key_stroke(key)
            key_strokes_length = key_strokes.attr_length
            new_key_strokes = nil
            if ((key_strokes_length > 0) && (!(remaining_stroke.get_modifier_keys).equal?(0)))
              new_key_strokes = Array.typed(self.class::KeyStroke).new(key_strokes_length) { nil }
              System.arraycopy(key_strokes, 0, new_key_strokes, 0, key_strokes_length - 1)
              new_key_strokes[key_strokes_length - 1] = remaining_stroke
            else
              if (key_strokes_length > 0)
                new_key_strokes = Array.typed(self.class::KeyStroke).new(key_strokes_length - 1) { nil }
                System.arraycopy(key_strokes, 0, new_key_strokes, 0, key_strokes_length - 1)
              else
                if (!(remaining_stroke.get_modifier_keys).equal?(0))
                  new_key_strokes = Array.typed(self.class::KeyStroke).new(key_strokes_length + 1) { nil }
                  System.arraycopy(key_strokes, 0, new_key_strokes, 0, key_strokes_length)
                  new_key_strokes[key_strokes_length] = remaining_stroke
                else
                  new_key_strokes = key_strokes
                end
              end
            end
            return new_key_strokes
          end
          return key_strokes
        end
        
        typesig { [class_self::Event, Array.typed(class_self::KeyStroke)] }
        # <p>
        # Handles the case where a key down event is leading to a key stroke
        # being inserted. The current selection is deleted, and an invalid
        # remanents of the stroke are also removed. The insertion is carried
        # out at the cursor position.
        # </p>
        # <p>
        # If only a natural key is selected (as part of a larger key stroke),
        # then it is possible for the user to press a natural key to replace
        # the old natural key. In this situation, pressing any modifier keys
        # will replace the whole thing.
        # </p>
        # <p>
        # If the insertion point is not at the end of the sequence, then
        # incomplete strokes will not be immediately inserted. Only when the
        # sequence is completed is the stroke inserted. This is a requirement
        # as the widget must always represent a valid key sequence. The
        # insertion point is tracked using <code>insertionIndex</code>,
        # which is an index into the key stroke array.
        # </p>
        # 
        # @param event
        # The triggering key down event; must not be
        # <code>null</code>.
        # @param keyStrokes
        # The key strokes into which the current stroke should be
        # inserted. This value must not be <code>null</code>, and
        # must represent a valid key sequence.
        def insert_key_stroke(event, key_strokes)
          # Compute the key stroke to insert.
          key = SWTKeySupport.convert_event_to_unmodified_accelerator(event)
          stroke = SWTKeySupport.convert_accelerator_to_key_stroke(key)
          # Only insert the stroke if it is *not ScrollLock. Let's not get
          # silly
          if (((SWT::NUM_LOCK).equal?(stroke.get_natural_key)) || ((SWT::CAPS_LOCK).equal?(stroke.get_natural_key)) || ((SWT::SCROLL_LOCK).equal?(stroke.get_natural_key)))
            return key_strokes
          end
          if (!(@insertion_index).equal?(-1))
            # There is a previous replacement still going on.
            if (stroke.is_complete)
              key_strokes = insert_stroke_at(key_strokes, stroke, @insertion_index)
              clear_insertion_index
            end
          else
            if (has_selection)
              # There is a selection that needs to be replaced.
              deleted_key_strokes = Array.typed(Array.typed(self.class::KeyStroke)).new(1) { nil }
              @insertion_index = delete_selection(key_strokes, stroke.is_complete, deleted_key_strokes)
              key_strokes = deleted_key_strokes[0]
              if ((stroke.is_complete) || (@insertion_index >= key_strokes.attr_length))
                key_strokes = insert_stroke_at(key_strokes, stroke, @insertion_index)
                clear_insertion_index
              end
            else
              # No selection, so remove the incomplete stroke, if any
              if ((has_incomplete_stroke) && (key_strokes.attr_length > 0))
                new_key_strokes = Array.typed(self.class::KeyStroke).new(key_strokes.attr_length - 1) { nil }
                System.arraycopy(key_strokes, 0, new_key_strokes, 0, key_strokes.attr_length - 1)
                key_strokes = new_key_strokes
              end
              # And then add the new stroke.
              if (((key_strokes.attr_length).equal?(0)) || (@insertion_index >= key_strokes.attr_length) || (is_cursor_in_last_position))
                key_strokes = insert_stroke_at(key_strokes, stroke, key_strokes.attr_length)
                clear_insertion_index
              else
                # I'm just getting the insertionIndex here. No actual
                # deletion should occur.
                deleted_key_strokes = Array.typed(Array.typed(self.class::KeyStroke)).new(1) { nil }
                @insertion_index = delete_selection(key_strokes, stroke.is_complete, deleted_key_strokes)
                key_strokes = deleted_key_strokes[0]
                if (stroke.is_complete)
                  key_strokes = insert_stroke_at(key_strokes, stroke, @insertion_index)
                  clear_insertion_index
                end
              end
            end
          end
          return key_strokes
        end
        
        typesig { [] }
        def initialize
          @insertion_index = -1
        end
        
        private
        alias_method :initialize__key_trap_listener, :initialize
      end }
      
      # A traversal listener that blocks all traversal except for tabs and arrow
      # keys.
      const_set_lazy(:TraversalFilter) { Class.new do
        extend LocalClass
        include_class_members KeySequenceText
        include Listener
        
        typesig { [class_self::Event] }
        # Handles the traverse event on the text field wrapped by this class.
        # It swallows all traverse events example for tab and arrow key
        # navigation. The other forms of navigation can be reached by tabbing
        # off of the control.
        # 
        # @param event
        # The trigger event; must not be <code>null</code>.
        def handle_event(event)
          case (event.attr_detail)
          # $FALL-THROUGH$ -- either no modifiers, or just shift.
          when SWT::TRAVERSE_ESCAPE, SWT::TRAVERSE_MNEMONIC, SWT::TRAVERSE_NONE, SWT::TRAVERSE_PAGE_NEXT, SWT::TRAVERSE_PAGE_PREVIOUS, SWT::TRAVERSE_RETURN
            event.attr_type = SWT::None
            event.attr_doit = false
          when SWT::TRAVERSE_TAB_NEXT, SWT::TRAVERSE_TAB_PREVIOUS
            # Check if modifiers other than just 'Shift' were
            # down.
            if (!((event.attr_state_mask & (SWT::MODIFIER_MASK ^ SWT::SHIFT))).equal?(0))
              # Modifiers other than shift were down.
              event.attr_type = SWT::None
              event.attr_doit = false
            end
          when SWT::TRAVERSE_ARROW_NEXT, SWT::TRAVERSE_ARROW_PREVIOUS
            # Let the traversal happen, but clear the incomplete
            # stroke
            if (has_incomplete_stroke)
              old_key_strokes = get_key_sequence.get_key_strokes
              new_key_strokes_length = old_key_strokes.attr_length - 1
              if (new_key_strokes_length >= 1)
                new_key_strokes = Array.typed(self.class::KeyStroke).new(new_key_strokes_length) { nil }
                System.arraycopy(old_key_strokes, 0, new_key_strokes, 0, new_key_strokes_length)
                set_key_sequence(KeySequence.get_instance(new_key_strokes))
              else
                set_key_sequence(KeySequence.get_instance)
              end
            end
          else
            # Let the traversal happen, but clear the incomplete
            # stroke
            if (has_incomplete_stroke)
              old_key_strokes = get_key_sequence.get_key_strokes
              new_key_strokes_length = old_key_strokes.attr_length - 1
              if (new_key_strokes_length >= 1)
                new_key_strokes = Array.typed(self.class::KeyStroke).new(new_key_strokes_length) { nil }
                System.arraycopy(old_key_strokes, 0, new_key_strokes, 0, new_key_strokes_length)
                set_key_sequence(KeySequence.get_instance(new_key_strokes))
              else
                set_key_sequence(KeySequence.get_instance)
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__traversal_filter, :initialize
      end }
      
      # The manager resposible for installing and removing the traversal filter
      # when the key sequence entry widget gains and loses focus.
      const_set_lazy(:TraversalFilterManager) { Class.new do
        extend LocalClass
        include_class_members KeySequenceText
        include FocusListener
        
        # The managed filter. We only need one instance.
        attr_accessor :filter
        alias_method :attr_filter, :filter
        undef_method :filter
        alias_method :attr_filter=, :filter=
        undef_method :filter=
        
        attr_accessor :filtering
        alias_method :attr_filtering, :filtering
        undef_method :filtering
        alias_method :attr_filtering=, :filtering=
        undef_method :filtering=
        
        typesig { [class_self::FocusEvent] }
        # Attaches the global traversal filter.
        # 
        # @param event
        # Ignored.
        def focus_gained(event)
          Display.get_current.add_filter(SWT::Traverse, @filter)
          @filtering = true
        end
        
        typesig { [class_self::FocusEvent] }
        # Detaches the global traversal filter.
        # 
        # @param event
        # Ignored.
        def focus_lost(event)
          Display.get_current.remove_filter(SWT::Traverse, @filter)
          @filtering = false
        end
        
        typesig { [] }
        # Remove the traverse filter if we close without focusOut.
        def dispose
          if (@filtering)
            Display.get_current.remove_filter(SWT::Traverse, @filter)
          end
        end
        
        typesig { [] }
        def initialize
          @filter = self.class::TraversalFilter.new
          @filtering = false
        end
        
        private
        alias_method :initialize__traversal_filter_manager, :initialize
      end }
      
      # A modification listener that makes sure that external events to this
      # class (i.e., direct modification of the underlying text) do not break
      # this class' view of the world.
      const_set_lazy(:UpdateSequenceListener) { Class.new do
        extend LocalClass
        include_class_members KeySequenceText
        include ModifyListener
        
        typesig { [class_self::ModifyEvent] }
        # Handles the modify event on the underlying text widget.
        # 
        # @param event
        # The triggering event; ignored.
        def modify_text(event)
          begin
            # The original sequence.
            original_sequence = get_key_sequence
            # The new sequence drawn from the text.
            contents = get_text
            new_sequence = KeySequence.get_instance(contents)
            # Check to see if they're the same.
            if (!(original_sequence == new_sequence))
              set_key_sequence(new_sequence)
            end
          rescue self.class::ParseException => e
            # Abort any cut/paste-driven modifications
            set_key_sequence(get_key_sequence)
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__update_sequence_listener, :initialize
      end }
      
      when_class_loaded do
        trapped_keys = TreeSet.new
        trapped_keys.add(SWTKeySupport.convert_accelerator_to_key_stroke(SWT::TAB))
        trapped_keys.add(SWTKeySupport.convert_accelerator_to_key_stroke(SWT::TAB | SWT::SHIFT))
        trapped_keys.add(SWTKeySupport.convert_accelerator_to_key_stroke(SWT::BS))
        trapped_key_list = ArrayList.new(trapped_keys)
        const_set :TRAPPED_KEYS, Collections.unmodifiable_list(trapped_key_list)
      end
      
      # An empty string instance for use in clearing text values.
      const_set_lazy(:EMPTY_STRING) { "" }
      const_attr_reader  :EMPTY_STRING
      
      # $NON-NLS-1$
      # 
      # The special integer value for the maximum number of strokes indicating
      # that an infinite number should be allowed.
      const_set_lazy(:INFINITE) { -1 }
      const_attr_reader  :INFINITE
      
      # The name of the property representing the current key sequence in this
      # key sequence widget.
      # 
      # @since 3.2
      const_set_lazy(:P_KEY_SEQUENCE) { "org.eclipse.jface.bindings.keys.KeySequenceText.KeySequence" }
      const_attr_reader  :P_KEY_SEQUENCE
    }
    
    # The key filter attached to the underlying widget that traps key events.
    attr_accessor :key_filter
    alias_method :attr_key_filter, :key_filter
    undef_method :key_filter
    alias_method :attr_key_filter=, :key_filter=
    undef_method :key_filter=
    
    # The text of the key sequence -- containing only the complete key strokes.
    attr_accessor :key_sequence
    alias_method :attr_key_sequence, :key_sequence
    undef_method :key_sequence
    alias_method :attr_key_sequence=, :key_sequence=
    undef_method :key_sequence=
    
    # Those listening to changes to the key sequence in this widget. This value
    # may be <code>null</code> if there are no listeners.
    attr_accessor :listeners
    alias_method :attr_listeners, :listeners
    undef_method :listeners
    alias_method :attr_listeners=, :listeners=
    undef_method :listeners=
    
    # The maximum number of key strokes permitted in the sequence.
    attr_accessor :max_strokes
    alias_method :attr_max_strokes, :max_strokes
    undef_method :max_strokes
    alias_method :attr_max_strokes=, :max_strokes=
    undef_method :max_strokes=
    
    # The text widget that is wrapped for this class.
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    # The listener that makes sure that the text widget remains up-to-date with
    # regards to external modification of the text (e.g., cut & pasting).
    attr_accessor :update_sequence_listener
    alias_method :attr_update_sequence_listener, :update_sequence_listener
    undef_method :update_sequence_listener
    alias_method :attr_update_sequence_listener=, :update_sequence_listener=
    undef_method :update_sequence_listener=
    
    typesig { [Text] }
    # Constructs an instance of <code>KeySequenceTextField</code> with the
    # text field to use. If the platform is carbon (MacOS X), then the font is
    # set to be the same font used to display accelerators in the menus.
    # 
    # @param wrappedText
    # The text widget to wrap; must not be <code>null</code>.
    def initialize(wrapped_text)
      @key_filter = KeyTrapListener.new_local(self)
      @key_sequence = KeySequence.get_instance
      @listeners = nil
      @max_strokes = INFINITE
      @text = nil
      @update_sequence_listener = UpdateSequenceListener.new_local(self)
      @text = wrapped_text
      # Set the font if the platform is carbon.
      if (Util.is_mac)
        # Don't worry about this font name here; it is the official menu
        # font and point size on the Mac.
        font = Font.new(@text.get_display, "Lucida Grande", 13, SWT::NORMAL) # $NON-NLS-1$
        @text.set_font(font)
        @text.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          extend LocalClass
          include_class_members KeySequenceText
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |e|
            font.dispose
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      # Add the key listener.
      @text.add_listener(SWT::KeyUp, @key_filter)
      @text.add_listener(SWT::KeyDown, @key_filter)
      traversal_filter_manager = TraversalFilterManager.new_local(self)
      @text.add_focus_listener(traversal_filter_manager)
      @text.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members KeySequenceText
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          traversal_filter_manager.dispose
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      # Add an internal modify listener.
      @text.add_modify_listener(@update_sequence_listener)
    end
    
    typesig { [IPropertyChangeListener] }
    # Adds a property change listener to this key sequence widget. It will be
    # notified when the key sequence changes.
    # 
    # @param listener
    # The listener to be notified when changes occur; must not be
    # <code>null</code>.
    # @since 3.2
    def add_property_change_listener(listener)
      if ((listener).nil?)
        return
      end
      if ((@listeners).nil?)
        @listeners = ArrayList.new(1)
      end
      @listeners.add(listener)
    end
    
    typesig { [] }
    # Clears the text field and resets all the internal values.
    def clear
      old_key_sequence = @key_sequence
      @key_sequence = KeySequence.get_instance
      @text.set_text(EMPTY_STRING)
      fire_property_change_event(old_key_sequence)
    end
    
    typesig { [Array.typed(KeyStroke), ::Java::Boolean, Array.typed(Array.typed(KeyStroke))] }
    # Removes the key strokes from the list corresponding the selection. If
    # <code>allowIncomplete</code>, then invalid key sequences will be
    # allowed (i.e., those with incomplete strokes in the non-terminal
    # position). Otherwise, incomplete strokes will be removed. This modifies
    # <code>keyStrokes</code> in place, and has no effect on the text widget
    # this class wraps.
    # 
    # @param keyStrokes
    # The list of key strokes from which the selection should be
    # removed; must not be <code>null</code>.
    # @param allowIncomplete
    # Whether incomplete strokes should be allowed to exist in the
    # list after the deletion.
    # @param deletedKeyStrokes
    # The list of keystrokes that were deleted by this operation.
    # Declared as final since it will hold a reference to the new
    # keyStroke array that has deleted the selected keystrokes.
    # @return The index at which a subsequent insert should occur. This index
    # only has meaning to the <code>insertStrokeAt</code> method.
    def delete_selection(key_strokes, allow_incomplete, deleted_key_strokes)
      # Get the current selection.
      selection = @text.get_selection
      start = selection.attr_x
      end_ = selection.attr_y
      # Using the key sequence format method, discover the point at which
      # adding key strokes passes or equals the start of the selection. In
      # other words, find the first stroke that is part of the selection.
      # Keep track of the text range under which the stroke appears (i.e.,
      # startTextIndex->string.length() is the first selected stroke).
      string = String.new
      current_strokes = ArrayList.new
      start_text_index = 0 # keeps track of the start of the stroke
      key_strokes_length = key_strokes.attr_length
      i = 0
      i = 0
      while (i < key_strokes_length) && (string.length < start)
        start_text_index = string.length
        current_strokes.add(key_strokes[i])
        string = RJava.cast_to_string(KeySequence.get_instance(current_strokes).format)
        i += 1
      end
      # If string.length() == start, then the cursor is positioned between
      # strokes (i.e., selection is outside of a stroke).
      start_stroke_index = 0
      if ((string.length).equal?(start))
        start_stroke_index = current_strokes.size
      else
        start_stroke_index = current_strokes.size - 1
      end
      # Check to see if the cursor is only positioned, rather than actually
      # selecting something. We only need to compute the end if there is a
      # selection.
      end_stroke_index = 0
      if ((start).equal?(end_))
        # return the current keystrokes, nothing has to be deleted
        deleted_key_strokes[0] = key_strokes
        return start_stroke_index
      end
      while (i < key_strokes_length) && (string.length < end_)
        current_strokes.add(key_strokes[i])
        string = RJava.cast_to_string(KeySequence.get_instance(current_strokes).format)
        i += 1
      end
      end_stroke_index = current_strokes.size - 1
      if (end_stroke_index < 0)
        end_stroke_index = 0
      end
      # Remove the strokes that are touched by the selection. Keep track of
      # the first stroke removed.
      new_length = key_strokes_length - (end_stroke_index - start_stroke_index + 1)
      deleted_key_strokes[0] = Array.typed(KeyStroke).new(new_length) { nil }
      start_stroke = key_strokes[start_stroke_index]
      key_stroke_result = Array.typed(KeyStroke).new(new_length) { nil }
      System.arraycopy(key_strokes, 0, key_stroke_result, 0, start_stroke_index)
      System.arraycopy(key_strokes, end_stroke_index + 1, key_stroke_result, start_stroke_index, key_strokes_length - end_stroke_index - 1)
      System.arraycopy(key_stroke_result, 0, deleted_key_strokes[0], 0, new_length)
      # Allow the first stroke removed to be replaced by an incomplete
      # stroke.
      if (allow_incomplete)
        modifier_keys = start_stroke.get_modifier_keys
        incomplete_stroke = KeyStroke.get_instance(modifier_keys, KeyStroke::NO_KEY)
        incomplete_stroke_length = incomplete_stroke.format.length
        if ((start_text_index + incomplete_stroke_length) <= start)
          added = Array.typed(KeyStroke).new(new_length + 1) { nil }
          System.arraycopy(deleted_key_strokes[0], 0, added, 0, start_stroke_index)
          added[start_stroke_index] = incomplete_stroke
          System.arraycopy(deleted_key_strokes[0], start_stroke_index, added, start_stroke_index + 1, new_length - start_stroke_index)
          deleted_key_strokes[0] = added
        end
      end
      return start_stroke_index
    end
    
    typesig { [KeySequence] }
    # Fires a property change event to all of the listeners.
    # 
    # @param oldKeySequence
    # The old key sequence; must not be <code>null</code>.
    # @since 3.2
    def fire_property_change_event(old_key_sequence)
      if (!(@listeners).nil?)
        listener_itr = @listeners.iterator
        event = PropertyChangeEvent.new(self, P_KEY_SEQUENCE, old_key_sequence, get_key_sequence)
        while (listener_itr.has_next)
          listener = listener_itr.next_
          listener.property_change(event)
        end
      end
    end
    
    typesig { [] }
    # An accessor for the <code>KeySequence</code> that corresponds to the
    # current state of the text field. This includes incomplete strokes.
    # 
    # @return The key sequence representation; never <code>null</code>.
    def get_key_sequence
      return @key_sequence
    end
    
    typesig { [] }
    # An accessor for the underlying text widget's contents.
    # 
    # @return The text contents of this entry; never <code>null</code>.
    def get_text
      return @text.get_text
    end
    
    typesig { [] }
    # Tests whether the current key sequence has a stroke with no natural key.
    # 
    # @return <code>true</code> is there is an incomplete stroke;
    # <code>false</code> otherwise.
    def has_incomplete_stroke
      return !@key_sequence.is_complete
    end
    
    typesig { [] }
    # Tests whether the current text widget has some text selection.
    # 
    # @return <code>true</code> if the number of selected characters it
    # greater than zero; <code>false</code> otherwise.
    def has_selection
      return (@text.get_selection_count > 0)
    end
    
    typesig { [KeyStroke] }
    # Inserts the key stroke at the current insertion point. This does a
    # regular delete and insert, as if the key had been pressed.
    # 
    # @param stroke
    # The key stroke to insert; must not be <code>null</code>.
    def insert(stroke)
      if (!stroke.is_complete)
        return
      end
      # Copy the key strokes in the current key sequence.
      key_sequence = get_key_sequence
      old_key_strokes = key_sequence.get_key_strokes
      new_key_strokes = nil
      if ((has_incomplete_stroke) && (!key_sequence.is_empty))
        new_key_strokes_length = old_key_strokes.attr_length - 1
        new_key_strokes = Array.typed(KeyStroke).new(new_key_strokes_length) { nil }
        System.arraycopy(old_key_strokes, 0, new_key_strokes, 0, new_key_strokes_length)
      else
        new_key_strokes = old_key_strokes
      end
      deleted_key_strokes = Array.typed(Array.typed(KeyStroke)).new(1) { nil }
      index = delete_selection(new_key_strokes, false, deleted_key_strokes)
      if ((index).equal?(-1))
        index = 0
      end
      key_strokes = insert_stroke_at(new_key_strokes, stroke, index)
      @key_filter.clear_insertion_index
      set_key_sequence(KeySequence.get_instance(key_strokes))
    end
    
    typesig { [Array.typed(KeyStroke), KeyStroke, ::Java::Int] }
    # Inserts the stroke at the given index in the list of strokes. If the
    # stroke currently at that index is incomplete, then it tries to merge the
    # two strokes. If merging is a complete failure (unlikely), then it will
    # simply overwrite the incomplete stroke. If the stroke at the index is
    # complete, then it simply inserts the stroke independently.
    # 
    # @param keyStrokes
    # The list of key strokes in which the key stroke should be
    # appended; must not be <code>null</code>.
    # @param stroke
    # The stroke to insert; should not be <code>null</code>.
    # @param index
    # The index at which to insert; must be a valid index into the
    # list of key strokes.
    def insert_stroke_at(key_strokes, stroke, index)
      key_strokes_length = key_strokes.attr_length
      current_stroke = (index >= key_strokes_length) ? nil : key_strokes[index]
      if ((!(current_stroke).nil?) && (!current_stroke.is_complete))
        modifier_keys = current_stroke.get_modifier_keys
        natural_key = stroke.get_natural_key
        modifier_keys |= stroke.get_modifier_keys
        key_strokes[index] = KeyStroke.get_instance(modifier_keys, natural_key)
        return key_strokes
      end
      new_key_strokes = Array.typed(KeyStroke).new(key_strokes_length + 1) { nil }
      System.arraycopy(key_strokes, 0, new_key_strokes, 0, index)
      new_key_strokes[index] = stroke
      if (index < key_strokes_length)
        System.arraycopy(key_strokes, index, new_key_strokes, index + 1, key_strokes_length - index)
      end
      return new_key_strokes
    end
    
    typesig { [] }
    # Tests whether the cursor is in the last position. This means that the
    # selection extends to the last position.
    # 
    # @return <code>true</code> if the selection extends to the last
    # position; <code>false</code> otherwise.
    def is_cursor_in_last_position
      return (@text.get_selection.attr_y >= get_text.length)
    end
    
    typesig { [IPropertyChangeListener] }
    # Removes the given listener from this key sequence widget.
    # 
    # @param listener
    # The listener to be removed; must not be <code>null</code>.
    # @since 3.2
    def remove_property_change_listener(listener)
      if (((listener).nil?) || ((@listeners).nil?))
        return
      end
      @listeners.remove(listener)
    end
    
    typesig { [KeySequence] }
    # <p>
    # A mutator for the key sequence stored within this widget. The text and
    # caret position are updated.
    # </p>
    # <p>
    # All sequences are limited to maxStrokes number of strokes in length. If
    # there are already that number of strokes, then it does not show
    # incomplete strokes, and does not keep track of them.
    # </p>
    # 
    # @param newKeySequence
    # The new key sequence for this widget; may be <code>null</code>
    # if none.
    def set_key_sequence(new_key_sequence)
      old_key_sequence = @key_sequence
      if ((new_key_sequence).nil?)
        @text.set_text("") # $NON-NLS-1$
      else
        @key_sequence = new_key_sequence
      end
      # Trim any extra strokes.
      if (!(@max_strokes).equal?(INFINITE))
        old_key_strokes = @key_sequence.get_key_strokes
        if (@max_strokes < old_key_strokes.attr_length)
          new_key_strokes = Array.typed(KeyStroke).new(@max_strokes) { nil }
          System.arraycopy(old_key_strokes, 0, new_key_strokes, 0, @max_strokes)
          @key_sequence = KeySequence.get_instance(new_key_strokes)
        end
      end
      # Check to see if the text has changed.
      current_string = get_text
      new_string = @key_sequence.format
      if (!(current_string == new_string))
        # We need to update the text
        @text.remove_modify_listener(@update_sequence_listener)
        @text.set_text(@key_sequence.format)
        @text.add_modify_listener(@update_sequence_listener)
        @text.set_selection(get_text.length)
      end
      fire_property_change_event(old_key_sequence)
    end
    
    typesig { [] }
    # Returns the maximum number of strokes that are permitted in this widget
    # at one time.
    # 
    # @return The maximum number of strokes; will be a positive integer or
    # <code>INFINITE</code>.
    def get_key_stroke_limit
      return @max_strokes
    end
    
    typesig { [::Java::Int] }
    # A mutator for the maximum number of strokes that are permitted in this
    # widget at one time.
    # 
    # @param keyStrokeLimit
    # The maximum number of strokes; must be a positive integer or
    # <code>INFINITE</code>.
    def set_key_stroke_limit(key_stroke_limit)
      if (key_stroke_limit > 0 || (key_stroke_limit).equal?(INFINITE))
        @max_strokes = key_stroke_limit
      else
        raise IllegalArgumentException.new
      end
      # Make sure we are obeying the new limit.
      set_key_sequence(get_key_sequence)
    end
    
    private
    alias_method :initialize__key_sequence_text, :initialize
  end
  
end
