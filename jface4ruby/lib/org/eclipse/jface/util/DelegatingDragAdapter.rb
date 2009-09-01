require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Util
  module DelegatingDragAdapterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt::Dnd, :DragSource
      include_const ::Org::Eclipse::Swt::Dnd, :DragSourceEvent
      include_const ::Org::Eclipse::Swt::Dnd, :DragSourceListener
      include_const ::Org::Eclipse::Swt::Dnd, :Transfer
      include_const ::Org::Eclipse::Swt::Dnd, :TransferData
    }
  end
  
  # A <code>DelegatingDragAdapter</code> is a <code>DragSourceListener</code> that
  # maintains and delegates to a set of {@link TransferDragSourceListener}s. Each
  # TransferDragSourceListener can then be implemented as if it were the
  # <code>DragSource's</code> only DragSourceListener.
  # <p>
  # When a drag is started, a subset of all <code>TransferDragSourceListeners</code>
  # is generated and stored in a list of <i>active</i> listeners. This subset is
  # calculated by forwarding {@link DragSourceListener#dragStart(DragSourceEvent)} to
  # every listener, and checking if the {@link DragSourceEvent#doit doit} field is left
  # set to <code>true</code>.
  # </p>
  # The <code>DragSource</code>'s set of supported Transfer types ({@link
  # DragSource#setTransfer(Transfer[])}) is updated to reflect the Transfer types
  # corresponding to the active listener subset.
  # <p>
  # If and when {@link #dragSetData(DragSourceEvent)} is called, a single
  # <code>TransferDragSourceListener</code> is chosen, and only it is allowed to set the
  # drag data. The chosen listener is the first listener in the subset of active listeners
  # whose Transfer supports ({@link Transfer#isSupportedType(TransferData)}) the
  # <code>dataType</code> in the <code>DragSourceEvent</code>.
  # </p>
  # <p>
  # The following example snippet shows a <code>DelegatingDragAdapter</code> with two
  # <code>TransferDragSourceListeners</code>. One implements drag of text strings,
  # the other supports file transfer and demonstrates how a listener can be disabled using
  # the dragStart method.
  # </p>
  # <code><pre>
  # final TreeViewer viewer = new TreeViewer(shell, SWT.NONE);
  # 
  # DelegatingDragAdapter dragAdapter = new DelegatingDragAdapter();
  # dragAdapter.addDragSourceListener(new TransferDragSourceListener() {
  # public Transfer getTransfer() {
  # return TextTransfer.getInstance();
  # }
  # public void dragStart(DragSourceEvent event) {
  # // always enabled, can control enablement based on selection etc.
  # }
  # public void dragSetData(DragSourceEvent event) {
  # event.data = "Transfer data";
  # }
  # public void dragFinished(DragSourceEvent event) {
  # // no clean-up required
  # }
  # });
  # dragAdapter.addDragSourceListener(new TransferDragSourceListener() {
  # public Transfer getTransfer() {
  # return FileTransfer.getInstance();
  # }
  # public void dragStart(DragSourceEvent event) {
  # // enable drag listener if there is a viewer selection
  # event.doit = !viewer.getSelection().isEmpty();
  # }
  # public void dragSetData(DragSourceEvent event) {
  # File file1 = new File("C:/temp/file1");
  # File file2 = new File("C:/temp/file2");
  # event.data = new String[] {file1.getAbsolutePath(), file2.getAbsolutePath()};
  # }
  # public void dragFinished(DragSourceEvent event) {
  # // no clean-up required
  # }
  # });
  # viewer.addDragSupport(DND.DROP_COPY | DND.DROP_MOVE, dragAdapter.getTransfers(), dragAdapter);
  # </pre></code>
  # @since 3.0
  class DelegatingDragAdapter 
    include_class_members DelegatingDragAdapterImports
    include DragSourceListener
    
    attr_accessor :listeners
    alias_method :attr_listeners, :listeners
    undef_method :listeners
    alias_method :attr_listeners=, :listeners=
    undef_method :listeners=
    
    attr_accessor :active_listeners
    alias_method :attr_active_listeners, :active_listeners
    undef_method :active_listeners
    alias_method :attr_active_listeners=, :active_listeners=
    undef_method :active_listeners=
    
    attr_accessor :current_listener
    alias_method :attr_current_listener, :current_listener
    undef_method :current_listener
    alias_method :attr_current_listener=, :current_listener=
    undef_method :current_listener=
    
    typesig { [TransferDragSourceListener] }
    # Adds the given <code>TransferDragSourceListener</code>.
    # 
    # @param listener the new listener
    def add_drag_source_listener(listener)
      @listeners.add(listener)
    end
    
    typesig { [DragSourceEvent] }
    # The drop has successfully completed. This event is forwarded to the current
    # drag listener.
    # Doesn't update the current listener, since the current listener  is already the one
    # that completed the drag operation.
    # 
    # @param event the drag source event
    # @see DragSourceListener#dragFinished(DragSourceEvent)
    def drag_finished(event)
      SafeRunnable.run(# if (Policy.DEBUG_DRAG_DROP)
      # System.out.println("Drag Finished: " + toString()); //$NON-NLS-1$
      Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
        extend LocalClass
        include_class_members DelegatingDragAdapter
        include SafeRunnable if SafeRunnable.class == Module
        
        typesig { [] }
        define_method :run do
          if (!(self.attr_current_listener).nil?)
            # there is a listener that can handle the drop, delegate the event
            self.attr_current_listener.drag_finished(event)
          else
            # The drag was canceled and currentListener was never set, so send the
            # dragFinished event to all the active listeners.
            iterator_ = self.attr_active_listeners.iterator
            while (iterator_.has_next)
              (iterator_.next_).drag_finished(event)
            end
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @current_listener = nil
      @active_listeners.clear
    end
    
    typesig { [DragSourceEvent] }
    # The drop data is requested.
    # Updates the current listener and then forwards the event to it.
    # 
    # @param event the drag source event
    # @see DragSourceListener#dragSetData(DragSourceEvent)
    def drag_set_data(event)
      # if (Policy.DEBUG_DRAG_DROP)
      # System.out.println("Drag Set Data: " + toString()); //$NON-NLS-1$
      update_current_listener(event) # find a listener that can provide the given data type
      if (!(@current_listener).nil?)
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members DelegatingDragAdapter
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            self.attr_current_listener.drag_set_data(event)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    end
    
    typesig { [DragSourceEvent] }
    # A drag operation has started.
    # Forwards this event to each listener. A listener must set <code>event.doit</code>
    # to <code>false</code> if it cannot handle the drag operation. If a listener can
    # handle the drag, it is added to the list of active listeners.
    # The drag is aborted if there are no listeners that can handle it.
    # 
    # @param event the drag source event
    # @see DragSourceListener#dragStart(DragSourceEvent)
    def drag_start(event)
      # if (Policy.DEBUG_DRAG_DROP)
      # System.out.println("Drag Start: " + toString()); //$NON-NLS-1$
      doit = false # true if any one of the listeners can handle the drag
      transfers = ArrayList.new(@listeners.size)
      @active_listeners.clear
      i = 0
      while i < @listeners.size
        listener = @listeners.get(i)
        event.attr_doit = true # restore event.doit
        SafeRunnable.run(Class.new(SafeRunnable.class == Class ? SafeRunnable : Object) do
          extend LocalClass
          include_class_members DelegatingDragAdapter
          include SafeRunnable if SafeRunnable.class == Module
          
          typesig { [] }
          define_method :run do
            listener.drag_start(event)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        if (event.attr_doit)
          # the listener can handle this drag
          transfers.add(listener.get_transfer)
          @active_listeners.add(listener)
        end
        doit |= event.attr_doit
        i += 1
      end
      if (doit)
        (event.attr_widget).set_transfer(transfers.to_array(Array.typed(Transfer).new(transfers.size) { nil }))
      end
      event.attr_doit = doit
    end
    
    typesig { [] }
    # Returns the <code>Transfer<code>s from every <code>TransferDragSourceListener</code>.
    # 
    # @return the combined <code>Transfer</code>s
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
    # Returns <code>true</code> if there are no listeners to delegate drag events to.
    # 
    # @return <code>true</code> if there are no <code>TransferDragSourceListeners</code>
    # <code>false</code> otherwise.
    def is_empty
      return @listeners.is_empty
    end
    
    typesig { [TransferDragSourceListener] }
    # Removes the given <code>TransferDragSourceListener</code>.
    # Listeners should not be removed while a drag and drop operation is in progress.
    # 
    # @param listener the <code>TransferDragSourceListener</code> to remove
    def remove_drag_source_listener(listener)
      @listeners.remove(listener)
      if ((@current_listener).equal?(listener))
        @current_listener = nil
      end
      if (@active_listeners.contains(listener))
        @active_listeners.remove(listener)
      end
    end
    
    typesig { [DragSourceEvent] }
    # Updates the current listener to one that can handle the drag. There can
    # be many listeners and each listener may be able to handle many <code>TransferData</code>
    # types.  The first listener found that supports one of the <code>TransferData</ode>
    # types specified in the <code>DragSourceEvent</code> will be selected.
    # 
    # @param event the drag source event
    def update_current_listener(event)
      @current_listener = nil
      if ((event.attr_data_type).nil?)
        return
      end
      iterator_ = @active_listeners.iterator
      while (iterator_.has_next)
        listener = iterator_.next_
        if (listener.get_transfer.is_supported_type(event.attr_data_type))
          # if (Policy.DEBUG_DRAG_DROP)
          # System.out.println("Current drag listener: " + listener); //$NON-NLS-1$
          @current_listener = listener
          return
        end
      end
    end
    
    typesig { [] }
    def initialize
      @listeners = ArrayList.new
      @active_listeners = ArrayList.new
      @current_listener = nil
    end
    
    private
    alias_method :initialize__delegating_drag_adapter, :initialize
  end
  
end
