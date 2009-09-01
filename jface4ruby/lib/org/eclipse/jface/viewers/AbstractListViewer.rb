require "rjava"

# Copyright (c) 2004, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Chris Longfield <clongfield@internap.com> - Fix for Bug 70856
# Tom Schindl - fix for bug 157309
# Brad Reynolds - bug 141435
module Org::Eclipse::Jface::Viewers
  module AbstractListViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # Abstract base class for viewers that contain lists of items (such as a combo or list).
  # Most of the viewer implementation is in this base class, except for the minimal code that
  # actually communicates with the underlying widget.
  # 
  # @see org.eclipse.jface.viewers.ListViewer
  # @see org.eclipse.jface.viewers.ComboViewer
  # 
  # @since 3.0
  class AbstractListViewer < AbstractListViewerImports.const_get :StructuredViewer
    include_class_members AbstractListViewerImports
    
    # A list of viewer elements (element type: <code>Object</code>).
    attr_accessor :list_map
    alias_method :attr_list_map, :list_map
    undef_method :list_map
    alias_method :attr_list_map=, :list_map=
    undef_method :list_map=
    
    typesig { [String, ::Java::Int] }
    # Adds the given string to the underlying widget at the given index
    # 
    # @param string the string to add
    # @param index position to insert the string into
    def list_add(string, index)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, String] }
    # Sets the text of the item at the given index in the underlying widget.
    # 
    # @param index index to modify
    # @param string new text
    def list_set_item(index, string)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the zero-relative indices of the items which are currently
    # selected in the underlying widget.  The array is empty if no items are selected.
    # <p>
    # Note: This is not the actual structure used by the receiver
    # to maintain its selection, so modifying the array will
    # not affect the receiver.
    # </p>
    # @return the array of indices of the selected items
    def list_get_selection_indices
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of items contained in the underlying widget.
    # 
    # @return the number of items
    def list_get_item_count
      raise NotImplementedError
    end
    
    typesig { [Array.typed(String)] }
    # Sets the underlying widget's items to be the given array of items.
    # 
    # @param labels the array of label text
    def list_set_items(labels)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Removes all of the items from the underlying widget.
    def list_remove_all
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Removes the item from the underlying widget at the given
    # zero-relative index.
    # 
    # @param index the index for the item
    def list_remove(index)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Selects the items at the given zero-relative indices in the underlying widget.
    # The current selection is cleared before the new items are selected.
    # <p>
    # Indices that are out of range and duplicate indices are ignored.
    # If the receiver is single-select and multiple indices are specified,
    # then all indices are ignored.
    # 
    # @param ixs the indices of the items to select
    def list_set_selection(ixs)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Shows the selection.  If the selection is already showing in the receiver,
    # this method simply returns.  Otherwise, the items are scrolled until
    # the selection is visible.
    def list_show_selection
      raise NotImplementedError
    end
    
    typesig { [] }
    # Deselects all selected items in the underlying widget.
    def list_deselect_all
      raise NotImplementedError
    end
    
    typesig { [Array.typed(Object)] }
    # Adds the given elements to this list viewer.
    # If this viewer does not have a sorter, the elements are added at the end
    # in the order given; otherwise the elements are inserted at appropriate positions.
    # <p>
    # This method should be called (by the content provider) when elements
    # have been added to the model, in order to cause the viewer to accurately
    # reflect the model. This method only affects the viewer, not the model.
    # </p>
    # 
    # @param elements the elements to add
    def add(elements)
      assert_elements_not_null(elements)
      filtered = filter(elements)
      label_provider = get_label_provider
      i = 0
      while i < filtered.attr_length
        element = filtered[i]
        ix = index_for_element(element)
        insert_item(label_provider, element, ix)
        i += 1
      end
    end
    
    typesig { [ILabelProvider, Object, ::Java::Int] }
    def insert_item(label_provider, element, index)
      list_add(get_label_provider_text(label_provider, element), index)
      @list_map.add(index, element)
      map_element(element, get_control) # must map it, since findItem only looks in map, if enabled
    end
    
    typesig { [Object, ::Java::Int] }
    # Inserts the given element into this list viewer at the given position.
    # If this viewer has a sorter, the position is ignored and the element is
    # inserted at the correct position in the sort order.
    # <p>
    # This method should be called (by the content provider) when elements have
    # been added to the model, in order to cause the viewer to accurately
    # reflect the model. This method only affects the viewer, not the model.
    # </p>
    # 
    # @param element
    # the element
    # @param position
    # a 0-based position relative to the model, or -1 to indicate
    # the last position
    # @since 3.3
    def insert(element, position)
      if (!(get_comparator).nil? || has_filters)
        add(element)
        return
      end
      insert_item(get_label_provider, element, position)
    end
    
    typesig { [ILabelProvider, Object] }
    # Return the text for the element from the labelProvider.
    # If it is null then return the empty String.
    # @param labelProvider ILabelProvider
    # @param element
    # @return String. Return the emptyString if the labelProvider
    # returns null for the text.
    # 
    # @since 3.1
    def get_label_provider_text(label_provider, element)
      text = label_provider.get_text(element)
      if ((text).nil?)
        return "" # $NON-NLS-1$
      end
      return text
    end
    
    typesig { [Object] }
    # Adds the given element to this list viewer.
    # If this viewer does not have a sorter, the element is added at the end;
    # otherwise the element is inserted at the appropriate position.
    # <p>
    # This method should be called (by the content provider) when a single element
    # has been added to the model, in order to cause the viewer to accurately
    # reflect the model. This method only affects the viewer, not the model.
    # Note that there is another method for efficiently processing the simultaneous
    # addition of multiple elements.
    # </p>
    # 
    # @param element the element
    def add(element)
      add(Array.typed(Object).new([element]))
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # Method declared on StructuredViewer.
    # Since SWT.List doesn't use items we always return the List itself.
    def do_find_input_item(element)
      if (!(element).nil? && self.==(element, get_root))
        return get_control
      end
      return nil
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # Method declared on StructuredViewer.
    # Since SWT.List doesn't use items we always return the List itself.
    def do_find_item(element)
      if (!(element).nil?)
        if (list_map_contains(element))
          return get_control
        end
      end
      return nil
    end
    
    typesig { [Widget, Object, ::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on StructuredViewer.
    def do_update_item(data, element, full_map)
      if (!(element).nil?)
        ix = get_element_index(element)
        if (ix >= 0)
          label_provider = get_label_provider
          list_set_item(ix, get_label_provider_text(label_provider, element))
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the element with the given index from this list viewer.
    # Returns <code>null</code> if the index is out of range.
    # 
    # @param index the zero-based index
    # @return the element at the given index, or <code>null</code> if the
    # index is out of range
    def get_element_at(index)
      if (index >= 0 && index < @list_map.size)
        return @list_map.get(index)
      end
      return nil
    end
    
    typesig { [] }
    # The list viewer implementation of this <code>Viewer</code> framework
    # method returns the label provider, which in the case of list
    # viewers will be an instance of <code>ILabelProvider</code>.
    def get_label_provider
      return super
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on Viewer.
    # 
    # (non-Javadoc)
    # Method declared on StructuredViewer.
    def get_selection_from_widget
      ixs = list_get_selection_indices
      list = ArrayList.new(ixs.attr_length)
      i = 0
      while i < ixs.attr_length
        e = get_element_at(ixs[i])
        if (!(e).nil?)
          list.add(e)
        end
        i += 1
      end
      return list
    end
    
    typesig { [Object] }
    # @param element the element to insert
    # @return the index where the item should be inserted.
    def index_for_element(element)
      comparator = get_comparator
      if ((comparator).nil?)
        return list_get_item_count
      end
      count = list_get_item_count
      min = 0
      max = count - 1
      while (min <= max)
        mid = (min + max) / 2
        data = @list_map.get(mid)
        compare_ = comparator.compare(self, data, element)
        if ((compare_).equal?(0))
          # find first item > element
          while ((compare_).equal?(0))
            (mid += 1)
            if (mid >= count)
              break
            end
            data = @list_map.get(mid)
            compare_ = comparator.compare(self, data, element)
          end
          return mid
        end
        if (compare_ < 0)
          min = mid + 1
        else
          max = mid - 1
        end
      end
      return min
    end
    
    typesig { [Object, Object] }
    # (non-Javadoc)
    # Method declared on Viewer.
    def input_changed(input, old_input)
      @list_map.clear
      children = get_sorted_children(get_root)
      size_ = children.attr_length
      list_remove_all
      labels = Array.typed(String).new(size_) { nil }
      i = 0
      while i < size_
        el = children[i]
        labels[i] = get_label_provider_text(get_label_provider, el)
        @list_map.add(el)
        map_element(el, get_control) # must map it, since findItem only looks in map, if enabled
        i += 1
      end
      list_set_items(labels)
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # Method declared on StructuredViewer.
    def internal_refresh(element)
      list = get_control
      if ((element).nil? || self.==(element, get_root))
        # the parent
        if (!(@list_map).nil?)
          @list_map.clear
        end
        unmap_all_elements
        selection = get_selection_from_widget
        top_index = -1
        if ((selection).nil? || selection.is_empty)
          top_index = list_get_top_index
        end
        children = nil
        list.set_redraw(false)
        begin
          list_remove_all
          children = get_sorted_children(get_root)
          items = Array.typed(String).new(children.attr_length) { nil }
          label_provider = get_label_provider
          i = 0
          while i < items.attr_length
            el = children[i]
            items[i] = get_label_provider_text(label_provider, el)
            @list_map.add(el)
            map_element(el, list) # must map it, since findItem only looks in map, if enabled
            i += 1
          end
          list_set_items(items)
        ensure
          list.set_redraw(true)
        end
        if ((top_index).equal?(-1))
          set_selection_to_widget(selection, false)
        else
          list_set_top_index(Math.min(top_index, children.attr_length))
        end
      else
        do_update_item(list, element, true)
      end
    end
    
    typesig { [] }
    # Returns the index of the item currently at the top of the viewable area.
    # <p>
    # Default implementation returns -1.
    # </p>
    # @return index, -1 for none
    # @since 3.3
    def list_get_top_index
      return -1
    end
    
    typesig { [::Java::Int] }
    # Sets the index of the item to be at the top of the viewable area.
    # <p>
    # Default implementation does nothing.
    # </p>
    # @param index the given index. -1 for none.  index will always refer to a valid index.
    # @since 3.3
    def list_set_top_index(index)
    end
    
    typesig { [Array.typed(Object)] }
    # Removes the given elements from this list viewer.
    # 
    # @param elements the elements to remove
    def internal_remove(elements)
      input = get_input
      i = 0
      while i < elements.attr_length
        if (self.==(elements[i], input))
          set_input(nil)
          return
        end
        ix = get_element_index(elements[i])
        if (ix >= 0)
          list_remove(ix)
          @list_map.remove(ix)
          unmap_element(elements[i], get_control)
        end
        (i += 1)
      end
    end
    
    typesig { [Array.typed(Object)] }
    # Removes the given elements from this list viewer.
    # The selection is updated if required.
    # <p>
    # This method should be called (by the content provider) when elements
    # have been removed from the model, in order to cause the viewer to accurately
    # reflect the model. This method only affects the viewer, not the model.
    # </p>
    # 
    # @param elements the elements to remove
    def remove(elements)
      assert_elements_not_null(elements)
      if ((elements.attr_length).equal?(0))
        return
      end
      preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members AbstractListViewer
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          internal_remove(elements)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Object] }
    # Removes the given element from this list viewer.
    # The selection is updated if necessary.
    # <p>
    # This method should be called (by the content provider) when a single element
    # has been removed from the model, in order to cause the viewer to accurately
    # reflect the model. This method only affects the viewer, not the model.
    # Note that there is another method for efficiently processing the simultaneous
    # removal of multiple elements.
    # </p>
    # 
    # @param element the element
    def remove(element)
      remove(Array.typed(Object).new([element]))
    end
    
    typesig { [IBaseLabelProvider] }
    # The list viewer implementation of this <code>Viewer</code> framework
    # method ensures that the given label provider is an instance of
    # <code>ILabelProvider</code>.
    # 
    # <b>The optional interfaces {@link IColorProvider} and
    # {@link IFontProvider} have no effect for this type of viewer</b>
    def set_label_provider(label_provider)
      Assert.is_true(label_provider.is_a?(ILabelProvider))
      super(label_provider)
    end
    
    typesig { [JavaList, ::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on StructuredViewer.
    def set_selection_to_widget(in_, reveal)
      if ((in_).nil? || (in_.size).equal?(0))
        # clear selection
        list_deselect_all
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
        list_set_selection(ixs)
        if (reveal)
          list_show_selection
        end
      end
    end
    
    typesig { [Object] }
    # Returns the index of the given element in listMap, or -1 if the element cannot be found.
    # As of 3.3, uses the element comparer if available.
    # 
    # @param element
    # @return the index
    def get_element_index(element)
      comparer = get_comparer
      if ((comparer).nil?)
        return @list_map.index_of(element)
      end
      size_ = @list_map.size
      i = 0
      while i < size_
        if ((comparer == element))
          return i
        end
        i += 1
      end
      return -1
    end
    
    typesig { [Object] }
    # @param element
    # @return true if listMap contains the given element
    # 
    # @since 3.3
    def list_map_contains(element)
      return !(get_element_index(element)).equal?(-1)
    end
    
    typesig { [] }
    def initialize
      @list_map = nil
      super()
      @list_map = ArrayList.new
    end
    
    private
    alias_method :initialize__abstract_list_viewer, :initialize
  end
  
end
