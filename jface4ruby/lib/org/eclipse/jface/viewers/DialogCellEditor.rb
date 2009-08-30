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
  module DialogCellEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Text, :MessageFormat
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Jface::Resource, :ImageRegistry
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :KeyAdapter
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
    }
  end
  
  # Not using ICU to support standalone JFace scenario
  # 
  # An abstract cell editor that uses a dialog.
  # Dialog cell editors usually have a label control on the left and a button on
  # the right. Pressing the button opens a dialog window (for example, a color dialog
  # or a file dialog) to change the cell editor's value.
  # The cell editor's value is the value of the dialog.
  # <p>
  # Subclasses may override the following methods:
  # <ul>
  # <li><code>createButton</code>: creates the cell editor's button control</li>
  # <li><code>createContents</code>: creates the cell editor's 'display value' control</li>
  # <li><code>updateContents</code>: updates the cell editor's 'display value' control
  # after its value has changed</li>
  # <li><code>openDialogBox</code>: opens the dialog box when the end user presses
  # the button</li>
  # </ul>
  # </p>
  class DialogCellEditor < DialogCellEditorImports.const_get :CellEditor
    include_class_members DialogCellEditorImports
    
    class_module.module_eval {
      # Image registry key for three dot image (value <code>"cell_editor_dots_button_image"</code>).
      const_set_lazy(:CELL_EDITOR_IMG_DOTS_BUTTON) { "cell_editor_dots_button_image" }
      const_attr_reader  :CELL_EDITOR_IMG_DOTS_BUTTON
    }
    
    # $NON-NLS-1$
    # 
    # The editor control.
    attr_accessor :editor
    alias_method :attr_editor, :editor
    undef_method :editor
    alias_method :attr_editor=, :editor=
    undef_method :editor=
    
    # The current contents.
    attr_accessor :contents
    alias_method :attr_contents, :contents
    undef_method :contents
    alias_method :attr_contents=, :contents=
    undef_method :contents=
    
    # The label that gets reused by <code>updateLabel</code>.
    attr_accessor :default_label
    alias_method :attr_default_label, :default_label
    undef_method :default_label
    alias_method :attr_default_label=, :default_label=
    undef_method :default_label=
    
    # The button.
    attr_accessor :button
    alias_method :attr_button, :button
    undef_method :button
    alias_method :attr_button=, :button=
    undef_method :button=
    
    # Listens for 'focusLost' events and  fires the 'apply' event as long
    # as the focus wasn't lost because the dialog was opened.
    attr_accessor :button_focus_listener
    alias_method :attr_button_focus_listener, :button_focus_listener
    undef_method :button_focus_listener
    alias_method :attr_button_focus_listener=, :button_focus_listener=
    undef_method :button_focus_listener=
    
    # The value of this cell editor; initially <code>null</code>.
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    class_module.module_eval {
      when_class_loaded do
        reg = JFaceResources.get_image_registry
        reg.put(CELL_EDITOR_IMG_DOTS_BUTTON, ImageDescriptor.create_from_file(DialogCellEditor, "images/dots_button.gif")) # $NON-NLS-1$
      end
      
      # Internal class for laying out the dialog.
      const_set_lazy(:DialogCellLayout) { Class.new(Layout) do
        extend LocalClass
        include_class_members DialogCellEditor
        
        typesig { [class_self::Composite, ::Java::Boolean] }
        def layout(editor, force)
          bounds = editor.get_client_area
          size = self.attr_button.compute_size(SWT::DEFAULT, SWT::DEFAULT, force)
          if (!(self.attr_contents).nil?)
            self.attr_contents.set_bounds(0, 0, bounds.attr_width - size.attr_x, bounds.attr_height)
          end
          self.attr_button.set_bounds(bounds.attr_width - size.attr_x, 0, size.attr_x, bounds.attr_height)
        end
        
        typesig { [class_self::Composite, ::Java::Int, ::Java::Int, ::Java::Boolean] }
        def compute_size(editor, w_hint, h_hint, force)
          if (!(w_hint).equal?(SWT::DEFAULT) && !(h_hint).equal?(SWT::DEFAULT))
            return self.class::Point.new(w_hint, h_hint)
          end
          contents_size = self.attr_contents.compute_size(SWT::DEFAULT, SWT::DEFAULT, force)
          button_size = self.attr_button.compute_size(SWT::DEFAULT, SWT::DEFAULT, force)
          # Just return the button width to ensure the button is not clipped
          # if the label is long.
          # The label will just use whatever extra width there is
          result = self.class::Point.new(button_size.attr_x, Math.max(contents_size.attr_y, button_size.attr_y))
          return result
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__dialog_cell_layout, :initialize
      end }
      
      # Default DialogCellEditor style
      const_set_lazy(:DefaultStyle) { SWT::NONE }
      const_attr_reader  :DefaultStyle
    }
    
    typesig { [] }
    # Creates a new dialog cell editor with no control
    # @since 2.1
    def initialize
      @editor = nil
      @contents = nil
      @default_label = nil
      @button = nil
      @button_focus_listener = nil
      @value = nil
      super()
      @value = nil
      set_style(DefaultStyle)
    end
    
    typesig { [Composite] }
    # Creates a new dialog cell editor parented under the given control.
    # The cell editor value is <code>null</code> initially, and has no
    # validator.
    # 
    # @param parent the parent control
    def initialize(parent)
      initialize__dialog_cell_editor(parent, DefaultStyle)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a new dialog cell editor parented under the given control.
    # The cell editor value is <code>null</code> initially, and has no
    # validator.
    # 
    # @param parent the parent control
    # @param style the style bits
    # @since 2.1
    def initialize(parent, style)
      @editor = nil
      @contents = nil
      @default_label = nil
      @button = nil
      @button_focus_listener = nil
      @value = nil
      super(parent, style)
      @value = nil
    end
    
    typesig { [Composite] }
    # Creates the button for this cell editor under the given parent control.
    # <p>
    # The default implementation of this framework method creates the button
    # display on the right hand side of the dialog cell editor. Subclasses
    # may extend or reimplement.
    # </p>
    # 
    # @param parent the parent control
    # @return the new button control
    def create_button(parent)
      result = Button.new(parent, SWT::DOWN)
      result.set_text("...") # $NON-NLS-1$
      return result
    end
    
    typesig { [Composite] }
    # Creates the controls used to show the value of this cell editor.
    # <p>
    # The default implementation of this framework method creates
    # a label widget, using the same font and background color as the parent control.
    # </p>
    # <p>
    # Subclasses may reimplement.  If you reimplement this method, you
    # should also reimplement <code>updateContents</code>.
    # </p>
    # 
    # @param cell the control for this cell editor
    # @return the underlying control
    def create_contents(cell)
      @default_label = Label.new(cell, SWT::LEFT)
      @default_label.set_font(cell.get_font)
      @default_label.set_background(cell.get_background)
      return @default_label
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # Method declared on CellEditor.
    def create_control(parent)
      font = parent.get_font
      bg = parent.get_background
      @editor = Composite.new(parent, get_style)
      @editor.set_font(font)
      @editor.set_background(bg)
      @editor.set_layout(DialogCellLayout.new_local(self))
      @contents = create_contents(@editor)
      update_contents(@value)
      @button = create_button(@editor)
      @button.set_font(font)
      @button.add_key_listener(Class.new(KeyAdapter.class == Class ? KeyAdapter : Object) do
        extend LocalClass
        include_class_members DialogCellEditor
        include KeyAdapter if KeyAdapter.class == Module
        
        typesig { [KeyEvent] }
        # (non-Javadoc)
        # @see org.eclipse.swt.events.KeyListener#keyReleased(org.eclipse.swt.events.KeyEvent)
        define_method :key_released do |e|
          if ((e.attr_character).equal?(Character.new(0x001b)))
            # Escape
            fire_cancel_editor
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @button.add_focus_listener(get_button_focus_listener)
      @button.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        extend LocalClass
        include_class_members DialogCellEditor
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        # (non-Javadoc)
        # @see org.eclipse.swt.events.SelectionListener#widgetSelected(org.eclipse.swt.events.SelectionEvent)
        define_method :widget_selected do |event|
          # Remove the button's focus listener since it's guaranteed
          # to lose focus when the dialog opens
          self.attr_button.remove_focus_listener(get_button_focus_listener)
          new_value = open_dialog_box(self.attr_editor)
          # Re-add the listener once the dialog closes
          self.attr_button.add_focus_listener(get_button_focus_listener)
          if (!(new_value).nil?)
            new_valid_state = is_correct(new_value)
            if (new_valid_state)
              mark_dirty
              do_set_value(new_value)
            else
              # try to insert the current value into the error message.
              set_error_message(MessageFormat.format(get_error_message, Array.typed(Object).new([new_value.to_s])))
            end
            fire_apply_editor_value
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      set_value_valid(true)
      return @editor
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # Override in order to remove the button's focus listener if the celleditor
    # is deactivating.
    # 
    # @see org.eclipse.jface.viewers.CellEditor#deactivate()
    def deactivate
      if (!(@button).nil? && !@button.is_disposed)
        @button.remove_focus_listener(get_button_focus_listener)
      end
      super
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on CellEditor.
    def do_get_value
      return @value
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on CellEditor.
    # The focus is set to the cell editor's button.
    def do_set_focus
      @button.set_focus
      # add a FocusListener to the button
      @button.add_focus_listener(get_button_focus_listener)
    end
    
    typesig { [] }
    # Return a listener for button focus.
    # @return FocusListener
    def get_button_focus_listener
      if ((@button_focus_listener).nil?)
        @button_focus_listener = Class.new(FocusListener.class == Class ? FocusListener : Object) do
          extend LocalClass
          include_class_members DialogCellEditor
          include FocusListener if FocusListener.class == Module
          
          typesig { [FocusEvent] }
          # (non-Javadoc)
          # @see org.eclipse.swt.events.FocusListener#focusGained(org.eclipse.swt.events.FocusEvent)
          define_method :focus_gained do |e|
            # Do nothing
          end
          
          typesig { [FocusEvent] }
          # (non-Javadoc)
          # @see org.eclipse.swt.events.FocusListener#focusLost(org.eclipse.swt.events.FocusEvent)
          define_method :focus_lost do |e|
            @local_class_parent.focus_lost
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return @button_focus_listener
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # Method declared on CellEditor.
    def do_set_value(value)
      @value = value
      update_contents(value)
    end
    
    typesig { [] }
    # Returns the default label widget created by <code>createContents</code>.
    # 
    # @return the default label widget
    def get_default_label
      return @default_label
    end
    
    typesig { [Control] }
    # Opens a dialog box under the given parent control and returns the
    # dialog's value when it closes, or <code>null</code> if the dialog
    # was canceled or no selection was made in the dialog.
    # <p>
    # This framework method must be implemented by concrete subclasses.
    # It is called when the user has pressed the button and the dialog
    # box must pop up.
    # </p>
    # 
    # @param cellEditorWindow the parent control cell editor's window
    # so that a subclass can adjust the dialog box accordingly
    # @return the selected value, or <code>null</code> if the dialog was
    # canceled or no selection was made in the dialog
    def open_dialog_box(cell_editor_window)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Updates the controls showing the value of this cell editor.
    # <p>
    # The default implementation of this framework method just converts
    # the passed object to a string using <code>toString</code> and
    # sets this as the text of the label widget.
    # </p>
    # <p>
    # Subclasses may reimplement.  If you reimplement this method, you
    # should also reimplement <code>createContents</code>.
    # </p>
    # 
    # @param value the new value of this cell editor
    def update_contents(value)
      if ((@default_label).nil?)
        return
      end
      text = "" # $NON-NLS-1$
      if (!(value).nil?)
        text = RJava.cast_to_string(value.to_s)
      end
      @default_label.set_text(text)
    end
    
    private
    alias_method :initialize__dialog_cell_editor, :initialize
  end
  
end
