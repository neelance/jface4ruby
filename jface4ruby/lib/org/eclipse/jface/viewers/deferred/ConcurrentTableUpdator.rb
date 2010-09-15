require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers::Deferred
  module ConcurrentTableUpdatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers::Deferred
    }
  end
  
  # Allows a table to be accessed from a background thread. Provides a table-like public
  # interface that can accessed from a background thread. As updates arrive from the
  # background thread, it batches and schedules updates to the real table in the UI thread.
  # This class can be used with any widget that can be wrapped in the
  # <code>AbstractVirtualTable</code> interface.
  # 
  # @since 3.1
  # 
  # package
  class ConcurrentTableUpdator 
    include_class_members ConcurrentTableUpdatorImports
    
    # Wrapper for the real table. May only be accessed in the UI thread.
    attr_accessor :table
    alias_method :attr_table, :table
    undef_method :table
    alias_method :attr_table=, :table=
    undef_method :table=
    
    # The array of objects that have been sent to the UI. Elements are null
    # if they either haven't been sent yet or have been scheduled for clear.
    # Maps indices onto elements.
    attr_accessor :sent_objects
    alias_method :attr_sent_objects, :sent_objects
    undef_method :sent_objects
    alias_method :attr_sent_objects=, :sent_objects=
    undef_method :sent_objects=
    
    # Map of elements to object indices (inverse of the knownObjects array)
    attr_accessor :known_indices
    alias_method :attr_known_indices, :known_indices
    undef_method :known_indices
    alias_method :attr_known_indices=, :known_indices=
    undef_method :known_indices=
    
    # Contains all known objects that have been sent here from the background
    # thread.
    attr_accessor :known_objects
    alias_method :attr_known_objects, :known_objects
    undef_method :known_objects
    alias_method :attr_known_objects=, :known_objects=
    undef_method :known_objects=
    
    class_module.module_eval {
      # Minimum length for the pendingFlushes stack
      const_set_lazy(:MIN_FLUSHLENGTH) { 64 }
      const_attr_reader  :MIN_FLUSHLENGTH
    }
    
    # Array of element indices. Contains elements scheduled to be
    # cleared. Only the beginning of the array is used. The number
    # of used elements is stored in lastClear
    attr_accessor :pending_clears
    alias_method :attr_pending_clears, :pending_clears
    undef_method :pending_clears
    alias_method :attr_pending_clears=, :pending_clears=
    undef_method :pending_clears=
    
    # Number of pending clears in the pendingClears array (this is normally
    # used instead of pendingClears.length since the
    # pendingClears array is usually larger than the actual number of pending
    # clears)
    attr_accessor :last_clear
    alias_method :attr_last_clear, :last_clear
    undef_method :last_clear
    alias_method :attr_last_clear=, :last_clear=
    undef_method :last_clear=
    
    # Last known visible range
    attr_accessor :last_range
    alias_method :attr_last_range, :last_range
    undef_method :last_range
    alias_method :attr_last_range=, :last_range=
    undef_method :last_range=
    
    # True iff a UI update has been scheduled
    attr_accessor :update_scheduled
    alias_method :attr_update_scheduled, :update_scheduled
    undef_method :update_scheduled
    alias_method :attr_update_scheduled=, :update_scheduled=
    undef_method :update_scheduled=
    
    # True iff this object has been disposed
    attr_accessor :disposed
    alias_method :attr_disposed, :disposed
    undef_method :disposed
    alias_method :attr_disposed=, :disposed=
    undef_method :disposed=
    
    class_module.module_eval {
      # Object that holds a start index and length. Allows
      # the visible range to be returned as an atomic operation.
      const_set_lazy(:Range) { Class.new do
        include_class_members ConcurrentTableUpdator
        
        attr_accessor :start
        alias_method :attr_start, :start
        undef_method :start
        alias_method :attr_start=, :start=
        undef_method :start=
        
        attr_accessor :length
        alias_method :attr_length, :length
        undef_method :length
        alias_method :attr_length=, :length=
        undef_method :length=
        
        typesig { [::Java::Int, ::Java::Int] }
        # @param s
        # @param l
        def initialize(s, l)
          @start = 0
          @length = 0
          @start = s
          @length = l
        end
        
        private
        alias_method :initialize__range, :initialize
      end }
    }
    
    # Runnable that can be posted with an asyncExec to schedule
    # an update to the real table.
    attr_accessor :ui_runnable
    alias_method :attr_ui_runnable, :ui_runnable
    undef_method :ui_runnable
    alias_method :attr_ui_runnable=, :ui_runnable=
    undef_method :ui_runnable=
    
    typesig { [AbstractVirtualTable] }
    # Creates a new table updator
    # 
    # @param table real table to update
    def initialize(table)
      @table = nil
      @sent_objects = Array.typed(Object).new(0) { nil }
      @known_indices = IntHashMap.new
      @known_objects = Array.typed(Object).new(0) { nil }
      @pending_clears = Array.typed(::Java::Int).new(MIN_FLUSHLENGTH) { 0 }
      @last_clear = 0
      @last_range = Range.new(0, 0)
      @update_scheduled = false
      @disposed = false
      @ui_runnable = Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in ConcurrentTableUpdator
        include_class_members ConcurrentTableUpdator
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          self.attr_update_scheduled = false
          if (!table.get_control.is_disposed)
            update_table
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @table = table
    end
    
    typesig { [] }
    # Cleans up the updator object (but not the table itself).
    def dispose
      @disposed = true
    end
    
    typesig { [] }
    # True iff this object has been disposed.
    # 
    # @return true iff dispose() has been called
    def is_disposed
      return @disposed
    end
    
    typesig { [] }
    # Returns the currently visible range
    # 
    # @return the currently visible range
    def get_visible_range
      return @last_range
    end
    
    typesig { [Object] }
    # Marks the given object as dirty. Will cause it to be cleared
    # in the table.
    # 
    # @param toFlush
    def clear(to_flush)
      synchronized((self)) do
        current_idx = @known_indices.get(to_flush, -1)
        # If we've never heard of this object, bail out.
        if ((current_idx).equal?(-1))
          return
        end
        push_clear(current_idx)
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the size of the table. Called from a background thread.
    # 
    # @param newTotal
    def set_total_items(new_total)
      synchronized((self)) do
        if (!(new_total).equal?(@known_objects.attr_length))
          if (new_total < @known_objects.attr_length)
            # Flush any objects that are being removed as a result of the resize
            i = new_total
            while i < @known_objects.attr_length
              to_flush = @known_objects[i]
              if (!(to_flush).nil?)
                @known_indices.remove(to_flush)
              end
              i += 1
            end
          end
          min_size = Math.min(@known_objects.attr_length, new_total)
          new_known_objects = Array.typed(Object).new(new_total) { nil }
          System.arraycopy(@known_objects, 0, new_known_objects, 0, min_size)
          @known_objects = new_known_objects
          schedule_uiupdate
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Pushes an index onto the clear stack
    # 
    # @param toClear row to clear
    def push_clear(to_clear)
      # If beyond the end of the table
      if (to_clear >= @sent_objects.attr_length)
        return
      end
      # If already flushed or never sent
      if ((@sent_objects[to_clear]).nil?)
        return
      end
      # Mark as flushed
      @sent_objects[to_clear] = nil
      if (@last_clear >= @pending_clears.attr_length)
        new_capacity = Math.min(MIN_FLUSHLENGTH, @last_clear * 2)
        new_pending_clears = Array.typed(::Java::Int).new(new_capacity) { 0 }
        System.arraycopy(@pending_clears, 0, new_pending_clears, 0, @last_clear)
        @pending_clears = new_pending_clears
      end
      @pending_clears[((@last_clear += 1) - 1)] = to_clear
    end
    
    typesig { [Object, ::Java::Int] }
    # Sets the item on the given row to the given value. May be called from a background
    # thread. Schedules a UI update if necessary
    # 
    # @param idx row to change
    # @param value new value for the given row
    def replace(value, idx)
      # Keep the synchronized block as small as possible, since the UI may
      # be waiting on it.
      synchronized((self)) do
        old_object = @known_objects[idx]
        if (!(old_object).equal?(value))
          if (!(old_object).nil?)
            @known_indices.remove(old_object)
          end
          @known_objects[idx] = value
          if (!(value).nil?)
            old_index = @known_indices.get(value, -1)
            if (!(old_index).equal?(-1))
              @known_objects[old_index] = nil
              push_clear(old_index)
            end
            @known_indices.put(value, idx)
          end
          push_clear(idx)
          schedule_uiupdate
        end
      end
    end
    
    typesig { [] }
    # Schedules a UI update. Has no effect if an update has already been
    # scheduled.
    def schedule_uiupdate
      synchronized((self)) do
        if (!@update_scheduled)
          @update_scheduled = true
          if (!@table.get_control.is_disposed)
            @table.get_control.get_display.async_exec(@ui_runnable)
          end
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Called in the UI thread by a SetData callback. Refreshes the
    # table if necessary. Returns true iff a refresh is needed.
    # @param includeIndex the index that should be included in the visible range.
    def check_visible_range(include_index)
      start = Math.min(@table.get_top_index - 1, include_index)
      length = Math.max(@table.get_visible_item_count, include_index - start)
      r = @last_range
      if (!(start).equal?(r.attr_start) || !(length).equal?(r.attr_length))
        update_table
      end
    end
    
    typesig { [] }
    # Updates the table. Sends any unsent items in the visible range to the table,
    # and clears any previously-visible items that have not yet been sent to the table.
    # Must be called from the UI thread.
    def update_table
      synchronized((self)) do
        # Resize the table if necessary
        if (!(@sent_objects.attr_length).equal?(@known_objects.attr_length))
          new_sent_objects = Array.typed(Object).new(@known_objects.attr_length) { nil }
          System.arraycopy(new_sent_objects, 0, @sent_objects, 0, Math.min(new_sent_objects.attr_length, @sent_objects.attr_length))
          @sent_objects = new_sent_objects
          @table.set_item_count(new_sent_objects.attr_length)
        end
        # Compute the currently visible range
        start = Math.min(@table.get_top_index, @known_objects.attr_length)
        length = Math.min(@table.get_visible_item_count, @known_objects.attr_length - start)
        item_count = @table.get_item_count
        old_start = @last_range.attr_start
        old_len = @last_range.attr_length
        # Store the visible range. Do it BEFORE sending any table.clear calls,
        # since clearing a visible row will result in a SetData callback which
        # cause another table update if the visible range is different from
        # the stored values -- this could cause infinite recursion.
        @last_range = Range.new(start, length)
        # Re-clear any items in the old range that were never filled in
        idx = 0
        while idx < old_len
          row = idx + old_start
          # If this item is no longer visible
          if (row < item_count && (row < start || row >= start + length))
            # Note: if we wanted to be really aggressive about clearing
            # items that are no longer visible, we could clear here unconditionally.
            # The current way of doing things won't clear a row if its contents are
            # up-to-date.
            if ((@sent_objects[row]).nil?)
              @table.clear(row)
            end
          end
          idx += 1
        end
        # Process any pending clears
        if (@last_clear > 0)
          i = 0
          while i < @last_clear
            row = @pending_clears[i]
            if (row < @sent_objects.attr_length)
              @table.clear(row)
            end
            i += 1
          end
          if (@pending_clears.attr_length > MIN_FLUSHLENGTH)
            @pending_clears = Array.typed(::Java::Int).new(MIN_FLUSHLENGTH) { 0 }
          end
          @last_clear = 0
        end
        # Send any unsent items in the visible range
        idx_ = 0
        while idx_ < length
          row = idx_ + start
          obj = @known_objects[row]
          if (!(obj).nil? && !(obj).equal?(@sent_objects[idx_]))
            @table.replace(obj, row)
            @sent_objects[idx_] = obj
          end
          idx_ += 1
        end
      end
    end
    
    typesig { [] }
    # Return the array of all known objects that have been sent here from the background
    # thread.
    # @return the array of all known objects
    def get_known_objects
      return @known_objects
    end
    
    private
    alias_method :initialize__concurrent_table_updator, :initialize
  end
  
end
