require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module PropagatingFontFieldEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Jface::Preference, :FontFieldEditor
      include_const ::Org::Eclipse::Jface::Preference, :IPreferenceStore
      include_const ::Org::Eclipse::Jface::Preference, :PreferenceConverter
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
    }
  end
  
  # This font field editor implements chaining between a source preference
  # store and a target preference store. Any time the source preference
  # store changes, the change is propagated to the target store. Propagation
  # means that the actual value stored in the source store is set as default
  # value in the target store. If the target store does not contain a value
  # other than the default value, the new default value is immediately
  # effective.
  # 
  # @see FontFieldEditor
  # @since 2.0
  # @deprecated since 3.0 not longer in use, no longer supported
  class PropagatingFontFieldEditor < PropagatingFontFieldEditorImports.const_get :FontFieldEditor
    include_class_members PropagatingFontFieldEditorImports
    
    # The editor's parent widget
    attr_accessor :f_parent
    alias_method :attr_f_parent, :f_parent
    undef_method :f_parent
    alias_method :attr_f_parent=, :f_parent=
    undef_method :f_parent=
    
    # The representation of the default font choice
    attr_accessor :f_default_font_label
    alias_method :attr_f_default_font_label, :f_default_font_label
    undef_method :f_default_font_label
    alias_method :attr_f_default_font_label=, :f_default_font_label=
    undef_method :f_default_font_label=
    
    typesig { [String, String, Composite, String] }
    # Creates a new font field editor with the given parameters.
    # 
    # @param name the editor's name
    # @param labelText the text shown as editor description
    # @param parent the editor's parent widget
    # @param defaultFontLabel the label shown in the editor value field when the default value should be taken
    def initialize(name, label_text, parent, default_font_label)
      @f_parent = nil
      @f_default_font_label = nil
      super(name, label_text, parent)
      @f_parent = parent
      @f_default_font_label = RJava.cast_to_string((default_font_label).nil? ? "" : default_font_label) # $NON-NLS-1$
    end
    
    typesig { [] }
    # @see FontFieldEditor#doLoad()
    def do_load
      if (get_preference_store.is_default(get_preference_name))
        load_default
      end
      super
      check_for_default
    end
    
    typesig { [] }
    # @see FontFieldEditor#doLoadDefault()
    def do_load_default
      super
      check_for_default
    end
    
    typesig { [] }
    # Checks whether this editor presents the default value "inherited"
    # from the workbench rather than its own font.
    def check_for_default
      if (presents_default_value)
        c = get_value_control(@f_parent)
        if (c.is_a?(Label))
          (c).set_text(@f_default_font_label)
        end
      end
    end
    
    class_module.module_eval {
      typesig { [IPreferenceStore, String, IPreferenceStore, String] }
      # Propagates the font set in the source store to the
      # target store using the given keys.
      # 
      # @param source the store from which to read the text font
      # @param sourceKey the key under which the font can be found
      # @param target the store to which to propagate the font
      # @param targetKey the key under which to store the font
      def propagate_font(source, source_key, target, target_key)
        fd = PreferenceConverter.get_font_data(source, source_key)
        if (!(fd).nil?)
          is_default_ = target.is_default(target_key) # save old state!
          PreferenceConverter.set_default(target, target_key, fd)
          if (is_default_)
            # restore old state
            target.set_to_default(target_key)
          end
        end
      end
      
      typesig { [IPreferenceStore, String, IPreferenceStore, String] }
      # Starts the propagation of the font preference stored in the source preference
      # store under the source key to the target preference store using the target
      # preference key.
      # 
      # @param source the source preference store
      # @param sourceKey the key to be used in the source preference store
      # @param target the target preference store
      # @param targetKey the key to be used in the target preference store
      def start_propagate(source, source_key, target, target_key)
        source.add_property_change_listener(Class.new(IPropertyChangeListener.class == Class ? IPropertyChangeListener : Object) do
          extend LocalClass
          include_class_members PropagatingFontFieldEditor
          include IPropertyChangeListener if IPropertyChangeListener.class == Module
          
          typesig { [PropertyChangeEvent] }
          define_method :property_change do |event|
            if ((source_key == event.get_property))
              propagate_font(source, source_key, target, target_key)
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        propagate_font(source, source_key, target, target_key)
      end
    }
    
    private
    alias_method :initialize__propagating_font_field_editor, :initialize
  end
  
end
