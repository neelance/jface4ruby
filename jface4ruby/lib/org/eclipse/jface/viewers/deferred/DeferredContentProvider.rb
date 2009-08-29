require "rjava"

# Copyright (c) 2004, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers::Deferred
  module DeferredContentProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers::Deferred
      include_const ::Java::Util, :Comparator
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Viewers, :AcceptAllFilter
      include_const ::Org::Eclipse::Jface::Viewers, :IFilter
      include_const ::Org::Eclipse::Jface::Viewers, :ILazyContentProvider
      include_const ::Org::Eclipse::Jface::Viewers, :TableViewer
      include_const ::Org::Eclipse::Jface::Viewers, :Viewer
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Table
    }
  end
  
  # Content provider that performs sorting and filtering in a background thread.
  # Requires a <code>TableViewer</code> created with the <code>SWT.VIRTUAL</code>
  # flag and an <code>IConcurrentModel</code> as input.
  # <p>
  # The sorter and filter must be set directly on the content provider.
  # Any sorter or filter on the TableViewer will be ignored.
  # </p>
  # 
  # <p>
  # The real implementation is in <code>BackgroundContentProvider</code>. This
  # object is a lightweight wrapper that adapts the algorithm to work with
  # <code>TableViewer</code>.
  # </p>
  # 
  # @since 3.1
  class DeferredContentProvider 
    include_class_members DeferredContentProviderImports
    include ILazyContentProvider
    
    attr_accessor :limit
    alias_method :attr_limit, :limit
    undef_method :limit
    alias_method :attr_limit=, :limit=
    undef_method :limit=
    
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    attr_accessor :sort_order
    alias_method :attr_sort_order, :sort_order
    undef_method :sort_order
    alias_method :attr_sort_order=, :sort_order=
    undef_method :sort_order=
    
    attr_accessor :filter
    alias_method :attr_filter, :filter
    undef_method :filter
    alias_method :attr_filter=, :filter=
    undef_method :filter=
    
    attr_accessor :table
    alias_method :attr_table, :table
    undef_method :table
    alias_method :attr_table=, :table=
    undef_method :table=
    
    class_module.module_eval {
      const_set_lazy(:TableViewerAdapter) { Class.new(AbstractVirtualTable) do
        include_class_members DeferredContentProvider
        
        attr_accessor :viewer
        alias_method :attr_viewer, :viewer
        undef_method :viewer
        alias_method :attr_viewer=, :viewer=
        undef_method :viewer=
        
        typesig { [class_self::TableViewer] }
        # @param viewer
        def initialize(viewer)
          @viewer = nil
          super()
          @viewer = viewer
        end
        
        typesig { [::Java::Int] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.deferred.AbstractVirtualTable#flushCache(java.lang.Object)
        def clear(index)
          @viewer.clear(index)
        end
        
        typesig { [Object, ::Java::Int] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.deferred.AbstractVirtualTable#replace(java.lang.Object, int)
        def replace(element, item_index)
          @viewer.replace(element, item_index)
        end
        
        typesig { [::Java::Int] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.deferred.AbstractVirtualTable#setItemCount(int)
        def set_item_count(total)
          @viewer.set_item_count(total)
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.deferred.AbstractVirtualTable#getItemCount()
        def get_item_count
          return @viewer.get_table.get_item_count
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.deferred.AbstractVirtualTable#getTopIndex()
        def get_top_index
          return Math.max(@viewer.get_table.get_top_index - 1, 0)
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.deferred.AbstractVirtualTable#getVisibleItemCount()
        def get_visible_item_count
          table = @viewer.get_table
          rect = table.get_client_area
          item_height = table.get_item_height
          header_height = table.get_header_height
          return (rect.attr_height - header_height + item_height - 1) / (item_height + table.get_grid_line_width)
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.deferred.AbstractVirtualTable#getControl()
        def get_control
          return @viewer.get_control
        end
        
        private
        alias_method :initialize__table_viewer_adapter, :initialize
      end }
    }
    
    typesig { [Comparator] }
    # Create a DeferredContentProvider with the given sort order.
    # @param sortOrder a comparator that sorts the content.
    def initialize(sort_order)
      @limit = -1
      @provider = nil
      @sort_order = nil
      @filter = AcceptAllFilter.get_instance
      @table = nil
      @sort_order = sort_order
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IContentProvider#dispose()
    def dispose
      set_provider(nil)
    end
    
    typesig { [Viewer, Object, Object] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.IContentProvider#inputChanged(org.eclipse.jface.viewers.Viewer, java.lang.Object, java.lang.Object)
    def input_changed(viewer, old_input, new_input)
      if ((new_input).nil?)
        set_provider(nil)
        return
      end
      Assert.is_true(new_input.is_a?(IConcurrentModel))
      Assert.is_true(viewer.is_a?(TableViewer))
      model = new_input
      @table = TableViewerAdapter.new(viewer)
      new_provider = BackgroundContentProvider.new(@table, model, @sort_order)
      set_provider(new_provider)
      new_provider.set_limit(@limit)
      new_provider.set_filter(@filter)
    end
    
    typesig { [Comparator] }
    # Sets the sort order for this content provider. This sort order takes priority
    # over anything that was supplied to the <code>TableViewer</code>.
    # 
    # @param sortOrder new sort order. The comparator must be able to support being
    # used in a background thread.
    def set_sort_order(sort_order)
      Assert.is_not_null(sort_order)
      @sort_order = sort_order
      if (!(@provider).nil?)
        @provider.set_sort_order(sort_order)
      end
    end
    
    typesig { [IFilter] }
    # Sets the filter for this content provider. This filter takes priority over
    # anything that was supplied to the <code>TableViewer</code>. The filter
    # must be capable of being used in a background thread.
    # 
    # @param toSet filter to set
    def set_filter(to_set)
      @filter = to_set
      if (!(@provider).nil?)
        @provider.set_filter(to_set)
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the maximum number of rows in the table. If the model contains more
    # than this number of elements, only the top elements will be shown based on
    # the current sort order.
    # 
    # @param limit maximum number of rows to show or -1 if unbounded
    def set_limit(limit)
      @limit = limit
      if (!(@provider).nil?)
        @provider.set_limit(limit)
      end
    end
    
    typesig { [] }
    # Returns the current maximum number of rows or -1 if unbounded
    # 
    # @return the current maximum number of rows or -1 if unbounded
    def get_limit
      return @limit
    end
    
    typesig { [::Java::Int] }
    # (non-Javadoc)
    # @see org.eclipse.jface.viewers.ILazyContentProvider#updateElement(int)
    def update_element(element)
      if (!(@provider).nil?)
        @provider.check_visible_range(element)
      end
    end
    
    typesig { [BackgroundContentProvider] }
    def set_provider(new_provider)
      if (!(@provider).nil?)
        @provider.dispose
      end
      @provider = new_provider
    end
    
    private
    alias_method :initialize__deferred_content_provider, :initialize
  end
  
end
