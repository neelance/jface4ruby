require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Revisions
  module RevisionSelectionProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Revisions
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Jface::Viewers, :IPostSelectionProvider
      include_const ::Org::Eclipse::Jface::Viewers, :ISelection
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionChangedListener
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionProvider
      include_const ::Org::Eclipse::Jface::Viewers, :IStructuredSelection
      include_const ::Org::Eclipse::Jface::Viewers, :SelectionChangedEvent
      include_const ::Org::Eclipse::Jface::Viewers, :StructuredSelection
      include_const ::Org::Eclipse::Jface::Text, :ITextSelection
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text::Revisions, :Revision
    }
  end
  
  # A selection provider for annotate revisions. Selections of a revision can currently happen in
  # following ways - note that this list may be changed in the future:
  # <ul>
  # <li>when the user clicks the revision ruler with the mouse</li>
  # <li>when the caret is moved to a revision's line (only on post-selection)</li>
  # </ul>
  # <p>
  # Calling {@link #setSelection(ISelection)} will set the current sticky revision on the ruler.
  # </p>
  # 
  # @since 3.2
  class RevisionSelectionProvider 
    include_class_members RevisionSelectionProviderImports
    include ISelectionProvider
    
    class_module.module_eval {
      # Post selection listener on the viewer that remembers the selection provider it is registered
      # with.
      const_set_lazy(:PostSelectionListener) { Class.new do
        extend LocalClass
        include_class_members RevisionSelectionProvider
        include ISelectionChangedListener
        
        attr_accessor :f_post_provider
        alias_method :attr_f_post_provider, :f_post_provider
        undef_method :f_post_provider
        alias_method :attr_f_post_provider=, :f_post_provider=
        undef_method :f_post_provider=
        
        typesig { [class_self::IPostSelectionProvider] }
        def initialize(post_provider)
          @f_post_provider = nil
          post_provider.add_post_selection_changed_listener(self)
          @f_post_provider = post_provider
        end
        
        typesig { [class_self::SelectionChangedEvent] }
        def selection_changed(event)
          selection = event.get_selection
          if (selection.is_a?(self.class::ITextSelection))
            ts = selection
            offset = ts.get_offset
            set_selected_revision(self.attr_f_painter.get_revision(offset))
          end
        end
        
        typesig { [] }
        def dispose
          @f_post_provider.remove_post_selection_changed_listener(self)
        end
        
        private
        alias_method :initialize__post_selection_listener, :initialize
      end }
    }
    
    attr_accessor :f_painter
    alias_method :attr_f_painter, :f_painter
    undef_method :f_painter
    alias_method :attr_f_painter=, :f_painter=
    undef_method :f_painter=
    
    attr_accessor :f_listeners
    alias_method :attr_f_listeners, :f_listeners
    undef_method :f_listeners
    alias_method :attr_f_listeners=, :f_listeners=
    undef_method :f_listeners=
    
    # The text viewer once we are installed, <code>null</code> if not installed.
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    # The selection listener on the viewer, or <code>null</code>.
    attr_accessor :f_selection_listener
    alias_method :attr_f_selection_listener, :f_selection_listener
    undef_method :f_selection_listener
    alias_method :attr_f_selection_listener=, :f_selection_listener=
    undef_method :f_selection_listener=
    
    # The last selection, or <code>null</code>.
    attr_accessor :f_selection
    alias_method :attr_f_selection, :f_selection
    undef_method :f_selection
    alias_method :attr_f_selection=, :f_selection=
    undef_method :f_selection=
    
    # Incoming selection changes are ignored while sending out events.
    # 
    # @since 3.3
    attr_accessor :f_ignore_events
    alias_method :attr_f_ignore_events, :f_ignore_events
    undef_method :f_ignore_events
    alias_method :attr_f_ignore_events=, :f_ignore_events=
    undef_method :f_ignore_events=
    
    typesig { [RevisionPainter] }
    # Creates a new selection provider.
    # 
    # @param painter the painter that the created provider interacts with
    def initialize(painter)
      @f_painter = nil
      @f_listeners = ListenerList.new
      @f_viewer = nil
      @f_selection_listener = nil
      @f_selection = nil
      @f_ignore_events = false
      @f_painter = painter
    end
    
    typesig { [ISelectionChangedListener] }
    # @see org.eclipse.jface.viewers.ISelectionProvider#addSelectionChangedListener(org.eclipse.jface.viewers.ISelectionChangedListener)
    def add_selection_changed_listener(listener)
      @f_listeners.add(listener)
    end
    
    typesig { [ISelectionChangedListener] }
    # @see org.eclipse.jface.viewers.ISelectionProvider#removeSelectionChangedListener(org.eclipse.jface.viewers.ISelectionChangedListener)
    def remove_selection_changed_listener(listener)
      @f_listeners.remove(listener)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.viewers.ISelectionProvider#getSelection()
    def get_selection
      if ((@f_selection).nil?)
        return StructuredSelection::EMPTY
      end
      return StructuredSelection.new(@f_selection)
    end
    
    typesig { [ISelection] }
    # @see org.eclipse.jface.viewers.ISelectionProvider#setSelection(org.eclipse.jface.viewers.ISelection)
    def set_selection(selection)
      if (@f_ignore_events)
        return
      end
      if (selection.is_a?(IStructuredSelection))
        first = (selection).get_first_element
        if (first.is_a?(Revision))
          @f_painter.handle_revision_selected(first)
        else
          if (first.is_a?(String))
            @f_painter.handle_revision_selected(first)
          else
            if (selection.is_empty)
              @f_painter.handle_revision_selected(nil)
            end
          end
        end
      end
    end
    
    typesig { [ITextViewer] }
    # Installs the selection provider on the viewer.
    # 
    # @param viewer the viewer on which we listen to for post selection events
    def install(viewer)
      uninstall
      @f_viewer = viewer
      if (!(@f_viewer).nil?)
        provider = @f_viewer.get_selection_provider
        if (provider.is_a?(IPostSelectionProvider))
          post_provider = provider
          @f_selection_listener = PostSelectionListener.new_local(self, post_provider)
        end
      end
    end
    
    typesig { [] }
    # Uninstalls the selection provider.
    def uninstall
      @f_viewer = nil
      if (!(@f_selection_listener).nil?)
        @f_selection_listener.dispose
        @f_selection_listener = nil
      end
    end
    
    typesig { [Revision] }
    # Private protocol used by {@link RevisionPainter} to signal selection of a revision.
    # 
    # @param revision the selected revision, or <code>null</code> for none
    def revision_selected(revision)
      set_selected_revision(revision)
    end
    
    typesig { [Revision] }
    # Updates the currently selected revision and sends out an event if it changed.
    # 
    # @param revision the newly selected revision or <code>null</code> for none
    def set_selected_revision(revision)
      if (!(revision).equal?(@f_selection))
        @f_selection = revision
        fire_selection_event
      end
    end
    
    typesig { [] }
    def fire_selection_event
      @f_ignore_events = true
      begin
        selection = get_selection
        event = SelectionChangedEvent.new(self, selection)
        listeners = @f_listeners.get_listeners
        i = 0
        while i < listeners.attr_length
          (listeners[i]).selection_changed(event)
          i += 1
        end
      ensure
        @f_ignore_events = false
      end
    end
    
    private
    alias_method :initialize__revision_selection_provider, :initialize
  end
  
end
