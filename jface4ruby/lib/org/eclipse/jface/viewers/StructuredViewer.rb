require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl - bug 151205
module Org::Eclipse::Jface::Viewers
  module StructuredViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Util, :IOpenEventListener
      include_const ::Org::Eclipse::Jface::Util, :OpenStrategy
      include_const ::Org::Eclipse::Jface::Util, :SafeRunnable
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :TableTreeItem
      include_const ::Org::Eclipse::Swt::Dnd, :DragSource
      include_const ::Org::Eclipse::Swt::Dnd, :DragSourceListener
      include_const ::Org::Eclipse::Swt::Dnd, :DropTarget
      include_const ::Org::Eclipse::Swt::Dnd, :DropTargetListener
      include_const ::Org::Eclipse::Swt::Dnd, :Transfer
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Swt::Widgets, :TreeItem
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # Abstract base implementation for structure-oriented viewers (trees, lists,
  # tables). Supports custom sorting, filtering, and rendering.
  # <p>
  # Any number of viewer filters can be added to this viewer (using
  # <code>addFilter</code>). When the viewer receives an update, it asks each
  # of its filters if it is out of date, and refilters elements as required.
  # </p>
  # 
  # @see ViewerFilter
  # @see ViewerComparator
  class StructuredViewer < StructuredViewerImports.const_get :ContentViewer
    include_class_members StructuredViewerImports
    overload_protected {
      include IPostSelectionProvider
    }
    
    # A map from the viewer's model elements to SWT widgets. (key type:
    # <code>Object</code>, value type: <code>Widget</code>, or <code>Widget[]</code>).
    # <code>null</code> means that the element map is disabled.
    attr_accessor :element_map
    alias_method :attr_element_map, :element_map
    undef_method :element_map
    alias_method :attr_element_map=, :element_map=
    undef_method :element_map=
    
    # The comparer to use for comparing elements, or <code>null</code> to use
    # the default <code>equals</code> and <code>hashCode</code> methods on
    # the element itself.
    attr_accessor :comparer
    alias_method :attr_comparer, :comparer
    undef_method :comparer
    alias_method :attr_comparer=, :comparer=
    undef_method :comparer=
    
    # This viewer's comparator used for sorting. <code>null</code> means there is no comparator.
    attr_accessor :sorter
    alias_method :attr_sorter, :sorter
    undef_method :sorter
    alias_method :attr_sorter=, :sorter=
    undef_method :sorter=
    
    # This viewer's filters (element type: <code>ViewerFilter</code>).
    # <code>null</code> means there are no filters.
    attr_accessor :filters
    alias_method :attr_filters, :filters
    undef_method :filters
    alias_method :attr_filters=, :filters=
    undef_method :filters=
    
    # Indicates whether the viewer should attempt to preserve the selection
    # across update operations.
    # 
    # @see #setSelection(ISelection, boolean)
    attr_accessor :preserve_selection
    alias_method :attr_preserve_selection, :preserve_selection
    undef_method :preserve_selection
    alias_method :attr_preserve_selection=, :preserve_selection=
    undef_method :preserve_selection=
    
    # Indicates whether a selection change is in progress on this viewer.
    # 
    # @see #setSelection(ISelection, boolean)
    attr_accessor :in_change
    alias_method :attr_in_change, :in_change
    undef_method :in_change
    alias_method :attr_in_change=, :in_change=
    undef_method :in_change=
    
    # Used while a selection change is in progress on this viewer to indicates
    # whether the selection should be restored.
    # 
    # @see #setSelection(ISelection, boolean)
    attr_accessor :restore_selection
    alias_method :attr_restore_selection, :restore_selection
    undef_method :restore_selection
    alias_method :attr_restore_selection=, :restore_selection=
    undef_method :restore_selection=
    
    # List of double-click state listeners (element type:
    # <code>IDoubleClickListener</code>).
    # 
    # @see #fireDoubleClick
    attr_accessor :double_click_listeners
    alias_method :attr_double_click_listeners, :double_click_listeners
    undef_method :double_click_listeners
    alias_method :attr_double_click_listeners=, :double_click_listeners=
    undef_method :double_click_listeners=
    
    # List of open listeners (element type:
    # <code>ISelectionActivateListener</code>).
    # 
    # @see #fireOpen
    attr_accessor :open_listeners
    alias_method :attr_open_listeners, :open_listeners
    undef_method :open_listeners
    alias_method :attr_open_listeners=, :open_listeners=
    undef_method :open_listeners=
    
    # List of post selection listeners (element type:
    # <code>ISelectionActivateListener</code>).
    # 
    # @see #firePostSelectionChanged
    attr_accessor :post_selection_changed_listeners
    alias_method :attr_post_selection_changed_listeners, :post_selection_changed_listeners
    undef_method :post_selection_changed_listeners
    alias_method :attr_post_selection_changed_listeners=, :post_selection_changed_listeners=
    undef_method :post_selection_changed_listeners=
    
    # The colorAndFontCollector is an object used by viewers that
    # support the IColorProvider, the IFontProvider and/or the
    # IViewerLabelProvider for color and font updates.
    # Initialize it to have no color or font providing
    # initially.
    # @since 3.1
    attr_accessor :color_and_font_collector
    alias_method :attr_color_and_font_collector, :color_and_font_collector
    undef_method :color_and_font_collector
    alias_method :attr_color_and_font_collector=, :color_and_font_collector=
    undef_method :color_and_font_collector=
    
    # Calls when associate() and disassociate() are called
    attr_accessor :associate_listener
    alias_method :attr_associate_listener, :associate_listener
    undef_method :associate_listener
    alias_method :attr_associate_listener=, :associate_listener=
    undef_method :associate_listener=
    
    class_module.module_eval {
      # Empty array of widgets.
      
      def no_widgets
        defined?(@@no_widgets) ? @@no_widgets : @@no_widgets= Array.typed(Widget).new(0) { nil }
      end
      alias_method :attr_no_widgets, :no_widgets
      
      def no_widgets=(value)
        @@no_widgets = value
      end
      alias_method :attr_no_widgets=, :no_widgets=
      
      # The ColorAndFontCollector is a helper class for viewers
      # that have color and font support ad optionally decorators.
      # @see IColorDecorator
      # @see IFontDecorator
      # @see IColorProvider
      # @see IFontProvider
      # @see IDecoration
      const_set_lazy(:ColorAndFontCollectorWithProviders) { Class.new(ColorAndFontCollector) do
        local_class_in StructuredViewer
        include_class_members StructuredViewer
        
        attr_accessor :color_provider
        alias_method :attr_color_provider, :color_provider
        undef_method :color_provider
        alias_method :attr_color_provider=, :color_provider=
        undef_method :color_provider=
        
        attr_accessor :font_provider
        alias_method :attr_font_provider, :font_provider
        undef_method :font_provider
        alias_method :attr_font_provider=, :font_provider=
        undef_method :font_provider=
        
        typesig { [class_self::IBaseLabelProvider] }
        # Create a new instance of the receiver using the supplied
        # label provider. If it is an IColorProvider or IFontProvider
        # set these values up.
        # @param provider IBaseLabelProvider
        # @see IColorProvider
        # @see IFontProvider
        def initialize(provider)
          @color_provider = nil
          @font_provider = nil
          super()
          if (provider.is_a?(self.class::IColorProvider))
            @color_provider = provider
          end
          if (provider.is_a?(self.class::IFontProvider))
            @font_provider = provider
          end
        end
        
        typesig { [Object] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.StructuredViewer.ColorAndFontManager#setFontsAndColors(java.lang.Object)
        def set_fonts_and_colors(element)
          if (!(@font_provider).nil?)
            if ((self.attr_font).nil?)
              self.attr_font = @font_provider.get_font(element)
            end
          end
          if ((@color_provider).nil?)
            return
          end
          # Set the colors if they are not set yet
          if ((self.attr_background).nil?)
            self.attr_background = @color_provider.get_background(element)
          end
          if ((self.attr_foreground).nil?)
            self.attr_foreground = @color_provider.get_foreground(element)
          end
        end
        
        typesig { [class_self::TableItem] }
        # Apply the fonts and colors to the control if
        # required.
        # @param control
        def apply_fonts_and_colors(control)
          if ((@color_provider).nil?)
            if (self.attr_used_decorators)
              # If there is no provider only apply set values
              if (!(self.attr_background).nil?)
                control.set_background(self.attr_background)
              end
              if (!(self.attr_foreground).nil?)
                control.set_foreground(self.attr_foreground)
              end
            end
          else
            # Always set the value if there is a provider
            control.set_background(self.attr_background)
            control.set_foreground(self.attr_foreground)
          end
          if ((@font_provider).nil?)
            if (self.attr_used_decorators && !(self.attr_font).nil?)
              control.set_font(self.attr_font)
            end
          else
            control.set_font(self.attr_font)
          end
          clear
        end
        
        typesig { [class_self::TreeItem] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.StructuredViewer.ColorAndFontManager#applyFontsAndColors(org.eclipse.swt.widgets.TreeItem)
        def apply_fonts_and_colors(control)
          if ((@color_provider).nil?)
            if (self.attr_used_decorators)
              # If there is no provider only apply set values
              if (!(self.attr_background).nil?)
                control.set_background(self.attr_background)
              end
              if (!(self.attr_foreground).nil?)
                control.set_foreground(self.attr_foreground)
              end
            end
          else
            # Always set the value if there is a provider
            control.set_background(self.attr_background)
            control.set_foreground(self.attr_foreground)
          end
          if ((@font_provider).nil?)
            if (self.attr_used_decorators && !(self.attr_font).nil?)
              control.set_font(self.attr_font)
            end
          else
            control.set_font(self.attr_font)
          end
          clear
        end
        
        typesig { [class_self::TableTreeItem] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.StructuredViewer.ColorAndFontManager#applyFontsAndColors(org.eclipse.swt.custom.TableTreeItem)
        def apply_fonts_and_colors(control)
          if ((@color_provider).nil?)
            if (self.attr_used_decorators)
              # If there is no provider only apply set values
              if (!(self.attr_background).nil?)
                control.set_background(self.attr_background)
              end
              if (!(self.attr_foreground).nil?)
                control.set_foreground(self.attr_foreground)
              end
            end
          else
            # Always set the value if there is a provider
            control.set_background(self.attr_background)
            control.set_foreground(self.attr_foreground)
          end
          if ((@font_provider).nil?)
            if (self.attr_used_decorators && !(self.attr_font).nil?)
              control.set_font(self.attr_font)
            end
          else
            control.set_font(self.attr_font)
          end
          clear
        end
        
        private
        alias_method :initialize__color_and_font_collector_with_providers, :initialize
      end }
      
      # The ColorAndFontCollector collects fonts and colors without a
      # a color or font provider.
      const_set_lazy(:ColorAndFontCollector) { Class.new do
        local_class_in StructuredViewer
        include_class_members StructuredViewer
        
        attr_accessor :foreground
        alias_method :attr_foreground, :foreground
        undef_method :foreground
        alias_method :attr_foreground=, :foreground=
        undef_method :foreground=
        
        attr_accessor :background
        alias_method :attr_background, :background
        undef_method :background
        alias_method :attr_background=, :background=
        undef_method :background=
        
        attr_accessor :font
        alias_method :attr_font, :font
        undef_method :font
        alias_method :attr_font=, :font=
        undef_method :font=
        
        attr_accessor :used_decorators
        alias_method :attr_used_decorators, :used_decorators
        undef_method :used_decorators
        alias_method :attr_used_decorators=, :used_decorators=
        undef_method :used_decorators=
        
        typesig { [] }
        # Create a new instance of the receiver with
        # no color and font provider.
        def initialize
          @foreground = nil
          @background = nil
          @font = nil
          @used_decorators = false
        end
        
        typesig { [] }
        # Clear all of the results.
        def clear
          @foreground = nil
          @background = nil
          @font = nil
          @used_decorators = false
        end
        
        typesig { [Object] }
        # Set the initial fonts and colors for the element from the
        # content providers.
        # @param element Object
        def set_fonts_and_colors(element)
          # Do nothing if there are no providers
        end
        
        typesig { [] }
        # Set that decorators were applied.
        def set_used_decorators
          @used_decorators = true
        end
        
        typesig { [class_self::TableItem] }
        # Apply the fonts and colors to the control if
        # required.
        # @param control
        def apply_fonts_and_colors(control)
          if (@used_decorators)
            # If there is no provider only apply set values
            if (!(@background).nil?)
              control.set_background(@background)
            end
            if (!(@foreground).nil?)
              control.set_foreground(@foreground)
            end
            if (!(@font).nil?)
              control.set_font(@font)
            end
          end
          clear
        end
        
        typesig { [class_self::TreeItem] }
        # Apply the fonts and colors to the control if
        # required.
        # @param control
        def apply_fonts_and_colors(control)
          if (@used_decorators)
            # If there is no provider only apply set values
            if (!(@background).nil?)
              control.set_background(@background)
            end
            if (!(@foreground).nil?)
              control.set_foreground(@foreground)
            end
            if (!(@font).nil?)
              control.set_font(@font)
            end
          end
          clear
        end
        
        typesig { [class_self::TableTreeItem] }
        # Apply the fonts and colors to the control if
        # required.
        # @param control
        def apply_fonts_and_colors(control)
          if (@used_decorators)
            # If there is no provider only apply set values
            if (!(@background).nil?)
              control.set_background(@background)
            end
            if (!(@foreground).nil?)
              control.set_foreground(@foreground)
            end
            if (!(@font).nil?)
              control.set_font(@font)
            end
          end
          clear
        end
        
        typesig { [class_self::Color] }
        # Set the background color.
        # @param background
        def set_background(background)
          @background = background
        end
        
        typesig { [class_self::Font] }
        # Set the font.
        # @param font
        def set_font(font)
          @font = font
        end
        
        typesig { [class_self::Color] }
        # Set the foreground color.
        # @param foreground
        def set_foreground(foreground)
          @foreground = foreground
        end
        
        private
        alias_method :initialize__color_and_font_collector, :initialize
      end }
      
      # The safe runnable used to update an item.
      const_set_lazy(:UpdateItemSafeRunnable) { Class.new(SafeRunnable) do
        local_class_in StructuredViewer
        include_class_members StructuredViewer
        
        attr_accessor :widget
        alias_method :attr_widget, :widget
        undef_method :widget
        alias_method :attr_widget=, :widget=
        undef_method :widget=
        
        attr_accessor :element
        alias_method :attr_element, :element
        undef_method :element
        alias_method :attr_element=, :element=
        undef_method :element=
        
        attr_accessor :full_map
        alias_method :attr_full_map, :full_map
        undef_method :full_map
        alias_method :attr_full_map=, :full_map=
        undef_method :full_map=
        
        typesig { [class_self::Widget, Object, ::Java::Boolean] }
        def initialize(widget, element, full_map)
          @widget = nil
          @element = nil
          @full_map = false
          super()
          @widget = widget
          @element = element
          @full_map = full_map
        end
        
        typesig { [] }
        def run
          do_update_item(@widget, @element, @full_map)
        end
        
        private
        alias_method :initialize__update_item_safe_runnable, :initialize
      end }
    }
    
    typesig { [] }
    # Creates a structured element viewer. The viewer has no input, no content
    # provider, a default label provider, no sorter, and no filters.
    def initialize
      @element_map = nil
      @comparer = nil
      @sorter = nil
      @filters = nil
      @preserve_selection = false
      @in_change = false
      @restore_selection = false
      @double_click_listeners = nil
      @open_listeners = nil
      @post_selection_changed_listeners = nil
      @color_and_font_collector = nil
      @associate_listener = nil
      @refresh_occurred = false
      super()
      @preserve_selection = true
      @double_click_listeners = ListenerList.new
      @open_listeners = ListenerList.new
      @post_selection_changed_listeners = ListenerList.new
      @color_and_font_collector = ColorAndFontCollector.new_local(self)
      # do nothing
    end
    
    typesig { [IDoubleClickListener] }
    # Adds a listener for double-clicks in this viewer. Has no effect if an
    # identical listener is already registered.
    # 
    # @param listener
    # a double-click listener
    def add_double_click_listener(listener)
      @double_click_listeners.add(listener)
    end
    
    typesig { [IOpenListener] }
    # Adds a listener for selection-open in this viewer. Has no effect if an
    # identical listener is already registered.
    # 
    # @param listener
    # an open listener
    def add_open_listener(listener)
      @open_listeners.add(listener)
    end
    
    typesig { [ISelectionChangedListener] }
    # (non-Javadoc) Method declared on IPostSelectionProvider.
    def add_post_selection_changed_listener(listener)
      @post_selection_changed_listeners.add(listener)
    end
    
    typesig { [::Java::Int, Array.typed(Transfer), DragSourceListener] }
    # Adds support for dragging items out of this viewer via a user
    # drag-and-drop operation.
    # 
    # @param operations
    # a bitwise OR of the supported drag and drop operation types (
    # <code>DROP_COPY</code>,<code>DROP_LINK</code>, and
    # <code>DROP_MOVE</code>)
    # @param transferTypes
    # the transfer types that are supported by the drag operation
    # @param listener
    # the callback that will be invoked to set the drag data and to
    # cleanup after the drag and drop operation finishes
    # @see org.eclipse.swt.dnd.DND
    def add_drag_support(operations, transfer_types, listener)
      my_control = get_control
      drag_source = DragSource.new(my_control, operations)
      drag_source.set_transfer(transfer_types)
      drag_source.add_drag_listener(listener)
    end
    
    typesig { [::Java::Int, Array.typed(Transfer), DropTargetListener] }
    # Adds support for dropping items into this viewer via a user drag-and-drop
    # operation.
    # 
    # @param operations
    # a bitwise OR of the supported drag and drop operation types (
    # <code>DROP_COPY</code>,<code>DROP_LINK</code>, and
    # <code>DROP_MOVE</code>)
    # @param transferTypes
    # the transfer types that are supported by the drop operation
    # @param listener
    # the callback that will be invoked after the drag and drop
    # operation finishes
    # @see org.eclipse.swt.dnd.DND
    def add_drop_support(operations, transfer_types, listener)
      control = get_control
      drop_target = DropTarget.new(control, operations)
      drop_target.set_transfer(transfer_types)
      drop_target.add_drop_listener(listener)
    end
    
    typesig { [ViewerFilter] }
    # Adds the given filter to this viewer, and triggers refiltering and
    # resorting of the elements. If you want to add more than one filter
    # consider using {@link StructuredViewer#setFilters(ViewerFilter[])}.
    # 
    # @param filter
    # a viewer filter
    # @see StructuredViewer#setFilters(ViewerFilter[])
    def add_filter(filter)
      if ((@filters).nil?)
        @filters = ArrayList.new
      end
      @filters.add(filter)
      refresh
    end
    
    typesig { [Array.typed(Object)] }
    # Asserts that the given array of elements is itself non- <code>null</code>
    # and contains no <code>null</code> elements.
    # 
    # @param elements
    # the array to check
    def assert_elements_not_null(elements)
      Assert.is_not_null(elements)
      i = 0
      n = elements.attr_length
      while i < n
        Assert.is_not_null(elements[i])
        (i += 1)
      end
    end
    
    typesig { [Object, Item] }
    # Associates the given element with the given widget. Sets the given item's
    # data to be the element, and maps the element to the item in the element
    # map (if enabled).
    # 
    # @param element
    # the element
    # @param item
    # the widget
    def associate(element, item)
      data = item.get_data
      if (!(data).equal?(element))
        if (!(data).nil?)
          disassociate(item)
        end
        item.set_data(element)
        map_element(element, item)
        if (!(@associate_listener).nil?)
          @associate_listener.associate(element, item)
        end
      else
        # Always map the element, even if data == element,
        # since unmapAllElements() can leave the map inconsistent
        # See bug 2741 for details.
        map_element(element, item)
      end
    end
    
    typesig { [Item] }
    # Disassociates the given SWT item from its corresponding element. Sets the
    # item's data to <code>null</code> and removes the element from the
    # element map (if enabled).
    # 
    # @param item
    # the widget
    def disassociate(item)
      if (!(@associate_listener).nil?)
        @associate_listener.disassociate(item)
      end
      element = item.get_data
      Assert.is_not_null(element)
      # Clear the map before we clear the data
      unmap_element(element, item)
      item.set_data(nil)
    end
    
    typesig { [Object] }
    # Returns the widget in this viewer's control which represents the given
    # element if it is the viewer's input.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # 
    # @param element
    # @return the corresponding widget, or <code>null</code> if none
    def do_find_input_item(element)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Returns the widget in this viewer's control which represent the given
    # element. This method searches all the children of the input element.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # 
    # @param element
    # @return the corresponding widget, or <code>null</code> if none
    def do_find_item(element)
      raise NotImplementedError
    end
    
    typesig { [Widget, Object, ::Java::Boolean] }
    # Copies the attributes of the given element into the given SWT item. The
    # element map is updated according to the value of <code>fullMap</code>.
    # If <code>fullMap</code> is <code>true</code> then the current mapping
    # from element to widgets is removed and the new mapping is added. If
    # full map is <code>false</code> then only the new map gets installed.
    # Installing only the new map is necessary in cases where only the order of
    # elements changes but not the set of elements.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # 
    # @param item
    # @param element element
    # @param fullMap
    # <code>true</code> if mappings are added and removed, and
    # <code>false</code> if only the new map gets installed
    def do_update_item(item, element, full_map)
      raise NotImplementedError
    end
    
    typesig { [Object, Object] }
    # Compares two elements for equality. Uses the element comparer if one has
    # been set, otherwise uses the default <code>equals</code> method on the
    # elements themselves.
    # 
    # @param elementA
    # the first element
    # @param elementB
    # the second element
    # @return whether elementA is equal to elementB
    def ==(element_a, element_b)
      if ((@comparer).nil?)
        return (element_a).nil? ? (element_b).nil? : (element_a == element_b)
      else
        return (element_a).nil? ? (element_b).nil? : @comparer.==(element_a, element_b)
      end
    end
    
    typesig { [Array.typed(Object)] }
    # Returns the result of running the given elements through the filters.
    # 
    # @param elements
    # the elements to filter
    # @return only the elements which all filters accept
    def filter(elements)
      if (!(@filters).nil?)
        filtered = ArrayList.new(elements.attr_length)
        root = get_root
        i = 0
        while i < elements.attr_length
          add_ = true
          j = 0
          while j < @filters.size
            add_ = (@filters.get(j)).select(self, root, elements[i])
            if (!add_)
              break
            end
            j += 1
          end
          if (add_)
            filtered.add(elements[i])
          end
          i += 1
        end
        return filtered.to_array
      end
      return elements
    end
    
    typesig { [Object] }
    # Finds the widget which represents the given element.
    # <p>
    # The default implementation of this method tries first to find the widget
    # for the given element assuming that it is the viewer's input; this is
    # done by calling <code>doFindInputItem</code>. If it is not found
    # there, it is looked up in the internal element map provided that this
    # feature has been enabled. If the element map is disabled, the widget is
    # found via <code>doFindInputItem</code>.
    # </p>
    # 
    # @param element
    # the element
    # @return the corresponding widget, or <code>null</code> if none
    def find_item(element)
      result = find_items(element)
      return (result.attr_length).equal?(0) ? nil : result[0]
    end
    
    typesig { [Object] }
    # Finds the widgets which represent the given element. The returned array
    # must not be changed by clients; it might change upon calling other
    # methods on this viewer.
    # <p>
    # This method was introduced to support multiple equal elements in a viewer
    # (@see {@link AbstractTreeViewer}). Multiple equal elements are only
    # supported if the element map is enabled by calling
    # {@link #setUseHashlookup(boolean)} and passing <code>true</code>.
    # </p>
    # <p>
    # The default implementation of this method tries first to find the widget
    # for the given element assuming that it is the viewer's input; this is
    # done by calling <code>doFindInputItem</code>. If it is not found
    # there, the widgets are looked up in the internal element map provided
    # that this feature has been enabled. If the element map is disabled, the
    # widget is found via <code>doFindInputItem</code>.
    # </p>
    # 
    # @param element
    # the element
    # @return the corresponding widgets
    # 
    # @since 3.2
    def find_items(element)
      result = do_find_input_item(element)
      if (!(result).nil?)
        return Array.typed(Widget).new([result])
      end
      # if we have an element map use it, otherwise search for the item.
      if (using_element_map)
        widget_or_widgets = @element_map.get(element)
        if ((widget_or_widgets).nil?)
          return self.attr_no_widgets
        else
          if (widget_or_widgets.is_a?(Widget))
            return Array.typed(Widget).new([widget_or_widgets])
          else
            return widget_or_widgets
          end
        end
      end
      result = do_find_item(element)
      return (result).nil? ? self.attr_no_widgets : Array.typed(Widget).new([result])
    end
    
    typesig { [DoubleClickEvent] }
    # Notifies any double-click listeners that a double-click has been
    # received. Only listeners registered at the time this method is called are
    # notified.
    # 
    # @param event
    # a double-click event
    # 
    # @see IDoubleClickListener#doubleClick
    def fire_double_click(event)
      listeners = @double_click_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        l = listeners[i]
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          local_class_in StructuredViewer
          include_class_members StructuredViewer
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.double_click(event)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        (i += 1)
      end
    end
    
    typesig { [OpenEvent] }
    # Notifies any open event listeners that a open event has been received.
    # Only listeners registered at the time this method is called are notified.
    # 
    # @param event
    # a double-click event
    # 
    # @see IOpenListener#open(OpenEvent)
    def fire_open(event)
      listeners = @open_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        l = listeners[i]
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          local_class_in StructuredViewer
          include_class_members StructuredViewer
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.open(event)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        (i += 1)
      end
    end
    
    typesig { [SelectionChangedEvent] }
    # Notifies any post selection listeners that a post selection event has
    # been received. Only listeners registered at the time this method is
    # called are notified.
    # 
    # @param event
    # a selection changed event
    # 
    # @see #addPostSelectionChangedListener(ISelectionChangedListener)
    def fire_post_selection_changed(event)
      listeners = @post_selection_changed_listeners.get_listeners
      i = 0
      while i < listeners.attr_length
        l = listeners[i]
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          local_class_in StructuredViewer
          include_class_members StructuredViewer
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            l.selection_changed(event)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        (i += 1)
      end
    end
    
    typesig { [] }
    # Returns the comparer to use for comparing elements, or
    # <code>null</code> if none has been set.  If specified,
    # the viewer uses this to compare and hash elements rather
    # than the elements' own equals and hashCode methods.
    # 
    # @return the comparer to use for comparing elements or
    # <code>null</code>
    def get_comparer
      return @comparer
    end
    
    typesig { [Object] }
    # Returns the filtered array of children of the given element. The
    # resulting array must not be modified, as it may come directly from the
    # model's internal state.
    # 
    # @param parent
    # the parent element
    # @return a filtered array of child elements
    def get_filtered_children(parent)
      result = get_raw_children(parent)
      if (!(@filters).nil?)
        iter = @filters.iterator
        while iter.has_next
          f = iter.next_
          result = f.filter(self, parent, result)
        end
      end
      return result
    end
    
    typesig { [] }
    # Returns this viewer's filters.
    # 
    # @return an array of viewer filters
    # @see StructuredViewer#setFilters(ViewerFilter[])
    def get_filters
      if ((@filters).nil?)
        return Array.typed(ViewerFilter).new(0) { nil }
      end
      result = Array.typed(ViewerFilter).new(@filters.size) { nil }
      @filters.to_array(result)
      return result
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the item at the given display-relative coordinates, or
    # <code>null</code> if there is no item at that location or
    # the underlying SWT-Control is not made up of {@link Item}
    # (e.g {@link ListViewer})
    # <p>
    # The default implementation of this method returns <code>null</code>.
    # </p>
    # 
    # @param x
    # horizontal coordinate
    # @param y
    # vertical coordinate
    # @return the item, or <code>null</code> if there is no item at the given
    # coordinates
    # @deprecated This method is deprecated in 3.3 in favor of {@link ColumnViewer#getItemAt(org.eclipse.swt.graphics.Point)}.
    # Viewers who are not subclasses of {@link ColumnViewer} should consider using a
    # widget relative implementation like {@link ColumnViewer#getItemAt(org.eclipse.swt.graphics.Point)}.
    def get_item(x, y)
      return nil
    end
    
    typesig { [Object] }
    # Returns the children of the given parent without sorting and filtering
    # them. The resulting array must not be modified, as it may come directly
    # from the model's internal state.
    # <p>
    # Returns an empty array if the given parent is <code>null</code>.
    # </p>
    # 
    # @param parent
    # the parent element
    # @return the child elements
    def get_raw_children(parent)
      result = nil
      if (!(parent).nil?)
        cp = get_content_provider
        if (!(cp).nil?)
          result = cp.get_elements(parent)
          assert_elements_not_null(result)
        end
      end
      return (!(result).nil?) ? result : Array.typed(Object).new(0) { nil }
    end
    
    typesig { [] }
    # Returns the root element.
    # <p>
    # The default implementation of this framework method forwards to
    # <code>getInput</code>. Override if the root element is different from
    # the viewer's input element.
    # </p>
    # 
    # @return the root element, or <code>null</code> if none
    def get_root
      return get_input
    end
    
    typesig { [] }
    # The <code>StructuredViewer</code> implementation of this method returns
    # the result as an <code>IStructuredSelection</code>.
    # <p>
    # Subclasses do not typically override this method, but implement
    # <code>getSelectionFromWidget(List)</code> instead.
    # <p>
    # @return ISelection
    def get_selection
      control = get_control
      if ((control).nil? || control.is_disposed)
        return StructuredSelection::EMPTY
      end
      list = get_selection_from_widget
      return StructuredSelection.new(list, @comparer)
    end
    
    typesig { [] }
    # Retrieves the selection, as a <code>List</code>, from the underlying
    # widget.
    # 
    # @return the list of selected elements
    def get_selection_from_widget
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Returns the sorted and filtered set of children of the given element. The
    # resulting array must not be modified, as it may come directly from the
    # model's internal state.
    # 
    # @param parent
    # the parent element
    # @return a sorted and filtered array of child elements
    def get_sorted_children(parent)
      result = get_filtered_children(parent)
      if (!(@sorter).nil?)
        # be sure we're not modifying the original array from the model
        result = result.clone
        @sorter.sort(self, result)
      end
      return result
    end
    
    typesig { [] }
    # Returns this viewer's sorter, or <code>null</code> if it does not have
    # one.  If this viewer has a comparator that was set via
    # <code>setComparator(ViewerComparator)</code> then this method will return
    # <code>null</code> if the comparator is not an instance of ViewerSorter.
    # <p>
    # It is recommended to use <code>getComparator()</code> instead.
    # </p>
    # 
    # @return a viewer sorter, or <code>null</code> if none or if the comparator is
    # not an instance of ViewerSorter
    def get_sorter
      if (@sorter.is_a?(ViewerSorter))
        return @sorter
      end
      return nil
    end
    
    typesig { [] }
    # Return this viewer's comparator used to sort elements.
    # This method should be used instead of <code>getSorter()</code>.
    # 
    # @return a viewer comparator, or <code>null</code> if none
    # 
    # @since 3.2
    def get_comparator
      return @sorter
    end
    
    typesig { [SelectionEvent] }
    # Handles a double-click select event from the widget.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # 
    # @param event
    # the SWT selection event
    def handle_double_select(event)
      # This method is reimplemented in AbstractTreeViewer to fix bug 108102.
      # handle case where an earlier selection listener disposed the control.
      control = get_control
      if (!(control).nil? && !control.is_disposed)
        # If the double-clicked element can be obtained from the event, use it
        # otherwise get it from the control.  Some controls like List do
        # not have the notion of item.
        # For details, see bug 90161 [Navigator] DefaultSelecting folders shouldn't always expand first one
        selection = nil
        if (!(event.attr_item).nil? && !(event.attr_item.get_data).nil?)
          selection = StructuredSelection.new(event.attr_item.get_data)
        else
          selection = get_selection
          update_selection(selection)
        end
        fire_double_click(DoubleClickEvent.new(self, selection))
      end
    end
    
    typesig { [SelectionEvent] }
    # Handles an open event from the OpenStrategy.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # 
    # @param event
    # the SWT selection event
    def handle_open(event)
      control = get_control
      if (!(control).nil? && !control.is_disposed)
        selection = get_selection
        fire_open(OpenEvent.new(self, selection))
      end
    end
    
    typesig { [ISelection, ISelection] }
    # Handles an invalid selection.
    # <p>
    # This framework method is called if a model change picked up by a viewer
    # results in an invalid selection. For instance if an element contained in
    # the selection has been removed from the viewer, the viewer is free to
    # either remove the element from the selection or to pick another element
    # as its new selection. The default implementation of this method calls
    # <code>updateSelection</code>. Subclasses may override it to implement
    # a different strategy for picking a new selection when the old selection
    # becomes invalid.
    # </p>
    # 
    # @param invalidSelection
    # the selection before the viewer was updated
    # @param newSelection
    # the selection after the update, or <code>null</code> if none
    def handle_invalid_selection(invalid_selection, new_selection)
      update_selection(new_selection)
      event = SelectionChangedEvent.new(self, new_selection)
      fire_post_selection_changed(event)
    end
    
    typesig { [LabelProviderChangedEvent] }
    # The <code>StructuredViewer</code> implementation of this
    # <code>ContentViewer</code> method calls <code>update</code> if the
    # event specifies that the label of a given element has changed, otherwise
    # it calls super. Subclasses may reimplement or extend.
    # </p>
    # @param event the event that generated this update
    def handle_label_provider_changed(event)
      elements = event.get_elements
      if (!(elements).nil?)
        update(elements, nil)
      else
        super(event)
      end
    end
    
    typesig { [SelectionEvent] }
    # Handles a select event from the widget.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # 
    # @param event
    # the SWT selection event
    def handle_select(event)
      # handle case where an earlier selection listener disposed the control.
      control = get_control
      if (!(control).nil? && !control.is_disposed)
        update_selection(get_selection)
      end
    end
    
    typesig { [SelectionEvent] }
    # Handles a post select event from the widget.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # 
    # @param e the SWT selection event
    def handle_post_select(e)
      event = SelectionChangedEvent.new(self, get_selection)
      fire_post_selection_changed(event)
    end
    
    typesig { [Control] }
    # (non-Javadoc) Method declared on Viewer.
    def hook_control(control)
      super(control)
      handler = OpenStrategy.new(control)
      handler.add_selection_listener(Class.new(SelectionListener.class == Class ? SelectionListener : Object) do
        local_class_in StructuredViewer
        include_class_members StructuredViewer
        include SelectionListener if SelectionListener.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |e|
          # On Windows, selection events may happen during a refresh.
          # Ignore these events if we are currently in preservingSelection().
          # See bug 184441.
          if (!self.attr_in_change)
            handle_select(e)
          end
        end
        
        typesig { [SelectionEvent] }
        define_method :widget_default_selected do |e|
          handle_double_select(e)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      handler.add_post_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        local_class_in StructuredViewer
        include_class_members StructuredViewer
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |e|
          handle_post_select(e)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      handler.add_open_listener(Class.new(IOpenEventListener.class == Class ? IOpenEventListener : Object) do
        local_class_in StructuredViewer
        include_class_members StructuredViewer
        include IOpenEventListener if IOpenEventListener.class == Module
        
        typesig { [SelectionEvent] }
        define_method :handle_open do |e|
          @local_class_parent.handle_open(e)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [] }
    # Returns whether this viewer has any filters.
    # @return boolean
    def has_filters
      return !(@filters).nil? && @filters.size > 0
    end
    
    typesig { [Object] }
    # Refreshes this viewer starting at the given element.
    # 
    # @param element
    # the element
    def internal_refresh(element)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Refreshes this viewer starting at the given element. Labels are updated
    # as described in <code>refresh(boolean updateLabels)</code>.
    # <p>
    # The default implementation simply calls
    # <code>internalRefresh(element)</code>, ignoring
    # <code>updateLabels</code>.
    # <p>
    # If this method is overridden to do the actual refresh, then
    # <code>internalRefresh(Object element)</code> should simply call
    # <code>internalRefresh(element, true)</code>.
    # 
    # @param element
    # the element
    # @param updateLabels
    # <code>true</code> to update labels for existing elements,
    # <code>false</code> to only update labels as needed, assuming
    # that labels for existing elements are unchanged.
    # 
    # @since 2.0
    def internal_refresh(element, update_labels)
      internal_refresh(element)
    end
    
    typesig { [Object, Widget] }
    # Adds the element item pair to the element map.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # 
    # @param element
    # the element
    # @param item
    # the corresponding widget
    def map_element(element, item)
      if (!(@element_map).nil?)
        widget_or_widgets = @element_map.get(element)
        if ((widget_or_widgets).nil?)
          @element_map.put(element, item)
        else
          if (widget_or_widgets.is_a?(Widget))
            if (!(widget_or_widgets).equal?(item))
              @element_map.put(element, Array.typed(Widget).new([widget_or_widgets, item]))
            end
          else
            widgets = widget_or_widgets
            index_of_item = Arrays.as_list(widgets).index_of(item)
            if ((index_of_item).equal?(-1))
              length = widgets.attr_length
              System.arraycopy(widgets, 0, widgets = Array.typed(Widget).new(length + 1) { nil }, 0, length)
              widgets[length] = item
              @element_map.put(element, widgets)
            end
          end
        end
      end
    end
    
    typesig { [Object, String] }
    # Determines whether a change to the given property of the given element
    # would require refiltering and/or resorting.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # 
    # @param element
    # the element
    # @param property
    # the property
    # @return <code>true</code> if refiltering is required, and
    # <code>false</code> otherwise
    def needs_refilter(element, property)
      if (!(@sorter).nil? && @sorter.is_sorter_property(element, property))
        return true
      end
      if (!(@filters).nil?)
        i = 0
        n = @filters.size
        while i < n
          filter_ = @filters.get(i)
          if (filter_.is_filter_property(element, property))
            return true
          end
          (i += 1)
        end
      end
      return false
    end
    
    typesig { [::Java::Int] }
    # Returns a new hashtable using the given capacity and this viewer's element comparer.
    # 
    # @param capacity the initial capacity of the hashtable
    # @return a new hashtable
    # 
    # @since 3.0
    def new_hashtable(capacity)
      return CustomHashtable.new(capacity, get_comparer)
    end
    
    typesig { [Runnable] }
    # Attempts to preserves the current selection across a run of the given
    # code. This method should not preserve the selection if
    # {link #getPreserveSelection()} returns false.
    # <p>
    # The default implementation of this method:
    # <ul>
    # <li>discovers the old selection (via <code>getSelection</code>)</li>
    # <li>runs the given runnable</li>
    # <li>attempts to restore the old selection (using
    # <code>setSelectionToWidget</code></li>
    # <li>rediscovers the resulting selection (via <code>getSelection</code>)</li>
    # <li>calls <code>handleInvalidSelection</code> if the resulting selection
    # is different from the old selection</li>
    # </ul>
    # </p>
    # 
    # @param updateCode
    # the code to run
    # 
    # see #getPreserveSelection()
    def preserving_selection(update_code)
      preserving_selection(update_code, false)
    end
    
    typesig { [Runnable, ::Java::Boolean] }
    # Attempts to preserves the current selection across a run of the given
    # code, with a best effort to avoid scrolling if <code>reveal</code> is
    # false, or to reveal the selection if <code>reveal</code> is true.
    # <p>
    # The default implementation of this method:
    # <ul>
    # <li>discovers the old selection (via <code>getSelection</code>)</li>
    # <li>runs the given runnable</li>
    # <li>attempts to restore the old selection (using
    # <code>setSelectionToWidget</code></li>
    # <li>rediscovers the resulting selection (via <code>getSelection</code>)</li>
    # <li>calls <code>handleInvalidSelection</code> if the selection did not
    # take</li>
    # </ul>
    # </p>
    # 
    # @param updateCode
    # the code to run
    # @param reveal
    # <code>true</code> if the selection should be made visible,
    # <code>false</code> if scrolling should be avoided
    # @since 3.3
    def preserving_selection(update_code, reveal)
      if (!@preserve_selection)
        return
      end
      old_selection = nil
      begin
        # preserve selection
        old_selection = get_selection
        @in_change = @restore_selection = true
        # perform the update
        update_code.run
      ensure
        @in_change = false
        # restore selection
        if (@restore_selection)
          set_selection_to_widget(old_selection, reveal)
        end
        # send out notification if old and new differ
        new_selection = get_selection
        if (!(new_selection == old_selection))
          handle_invalid_selection(old_selection, new_selection)
        end
      end
    end
    
    typesig { [] }
    # Non-Javadoc. Method declared on Viewer.
    def refresh
      refresh(get_root)
    end
    
    typesig { [::Java::Boolean] }
    # Refreshes this viewer with information freshly obtained from this
    # viewer's model. If <code>updateLabels</code> is <code>true</code>
    # then labels for otherwise unaffected elements are updated as well.
    # Otherwise, it assumes labels for existing elements are unchanged, and
    # labels are only obtained as needed (for example, for new elements).
    # <p>
    # Calling <code>refresh(true)</code> has the same effect as
    # <code>refresh()</code>.
    # <p>
    # Note that the implementation may still obtain labels for existing
    # elements even if <code>updateLabels</code> is false. The intent is
    # simply to allow optimization where possible.
    # 
    # @param updateLabels
    # <code>true</code> to update labels for existing elements,
    # <code>false</code> to only update labels as needed, assuming
    # that labels for existing elements are unchanged.
    # 
    # @since 2.0
    def refresh(update_labels)
      refresh(get_root, update_labels)
    end
    
    typesig { [Object] }
    # Refreshes this viewer starting with the given element.
    # <p>
    # Unlike the <code>update</code> methods, this handles structural changes
    # to the given element (e.g. addition or removal of children). If only the
    # given element needs updating, it is more efficient to use the
    # <code>update</code> methods.
    # </p>
    # 
    # @param element
    # the element
    def refresh(element)
      preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in StructuredViewer
        include_class_members StructuredViewer
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          internal_refresh(element)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Refreshes this viewer starting with the given element. Labels are updated
    # as described in <code>refresh(boolean updateLabels)</code>.
    # <p>
    # Unlike the <code>update</code> methods, this handles structural changes
    # to the given element (e.g. addition or removal of children). If only the
    # given element needs updating, it is more efficient to use the
    # <code>update</code> methods.
    # </p>
    # 
    # @param element
    # the element
    # @param updateLabels
    # <code>true</code> to update labels for existing elements,
    # <code>false</code> to only update labels as needed, assuming
    # that labels for existing elements are unchanged.
    # 
    # @since 2.0
    def refresh(element, update_labels)
      preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in StructuredViewer
        include_class_members StructuredViewer
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          internal_refresh(element, update_labels)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Widget, Object] }
    # Refreshes the given item with the given element. Calls
    # <code>doUpdateItem(..., false)</code>.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # @param widget
    # the widget
    # @param element
    # the element
    def refresh_item(widget, element)
      SafeRunnable.run(UpdateItemSafeRunnable.new_local(self, widget, element, true))
    end
    
    typesig { [IOpenListener] }
    # Removes the given open listener from this viewer. Has no affect if an
    # identical listener is not registered.
    # 
    # @param listener
    # an open listener
    def remove_open_listener(listener)
      @open_listeners.remove(listener)
    end
    
    typesig { [ISelectionChangedListener] }
    # (non-Javadoc) Method declared on IPostSelectionProvider.
    def remove_post_selection_changed_listener(listener)
      @post_selection_changed_listeners.remove(listener)
    end
    
    typesig { [IDoubleClickListener] }
    # Removes the given double-click listener from this viewer. Has no affect
    # if an identical listener is not registered.
    # 
    # @param listener
    # a double-click listener
    def remove_double_click_listener(listener)
      @double_click_listeners.remove(listener)
    end
    
    typesig { [ViewerFilter] }
    # Removes the given filter from this viewer, and triggers refiltering and
    # resorting of the elements if required. Has no effect if the identical
    # filter is not registered. If you want to remove more than one filter
    # consider using {@link StructuredViewer#setFilters(ViewerFilter[])}.
    # 
    # @param filter
    # a viewer filter
    # @see StructuredViewer#setFilters(ViewerFilter[])
    def remove_filter(filter_)
      Assert.is_not_null(filter_)
      if (!(@filters).nil?)
        # Note: can't use List.remove(Object). Use identity comparison
        # instead.
        i = @filters.iterator
        while i.has_next
          o = i.next_
          if ((o).equal?(filter_))
            i.remove
            refresh
            if ((@filters.size).equal?(0))
              @filters = nil
            end
            return
          end
        end
      end
    end
    
    typesig { [StructuredViewerInternals::AssociateListener] }
    def set_associate_listener(l)
      @associate_listener = l
    end
    
    typesig { [Array.typed(ViewerFilter)] }
    # Sets the filters, replacing any previous filters, and triggers
    # refiltering and resorting of the elements.
    # 
    # @param filters
    # an array of viewer filters
    # @since 3.3
    def set_filters(filters)
      if ((filters.attr_length).equal?(0))
        reset_filters
      else
        @filters = ArrayList.new(Arrays.as_list(filters))
        refresh
      end
    end
    
    typesig { [] }
    # Discards this viewer's filters and triggers refiltering and resorting of
    # the elements.
    def reset_filters
      if (!(@filters).nil?)
        @filters = nil
        refresh
      end
    end
    
    typesig { [Object] }
    # Ensures that the given element is visible, scrolling the viewer if
    # necessary. The selection is unchanged.
    # 
    # @param element
    # the element to reveal
    def reveal(element)
      raise NotImplementedError
    end
    
    typesig { [IContentProvider] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ContentViewer#setContentProvider(org.eclipse.jface.viewers.IContentProvider)
    def set_content_provider(provider)
      assert_content_provider_type(provider)
      super(provider)
    end
    
    typesig { [IContentProvider] }
    # Assert that the content provider is of one of the
    # supported types.
    # @param provider
    def assert_content_provider_type(provider)
      Assert.is_true(provider.is_a?(IStructuredContentProvider))
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.Viewer#setInput(java.lang.Object)
    def set_input(input)
      begin
        # fInChange= true;
        unmap_all_elements
        super(input)
      ensure
        # fInChange= false;
      end
    end
    
    typesig { [ISelection, ::Java::Boolean] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.Viewer#setSelection(org.eclipse.jface.viewers.ISelection, boolean)
    def set_selection(selection, reveal)
      # <p>
      # If the new selection differs from the current selection the hook
      # <code>updateSelection</code> is called.
      # </p>
      # <p>
      # If <code>setSelection</code> is called from within
      # <code>preserveSelection</code>, the call to
      # <code>updateSelection</code> is delayed until the end of
      # <code>preserveSelection</code>.
      # </p>
      # <p>
      # Subclasses do not typically override this method, but implement
      # <code>setSelectionToWidget</code> instead.
      # </p>
      control = get_control
      if ((control).nil? || control.is_disposed)
        return
      end
      if (!@in_change)
        set_selection_to_widget(selection, reveal)
        sel = get_selection
        update_selection(sel)
        fire_post_selection_changed(SelectionChangedEvent.new(self, sel))
      else
        @restore_selection = false
        set_selection_to_widget(selection, reveal)
      end
    end
    
    typesig { [JavaList, ::Java::Boolean] }
    # Parlays the given list of selected elements into selections on this
    # viewer's control.
    # <p>
    # Subclasses should override to set their selection based on the given list
    # of elements.
    # </p>
    # 
    # @param l
    # list of selected elements (element type: <code>Object</code>)
    # or <code>null</code> if the selection is to be cleared
    # @param reveal
    # <code>true</code> if the selection is to be made visible,
    # and <code>false</code> otherwise
    def set_selection_to_widget(l, reveal)
      raise NotImplementedError
    end
    
    typesig { [ISelection, ::Java::Boolean] }
    # Converts the selection to a <code>List</code> and calls
    # <code>setSelectionToWidget(List, boolean)</code>. The selection is
    # expected to be an <code>IStructuredSelection</code> of elements. If
    # not, the selection is cleared.
    # <p>
    # Subclasses do not typically override this method, but implement
    # <code>setSelectionToWidget(List, boolean)</code> instead.
    # 
    # @param selection
    # an IStructuredSelection of elements
    # @param reveal
    # <code>true</code> to reveal the first element in the
    # selection, or <code>false</code> otherwise
    def set_selection_to_widget(selection, reveal)
      if (selection.is_a?(IStructuredSelection))
        set_selection_to_widget((selection).to_list, reveal)
      else
        set_selection_to_widget(nil, reveal)
      end
    end
    
    typesig { [ViewerSorter] }
    # Sets this viewer's sorter and triggers refiltering and resorting of this
    # viewer's element. Passing <code>null</code> turns sorting off.
    # <p>
    # It is recommended to use <code>setComparator()</code> instead.
    # </p>
    # 
    # @param sorter
    # a viewer sorter, or <code>null</code> if none
    def set_sorter(sorter)
      if (!(@sorter).equal?(sorter))
        @sorter = sorter
        refresh
      end
    end
    
    typesig { [ViewerComparator] }
    # Sets this viewer's comparator to be used for sorting elements, and triggers refiltering and
    # resorting of this viewer's element.  <code>null</code> turns sorting off.
    # To get the viewer's comparator, call <code>getComparator()</code>.
    # <p>
    # IMPORTANT: This method was introduced in 3.2. If a reference to this viewer object
    # is passed to clients who call <code>getSorter()<code>, null may be returned from
    # from that method even though the viewer is sorting its elements using the
    # viewer's comparator.
    # </p>
    # 
    # @param comparator a viewer comparator, or <code>null</code> if none
    # 
    # @since 3.2
    def set_comparator(comparator)
      if (!(@sorter).equal?(comparator))
        @sorter = comparator
        refresh
      end
    end
    
    typesig { [::Java::Boolean] }
    # Configures whether this structured viewer uses an internal hash table to
    # speeds up the mapping between elements and SWT items. This must be called
    # before the viewer is given an input (via <code>setInput</code>).
    # 
    # @param enable
    # <code>true</code> to enable hash lookup, and
    # <code>false</code> to disable it
    def set_use_hashlookup(enable)
      Assert.is_true((get_input).nil?, "Can only enable the hash look up before input has been set") # $NON-NLS-1$
      if (enable)
        @element_map = new_hashtable(CustomHashtable::DEFAULT_CAPACITY)
      else
        @element_map = nil
      end
    end
    
    typesig { [IElementComparer] }
    # Sets the comparer to use for comparing elements, or <code>null</code>
    # to use the default <code>equals</code> and <code>hashCode</code>
    # methods on the elements themselves.
    # 
    # @param comparer
    # the comparer to use for comparing elements or
    # <code>null</code>
    def set_comparer(comparer)
      @comparer = comparer
      if (!(@element_map).nil?)
        @element_map = CustomHashtable.new(@element_map, comparer)
      end
    end
    
    typesig { [::Java::Boolean] }
    # NON-API - to be removed - see bug 200214
    # Enable or disable the preserve selection behavior of this viewer. The
    # default is that the viewer attempts to preserve the selection across
    # update operations. This is an advanced option, to support clients that
    # manage the selection without relying on the viewer, or clients running
    # into performance problems when using viewers and {@link SWT#VIRTUAL}.
    # Note that this method has been introduced in 3.5 and that trying to
    # disable the selection behavior may not be possible for all subclasses of
    # <code>StructuredViewer</code>, or may cause program errors. This method
    # is supported for {@link TableViewer}, {@link TreeViewer},
    # {@link ListViewer}, {@link CheckboxTableViewer},
    # {@link CheckboxTreeViewer}, and {@link ComboViewer}, but no promises are
    # made for other subclasses of StructuredViewer, or subclasses of the
    # listed viewer classes.
    # 
    # @param preserve
    # <code>true</code> if selection should be preserved,
    # <code>false</code> otherwise
    def set_preserve_selection(preserve)
      @preserve_selection = preserve
    end
    
    typesig { [] }
    # NON-API - to be removed - see bug 200214
    # Returns whether an attempt should be made to preserve selection across
    # update operations. To be used by subclasses that override
    # {@link #preservingSelection(Runnable)}.
    # 
    # @return <code>true</code> if selection should be preserved,
    # <code>false</code> otherwise
    def get_preserve_selection
      return @preserve_selection
    end
    
    typesig { [Object] }
    # Hook for testing.
    # @param element
    # @return Widget
    def test_find_item(element)
      return find_item(element)
    end
    
    typesig { [Object] }
    # Hook for testing.
    # @param element
    # @return Widget[]
    # @since 3.2
    def test_find_items(element)
      return find_items(element)
    end
    
    typesig { [] }
    # Removes all elements from the map.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    def unmap_all_elements
      if (!(@element_map).nil?)
        @element_map = new_hashtable(CustomHashtable::DEFAULT_CAPACITY)
      end
    end
    
    typesig { [Object] }
    # Removes the given element from the internal element to widget map. Does
    # nothing if mapping is disabled. If mapping is enabled, the given element
    # must be present.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # 
    # @param element
    # the element
    def unmap_element(element)
      if (!(@element_map).nil?)
        @element_map.remove(element)
      end
    end
    
    typesig { [Object, Widget] }
    # Removes the given association from the internal element to widget map.
    # Does nothing if mapping is disabled, or if the given element does not map
    # to the given item.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method.
    # </p>
    # 
    # @param element
    # the element
    # @param item the item to unmap
    # @since 2.0
    def unmap_element(element, item)
      # double-check that the element actually maps to the given item before
      # unmapping it
      if (!(@element_map).nil?)
        widget_or_widgets = @element_map.get(element)
        if ((widget_or_widgets).nil?)
          # item was not mapped, return
          return
        else
          if (widget_or_widgets.is_a?(Widget))
            if ((item).equal?(widget_or_widgets))
              @element_map.remove(element)
            end
          else
            widgets = widget_or_widgets
            index_of_item = Arrays.as_list(widgets).index_of(item)
            if ((index_of_item).equal?(-1))
              return
            end
            length = widgets.attr_length
            if ((index_of_item).equal?(0))
              if ((length).equal?(1))
                @element_map.remove(element)
              else
                updated_widgets = Array.typed(Widget).new(length - 1) { nil }
                System.arraycopy(widgets, 1, updated_widgets, 0, length - 1)
                @element_map.put(element, updated_widgets)
              end
            else
              updated_widgets = Array.typed(Widget).new(length - 1) { nil }
              System.arraycopy(widgets, 0, updated_widgets, 0, index_of_item)
              System.arraycopy(widgets, index_of_item + 1, updated_widgets, index_of_item, length - index_of_item - 1)
              @element_map.put(element, updated_widgets)
            end
          end
        end
      end
    end
    
    # flag to indicate that a full refresh took place. See bug 102440.
    attr_accessor :refresh_occurred
    alias_method :attr_refresh_occurred, :refresh_occurred
    undef_method :refresh_occurred
    alias_method :attr_refresh_occurred=, :refresh_occurred=
    undef_method :refresh_occurred=
    
    typesig { [Array.typed(Object), Array.typed(String)] }
    # Updates the given elements' presentation when one or more of their
    # properties change. Only the given elements are updated.
    # <p>
    # This does not handle structural changes (e.g. addition or removal of
    # elements), and does not update any other related elements (e.g. child
    # elements). To handle structural changes, use the <code>refresh</code>
    # methods instead.
    # </p>
    # <p>
    # This should be called when an element has changed in the model, in order
    # to have the viewer accurately reflect the model. This method only affects
    # the viewer, not the model.
    # </p>
    # <p>
    # Specifying which properties are affected may allow the viewer to optimize
    # the update. For example, if the label provider is not affected by changes
    # to any of these properties, an update may not actually be required.
    # Specifying <code>properties</code> as <code>null</code> forces a full
    # update of the given elements.
    # </p>
    # <p>
    # If the viewer has a sorter which is affected by a change to one of the
    # properties, the elements' positions are updated to maintain the sort
    # order. Note that resorting may not happen if <code>properties</code>
    # is <code>null</code>.
    # </p>
    # <p>
    # If the viewer has a filter which is affected by a change to one of the
    # properties, elements may appear or disappear if the change affects
    # whether or not they are filtered out. Note that resorting may not happen
    # if <code>properties</code> is <code>null</code>.
    # </p>
    # 
    # @param elements
    # the elements
    # @param properties
    # the properties that have changed, or <code>null</code> to
    # indicate unknown
    def update(elements, properties)
      previous_value = @refresh_occurred
      @refresh_occurred = false
      begin
        i = 0
        while i < elements.attr_length
          update(elements[i], properties)
          if (@refresh_occurred)
            return
          end
          (i += 1)
        end
      ensure
        @refresh_occurred = previous_value
      end
    end
    
    typesig { [Object, Array.typed(String)] }
    # Updates the given element's presentation when one or more of its
    # properties changes. Only the given element is updated.
    # <p>
    # This does not handle structural changes (e.g. addition or removal of
    # elements), and does not update any other related elements (e.g. child
    # elements). To handle structural changes, use the <code>refresh</code>
    # methods instead.
    # </p>
    # <p>
    # This should be called when an element has changed in the model, in order
    # to have the viewer accurately reflect the model. This method only affects
    # the viewer, not the model.
    # </p>
    # <p>
    # Specifying which properties are affected may allow the viewer to optimize
    # the update. For example, if the label provider is not affected by changes
    # to any of these properties, an update may not actually be required.
    # Specifying <code>properties</code> as <code>null</code> forces a full
    # update of the element.
    # </p>
    # <p>
    # If the viewer has a sorter which is affected by a change to one of the
    # properties, the element's position is updated to maintain the sort order.
    # Note that resorting may not happen if <code>properties</code> is
    # <code>null</code>.
    # </p>
    # <p>
    # If the viewer has a filter which is affected by a change to one of the
    # properties, the element may appear or disappear if the change affects
    # whether or not the element is filtered out. Note that filtering may not
    # happen if <code>properties</code> is <code>null</code>.
    # </p>
    # 
    # @param element
    # the element
    # @param properties
    # the properties that have changed, or <code>null</code> to
    # indicate unknown
    def update(element, properties)
      Assert.is_not_null(element)
      items = find_items(element)
      may_exit_early = !@refresh_occurred
      i = 0
      while i < items.attr_length
        internal_update(items[i], element, properties)
        if (may_exit_early && @refresh_occurred)
          # detected a change from refreshOccurred==false to refreshOccurred==true
          return
        end
        i += 1
      end
    end
    
    typesig { [Widget, Object, Array.typed(String)] }
    # Updates the given element's presentation when one or more of its
    # properties changes. Only the given element is updated.
    # <p>
    # EXPERIMENTAL.  Not to be used except by JDT.
    # This method was added to support JDT's explorations
    # into grouping by working sets, which requires viewers to support multiple
    # equal elements.  See bug 76482 for more details.  This support will
    # likely be removed in Eclipse 3.3 in favor of proper support for
    # multiple equal elements (which was implemented for AbtractTreeViewer in 3.2).
    # </p>
    # @param widget
    # the widget for the element
    # @param element
    # the element
    # @param properties
    # the properties that have changed, or <code>null</code> to
    # indicate unknown
    def internal_update(widget, element, properties)
      needs_refilter = false
      if (!(properties).nil?)
        i = 0
        while i < properties.attr_length
          needs_refilter = needs_refilter(element, properties[i])
          if (needs_refilter)
            break
          end
          (i += 1)
        end
      end
      if (needs_refilter)
        preserving_selection(Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in StructuredViewer
          include_class_members StructuredViewer
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            internal_refresh(get_root)
            self.attr_refresh_occurred = true
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        return
      end
      needs_update = false
      if ((properties).nil?)
        needs_update = true
      else
        needs_update = false
        label_provider = get_label_provider
        i = 0
        while i < properties.attr_length
          needs_update = label_provider.is_label_property(element, properties[i])
          if (needs_update)
            break
          end
          (i += 1)
        end
      end
      if (needs_update)
        update_item(widget, element)
      end
    end
    
    typesig { [Widget, Object] }
    # Copies attributes of the given element into the given widget.
    # <p>
    # This method is internal to the framework; subclassers should not call
    # this method. Calls <code>doUpdateItem(widget, element, true)</code>.
    # </p>
    # 
    # @param widget
    # the widget
    # @param element
    # the element
    def update_item(widget, element)
      SafeRunnable.run(UpdateItemSafeRunnable.new_local(self, widget, element, true))
    end
    
    typesig { [ISelection] }
    # Updates the selection of this viewer.
    # <p>
    # This framework method should be called when the selection in the viewer
    # widget changes.
    # </p>
    # <p>
    # The default implementation of this method notifies all selection change
    # listeners recorded in an internal state variable. Overriding this method
    # is generally not required; however, if overriding in a subclass,
    # <code>super.updateSelection</code> must be invoked.
    # </p>
    # 
    # @param selection
    # the selection, or <code>null</code> if none
    def update_selection(selection)
      event = SelectionChangedEvent.new(self, selection)
      fire_selection_changed(event)
    end
    
    typesig { [] }
    # Returns whether this structured viewer is configured to use an internal
    # map to speed up the mapping between elements and SWT items.
    # <p>
    # The default implementation of this framework method checks whether the
    # internal map has been initialized.
    # </p>
    # 
    # @return <code>true</code> if the element map is enabled, and
    # <code>false</code> if disabled
    def using_element_map
      return !(@element_map).nil?
    end
    
    typesig { [IBaseLabelProvider] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ContentViewer#setLabelProvider(org.eclipse.jface.viewers.IBaseLabelProvider)
    def set_label_provider(label_provider)
      if (label_provider.is_a?(IColorProvider) || label_provider.is_a?(IFontProvider))
        @color_and_font_collector = ColorAndFontCollectorWithProviders.new_local(self, label_provider)
      else
        @color_and_font_collector = ColorAndFontCollector.new_local(self)
      end
      super(label_provider)
    end
    
    typesig { [ViewerLabel, Object] }
    # Build a label up for the element using the supplied label provider.
    # @param updateLabel The ViewerLabel to collect the result in
    # @param element The element being decorated.
    def build_label(update_label, element)
      if (get_label_provider.is_a?(IViewerLabelProvider))
        item_provider = get_label_provider
        item_provider.update_label(update_label, element)
        @color_and_font_collector.set_used_decorators
        if (update_label.has_new_background)
          @color_and_font_collector.set_background(update_label.get_background)
        end
        if (update_label.has_new_foreground)
          @color_and_font_collector.set_foreground(update_label.get_foreground)
        end
        if (update_label.has_new_font)
          @color_and_font_collector.set_font(update_label.get_font)
        end
        return
      end
      if (get_label_provider.is_a?(ILabelProvider))
        label_provider = get_label_provider
        update_label.set_text(label_provider.get_text(element))
        update_label.set_image(label_provider.get_image(element))
      end
    end
    
    typesig { [ViewerLabel, Object, IViewerLabelProvider] }
    # Build a label up for the element using the supplied label provider.
    # @param updateLabel The ViewerLabel to collect the result in
    # @param element The element being decorated.
    # @param labelProvider ILabelProvider the labelProvider for the receiver.
    def build_label(update_label_, element, label_provider)
      label_provider.update_label(update_label_, element)
      @color_and_font_collector.set_used_decorators
      if (update_label_.has_new_background)
        @color_and_font_collector.set_background(update_label_.get_background)
      end
      if (update_label_.has_new_foreground)
        @color_and_font_collector.set_foreground(update_label_.get_foreground)
      end
      if (update_label_.has_new_font)
        @color_and_font_collector.set_font(update_label_.get_font)
      end
    end
    
    typesig { [ViewerLabel, TreePath, ITreePathLabelProvider] }
    # Build a label up for the element using the supplied label provider.
    # @param updateLabel The ViewerLabel to collect the result in
    # @param elementPath The path of the element being decorated.
    # @param labelProvider ILabelProvider the labelProvider for the receiver.
    def build_label(update_label_, element_path, label_provider)
      label_provider.update_label(update_label_, element_path)
      @color_and_font_collector.set_used_decorators
      if (update_label_.has_new_background)
        @color_and_font_collector.set_background(update_label_.get_background)
      end
      if (update_label_.has_new_foreground)
        @color_and_font_collector.set_foreground(update_label_.get_foreground)
      end
      if (update_label_.has_new_font)
        @color_and_font_collector.set_font(update_label_.get_font)
      end
    end
    
    typesig { [ViewerLabel, Object, ILabelProvider] }
    # Build a label up for the element using the supplied label provider.
    # @param updateLabel The ViewerLabel to collect the result in
    # @param element The element being decorated.
    # @param labelProvider ILabelProvider the labelProvider for the receiver.
    def build_label(update_label_, element, label_provider)
      update_label_.set_text(label_provider.get_text(element))
      update_label_.set_image(label_provider.get_image(element))
    end
    
    typesig { [] }
    # Get the ColorAndFontCollector for the receiver.
    # @return ColorAndFontCollector
    # @since 3.1
    def get_color_and_font_collector
      return @color_and_font_collector
    end
    
    typesig { [DisposeEvent] }
    def handle_dispose(event)
      super(event)
      @sorter = nil
      @comparer = nil
      if (!(@filters).nil?)
        @filters.clear
      end
      @element_map = new_hashtable(1)
      @open_listeners.clear
      @double_click_listeners.clear
      @color_and_font_collector.clear
      @post_selection_changed_listeners.clear
    end
    
    private
    alias_method :initialize__structured_viewer, :initialize
  end
  
end
