require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Shindl <tom.schindl@bestsolution.at> - initial API and implementation
# fix for bug 163317, 201905
module Org::Eclipse::Jface::Viewers
  module ViewerColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # Instances of this class represent a column of a {@link ColumnViewer}. Label
  # providers and editing support can be configured for each column separately.
  # Concrete subclasses of {@link ColumnViewer} should implement a matching
  # concrete subclass of {@link ViewerColumn}.
  # 
  # @since 3.3
  class ViewerColumn 
    include_class_members ViewerColumnImports
    
    attr_accessor :label_provider
    alias_method :attr_label_provider, :label_provider
    undef_method :label_provider
    alias_method :attr_label_provider=, :label_provider=
    undef_method :label_provider=
    
    class_module.module_eval {
      
      def column_viewer_key
        defined?(@@column_viewer_key) ? @@column_viewer_key : @@column_viewer_key= RJava.cast_to_string(Policy::JFACE) + ".columnViewer"
      end
      alias_method :attr_column_viewer_key, :column_viewer_key
      
      def column_viewer_key=(value)
        @@column_viewer_key = value
      end
      alias_method :attr_column_viewer_key=, :column_viewer_key=
    }
    
    # $NON-NLS-1$
    attr_accessor :editing_support
    alias_method :attr_editing_support, :editing_support
    undef_method :editing_support
    alias_method :attr_editing_support=, :editing_support=
    undef_method :editing_support=
    
    attr_accessor :listener
    alias_method :attr_listener, :listener
    undef_method :listener
    alias_method :attr_listener=, :listener=
    undef_method :listener=
    
    attr_accessor :listener_registered
    alias_method :attr_listener_registered, :listener_registered
    undef_method :listener_registered
    alias_method :attr_listener_registered=, :listener_registered=
    undef_method :listener_registered=
    
    attr_accessor :viewer
    alias_method :attr_viewer, :viewer
    undef_method :viewer
    alias_method :attr_viewer=, :viewer=
    undef_method :viewer=
    
    typesig { [ColumnViewer, Widget] }
    # Create a new instance of the receiver at columnIndex.
    # 
    # @param viewer
    # the viewer the column is part of
    # @param columnOwner
    # the widget owning the viewer in case the widget has no columns
    # this could be the widget itself
    def initialize(viewer, column_owner)
      @label_provider = nil
      @editing_support = nil
      @listener = nil
      @listener_registered = false
      @viewer = nil
      @viewer = viewer
      column_owner.set_data(self.attr_column_viewer_key, self)
      @listener = Class.new(ILabelProviderListener.class == Class ? ILabelProviderListener : Object) do
        extend LocalClass
        include_class_members ViewerColumn
        include ILabelProviderListener if ILabelProviderListener.class == Module
        
        typesig { [LabelProviderChangedEvent] }
        define_method :label_provider_changed do |event|
          viewer.handle_label_provider_changed(event)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      column_owner.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members ViewerColumn
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          handle_dispose(viewer)
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
    # Return the label provider for the receiver.
    # 
    # @return ViewerLabelProvider
    # 
    # package
    def get_label_provider
      return @label_provider
    end
    
    typesig { [CellLabelProvider] }
    # Set the label provider for the column. Subclasses may extend but must
    # call the super implementation.
    # 
    # @param labelProvider
    # the new {@link CellLabelProvider}
    def set_label_provider(label_provider)
      set_label_provider(label_provider, true)
    end
    
    typesig { [CellLabelProvider, ::Java::Boolean] }
    # @param labelProvider
    # @param registerListener
    # 
    # package
    def set_label_provider(label_provider, register_listener)
      if (@listener_registered && !(@label_provider).nil?)
        @label_provider.remove_listener(@listener)
        @listener_registered = false
        if (register_listener)
          @label_provider.dispose(@viewer, self)
        end
      end
      @label_provider = label_provider
      if (register_listener)
        @label_provider.initialize_(@viewer, self)
        @label_provider.add_listener(@listener)
        @listener_registered = true
      end
    end
    
    typesig { [] }
    # Return the editing support for the receiver.
    # 
    # @return {@link EditingSupport}
    # 
    # package
    def get_editing_support
      return @editing_support
    end
    
    typesig { [EditingSupport] }
    # Set the editing support. Subclasses may extend but must call the super
    # implementation.
    # <p>
    # Users setting up an editable {@link TreeViewer} or {@link TableViewer} with more than 1 column <b>have</b>
    # to pass the SWT.FULL_SELECTION style bit when creating the viewer
    # </p>
    # @param editingSupport
    # The {@link EditingSupport} to set.
    def set_editing_support(editing_support)
      @editing_support = editing_support
    end
    
    typesig { [ViewerCell] }
    # Refresh the cell for the given columnIndex. <strong>NOTE:</strong>the
    # {@link ViewerCell} provided to this method is no longer valid after this
    # method returns. Do not cache the cell for future use.
    # 
    # @param cell
    # {@link ViewerCell}
    # 
    # package
    def refresh(cell)
      get_label_provider.update(cell)
    end
    
    typesig { [] }
    # Disposes of the label provider (if set), unregisters the listener and
    # nulls the references to the label provider and editing support. This
    # method is called when the underlying widget is disposed. Subclasses may
    # extend but must call the super implementation.
    def handle_dispose
      dispose_label_provider = @listener_registered
      cell_label_provider = @label_provider
      set_label_provider(nil, false)
      if (dispose_label_provider)
        cell_label_provider.dispose(@viewer, self)
      end
      @editing_support = nil
      @listener = nil
      @viewer = nil
    end
    
    typesig { [ColumnViewer] }
    def handle_dispose(viewer)
      handle_dispose
      viewer.clear_legacy_editing_setup
    end
    
    typesig { [] }
    # Returns the viewer of this viewer column.
    # 
    # @return Returns the viewer.
    # 
    # @since 3.4
    def get_viewer
      return @viewer
    end
    
    private
    alias_method :initialize__viewer_column, :initialize
  end
  
end
