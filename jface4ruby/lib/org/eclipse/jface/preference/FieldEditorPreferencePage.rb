require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Chris Tilt (chris@tilts.net) - Bug 38547 - [Preferences] Changing preferences
# ignored after "Restore defaults" pressed.
module Org::Eclipse::Jface::Preference
  module FieldEditorPreferencePageImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # A special abstract preference page to host field editors.
  # <p>
  # Subclasses must implement the <code>createFieldEditors</code> method
  # and should override <code>createLayout</code> if a special layout of the field
  # editors is needed.
  # </p>
  class FieldEditorPreferencePage < FieldEditorPreferencePageImports.const_get :PreferencePage
    include_class_members FieldEditorPreferencePageImports
    overload_protected {
      include IPropertyChangeListener
    }
    
    class_module.module_eval {
      # Layout constant (value <code>0</code>) indicating that
      # each field editor is handled as a single component.
      const_set_lazy(:FLAT) { 0 }
      const_attr_reader  :FLAT
      
      # Layout constant (value <code>1</code>) indicating that
      # the field editors' basic controls are put into a grid layout.
      const_set_lazy(:GRID) { 1 }
      const_attr_reader  :GRID
      
      # The vertical spacing used by layout styles <code>FLAT</code>
      # and <code>GRID</code>.
      const_set_lazy(:VERTICAL_SPACING) { 10 }
      const_attr_reader  :VERTICAL_SPACING
      
      # The margin width used by layout styles <code>FLAT</code>
      # and <code>GRID</code>.
      const_set_lazy(:MARGIN_WIDTH) { 0 }
      const_attr_reader  :MARGIN_WIDTH
      
      # The margin height used by layout styles <code>FLAT</code>
      # and <code>GRID</code>.
      const_set_lazy(:MARGIN_HEIGHT) { 0 }
      const_attr_reader  :MARGIN_HEIGHT
    }
    
    # The field editors, or <code>null</code> if not created yet.
    attr_accessor :fields
    alias_method :attr_fields, :fields
    undef_method :fields
    alias_method :attr_fields=, :fields=
    undef_method :fields=
    
    # The layout style; either <code>FLAT</code> or <code>GRID</code>.
    attr_accessor :style
    alias_method :attr_style, :style
    undef_method :style
    alias_method :attr_style=, :style=
    undef_method :style=
    
    # The first invalid field editor, or <code>null</code>
    # if all field editors are valid.
    attr_accessor :invalid_field_editor
    alias_method :attr_invalid_field_editor, :invalid_field_editor
    undef_method :invalid_field_editor
    alias_method :attr_invalid_field_editor=, :invalid_field_editor=
    undef_method :invalid_field_editor=
    
    # The parent composite for field editors
    attr_accessor :field_editor_parent
    alias_method :attr_field_editor_parent, :field_editor_parent
    undef_method :field_editor_parent
    alias_method :attr_field_editor_parent=, :field_editor_parent=
    undef_method :field_editor_parent=
    
    typesig { [] }
    # Create a new instance of the reciever.
    def initialize
      initialize__field_editor_preference_page(FLAT)
    end
    
    typesig { [::Java::Int] }
    # Creates a new field editor preference page with the given style,
    # an empty title, and no image.
    # 
    # @param style either <code>GRID</code> or <code>FLAT</code>
    def initialize(style)
      @fields = nil
      @style = 0
      @invalid_field_editor = nil
      @field_editor_parent = nil
      super()
      @fields = nil
      @invalid_field_editor = nil
      @style = style
    end
    
    typesig { [String, ::Java::Int] }
    # Creates a new field editor preference page with the given title
    # and style, but no image.
    # 
    # @param title the title of this preference page
    # @param style either <code>GRID</code> or <code>FLAT</code>
    def initialize(title, style)
      @fields = nil
      @style = 0
      @invalid_field_editor = nil
      @field_editor_parent = nil
      super(title)
      @fields = nil
      @invalid_field_editor = nil
      @style = style
    end
    
    typesig { [String, ImageDescriptor, ::Java::Int] }
    # Creates a new field editor preference page with the given title,
    # image, and style.
    # 
    # @param title the title of this preference page
    # @param image the image for this preference page, or
    # <code>null</code> if none
    # @param style either <code>GRID</code> or <code>FLAT</code>
    def initialize(title, image, style)
      @fields = nil
      @style = 0
      @invalid_field_editor = nil
      @field_editor_parent = nil
      super(title, image)
      @fields = nil
      @invalid_field_editor = nil
      @style = style
    end
    
    typesig { [FieldEditor] }
    # Adds the given field editor to this page.
    # 
    # @param editor the field editor
    def add_field(editor)
      if ((@fields).nil?)
        @fields = ArrayList.new
      end
      @fields.add(editor)
    end
    
    typesig { [] }
    # Adjust the layout of the field editors so that
    # they are properly aligned.
    def adjust_grid_layout
      num_columns = calc_number_of_columns
      (@field_editor_parent.get_layout).attr_num_columns = num_columns
      if (!(@fields).nil?)
        i = 0
        while i < @fields.size
          field_editor = @fields.get(i)
          field_editor.adjust_for_num_columns(num_columns)
          i += 1
        end
      end
    end
    
    typesig { [] }
    # Applys the font to the field editors managed by this page.
    def apply_font
      if (!(@fields).nil?)
        e = @fields.iterator
        while (e.has_next)
          pe = e.next_
          pe.apply_font
        end
      end
    end
    
    typesig { [] }
    # Calculates the number of columns needed to host all field editors.
    # 
    # @return the number of columns
    def calc_number_of_columns
      result = 0
      if (!(@fields).nil?)
        e = @fields.iterator
        while (e.has_next)
          pe = e.next_
          result = Math.max(result, pe.get_number_of_controls)
        end
      end
      return result
    end
    
    typesig { [] }
    # Recomputes the page's error state by calling <code>isValid</code> for
    # every field editor.
    def check_state
      valid = true
      @invalid_field_editor = nil
      # The state can only be set to true if all
      # field editors contain a valid value. So we must check them all
      if (!(@fields).nil?)
        size_ = @fields.size
        i = 0
        while i < size_
          editor = @fields.get(i)
          valid = valid && editor.is_valid
          if (!valid)
            @invalid_field_editor = editor
            break
          end
          i += 1
        end
      end
      set_valid(valid)
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # Method declared on PreferencePage.
    def create_contents(parent)
      @field_editor_parent = Composite.new(parent, SWT::NULL)
      layout = GridLayout.new
      layout.attr_num_columns = 1
      layout.attr_margin_height = 0
      layout.attr_margin_width = 0
      @field_editor_parent.set_layout(layout)
      @field_editor_parent.set_font(parent.get_font)
      create_field_editors
      if ((@style).equal?(GRID))
        adjust_grid_layout
      end
      initialize_
      check_state
      return @field_editor_parent
    end
    
    typesig { [] }
    # Creates the page's field editors.
    # <p>
    # The default implementation of this framework method
    # does nothing. Subclass must implement this method to
    # create the field editors.
    # </p>
    # <p>
    # Subclasses should call <code>getFieldEditorParent</code>
    # to obtain the parent control for each field editor.
    # This same parent should not be used for more than
    # one editor as the parent may change for each field
    # editor depending on the layout style of the page
    # </p>
    def create_field_editors
      raise NotImplementedError
    end
    
    typesig { [] }
    # The field editor preference page implementation of an <code>IDialogPage</code>
    # method disposes of this page's controls and images.
    # Subclasses may override to release their own allocated SWT
    # resources, but must call <code>super.dispose</code>.
    def dispose
      super
      if (!(@fields).nil?)
        e = @fields.iterator
        while (e.has_next)
          pe = e.next_
          pe.set_page(nil)
          pe.set_property_change_listener(nil)
          pe.set_preference_store(nil)
        end
      end
    end
    
    typesig { [] }
    # Returns a parent composite for a field editor.
    # <p>
    # This value must not be cached since a new parent
    # may be created each time this method called. Thus
    # this method must be called each time a field editor
    # is constructed.
    # </p>
    # 
    # @return a parent
    def get_field_editor_parent
      if ((@style).equal?(FLAT))
        # Create a new parent for each field editor
        parent = Composite.new(@field_editor_parent, SWT::NULL)
        parent.set_layout_data(GridData.new(GridData::FILL_HORIZONTAL))
        return parent
      end
      # Just return the parent
      return @field_editor_parent
    end
    
    typesig { [] }
    # Initializes all field editors.
    def initialize_
      if (!(@fields).nil?)
        e = @fields.iterator
        while (e.has_next)
          pe = e.next_
          pe.set_page(self)
          pe.set_property_change_listener(self)
          pe.set_preference_store(get_preference_store)
          pe.load
        end
      end
    end
    
    typesig { [] }
    # The field editor preference page implementation of a <code>PreferencePage</code>
    # method loads all the field editors with their default values.
    def perform_defaults
      if (!(@fields).nil?)
        e = @fields.iterator
        while (e.has_next)
          pe = e.next_
          pe.load_default
        end
      end
      # Force a recalculation of my error state.
      check_state
      super
    end
    
    typesig { [] }
    # The field editor preference page implementation of this
    # <code>PreferencePage</code> method saves all field editors by
    # calling <code>FieldEditor.store</code>. Note that this method
    # does not save the preference store itself; it just stores the
    # values back into the preference store.
    # 
    # @see FieldEditor#store()
    def perform_ok
      if (!(@fields).nil?)
        e = @fields.iterator
        while (e.has_next)
          pe = e.next_
          pe.store
          pe.set_presents_default_value(false)
        end
      end
      return true
    end
    
    typesig { [PropertyChangeEvent] }
    # The field editor preference page implementation of this <code>IPreferencePage</code>
    # (and <code>IPropertyChangeListener</code>) method intercepts <code>IS_VALID</code>
    # events but passes other events on to its superclass.
    def property_change(event)
      if ((event.get_property == FieldEditor::IS_VALID))
        new_value = (event.get_new_value).boolean_value
        # If the new value is true then we must check all field editors.
        # If it is false, then the page is invalid in any case.
        if (new_value)
          check_state
        else
          @invalid_field_editor = event.get_source
          set_valid(new_value)
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on IDialog.
    def set_visible(visible)
      super(visible)
      if (visible && !(@invalid_field_editor).nil?)
        @invalid_field_editor.set_focus
      end
    end
    
    private
    alias_method :initialize__field_editor_preference_page, :initialize
  end
  
end
