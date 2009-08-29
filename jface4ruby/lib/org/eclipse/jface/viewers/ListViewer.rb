require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Brad Reynolds - bug 141435
# Tom Schindl <tom.schindl@bestsolution.at> - bug 157309, 177619
module Org::Eclipse::Jface::Viewers
  module ListViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # A concrete viewer based on an SWT <code>List</code> control.
  # <p>
  # This class is not intended to be subclassed. It is designed to be
  # instantiated with a pre-existing SWT <code>List</code> control and configured
  # with a domain-specific content provider, label provider, element filter (optional),
  # and element sorter (optional).
  # <p>
  # Note that the SWT <code>List</code> control only supports the display of strings, not icons.
  # If you need to show icons for items, use <code>TableViewer</code> instead.
  # </p>
  # 
  # @see TableViewer
  # @noextend This class is not intended to be subclassed by clients.
  class ListViewer < ListViewerImports.const_get :AbstractListViewer
    include_class_members ListViewerImports
    
    # This viewer's list control.
    attr_accessor :list
    alias_method :attr_list, :list
    undef_method :list
    alias_method :attr_list=, :list=
    undef_method :list=
    
    typesig { [Composite] }
    # Creates a list viewer on a newly-created list control under the given parent.
    # The list control is created using the SWT style bits <code>MULTI, H_SCROLL, V_SCROLL,</code> and <code>BORDER</code>.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # 
    # @param parent the parent control
    def initialize(parent)
      initialize__list_viewer(parent, SWT::MULTI | SWT::H_SCROLL | SWT::V_SCROLL | SWT::BORDER)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a list viewer on a newly-created list control under the given parent.
    # The list control is created using the given SWT style bits.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # 
    # @param parent the parent control
    # @param style the SWT style bits
    def initialize(parent, style)
      initialize__list_viewer(Org::Eclipse::Swt::Widgets::JavaList.new(parent, style))
    end
    
    typesig { [Org::Eclipse::Swt::Widgets::JavaList] }
    # Creates a list viewer on the given list control.
    # The viewer has no input, no content provider, a default label provider,
    # no sorter, and no filters.
    # 
    # @param list the list control
    def initialize(list)
      @list = nil
      super()
      @list = list
      hook_control(list)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on Viewer.
    def get_control
      return @list
    end
    
    typesig { [] }
    # Returns this list viewer's list control.
    # 
    # @return the list control
    def get_list
      return @list
    end
    
    typesig { [Object] }
    # Non-Javadoc.
    # Method defined on StructuredViewer.
    def reveal(element)
      Assert.is_not_null(element)
      index = get_element_index(element)
      if ((index).equal?(-1))
        return
      end
      # algorithm patterned after List.showSelection()
      count = @list.get_item_count
      if ((count).equal?(0))
        return
      end
      height = @list.get_item_height
      rect = @list.get_client_area
      top_index = @list.get_top_index
      visible_count = Math.max(rect.attr_height / height, 1)
      bottom_index = Math.min(top_index + visible_count, count) - 1
      if ((top_index <= index) && (index <= bottom_index))
        return
      end
      new_top = Math.min(Math.max(index - (visible_count / 2), 0), count - 1)
      @list.set_top_index(new_top)
    end
    
    typesig { [String, ::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listAdd(java.lang.String, int)
    def list_add(string, index)
      @list.add(string, index)
    end
    
    typesig { [::Java::Int, String] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listSetItem(int, java.lang.String)
    def list_set_item(index, string)
      @list.set_item(index, string)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listGetSelectionIndices()
    def list_get_selection_indices
      return @list.get_selection_indices
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listGetItemCount()
    def list_get_item_count
      return @list.get_item_count
    end
    
    typesig { [Array.typed(String)] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listSetItems(java.lang.String[])
    def list_set_items(labels)
      @list.set_items(labels)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listRemoveAll()
    def list_remove_all
      @list.remove_all
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listRemove(int)
    def list_remove(index)
      @list.remove(index)
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listSelectAndShow(int[])
    def list_set_selection(ixs)
      @list.set_selection(ixs)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listDeselectAll()
    def list_deselect_all
      @list.deselect_all
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listShowSelection()
    def list_show_selection
      @list.show_selection
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listGetTopIndex()
    def list_get_top_index
      return @list.get_top_index
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#listSetTopIndex(int)
    def list_set_top_index(index)
      @list.set_top_index(index)
    end
    
    typesig { [JavaList, ::Java::Boolean] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.AbstractListViewer#setSelectionToWidget(java.util.List, boolean)
    def set_selection_to_widget(in_, reveal)
      if (reveal)
        super(in_, reveal)
      else
        if ((in_).nil? || (in_.size).equal?(0))
          # clear selection
          @list.deselect_all
        else
          n = in_.size
          ixs = Array.typed(::Java::Int).new(n) { 0 }
          count = 0
          i = 0
          while i < n
            el = in_.get(i)
            ix = get_element_index(el)
            if (ix >= 0)
              ixs[((count += 1) - 1)] = ix
            end
            (i += 1)
          end
          if (count < n)
            System.arraycopy(ixs, 0, ixs = Array.typed(::Java::Int).new(count) { 0 }, 0, count)
          end
          @list.deselect_all
          @list.select(ixs)
        end
      end
    end
    
    private
    alias_method :initialize__list_viewer, :initialize
  end
  
end
