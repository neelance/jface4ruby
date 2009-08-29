require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module StatusLineManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitorWithBlocking
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # A status line manager is a contribution manager which realizes itself and its items
  # in a status line control.
  # <p>
  # This class may be instantiated; it may also be subclassed if a more
  # sophisticated layout is required.
  # </p>
  class StatusLineManager < StatusLineManagerImports.const_get :ContributionManager
    include_class_members StatusLineManagerImports
    overload_protected {
      include IStatusLineManager
    }
    
    class_module.module_eval {
      # Identifier of group marker used to position contributions at the beginning
      # of the status line.
      # 
      # @since 3.0
      const_set_lazy(:BEGIN_GROUP) { "BEGIN_GROUP" }
      const_attr_reader  :BEGIN_GROUP
      
      # $NON-NLS-1$
      # 
      # Identifier of group marker used to position contributions in the middle
      # of the status line.
      # 
      # @since 3.0
      const_set_lazy(:MIDDLE_GROUP) { "MIDDLE_GROUP" }
      const_attr_reader  :MIDDLE_GROUP
      
      # $NON-NLS-1$
      # 
      # Identifier of group marker used to position contributions at the end
      # of the status line.
      # 
      # @since 3.0
      const_set_lazy(:END_GROUP) { "END_GROUP" }
      const_attr_reader  :END_GROUP
    }
    
    # $NON-NLS-1$
    # 
    # The status line control; <code>null</code> before
    # creation and after disposal.
    attr_accessor :status_line
    alias_method :attr_status_line, :status_line
    undef_method :status_line
    alias_method :attr_status_line=, :status_line=
    undef_method :status_line=
    
    typesig { [] }
    # Creates a new status line manager.
    # Use the <code>createControl</code> method to create the
    # status line control.
    def initialize
      @status_line = nil
      super()
      @status_line = nil
      add(GroupMarker.new(BEGIN_GROUP))
      add(GroupMarker.new(MIDDLE_GROUP))
      add(GroupMarker.new(END_GROUP))
    end
    
    typesig { [Composite] }
    # Creates and returns this manager's status line control.
    # Does not create a new control if one already exists.
    # <p>
    # Note: Since 3.0 the return type is <code>Control</code>.  Before 3.0, the return type was
    # the package-private class <code>StatusLine</code>.
    # </p>
    # 
    # @param parent the parent control
    # @return the status line control
    def create_control(parent)
      return create_control(parent, SWT::NONE)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates and returns this manager's status line control.
    # Does not create a new control if one already exists.
    # 
    # @param parent the parent control
    # @param style the style for the control
    # @return the status line control
    # @since 3.0
    def create_control(parent, style)
      if (!status_line_exist && !(parent).nil?)
        @status_line = StatusLine.new(parent, style)
        update(false)
      end
      return @status_line
    end
    
    typesig { [] }
    # Disposes of this status line manager and frees all allocated SWT resources.
    # Notifies all contribution items of the dispose. Note that this method does
    # not clean up references between this status line manager and its associated
    # contribution items. Use <code>removeAll</code> for that purpose.
    def dispose
      if (status_line_exist)
        @status_line.dispose
      end
      @status_line = nil
      items = get_items
      i = 0
      while i < items.attr_length
        items[i].dispose
        i += 1
      end
    end
    
    typesig { [] }
    # Returns the control used by this StatusLineManager.
    # 
    # @return the control used by this manager
    def get_control
      return @status_line
    end
    
    typesig { [] }
    # Returns the progress monitor delegate. Override this method
    # to provide your own object used to handle progress.
    # 
    # @return the IProgressMonitor delegate
    # @since 3.0
    def get_progress_monitor_delegate
      return get_control
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager
    def get_progress_monitor
      return Class.new(IProgressMonitorWithBlocking.class == Class ? IProgressMonitorWithBlocking : Object) do
        extend LocalClass
        include_class_members StatusLineManager
        include IProgressMonitorWithBlocking if IProgressMonitorWithBlocking.class == Module
        
        attr_accessor :progress_delegate
        alias_method :attr_progress_delegate, :progress_delegate
        undef_method :progress_delegate
        alias_method :attr_progress_delegate=, :progress_delegate=
        undef_method :progress_delegate=
        
        typesig { [String, ::Java::Int] }
        # (non-Javadoc)
        # @see org.eclipse.core.runtime.IProgressMonitor#beginTask(java.lang.String, int)
        define_method :begin_task do |name, total_work|
          @progress_delegate.begin_task(name, total_work)
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see org.eclipse.core.runtime.IProgressMonitor#done()
        define_method :done do
          @progress_delegate.done
        end
        
        typesig { [::Java::Double] }
        # (non-Javadoc)
        # @see org.eclipse.core.runtime.IProgressMonitor#internalWorked(double)
        define_method :internal_worked do |work|
          @progress_delegate.internal_worked(work)
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see org.eclipse.core.runtime.IProgressMonitor#isCanceled()
        define_method :is_canceled do
          return @progress_delegate.is_canceled
        end
        
        typesig { [::Java::Boolean] }
        # (non-Javadoc)
        # @see org.eclipse.core.runtime.IProgressMonitor#setCanceled(boolean)
        define_method :set_canceled do |value|
          # Don't bother updating for disposed status
          if (self.attr_status_line.is_disposed)
            return
          end
          @progress_delegate.set_canceled(value)
        end
        
        typesig { [String] }
        # (non-Javadoc)
        # @see org.eclipse.core.runtime.IProgressMonitor#setTaskName(java.lang.String)
        define_method :set_task_name do |name|
          @progress_delegate.set_task_name(name)
        end
        
        typesig { [String] }
        # (non-Javadoc)
        # @see org.eclipse.core.runtime.IProgressMonitor#subTask(java.lang.String)
        define_method :sub_task do |name|
          @progress_delegate.sub_task(name)
        end
        
        typesig { [::Java::Int] }
        # (non-Javadoc)
        # @see org.eclipse.core.runtime.IProgressMonitor#worked(int)
        define_method :worked do |work|
          @progress_delegate.worked(work)
        end
        
        typesig { [] }
        # (non-Javadoc)
        # @see org.eclipse.core.runtime.IProgressMonitorWithBlocking#clearBlocked()
        define_method :clear_blocked do
          # Do nothing here as we let the modal context handle it
        end
        
        typesig { [IStatus] }
        # (non-Javadoc)
        # @see org.eclipse.core.runtime.IProgressMonitorWithBlocking#setBlocked(org.eclipse.core.runtime.IStatus)
        define_method :set_blocked do |reason|
          # Do nothing here as we let the modal context handle it
        end
        
        typesig { [] }
        define_method :initialize do
          @progress_delegate = nil
          super()
          @progress_delegate = get_progress_monitor_delegate
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IStatueLineManager
    def is_cancel_enabled
      return status_line_exist && (@status_line).is_cancel_enabled
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on IStatueLineManager
    def set_cancel_enabled(enabled)
      if (status_line_exist)
        (@status_line).set_cancel_enabled(enabled)
      end
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager.
    def set_error_message(message)
      if (status_line_exist)
        (@status_line).set_error_message(message)
      end
    end
    
    typesig { [Image, String] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager.
    def set_error_message(image, message)
      if (status_line_exist)
        (@status_line).set_error_message(image, message)
      end
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager.
    def set_message(message)
      if (status_line_exist)
        (@status_line).set_message(message)
      end
    end
    
    typesig { [Image, String] }
    # (non-Javadoc)
    # Method declared on IStatusLineManager.
    def set_message(image, message)
      if (status_line_exist)
        (@status_line).set_message(image, message)
      end
    end
    
    typesig { [] }
    # Returns whether the status line control is created
    # and not disposed.
    # 
    # @return <code>true</code> if the control is created
    # and not disposed, <code>false</code> otherwise
    def status_line_exist
      return !(@status_line).nil? && !@status_line.is_disposed
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc)
    # Method declared on IContributionManager.
    def update(force)
      # boolean DEBUG= false;
      if (is_dirty || force)
        if (status_line_exist)
          @status_line.set_redraw(false)
          # NOTE: the update algorithm is non-incremental.
          # An incremental algorithm requires that SWT items can be created in the middle of the list
          # but the ContributionItem.fill(Composite) method used here does not take an index, so this
          # is not possible.
          ws = @status_line.get_children
          i = 0
          while i < ws.attr_length
            w = ws[i]
            data = w.get_data
            if (data.is_a?(IContributionItem))
              w.dispose
            end
            i += 1
          end
          old_child_count = @status_line.get_children.attr_length
          items = get_items
          i_ = 0
          while i_ < items.attr_length
            ci = items[i_]
            if (ci.is_visible)
              ci.fill(@status_line)
              # associate controls with contribution item
              new_children = @status_line.get_children
              j = old_child_count
              while j < new_children.attr_length
                new_children[j].set_data(ci)
                j += 1
              end
              old_child_count = new_children.attr_length
            end
            (i_ += 1)
          end
          set_dirty(false)
          @status_line.layout
          @status_line.set_redraw(true)
        end
      end
    end
    
    private
    alias_method :initialize__status_line_manager, :initialize
  end
  
end
