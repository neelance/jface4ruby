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
  module FontFieldEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogConstants
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Resource, :StringConverter
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :FontDialog
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Text
    }
  end
  
  # A field editor for a font type preference.
  class FontFieldEditor < FontFieldEditorImports.const_get :FieldEditor
    include_class_members FontFieldEditorImports
    
    # The change font button, or <code>null</code> if none
    # (before creation and after disposal).
    attr_accessor :change_font_button
    alias_method :attr_change_font_button, :change_font_button
    undef_method :change_font_button
    alias_method :attr_change_font_button=, :change_font_button=
    undef_method :change_font_button=
    
    # The text for the change font button, or <code>null</code>
    # if missing.
    attr_accessor :change_button_text
    alias_method :attr_change_button_text, :change_button_text
    undef_method :change_button_text
    alias_method :attr_change_button_text=, :change_button_text=
    undef_method :change_button_text=
    
    # The text for the preview, or <code>null</code> if no preview is desired
    attr_accessor :preview_text
    alias_method :attr_preview_text, :preview_text
    undef_method :preview_text
    alias_method :attr_preview_text=, :preview_text=
    undef_method :preview_text=
    
    # Font data for the chosen font button, or <code>null</code> if none.
    attr_accessor :chosen_font
    alias_method :attr_chosen_font, :chosen_font
    undef_method :chosen_font
    alias_method :attr_chosen_font=, :chosen_font=
    undef_method :chosen_font=
    
    # The label that displays the selected font, or <code>null</code> if none.
    attr_accessor :value_control
    alias_method :attr_value_control, :value_control
    undef_method :value_control
    alias_method :attr_value_control=, :value_control=
    undef_method :value_control=
    
    # The previewer, or <code>null</code> if none.
    attr_accessor :previewer
    alias_method :attr_previewer, :previewer
    undef_method :previewer
    alias_method :attr_previewer=, :previewer=
    undef_method :previewer=
    
    class_module.module_eval {
      # Internal font previewer implementation.
      const_set_lazy(:DefaultPreviewer) { Class.new do
        include_class_members FontFieldEditor
        
        attr_accessor :text
        alias_method :attr_text, :text
        undef_method :text
        alias_method :attr_text=, :text=
        undef_method :text=
        
        attr_accessor :string
        alias_method :attr_string, :string
        undef_method :string
        alias_method :attr_string=, :string=
        undef_method :string=
        
        attr_accessor :font
        alias_method :attr_font, :font
        undef_method :font
        alias_method :attr_font=, :font=
        undef_method :font=
        
        typesig { [String, class_self::Composite] }
        # Constructor for the previewer.
        # @param s
        # @param parent
        def initialize(s, parent)
          @text = nil
          @string = nil
          @font = nil
          @string = s
          @text = self.class::Text.new(parent, SWT::READ_ONLY | SWT::BORDER)
          @text.add_dispose_listener(Class.new(self.class::DisposeListener.class == Class ? self.class::DisposeListener : Object) do
            local_class_in DefaultPreviewer
            include_class_members DefaultPreviewer
            include class_self::DisposeListener if class_self::DisposeListener.class == Module
            
            typesig { [class_self::DisposeEvent] }
            define_method :widget_disposed do |e|
              if (!(self.attr_font).nil?)
                self.attr_font.dispose
              end
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          if (!(@string).nil?)
            @text.set_text(@string)
          end
        end
        
        typesig { [] }
        # @return the control the previewer is using
        def get_control
          return @text
        end
        
        typesig { [Array.typed(class_self::FontData)] }
        # Set the font to display with
        # @param fontData
        def set_font(font_data)
          if (!(@font).nil?)
            @font.dispose
          end
          @font = self.class::Font.new(@text.get_display, font_data)
          @text.set_font(@font)
        end
        
        typesig { [] }
        # @return the preferred size of the previewer.
        def get_preferred_extent
          return 40
        end
        
        private
        alias_method :initialize__default_previewer, :initialize
      end }
    }
    
    typesig { [] }
    # Creates a new font field editor
    def initialize
      @change_font_button = nil
      @change_button_text = nil
      @preview_text = nil
      @chosen_font = nil
      @value_control = nil
      @previewer = nil
      super()
      @change_font_button = nil
    end
    
    typesig { [String, String, String, Composite] }
    # Creates a font field editor with an optional preview area.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param previewAreaText the text used for the preview window. If it is
    # <code>null</code> there will be no preview area,
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, preview_area_text, parent)
      @change_font_button = nil
      @change_button_text = nil
      @preview_text = nil
      @chosen_font = nil
      @value_control = nil
      @previewer = nil
      super()
      @change_font_button = nil
      init(name, label_text)
      @preview_text = preview_area_text
      @change_button_text = RJava.cast_to_string(JFaceResources.get_string("openChange")) # $NON-NLS-1$
      create_control(parent)
    end
    
    typesig { [String, String, Composite] }
    # Creates a font field editor without a preview.
    # 
    # @param name the name of the preference this field editor works on
    # @param labelText the label text of the field editor
    # @param parent the parent of the field editor's control
    def initialize(name, label_text, parent)
      initialize__font_field_editor(name, label_text, nil, parent)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def adjust_for_num_columns(num_columns)
      data = GridData.new
      if (!(@value_control.get_layout_data).nil?)
        data = @value_control.get_layout_data
      end
      data.attr_horizontal_span = num_columns - get_number_of_controls + 1
      @value_control.set_layout_data(data)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def apply_font
      if (!(@chosen_font).nil? && !(@previewer).nil?)
        @previewer.set_font(@chosen_font)
      end
    end
    
    typesig { [Composite, ::Java::Int] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_fill_into_grid(parent, num_columns)
      get_label_control(parent)
      @value_control = get_value_control(parent)
      gd = GridData.new(GridData::FILL_HORIZONTAL | GridData::GRAB_HORIZONTAL)
      gd.attr_horizontal_span = num_columns - get_number_of_controls + 1
      @value_control.set_layout_data(gd)
      if (!(@preview_text).nil?)
        @previewer = DefaultPreviewer.new(@preview_text, parent)
        gd = GridData.new(GridData::FILL_HORIZONTAL)
        gd.attr_height_hint = @previewer.get_preferred_extent
        gd.attr_width_hint = @previewer.get_preferred_extent
        @previewer.get_control.set_layout_data(gd)
      end
      @change_font_button = get_change_control(parent)
      gd = GridData.new
      width_hint = convert_horizontal_dlus_to_pixels(@change_font_button, IDialogConstants::BUTTON_WIDTH)
      gd.attr_width_hint = Math.max(width_hint, @change_font_button.compute_size(SWT::DEFAULT, SWT::DEFAULT, true).attr_x)
      @change_font_button.set_layout_data(gd)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_load
      if ((@change_font_button).nil?)
        return
      end
      update_font(PreferenceConverter.get_font_data_array(get_preference_store, get_preference_name))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_load_default
      if ((@change_font_button).nil?)
        return
      end
      update_font(PreferenceConverter.get_default_font_data_array(get_preference_store, get_preference_name))
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def do_store
      if (!(@chosen_font).nil?)
        PreferenceConverter.set_value(get_preference_store, get_preference_name, @chosen_font)
      end
    end
    
    typesig { [Composite] }
    # Returns the change button for this field editor.
    # 
    # @param parent The Composite to create the button in if required.
    # @return the change button
    def get_change_control(parent)
      if ((@change_font_button).nil?)
        @change_font_button = Button.new(parent, SWT::PUSH)
        if (!(@change_button_text).nil?)
          @change_font_button.set_text(@change_button_text)
        end
        @change_font_button.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
          local_class_in FontFieldEditor
          include_class_members FontFieldEditor
          include SelectionAdapter if SelectionAdapter.class == Module
          
          typesig { [SelectionEvent] }
          define_method :widget_selected do |event|
            font_dialog = self.class::FontDialog.new(self.attr_change_font_button.get_shell)
            if (!(self.attr_chosen_font).nil?)
              font_dialog.set_font_list(self.attr_chosen_font)
            end
            font = font_dialog.open
            if (!(font).nil?)
              old_font = self.attr_chosen_font
              if ((old_font).nil?)
                old_font = JFaceResources.get_default_font.get_font_data
              end
              set_presents_default_value(false)
              new_data = Array.typed(self.class::FontData).new(1) { nil }
              new_data[0] = font
              update_font(new_data)
              fire_value_changed(VALUE, old_font[0], font)
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        @change_font_button.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          local_class_in FontFieldEditor
          include_class_members FontFieldEditor
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |event|
            self.attr_change_font_button = nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        @change_font_button.set_font(parent.get_font)
        set_button_layout_data(@change_font_button)
      else
        check_parent(@change_font_button, parent)
      end
      return @change_font_button
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on FieldEditor.
    def get_number_of_controls
      if ((@previewer).nil?)
        return 3
      end
      return 4
    end
    
    typesig { [] }
    # Returns the preferred preview height.
    # 
    # @return the height, or <code>-1</code> if no previewer
    # is installed
    def get_preferred_preview_height
      if ((@previewer).nil?)
        return -1
      end
      return @previewer.get_preferred_extent
    end
    
    typesig { [] }
    # Returns the preview control for this field editor.
    # 
    # @return the preview control
    def get_preview_control
      if ((@previewer).nil?)
        return nil
      end
      return @previewer.get_control
    end
    
    typesig { [Composite] }
    # Returns the value control for this field editor. The value control
    # displays the currently selected font name.
    # @param parent The Composite to create the viewer in if required
    # @return the value control
    def get_value_control(parent)
      if ((@value_control).nil?)
        @value_control = Label.new(parent, SWT::LEFT)
        @value_control.set_font(parent.get_font)
        @value_control.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
          local_class_in FontFieldEditor
          include_class_members FontFieldEditor
          include DisposeListener if DisposeListener.class == Module
          
          typesig { [DisposeEvent] }
          define_method :widget_disposed do |event|
            self.attr_value_control = nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        check_parent(@value_control, parent)
      end
      return @value_control
    end
    
    typesig { [String] }
    # Sets the text of the change button.
    # 
    # @param text the new text
    def set_change_button_text(text)
      Assert.is_not_null(text)
      @change_button_text = text
      if (!(@change_font_button).nil?)
        @change_font_button.set_text(text)
      end
    end
    
    typesig { [Array.typed(FontData)] }
    # Updates the change font button and the previewer to reflect the
    # newly selected font.
    # @param font The FontData[] to update with.
    def update_font(font)
      best_font = JFaceResources.get_font_registry.filter_data(font, @value_control.get_display)
      # if we have nothing valid do as best we can
      if ((best_font).nil?)
        best_font = get_default_font_data
      end
      # Now cache this value in the receiver
      @chosen_font = best_font
      if (!(@value_control).nil?)
        @value_control.set_text(StringConverter.as_string(@chosen_font[0]))
      end
      if (!(@previewer).nil?)
        @previewer.set_font(best_font)
      end
    end
    
    typesig { [] }
    # Store the default preference for the field
    # being edited
    def set_to_default
      default_font_data = PreferenceConverter.get_default_font_data_array(get_preference_store, get_preference_name)
      PreferenceConverter.set_value(get_preference_store, get_preference_name, default_font_data)
    end
    
    typesig { [] }
    # Get the system default font data.
    # @return FontData[]
    def get_default_font_data
      return @value_control.get_display.get_system_font.get_font_data
    end
    
    typesig { [::Java::Boolean, Composite] }
    # @see FieldEditor.setEnabled(boolean,Composite).
    def set_enabled(enabled, parent)
      super(enabled, parent)
      get_change_control(parent).set_enabled(enabled)
      get_value_control(parent).set_enabled(enabled)
    end
    
    private
    alias_method :initialize__font_field_editor, :initialize
  end
  
end
