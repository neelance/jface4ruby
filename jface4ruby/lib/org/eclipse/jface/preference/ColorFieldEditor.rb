require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Preference
  module ColorFieldEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Preference
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # A field editor for a color type preference.
  class ColorFieldEditor < ColorFieldEditorImports.const_get :FieldEditor
    include_class_members ColorFieldEditorImports
    
    # The color selector, or <code>null</code> if none.
    attr_accessor :color_selector
    alias_method :attr_color_selector, :color_selector
    undef_method :color_selector
    alias_method :attr_color_selector=, :color_selector=
    undef_method :color_selector=
    
    typesig { [] }
    # Creates a new color field editor
    def initialize
      @color_selector = nil
      super()
      # No default behavior
    end
    
    typesig { [String, String, Composite] }
    # Creates a color field editor.
    # 
    # @param name
    # the name of the preference this field editor works on
    # @param labelText
    # the label text of the field editor
    # @param parent
    # the parent of the field editor's control
    def initialize(name, label_text, parent)
      @color_selector = nil
      super(name, label_text, parent)
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc) Method declared on FieldEditor.
    def adjust_for_num_columns(num_columns)
      (@color_selector.get_button.get_layout_data).attr_horizontal_span = num_columns - 1
    end
    
    typesig { [Control] }
    # Computes the size of the color image displayed on the button.
    # <p>
    # This is an internal method and should not be called by clients.
    # </p>
    # 
    # @param window
    # the window to create a GC on for calculation.
    # @return Point The image size
    def compute_image_size(window)
      # Make the image height as high as a corresponding character. This
      # makes sure that the button has the same size as a "normal" text
      # button.
      gc = SwtGC.new(window)
      f = JFaceResources.get_font_registry.get(JFaceResources::DEFAULT_FONT)
      gc.set_font(f)
      height = gc.get_font_metrics.get_height
      gc.dispose
      p = Point.new(height * 3 - 6, height)
      return p
    end
    
    typesig { [Composite, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.preference.FieldEditor#doFillIntoGrid(org.eclipse.swt.widgets.Composite, int)
    def do_fill_into_grid(parent, num_columns)
      control = get_label_control(parent)
      gd = GridData.new
      gd.attr_horizontal_span = num_columns - 1
      control.set_layout_data(gd)
      color_button = get_change_control(parent)
      color_button.set_layout_data(GridData.new)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.preference.FieldEditor#doLoad()
    def do_load
      if ((@color_selector).nil?)
        return
      end
      @color_selector.set_color_value(PreferenceConverter.get_color(get_preference_store, get_preference_name))
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on FieldEditor.
    def do_load_default
      if ((@color_selector).nil?)
        return
      end
      @color_selector.set_color_value(PreferenceConverter.get_default_color(get_preference_store, get_preference_name))
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on FieldEditor.
    def do_store
      PreferenceConverter.set_value(get_preference_store, get_preference_name, @color_selector.get_color_value)
    end
    
    typesig { [] }
    # Get the color selector used by the receiver.
    # 
    # @return ColorSelector/
    def get_color_selector
      return @color_selector
    end
    
    typesig { [Composite] }
    # Returns the change button for this field editor.
    # 
    # @param parent
    # The control to create the button in if required.
    # @return the change button
    def get_change_control(parent)
      if ((@color_selector).nil?)
        @color_selector = ColorSelector.new(parent)
        @color_selector.add_listener(Class.new(IPropertyChangeListener.class == Class ? IPropertyChangeListener : Object) do
          extend LocalClass
          include_class_members ColorFieldEditor
          include IPropertyChangeListener if IPropertyChangeListener.class == Module
          
          typesig { [PropertyChangeEvent] }
          # forward the property change of the color selector
          define_method :property_change do |event|
            @local_class_parent.fire_value_changed(event.get_property, event.get_old_value, event.get_new_value)
            set_presents_default_value(false)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        check_parent(@color_selector.get_button, parent)
      end
      return @color_selector.get_button
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on FieldEditor.
    def get_number_of_controls
      return 2
    end
    
    typesig { [::Java::Boolean, Composite] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.preference.FieldEditor#setEnabled(boolean,
    # org.eclipse.swt.widgets.Composite)
    def set_enabled(enabled, parent)
      super(enabled, parent)
      get_change_control(parent).set_enabled(enabled)
    end
    
    private
    alias_method :initialize__color_field_editor, :initialize
  end
  
end
