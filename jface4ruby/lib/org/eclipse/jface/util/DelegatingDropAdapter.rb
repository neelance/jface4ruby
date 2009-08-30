require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Util
  module DelegatingDropAdapterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt::Dnd, :DND
      include_const ::Org::Eclipse::Swt::Dnd, :DropTargetEvent
      include_const ::Org::Eclipse::Swt::Dnd, :DropTargetListener
      include_const ::Org::Eclipse::Swt::Dnd, :Transfer
      include_const ::Org::Eclipse::Swt::Dnd, :TransferData
    }
  end
  
  # A <code>DelegatingDropAdapter</code> is a <code>DropTargetListener</code> that
  # maintains and delegates to a set of {@link TransferDropTargetListener}s. Each
  # <code>TransferDropTargetListener</code> can then be implemented as if it were
  # the DropTarget's only <code>DropTargetListener</code>.
  # <p>
  # On <code>dragEnter</code>, <code>dragOperationChanged</code>, <code>dragOver</code>
  # and <code>drop</code>, a <i>current</i> listener is obtained from the set of all
  # <code>TransferDropTargetListeners</code>. The current listener is the first listener
  # to return <code>true</code> for
  # {@link TransferDropTargetListener#isEnabled(DropTargetEvent)}.
  # The current listener is forwarded all <code>DropTargetEvents</code> until some other
  # listener becomes the current listener, or the drop terminates.
  # </p>
  # <p>
  # After adding all <code>TransferDropTargetListeners</code> to the
  # <code>DelegatingDropAdapter</code> the combined set of <code>Transfers</code> should
  # be set in the SWT <code>DropTarget</code>. <code>#getTransfers()</code> provides the
  # set of <code>Transfer</code> types of all <code>TransferDropTargetListeners</code>.
  # </p>
  # <p>
  # The following example snippet shows a <code>DelegatingDropAdapter</code> with two
  # <code>TransferDropTargetListeners</code>. One supports dropping resources and
  # demonstrates how a listener can be disabled in the isEnabled method.
  # The other listener supports text transfer.
  # </p>
  # <code><pre>
  # final TreeViewer viewer = new TreeViewer(shell, SWT.NONE);
  # DelegatingDropAdapter dropAdapter = new DelegatingDropAdapter();
  # dropAdapter.addDropTargetListener(new TransferDropTargetListener() {
  # public Transfer getTransfer() {
  # return ResourceTransfer.getInstance();
  # }
  # public boolean isEnabled(DropTargetEvent event) {
  # // disable drop listener if there is no viewer selection
  # if (viewer.getSelection().isEmpty())
  # return false;
  # return true;
  # }
  # public void dragEnter(DropTargetEvent event) {}
  # public void dragLeave(DropTargetEvent event) {}
  # public void dragOperationChanged(DropTargetEvent event) {}
  # public void dragOver(DropTargetEvent event) {}
  # public void drop(DropTargetEvent event) {
  # if (event.data == null)
  # return;
  # IResource[] resources = (IResource[]) event.data;
  # if (event.detail == DND.DROP_COPY) {
  # // copy resources
  # } else {
  # // move resources
  # }
  # 
  # }
  # public void dropAccept(DropTargetEvent event) {}
  # });
  # dropAdapter.addDropTargetListener(new TransferDropTargetListener() {
  # public Transfer getTransfer() {
  # return TextTransfer.getInstance();
  # }
  # public boolean isEnabled(DropTargetEvent event) {
  # return true;
  # }
  # public void dragEnter(DropTargetEvent event) {}
  # public void dragLeave(DropTargetEvent event) {}
  # public void dragOperationChanged(DropTargetEvent event) {}
  # public void dragOver(DropTargetEvent event) {}
  # public void drop(DropTargetEvent event) {
  # if (event.data == null)
  # return;
  # System.out.println(event.data);
  # }
  # public void dropAccept(DropTargetEvent event) {}
  # });
  # viewer.addDropSupport(DND.DROP_COPY | DND.DROP_MOVE, dropAdapter.getTransfers(), dropAdapter);
  # </pre></code>
  # @since 3.0
  class DelegatingDropAdapter 
    include_class_members DelegatingDropAdapterImports
    include DropTargetListener
    
    attr_accessor :listeners
    alias_method :attr_listeners, :listeners
    undef_method :listeners
    alias_method :attr_listeners=, :listeners=
    undef_method :listeners=
    
    attr_accessor :current_listener
    alias_method :attr_current_listener, :current_listener
    undef_method :current_listener
    alias_method :attr_current_listener=, :current_listener=
    undef_method :current_listener=
    
    attr_accessor :original_drop_type
    alias_method :attr_original_drop_type, :original_drop_type
    undef_method :original_drop_type
    alias_method :attr_original_drop_type=, :original_drop_type=
    undef_method :original_drop_type=
    
    typesig { [TransferDropTargetListener] }
    # Adds the given <code>TransferDropTargetListener</code>.
    # 
    # @param listener the new listener
    def add_drop_target_listener(listener)
      @listeners.add(listener)
    end
    
    typesig { [DropTargetEvent] }
    # The cursor has entered the drop target boundaries. The current listener is
    # updated, and <code>#dragEnter()</code> is forwarded to the current listener.
    # 
    # @param event the drop target event
    # @see DropTargetListener#dragEnter(DropTargetEvent)
    def drag_enter(event)
      # if (Policy.DEBUG_DRAG_DROP)
      # System.out.println("Drag Enter: " + toString()); //$NON-NLS-1$
      @original_drop_type = event.attr_detail
      update_current_listener(event)
    end
    
    typesig { [DropTargetEvent] }
    # The cursor has left the drop target boundaries. The event is forwarded to the
    # current listener.
    # 
    # @param event the drop target event
    # @see DropTargetListener#dragLeave(DropTargetEvent)
    def drag_leave(event)
      # if (Policy.DEBUG_DRAG_DROP)
      # System.out.println("Drag Leave: " + toString()); //$NON-NLS-1$
      set_current_listener(nil, event)
    end
    
    typesig { [DropTargetEvent] }
    # The operation being performed has changed (usually due to the user changing
    # a drag modifier key while dragging). Updates the current listener and forwards
    # this event to that listener.
    # 
    # @param event the drop target event
    # @see DropTargetListener#dragOperationChanged(DropTargetEvent)
    def drag_operation_changed(event)
      # if (Policy.DEBUG_DRAG_DROP)
      # System.out.println("Drag Operation Changed to: " + event.detail); //$NON-NLS-1$
      @original_drop_type = event.attr_detail
      old_listener = get_current_listener
      update_current_listener(event)
      new_listener = get_current_listener
      # only notify the current listener if it hasn't changed based on the
      # operation change. otherwise the new listener would get a dragEnter
      # followed by a dragOperationChanged with the exact same event.
      if (!(new_listener).nil? && (new_listener).equal?(old_listener))
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members DelegatingDropAdapter
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            new_listener.drag_operation_changed(event)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    end
    
    typesig { [DropTargetEvent] }
    # The cursor is moving over the drop target. Updates the current listener and
    # forwards this event to that listener. If no listener can handle the drag
    # operation the <code>event.detail</code> field is set to <code>DND.DROP_NONE</code>
    # to indicate an invalid drop.
    # 
    # @param event the drop target event
    # @see DropTargetListener#dragOver(DropTargetEvent)
    def drag_over(event)
      old_listener = get_current_listener
      update_current_listener(event)
      new_listener = get_current_listener
      # only notify the current listener if it hasn't changed based on the
      # drag over. otherwise the new listener would get a dragEnter
      # followed by a dragOver with the exact same event.
      if (!(new_listener).nil? && (new_listener).equal?(old_listener))
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members DelegatingDropAdapter
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            new_listener.drag_over(event)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    end
    
    typesig { [DropTargetEvent] }
    # Forwards this event to the current listener, if there is one. Sets the
    # current listener to <code>null</code> afterwards.
    # 
    # @param event the drop target event
    # @see DropTargetListener#drop(DropTargetEvent)
    def drop(event)
      # if (Policy.DEBUG_DRAG_DROP)
      # System.out.println("Drop: " + toString()); //$NON-NLS-1$
      update_current_listener(event)
      if (!(get_current_listener).nil?)
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members DelegatingDropAdapter
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            get_current_listener.drop(event)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      set_current_listener(nil, event)
    end
    
    typesig { [DropTargetEvent] }
    # Forwards this event to the current listener if there is one.
    # 
    # @param event the drop target event
    # @see DropTargetListener#dropAccept(DropTargetEvent)
    def drop_accept(event)
      # if (Policy.DEBUG_DRAG_DROP)
      # System.out.println("Drop Accept: " + toString()); //$NON-NLS-1$
      if (!(get_current_listener).nil?)
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members DelegatingDropAdapter
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            get_current_listener.drop_accept(event)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    end
    
    typesig { [] }
    # Returns the listener which currently handles drop events.
    # 
    # @return the <code>TransferDropTargetListener</code> which currently
    # handles drop events.
    def get_current_listener
      return @current_listener
    end
    
    typesig { [Array.typed(TransferData), TransferDropTargetListener] }
    # Returns the transfer data type supported by the given listener.
    # Returns <code>null</code> if the listener does not support any of the
    # specified data types.
    # 
    # @param dataTypes available data types
    # @param listener <code>TransferDropTargetListener</code> to use for testing
    # supported data types.
    # @return the transfer data type supported by the given listener or
    # <code>null</code>.
    def get_supported_transfer_type(data_types, listener)
      i = 0
      while i < data_types.attr_length
        if (listener.get_transfer.is_supported_type(data_types[i]))
          return data_types[i]
        end
        i += 1
      end
      return nil
    end
    
    typesig { [] }
    # Returns the combined set of <code>Transfer</code> types of all
    # <code>TransferDropTargetListeners</code>.
    # 
    # @return the combined set of <code>Transfer</code> types
    def get_transfers
      types = Array.typed(Transfer).new(@listeners.size) { nil }
      i = 0
      while i < @listeners.size
        listener = @listeners.get(i)
        types[i] = listener.get_transfer
        i += 1
      end
      return types
    end
    
    typesig { [] }
    # Returns <code>true</code> if there are no listeners to delegate events to.
    # 
    # @return <code>true</code> if there are no <code>TransferDropTargetListeners</code>
    # <code>false</code> otherwise
    def is_empty
      return @listeners.is_empty
    end
    
    typesig { [TransferDropTargetListener] }
    # Removes the given <code>TransferDropTargetListener</code>.
    # Listeners should not be removed while a drag and drop operation is in progress.
    # 
    # @param listener the listener to remove
    def remove_drop_target_listener(listener)
      if ((@current_listener).equal?(listener))
        @current_listener = nil
      end
      @listeners.remove(listener)
    end
    
    typesig { [TransferDropTargetListener, DropTargetEvent] }
    # Sets the current listener to <code>listener</code>. Sends the given
    # <code>DropTargetEvent</code> if the current listener changes.
    # 
    # @return <code>true</code> if the new listener is different than the previous
    # <code>false</code> otherwise
    def set_current_listener(listener, event)
      if ((@current_listener).equal?(listener))
        return false
      end
      if (!(@current_listener).nil?)
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members DelegatingDropAdapter
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            self.attr_current_listener.drag_leave(event)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      @current_listener = listener
      # if (Policy.DEBUG_DRAG_DROP)
      # System.out.println("Current drop listener: " + listener); //$NON-NLS-1$
      if (!(@current_listener).nil?)
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members DelegatingDropAdapter
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            self.attr_current_listener.drag_enter(event)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      return true
    end
    
    typesig { [DropTargetEvent] }
    # Updates the current listener to one that can handle the drop. There can be many
    # listeners and each listener may be able to handle many <code>TransferData</code>
    # types. The first listener found that can handle a drop of one of the given
    # <code>TransferData</code> types will be selected.
    # If no listener can handle the drag operation the <code>event.detail</code> field
    # is set to <code>DND.DROP_NONE</code> to indicate an invalid drop.
    # 
    # @param event the drop target event
    def update_current_listener(event)
      original_detail = event.attr_detail
      # revert the detail to the "original" drop type that the User indicated.
      # this is necessary because the previous listener may have changed the detail
      # to something other than what the user indicated.
      event.attr_detail = @original_drop_type
      iter = @listeners.iterator
      while (iter.has_next)
        listener = iter.next_
        data_type = get_supported_transfer_type(event.attr_data_types, listener)
        if (!(data_type).nil?)
          original_data_type = event.attr_current_data_type
          # set the data type supported by the drop listener
          event.attr_current_data_type = data_type
          if (listener.is_enabled(event))
            # if the listener stays the same, set its previously determined
            # event detail
            if (!set_current_listener(listener, event))
              event.attr_detail = original_detail
            end
            return
          end
          event.attr_current_data_type = original_data_type
        end
      end
      set_current_listener(nil, event)
      event.attr_detail = DND::DROP_NONE
      # -always- ensure that expand/scroll are on...otherwise
      # if a valid drop target is a child of an invalid one
      # you can't get there...
      event.attr_feedback = DND::FEEDBACK_EXPAND | DND::FEEDBACK_SCROLL
    end
    
    typesig { [] }
    def initialize
      @listeners = ArrayList.new
      @current_listener = nil
      @original_drop_type = 0
    end
    
    private
    alias_method :initialize__delegating_drop_adapter, :initialize
  end
  
end
