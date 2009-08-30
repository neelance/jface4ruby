require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers::Deferred
  module BackgroundContentProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers::Deferred
      include_const ::Java::Util, :Comparator
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :NullProgressMonitor
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Viewers, :AcceptAllFilter
      include_const ::Org::Eclipse::Jface::Viewers, :IFilter
      include_const ::Org::Eclipse::Jface::Viewers::Deferred::ConcurrentTableUpdator, :Range
    }
  end
  
  # Contains the algorithm for performing background sorting and filtering in a virtual
  # table. This is the real implementation for <code>DeferredContentProvider</code>.
  # However, this class will work with anything that implements <code>AbstractVirtualTable</code>
  # rather than being tied to a <code>TableViewer</code>.
  # 
  # <p>
  # This is package visiblity since it currently only needs to be used in one place,
  # but it could potentially be made public if there was a need to use the same background
  # sorting algorithm for something other than a TableViewer.
  # </p>
  # 
  # <p>
  # Information flow is like this:
  # </p>
  # <ol>
  # <li>IConcurrentModel sends unordered elements to BackgroundContentProvider (in a background thread)</li>
  # <li>BackgroundContentProvider sorts, filters, and sends element/index pairs to
  # ConcurrentTableUpdator (in a background thread)</li>
  # <li>ConcurrentTableUpdator batches the updates and sends them to an AbstractVirtualTable
  # (in the UI thread)</li>
  # </ol>
  # 
  # <p>
  # Internally, sorting is done using a <code>LazySortedCollection</code>. This data structure
  # allows the content provider to locate and sort the visible range without fully sorting
  # all elements in the table. It also supports fast cancellation, allowing the visible range
  # to change in the middle of a sort without discarding partially-sorted information from
  # the previous range.
  # </p>
  # 
  # @since 3.1
  # 
  # package
  class BackgroundContentProvider 
    include_class_members BackgroundContentProviderImports
    
    class_module.module_eval {
      # Sorting message string
      const_set_lazy(:SORTING) { JFaceResources.get_string("Sorting") }
      const_attr_reader  :SORTING
    }
    
    # $NON-NLS-1$
    # 
    # Table limit. -1 if unlimited
    attr_accessor :limit
    alias_method :attr_limit, :limit
    undef_method :limit
    alias_method :attr_limit=, :limit=
    undef_method :limit=
    
    # Model that is currently providing input to this content provider.
    attr_accessor :model
    alias_method :attr_model, :model
    undef_method :model
    alias_method :attr_model=, :model=
    undef_method :model=
    
    # Current sort order
    attr_accessor :sort_order
    alias_method :attr_sort_order, :sort_order
    undef_method :sort_order
    alias_method :attr_sort_order=, :sort_order=
    undef_method :sort_order=
    
    # True iff the content provider has
    attr_accessor :filter
    alias_method :attr_filter, :filter
    undef_method :filter
    alias_method :attr_filter=, :filter=
    undef_method :filter=
    
    # Queued changes
    attr_accessor :change_queue
    alias_method :attr_change_queue, :change_queue
    undef_method :change_queue
    alias_method :attr_change_queue=, :change_queue=
    undef_method :change_queue=
    
    # Listener that gets callbacks from the model
    attr_accessor :listener
    alias_method :attr_listener, :listener
    undef_method :listener
    alias_method :attr_listener=, :listener=
    undef_method :listener=
    
    # Object that posts updates to the UI thread. Must synchronize on
    # sortMutex when accessing.
    attr_accessor :updator
    alias_method :attr_updator, :updator
    undef_method :updator
    alias_method :attr_updator=, :updator=
    undef_method :updator=
    
    attr_accessor :sorting_progress_monitor
    alias_method :attr_sorting_progress_monitor, :sorting_progress_monitor
    undef_method :sorting_progress_monitor
    alias_method :attr_sorting_progress_monitor=, :sorting_progress_monitor=
    undef_method :sorting_progress_monitor=
    
    attr_accessor :sort_thread
    alias_method :attr_sort_thread, :sort_thread
    undef_method :sort_thread
    alias_method :attr_sort_thread=, :sort_thread=
    undef_method :sort_thread=
    
    attr_accessor :sort_mon
    alias_method :attr_sort_mon, :sort_mon
    undef_method :sort_mon
    alias_method :attr_sort_mon=, :sort_mon=
    undef_method :sort_mon=
    
    attr_accessor :range
    alias_method :attr_range, :range
    undef_method :range
    alias_method :attr_range=, :range=
    undef_method :range=
    
    typesig { [AbstractVirtualTable, IConcurrentModel, Comparator] }
    # Creates a new background content provider
    # 
    # @param table table that will receive updates
    # @param model data source
    # @param sortOrder initial sort order
    def initialize(table, model, sort_order)
      @limit = -1
      @model = nil
      @sort_order = nil
      @filter = AcceptAllFilter.get_instance
      @change_queue = ChangeQueue.new
      @listener = Class.new(IConcurrentModelListener.class == Class ? IConcurrentModelListener : Object) do
        extend LocalClass
        include_class_members BackgroundContentProvider
        include IConcurrentModelListener if IConcurrentModelListener.class == Module
        
        typesig { [Array.typed(Object)] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.deferred.IConcurrentModelListener#add(java.lang.Object[])
        define_method :add do |added|
          @local_class_parent.add(added)
        end
        
        typesig { [Array.typed(Object)] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.deferred.IConcurrentModelListener#remove(java.lang.Object[])
        define_method :remove do |removed|
          @local_class_parent.remove(removed)
        end
        
        typesig { [Array.typed(Object)] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.deferred.IConcurrentModelListener#setContents(java.lang.Object[])
        define_method :set_contents do |new_contents|
          @local_class_parent.set_contents(new_contents)
        end
        
        typesig { [Array.typed(Object)] }
        # (non-Javadoc)
        # @see org.eclipse.jface.viewers.deferred.IConcurrentModelListener#update(java.lang.Object[])
        define_method :update do |changed|
          @local_class_parent.update(changed)
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @updator = nil
      @sorting_progress_monitor = NullProgressMonitor.new
      @sort_thread = nil
      @sort_mon = FastProgressReporter.new
      @range = Range.new(0, 0)
      @lock = Object.new
      @sort_thread_started = false
      @sort_scheduled = false
      @updator = ConcurrentTableUpdator.new(table)
      @model = model
      @sort_order = sort_order
      model.add_listener(@listener)
    end
    
    typesig { [] }
    # Cleans up this content provider, detaches listeners, frees up memory, etc.
    # Must be the last public method called on this object.
    def dispose
      cancel_sort_job
      @updator.dispose
      @model.remove_listener(@listener)
    end
    
    typesig { [] }
    # Force a refresh. Asks the model to re-send its complete contents.
    def refresh
      if (@updator.is_disposed)
        return
      end
      @model.request_update(@listener)
    end
    
    typesig { [IProgressMonitor] }
    # Called from sortJob. Sorts the elements defined by sortStart and sortLength.
    # Schedules a UI update when finished.
    # 
    # @param mon monitor where progress will be reported
    def do_sort(mon)
      # Workaround for some weirdness in the Jobs framework: if you cancel a monitor
      # for a job that has ended and reschedule that same job, it will start
      # the job with a monitor that is already cancelled. We can workaround this by
      # removing all references to the progress monitor whenever the job terminates,
      # but this would require additional synchronize blocks (which are slow) and more
      # complexity. Instead, we just un-cancel the monitor at the start of each job.
      mon.set_canceled(false)
      mon.begin_task(SORTING, 100)
      # Create a LazySortedCollection
      order = @sort_order
      f = @filter
      collection = LazySortedCollection.new(order)
      # Fill it in with all existing known objects
      known_objects = @updator.get_known_objects
      i = 0
      while i < known_objects.attr_length
        object = known_objects[i]
        if (!(object).nil?)
          collection.add(object)
        end
        i += 1
      end
      dirty = false
      prev_size = known_objects.attr_length
      @updator.set_total_items(prev_size)
      # Start processing changes
      while (true)
        # If the sort order has changed, build a new LazySortedCollection with
        # the new comparator
        if (!(order).equal?(@sort_order))
          dirty = true
          order = @sort_order
          # Copy all elements from the old collection to the new one
          new_collection = LazySortedCollection.new(order)
          items = collection.get_items(false)
          j = 0
          while j < items.attr_length && (order).equal?(@sort_order)
            item = items[j]
            new_collection.add(item)
            j += 1
          end
          # If the sort order changed again, re-loop
          if (!(order).equal?(@sort_order))
            next
          end
          collection = new_collection
          next
        end
        # If the filter has changed
        if (!(f).equal?(@filter))
          dirty = true
          f = @filter
          items = collection.get_items(false)
          # Remove any items that don't pass the new filter
          j = 0
          while j < items.attr_length && (f).equal?(@filter)
            to_test = items[j]
            if (!f.select(to_test))
              collection.remove(to_test)
            end
            j += 1
          end
          next
        end
        # If there are pending changes, process one of them
        if (!@change_queue.is_empty)
          dirty = true
          next_ = @change_queue.dequeue
          case (next_.get_type)
          when ChangeQueue::ADD
            filtered_add(collection, next_.get_elements, f)
          when ChangeQueue::REMOVE
            to_remove = next_.get_elements
            flush(to_remove, collection)
            collection.remove_all(to_remove)
          when ChangeQueue::UPDATE
            items = next_.get_elements
            i_ = 0
            while i_ < items.attr_length
              item = items[i_]
              if (collection.contains(item))
                # TODO: write a collection.update(...) method
                collection.remove(item)
                collection.add(item)
                @updator.clear(item)
              end
              i_ += 1
            end
          when ChangeQueue::SET
            items = next_.get_elements
            collection.clear
            filtered_add(collection, items, f)
          end
          next
        end
        total_elements = collection.size
        if (!(@limit).equal?(-1))
          if (total_elements > @limit)
            total_elements = @limit
          end
        end
        if (!(total_elements).equal?(prev_size))
          prev_size = total_elements
          # Send the total items to the updator ASAP -- the user may want
          # to scroll to a different section of the table, which would
          # cause our sort range to change and cause this job to get cancelled.
          @updator.set_total_items(total_elements)
          dirty = true
        end
        # Terminate loop
        if (!dirty)
          break
        end
        begin
          update_range = @updator.get_visible_range
          @sort_mon = FastProgressReporter.new
          @range = update_range
          sort_start = update_range.attr_start
          sort_length = update_range.attr_length
          if (!(@limit).equal?(-1))
            collection.retain_first(@limit, @sort_mon)
          end
          sort_length = Math.min(sort_length, total_elements - sort_start)
          sort_length = Math.max(sort_length, 0)
          objects_of_interest = Array.typed(Object).new(sort_length) { nil }
          collection.get_range(objects_of_interest, sort_start, true, @sort_mon)
          # Send the new elements to the table
          i_ = 0
          while i_ < sort_length
            object = objects_of_interest[i_]
            @updator.replace(object, sort_start + i_)
            i_ += 1
          end
          objects_of_interest = Array.typed(Object).new(collection.size) { nil }
          collection.get_first(objects_of_interest, true, @sort_mon)
          # Send the new elements to the table
          i__ = 0
          while i__ < total_elements
            object = objects_of_interest[i__]
            @updator.replace(object, i__)
            i__ += 1
          end
        rescue InterruptedException => e
          next
        end
        dirty = false
      end
      mon.done
    end
    
    class_module.module_eval {
      typesig { [LazySortedCollection, Array.typed(Object), IFilter] }
      # @param collection
      # @param toAdd
      def filtered_add(collection, to_add, filter)
        if (!(filter).equal?(AcceptAllFilter.get_instance))
          i = 0
          while i < to_add.attr_length
            object = to_add[i]
            if (filter.select(object))
              collection.add(object)
            end
            i += 1
          end
        else
          collection.add_all(to_add)
        end
      end
    }
    
    typesig { [Comparator] }
    # Sets the sort order for this content provider
    # 
    # @param sorter sort order
    def set_sort_order(sorter)
      Assert.is_not_null(sorter)
      @sort_order = sorter
      @sort_mon.cancel
      refresh
    end
    
    typesig { [IFilter] }
    # Sets the filter for this content provider
    # 
    # @param toSet filter to set
    def set_filter(to_set)
      Assert.is_not_null(to_set)
      @filter = to_set
      @sort_mon.cancel
      refresh
    end
    
    typesig { [::Java::Int] }
    # Sets the maximum table size. Based on the current sort order,
    # the table will be truncated if it grows beyond this size.
    # Using a limit improves memory usage and performance, and is
    # strongly recommended for large tables.
    # 
    # @param limit maximum rows to show in the table or -1 if unbounded
    def set_limit(limit)
      @limit = limit
      refresh
    end
    
    typesig { [] }
    # Returns the maximum table size or -1 if unbounded
    # 
    # @return the maximum number of rows in the table or -1 if unbounded
    def get_limit
      return @limit
    end
    
    typesig { [::Java::Int] }
    # Checks if currently visible range has changed, and triggers and update
    # and resort if necessary. Must be called in the UI thread, typically
    # within a SWT.SetData callback.
    # @param includeIndex the index that should be included in the visible range.
    def check_visible_range(include_index)
      @updator.check_visible_range(include_index)
      new_range = @updator.get_visible_range
      old_range = @range
      # If we're in the middle of processing an invalid range, cancel the sort
      if (!(new_range.attr_start).equal?(old_range.attr_start) || !(new_range.attr_length).equal?(old_range.attr_length))
        @sort_mon.cancel
      end
    end
    
    # This lock protects the two boolean variables sortThreadStarted and resortScheduled.
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    # true if the sort thread is running
    attr_accessor :sort_thread_started
    alias_method :attr_sort_thread_started, :sort_thread_started
    undef_method :sort_thread_started
    alias_method :attr_sort_thread_started=, :sort_thread_started=
    undef_method :sort_thread_started=
    
    # true if we need to sort
    attr_accessor :sort_scheduled
    alias_method :attr_sort_scheduled, :sort_scheduled
    undef_method :sort_scheduled
    alias_method :attr_sort_scheduled=, :sort_scheduled=
    undef_method :sort_scheduled=
    
    class_module.module_eval {
      const_set_lazy(:SortThread) { Class.new(JavaThread) do
        extend LocalClass
        include_class_members BackgroundContentProvider
        
        typesig { [String] }
        def initialize(name)
          super(name)
        end
        
        typesig { [] }
        def run
          while (true)
            synchronized((self.attr_lock)) do
              self.attr_sort_scheduled = false
            end
            begin
              # this is the main work
              do_sort(self.attr_sorting_progress_monitor)
            rescue self.class::JavaException => ex
              # ignore
            end
            synchronized((self.attr_lock)) do
              if (self.attr_sort_scheduled)
                next
              end
              self.attr_sort_thread_started = false
              break
            end
          end
        end
        
        private
        alias_method :initialize__sort_thread, :initialize
      end }
    }
    
    typesig { [] }
    # Must be called whenever the model changes. Dirties this object and triggers a sort
    # if necessary.
    def make_dirty
      synchronized((@lock)) do
        @sort_mon.cancel
        # request sorting
        @sort_scheduled = true
        if (!@sort_thread_started)
          @sort_thread_started = true
          @sort_thread = SortThread.new_local(self, SORTING)
          @sort_thread.set_daemon(true)
          @sort_thread.set_priority(JavaThread::NORM_PRIORITY - 1)
          @sort_thread.start
        end
      end
    end
    
    typesig { [] }
    # Cancels any sort in progress. Note that we try to use the
    # FastProgresReporter if possible since this is more responsive than
    # cancelling the sort job. However, it is not a problem to cancel in both
    # ways.
    def cancel_sort_job
      @sort_mon.cancel
      @sorting_progress_monitor.set_canceled(true)
    end
    
    typesig { [Array.typed(Object)] }
    # Called when new elements are added to the model.
    # 
    # @param toAdd
    # newly added elements
    def add(to_add)
      @change_queue.enqueue(ChangeQueue::ADD, to_add)
      make_dirty
    end
    
    typesig { [Array.typed(Object)] }
    # Called with the complete contents of the model
    # 
    # @param contents new contents of the model
    def set_contents(contents)
      @change_queue.enqueue(ChangeQueue::SET, contents)
      make_dirty
    end
    
    typesig { [Array.typed(Object)] }
    # Called when elements are removed from the model
    # 
    # @param toRemove elements removed from the model
    def remove(to_remove)
      @change_queue.enqueue(ChangeQueue::REMOVE, to_remove)
      make_dirty
      refresh
    end
    
    typesig { [Array.typed(Object), LazySortedCollection] }
    # Notifies the updator that the given elements have changed
    # 
    # @param toFlush changed elements
    # @param collection collection of currently-known elements
    def flush(to_flush, collection)
      i = 0
      while i < to_flush.attr_length
        item = to_flush[i]
        if (collection.contains(item))
          @updator.clear(item)
        end
        i += 1
      end
    end
    
    typesig { [Array.typed(Object)] }
    # Called when elements in the model change
    # 
    # @param items changed items
    def update(items)
      @change_queue.enqueue(ChangeQueue::UPDATE, items)
      make_dirty
    end
    
    private
    alias_method :initialize__background_content_provider, :initialize
  end
  
end
