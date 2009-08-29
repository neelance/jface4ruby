require "rjava"

# Copyright (c) 2004, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Sebastian Davids - bug 69254
module Org::Eclipse::Jface::Viewers
  module ComboViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :CCombo
      include_const ::Org::Eclipse::Swt::Widgets, :Combo
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # A concrete viewer based either on an SWT <code>Combo</code> control or <code>CCombo</code>
  # control. This class is intended as an alternative to the JFace <code>ListViewer</code>, which displays
  # its content in a combo box rather than a list. Wherever possible, this class attempts to behave
  # like ListViewer. <p>
  # 
  # This class is designed to be instantiated with a pre-existing SWT combo control
  # and configured with a domain-specific content provider, label provider, element
  # filter (optional), and element sorter (optional).
  # </p>
  # 
  # @see org.eclipse.jface.viewers.ListViewer
  # @since 3.0 (made non-final in 3.4)
  class ComboViewer < ComboViewerImports.const_get :AbstractListViewer
    include_class_members ComboViewerImports
    
    # This viewer's list control if this viewer is instantiated with a combo control; otherwise
    # <code>null</code>.
    # 
    # @see #ComboViewer(Combo)
    attr_accessor :combo
    alias_method :attr_combo, :combo
    undef_method :combo
    alias_method :attr_combo=, :combo=
    undef_method :combo=
    
    # This viewer's list control if this viewer is instantiated with a CCombo control; otherwise
    # <code>null</code>.
    # 
    # @see #ComboViewer(CCombo)
    # @since 3.3
    attr_accessor :ccombo
    alias_method :attr_ccombo, :ccombo
    undef_method :ccombo
    alias_method :attr_ccombo=, :ccombo=
    undef_method :ccombo=
    
    typesig { [Composite] }
    # Creates a combo viewer on a newly-created combo control under the given parent.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # 
    # @param parent the parent control
    def initialize(parent)
      initialize__combo_viewer(parent, SWT::READ_ONLY | SWT::BORDER)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a combo viewer on a newly-created combo control under the given parent.
    # The combo control is created using the given SWT style bits.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # 
    # @param parent the parent control
    # @param style the SWT style bits
    def initialize(parent, style)
      initialize__combo_viewer(Combo.new(parent, style))
    end
    
    typesig { [Combo] }
    # Creates a combo viewer on the given combo control.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # 
    # @param list the combo control
    def initialize(list)
      @combo = nil
      @ccombo = nil
      super()
      @combo = list
      hook_control(list)
    end
    
    typesig { [CCombo] }
    # Creates a combo viewer on the given CCombo control.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # 
    # @param list the CCombo control
    # @since 3.3
    def initialize(list)
      @combo = nil
      @ccombo = nil
      super()
      @ccombo = list
      hook_control(list)
    end
    
    typesig { [String, ::Java::Int] }
    def list_add(string, index)
      if ((@combo).nil?)
        @ccombo.add(string, index)
      else
        @combo.add(string, index)
      end
    end
    
    typesig { [::Java::Int, String] }
    def list_set_item(index, string)
      if ((@combo).nil?)
        @ccombo.set_item(index, string)
      else
        @combo.set_item(index, string)
      end
    end
    
    typesig { [] }
    def list_get_selection_indices
      if ((@combo).nil?)
        return Array.typed(::Java::Int).new([@ccombo.get_selection_index])
      else
        return Array.typed(::Java::Int).new([@combo.get_selection_index])
      end
    end
    
    typesig { [] }
    def list_get_item_count
      if ((@combo).nil?)
        return @ccombo.get_item_count
      else
        return @combo.get_item_count
      end
    end
    
    typesig { [Array.typed(String)] }
    def list_set_items(labels)
      if ((@combo).nil?)
        @ccombo.set_items(labels)
      else
        @combo.set_items(labels)
      end
    end
    
    typesig { [] }
    def list_remove_all
      if ((@combo).nil?)
        @ccombo.remove_all
      else
        @combo.remove_all
      end
    end
    
    typesig { [::Java::Int] }
    def list_remove(index)
      if ((@combo).nil?)
        @ccombo.remove(index)
      else
        @combo.remove(index)
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on Viewer.
    def get_control
      if ((@combo).nil?)
        return @ccombo
      else
        return @combo
      end
    end
    
    typesig { [] }
    # Returns this list viewer's list control. If the viewer was not created on
    # a CCombo control, some kind of unchecked exception is thrown.
    # 
    # @return the list control
    # @since 3.3
    def get_ccombo
      Assert.is_not_null(@ccombo)
      return @ccombo
    end
    
    typesig { [] }
    # Returns this list viewer's list control. If the viewer was not created on
    # a Combo control, some kind of unchecked exception is thrown.
    # 
    # @return the list control
    def get_combo
      Assert.is_not_null(@combo)
      return @combo
    end
    
    typesig { [Object] }
    # Do nothing -- combos only display the selected element, so there is no way
    # we can ensure that the given element is visible without changing the selection.
    # Method defined on StructuredViewer.
    def reveal(element)
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listSetSelection(int[])
    def list_set_selection(ixs)
      if ((@combo).nil?)
        idx = 0
        while idx < ixs.attr_length
          @ccombo.select(ixs[idx])
          idx += 1
        end
      else
        idx = 0
        while idx < ixs.attr_length
          @combo.select(ixs[idx])
          idx += 1
        end
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listDeselectAll()
    def list_deselect_all
      if ((@combo).nil?)
        @ccombo.deselect_all
        @ccombo.clear_selection
      else
        @combo.deselect_all
        @combo.clear_selection
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listShowSelection()
    def list_show_selection
    end
    
    private
    alias_method :initialize__combo_viewer, :initialize
  end
  
end
