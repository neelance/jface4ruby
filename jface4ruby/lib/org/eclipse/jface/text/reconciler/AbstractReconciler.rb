require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Reconciler
  module AbstractReconcilerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Reconciler
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :NullProgressMonitor
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :ITextInputListener
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
    }
  end
  
  # Abstract implementation of {@link IReconciler}. The reconciler
  # listens to input document changes as well as changes of
  # the input document of the text viewer it is installed on. Depending on
  # its configuration it manages the received change notifications in a
  # queue folding neighboring or overlapping changes together. The reconciler
  # processes the dirty regions as a background activity after having waited for further
  # changes for the configured duration of time. A reconciler is started using the
  # {@link #install(ITextViewer)} method.  As a first step {@link #initialProcess()} is
  # executed in the background. Then, the reconciling thread waits for changes that
  # need to be reconciled. A reconciler can be resumed by calling {@link #forceReconciling()}
  # independent from the existence of actual changes. This mechanism is for subclasses only.
  # It is the clients responsibility to stop a reconciler using its {@link #uninstall()}
  # method. Unstopped reconcilers do not free their resources.
  # <p>
  # It is subclass responsibility to specify how dirty regions are processed.
  # </p>
  # 
  # @see org.eclipse.jface.text.IDocumentListener
  # @see org.eclipse.jface.text.ITextInputListener
  # @see org.eclipse.jface.text.reconciler.DirtyRegion
  # @since 2.0
  class AbstractReconciler 
    include_class_members AbstractReconcilerImports
    include IReconciler
    
    class_module.module_eval {
      # Background thread for the reconciling activity.
      const_set_lazy(:BackgroundThread) { Class.new(JavaThread) do
        local_class_in AbstractReconciler
        include_class_members AbstractReconciler
        
        # Has the reconciler been canceled.
        attr_accessor :f_canceled
        alias_method :attr_f_canceled, :f_canceled
        undef_method :f_canceled
        alias_method :attr_f_canceled=, :f_canceled=
        undef_method :f_canceled=
        
        # Has the reconciler been reset.
        attr_accessor :f_reset
        alias_method :attr_f_reset, :f_reset
        undef_method :f_reset
        alias_method :attr_f_reset=, :f_reset=
        undef_method :f_reset=
        
        # Some changes need to be processed.
        attr_accessor :f_is_dirty
        alias_method :attr_f_is_dirty, :f_is_dirty
        undef_method :f_is_dirty
        alias_method :attr_f_is_dirty=, :f_is_dirty=
        undef_method :f_is_dirty=
        
        # Is a reconciling strategy active.
        attr_accessor :f_is_active
        alias_method :attr_f_is_active, :f_is_active
        undef_method :f_is_active
        alias_method :attr_f_is_active=, :f_is_active=
        undef_method :f_is_active=
        
        typesig { [String] }
        # Creates a new background thread. The thread
        # runs with minimal priority.
        # 
        # @param name the thread's name
        def initialize(name)
          @f_canceled = false
          @f_reset = false
          @f_is_dirty = false
          @f_is_active = false
          super(name)
          @f_canceled = false
          @f_reset = false
          @f_is_dirty = false
          @f_is_active = false
          set_priority(JavaThread::MIN_PRIORITY)
          set_daemon(true)
        end
        
        typesig { [] }
        # Returns whether a reconciling strategy is active right now.
        # 
        # @return <code>true</code> if a activity is active
        def is_active
          return @f_is_active
        end
        
        typesig { [] }
        # Returns whether some changes need to be processed.
        # 
        # @return <code>true</code> if changes wait to be processed
        # @since 3.0
        def is_dirty
          synchronized(self) do
            return @f_is_dirty
          end
        end
        
        typesig { [] }
        # Cancels the background thread.
        def cancel
          @f_canceled = true
          pm = self.attr_f_progress_monitor
          if (!(pm).nil?)
            pm.set_canceled(true)
          end
          synchronized((self.attr_f_dirty_region_queue)) do
            self.attr_f_dirty_region_queue.notify_all
          end
        end
        
        typesig { [] }
        # Suspends the caller of this method until this background thread has
        # emptied the dirty region queue.
        def suspend_caller_while_dirty
          is_dirty = false
          begin
            synchronized((self.attr_f_dirty_region_queue)) do
              is_dirty = self.attr_f_dirty_region_queue.get_size > 0
              if (is_dirty)
                begin
                  self.attr_f_dirty_region_queue.wait
                rescue self.class::InterruptedException => x
                end
              end
            end
          end while (is_dirty)
        end
        
        typesig { [] }
        # Reset the background thread as the text viewer has been changed,
        def reset
          if (self.attr_f_delay > 0)
            synchronized((self)) do
              @f_is_dirty = true
              @f_reset = true
            end
          else
            synchronized((self)) do
              @f_is_dirty = true
            end
            synchronized((self.attr_f_dirty_region_queue)) do
              self.attr_f_dirty_region_queue.notify_all
            end
          end
          reconciler_reset
        end
        
        typesig { [] }
        # The background activity. Waits until there is something in the
        # queue managing the changes that have been applied to the text viewer.
        # Removes the first change from the queue and process it.
        # <p>
        # Calls {@link AbstractReconciler#initialProcess()} on entrance.
        # </p>
        def run
          synchronized((self.attr_f_dirty_region_queue)) do
            begin
              self.attr_f_dirty_region_queue.wait(self.attr_f_delay)
            rescue self.class::InterruptedException => x
            end
          end
          if (@f_canceled)
            return
          end
          initial_process
          while (!@f_canceled)
            synchronized((self.attr_f_dirty_region_queue)) do
              begin
                self.attr_f_dirty_region_queue.wait(self.attr_f_delay)
              rescue self.class::InterruptedException => x
              end
            end
            if (@f_canceled)
              break
            end
            if (!is_dirty)
              next
            end
            synchronized((self)) do
              if (@f_reset)
                @f_reset = false
                next
              end
            end
            r = nil
            synchronized((self.attr_f_dirty_region_queue)) do
              r = self.attr_f_dirty_region_queue.remove_next_dirty_region
            end
            @f_is_active = true
            self.attr_f_progress_monitor.set_canceled(false)
            process(r)
            synchronized((self.attr_f_dirty_region_queue)) do
              if ((0).equal?(self.attr_f_dirty_region_queue.get_size))
                synchronized((self)) do
                  @f_is_dirty = self.attr_f_progress_monitor.is_canceled
                end
                self.attr_f_dirty_region_queue.notify_all
              end
            end
            @f_is_active = false
          end
        end
        
        private
        alias_method :initialize__background_thread, :initialize
      end }
      
      # Internal document listener and text input listener.
      const_set_lazy(:Listener) { Class.new do
        local_class_in AbstractReconciler
        include_class_members AbstractReconciler
        include IDocumentListener
        include ITextInputListener
        
        typesig { [class_self::DocumentEvent] }
        # @see IDocumentListener#documentAboutToBeChanged(DocumentEvent)
        def document_about_to_be_changed(e)
        end
        
        typesig { [class_self::DocumentEvent] }
        # @see IDocumentListener#documentChanged(DocumentEvent)
        def document_changed(e)
          if (!self.attr_f_thread.is_dirty && self.attr_f_thread.is_alive)
            if (!self.attr_f_is_allowed_to_modify_document && (JavaThread.current_thread).equal?(self.attr_f_thread))
              raise self.class::UnsupportedOperationException.new("The reconciler thread is not allowed to modify the document")
            end # $NON-NLS-1$
            about_to_be_reconciled
          end
          # The second OR condition handles the case when the document
          # gets changed while still inside initialProcess().
          if (self.attr_f_thread.is_active || self.attr_f_thread.is_dirty && self.attr_f_thread.is_alive)
            self.attr_f_progress_monitor.set_canceled(true)
          end
          if (self.attr_f_is_incremental_reconciler)
            create_dirty_region(e)
          end
          self.attr_f_thread.reset
        end
        
        typesig { [class_self::IDocument, class_self::IDocument] }
        # @see ITextInputListener#inputDocumentAboutToBeChanged(IDocument, IDocument)
        def input_document_about_to_be_changed(old_input, new_input)
          if ((old_input).equal?(self.attr_f_document))
            if (!(self.attr_f_document).nil?)
              self.attr_f_document.remove_document_listener(self)
            end
            if (self.attr_f_is_incremental_reconciler)
              synchronized((self.attr_f_dirty_region_queue)) do
                self.attr_f_dirty_region_queue.purge_queue
              end
              if (!(self.attr_f_document).nil? && self.attr_f_document.get_length > 0 && self.attr_f_thread.is_dirty && self.attr_f_thread.is_alive)
                e = self.class::DocumentEvent.new(self.attr_f_document, 0, self.attr_f_document.get_length, "") # $NON-NLS-1$
                create_dirty_region(e)
                self.attr_f_thread.reset
                self.attr_f_thread.suspend_caller_while_dirty
              end
            end
            self.attr_f_document = nil
          end
        end
        
        typesig { [class_self::IDocument, class_self::IDocument] }
        # @see ITextInputListener#inputDocumentChanged(IDocument, IDocument)
        def input_document_changed(old_input, new_input)
          self.attr_f_document = new_input
          if ((self.attr_f_document).nil?)
            return
          end
          reconciler_document_changed(self.attr_f_document)
          self.attr_f_document.add_document_listener(self)
          if (!self.attr_f_thread.is_dirty)
            about_to_be_reconciled
          end
          start_reconciling
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__listener, :initialize
      end }
    }
    
    # Queue to manage the changes applied to the text viewer.
    attr_accessor :f_dirty_region_queue
    alias_method :attr_f_dirty_region_queue, :f_dirty_region_queue
    undef_method :f_dirty_region_queue
    alias_method :attr_f_dirty_region_queue=, :f_dirty_region_queue=
    undef_method :f_dirty_region_queue=
    
    # The background thread.
    attr_accessor :f_thread
    alias_method :attr_f_thread, :f_thread
    undef_method :f_thread
    alias_method :attr_f_thread=, :f_thread=
    undef_method :f_thread=
    
    # Internal document and text input listener.
    attr_accessor :f_listener
    alias_method :attr_f_listener, :f_listener
    undef_method :f_listener
    alias_method :attr_f_listener=, :f_listener=
    undef_method :f_listener=
    
    # The background thread delay.
    attr_accessor :f_delay
    alias_method :attr_f_delay, :f_delay
    undef_method :f_delay
    alias_method :attr_f_delay=, :f_delay=
    undef_method :f_delay=
    
    # Are there incremental reconciling strategies?
    attr_accessor :f_is_incremental_reconciler
    alias_method :attr_f_is_incremental_reconciler, :f_is_incremental_reconciler
    undef_method :f_is_incremental_reconciler
    alias_method :attr_f_is_incremental_reconciler=, :f_is_incremental_reconciler=
    undef_method :f_is_incremental_reconciler=
    
    # The progress monitor used by this reconciler.
    attr_accessor :f_progress_monitor
    alias_method :attr_f_progress_monitor, :f_progress_monitor
    undef_method :f_progress_monitor
    alias_method :attr_f_progress_monitor=, :f_progress_monitor=
    undef_method :f_progress_monitor=
    
    # Tells whether this reconciler is allowed to modify the document.
    # @since 3.2
    attr_accessor :f_is_allowed_to_modify_document
    alias_method :attr_f_is_allowed_to_modify_document, :f_is_allowed_to_modify_document
    undef_method :f_is_allowed_to_modify_document
    alias_method :attr_f_is_allowed_to_modify_document=, :f_is_allowed_to_modify_document=
    undef_method :f_is_allowed_to_modify_document=
    
    # The text viewer's document.
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The text viewer
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    typesig { [DirtyRegion] }
    # Processes a dirty region. If the dirty region is <code>null</code> the whole
    # document is consider being dirty. The dirty region is partitioned by the
    # document and each partition is handed over to a reconciling strategy registered
    # for the partition's content type.
    # 
    # @param dirtyRegion the dirty region to be processed
    def process(dirty_region)
      raise NotImplementedError
    end
    
    typesig { [IDocument] }
    # Hook called when the document whose contents should be reconciled
    # has been changed, i.e., the input document of the text viewer this
    # reconciler is installed on. Usually, subclasses use this hook to
    # inform all their reconciling strategies about the change.
    # 
    # @param newDocument the new reconciler document
    def reconciler_document_changed(new_document)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Creates a new reconciler without configuring it.
    def initialize
      @f_dirty_region_queue = nil
      @f_thread = nil
      @f_listener = nil
      @f_delay = 500
      @f_is_incremental_reconciler = true
      @f_progress_monitor = nil
      @f_is_allowed_to_modify_document = true
      @f_document = nil
      @f_viewer = nil
      @f_progress_monitor = NullProgressMonitor.new
    end
    
    typesig { [::Java::Int] }
    # Tells the reconciler how long it should wait for further text changes before
    # activating the appropriate reconciling strategies.
    # 
    # @param delay the duration in milliseconds of a change collection period.
    def set_delay(delay)
      @f_delay = delay
    end
    
    typesig { [::Java::Boolean] }
    # Tells the reconciler whether any of the available reconciling strategies
    # is interested in getting detailed dirty region information or just in the
    # fact that the document has been changed. In the second case, the reconciling
    # can not incrementally be pursued.
    # 
    # @param isIncremental indicates whether this reconciler will be configured with
    # incremental reconciling strategies
    # 
    # @see DirtyRegion
    # @see IReconcilingStrategy
    def set_is_incremental_reconciler(is_incremental)
      @f_is_incremental_reconciler = is_incremental
    end
    
    typesig { [::Java::Boolean] }
    # Tells the reconciler whether it is allowed to change the document
    # inside its reconciler thread.
    # <p>
    # If this is set to <code>false</code> an {@link UnsupportedOperationException}
    # will be thrown when this restriction will be violated.
    # </p>
    # 
    # @param isAllowedToModify indicates whether this reconciler is allowed to modify the document
    # @since 3.2
    def set_is_allowed_to_modify_document(is_allowed_to_modify)
      @f_is_allowed_to_modify_document = is_allowed_to_modify
    end
    
    typesig { [IProgressMonitor] }
    # Sets the progress monitor of this reconciler.
    # 
    # @param monitor the monitor to be used
    def set_progress_monitor(monitor)
      Assert.is_legal(!(monitor).nil?)
      @f_progress_monitor = monitor
    end
    
    typesig { [] }
    # Returns whether any of the reconciling strategies is interested in
    # detailed dirty region information.
    # 
    # @return whether this reconciler is incremental
    # 
    # @see IReconcilingStrategy
    def is_incremental_reconciler
      return @f_is_incremental_reconciler
    end
    
    typesig { [] }
    # Returns the input document of the text viewer this reconciler is installed on.
    # 
    # @return the reconciler document
    def get_document
      return @f_document
    end
    
    typesig { [] }
    # Returns the text viewer this reconciler is installed on.
    # 
    # @return the text viewer this reconciler is installed on
    def get_text_viewer
      return @f_viewer
    end
    
    typesig { [] }
    # Returns the progress monitor of this reconciler.
    # 
    # @return the progress monitor of this reconciler
    def get_progress_monitor
      return @f_progress_monitor
    end
    
    typesig { [ITextViewer] }
    # @see IReconciler#install(ITextViewer)
    def install(text_viewer)
      Assert.is_not_null(text_viewer)
      @f_viewer = text_viewer
      synchronized((self)) do
        if (!(@f_thread).nil?)
          return
        end
        @f_thread = BackgroundThread.new_local(self, get_class.get_name)
      end
      @f_dirty_region_queue = DirtyRegionQueue.new
      @f_listener = Listener.new_local(self)
      @f_viewer.add_text_input_listener(@f_listener)
      # see bug https://bugs.eclipse.org/bugs/show_bug.cgi?id=67046
      # if the reconciler gets installed on a viewer that already has a document
      # (e.g. when reusing editors), we force the listener to register
      # itself as document listener, because there will be no input change
      # on the viewer.
      # In order to do that, we simulate an input change.
      document = text_viewer.get_document
      if (!(document).nil?)
        @f_listener.input_document_about_to_be_changed(@f_document, document)
        @f_listener.input_document_changed(@f_document, document)
      end
    end
    
    typesig { [] }
    # @see IReconciler#uninstall()
    def uninstall
      if (!(@f_listener).nil?)
        @f_viewer.remove_text_input_listener(@f_listener)
        if (!(@f_document).nil?)
          @f_listener.input_document_about_to_be_changed(@f_document, nil)
          @f_listener.input_document_changed(@f_document, nil)
        end
        @f_listener = nil
        synchronized((self)) do
          # http://dev.eclipse.org/bugs/show_bug.cgi?id=19135
          bt = @f_thread
          @f_thread = nil
          bt.cancel
        end
      end
    end
    
    typesig { [DocumentEvent] }
    # Creates a dirty region for a document event and adds it to the queue.
    # 
    # @param e the document event for which to create a dirty region
    def create_dirty_region(e)
      synchronized((@f_dirty_region_queue)) do
        if ((e.get_length).equal?(0) && !(e.get_text).nil?)
          # Insert
          @f_dirty_region_queue.add_dirty_region(DirtyRegion.new(e.get_offset, e.get_text.length, DirtyRegion::INSERT, e.get_text))
        else
          if ((e.get_text).nil? || (e.get_text.length).equal?(0))
            # Remove
            @f_dirty_region_queue.add_dirty_region(DirtyRegion.new(e.get_offset, e.get_length, DirtyRegion::REMOVE, nil))
          else
            # Replace (Remove + Insert)
            @f_dirty_region_queue.add_dirty_region(DirtyRegion.new(e.get_offset, e.get_length, DirtyRegion::REMOVE, nil))
            @f_dirty_region_queue.add_dirty_region(DirtyRegion.new(e.get_offset, e.get_text.length, DirtyRegion::INSERT, e.get_text))
          end
        end
      end
    end
    
    typesig { [] }
    # Hook for subclasses which want to perform some
    # action as soon as reconciliation is needed.
    # <p>
    # Default implementation is to do nothing.
    # </p>
    # 
    # @since 3.0
    def about_to_be_reconciled
    end
    
    typesig { [] }
    # This method is called on startup of the background activity. It is called only
    # once during the life time of the reconciler. Clients may reimplement this method.
    def initial_process
    end
    
    typesig { [] }
    # Forces the reconciler to reconcile the structure of the whole document.
    # Clients may extend this method.
    def force_reconciling
      if (!(@f_document).nil?)
        if (!@f_thread.is_dirty && @f_thread.is_alive)
          about_to_be_reconciled
        end
        if (@f_thread.is_active)
          @f_progress_monitor.set_canceled(true)
        end
        if (@f_is_incremental_reconciler)
          e = DocumentEvent.new(@f_document, 0, @f_document.get_length, @f_document.get)
          create_dirty_region(e)
        end
        start_reconciling
      end
    end
    
    typesig { [] }
    # Starts the reconciler to reconcile the queued dirty-regions.
    # Clients may extend this method.
    def start_reconciling
      synchronized(self) do
        if ((@f_thread).nil?)
          return
        end
        if (!@f_thread.is_alive)
          begin
            @f_thread.start
          rescue IllegalThreadStateException => e
            # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=40549
            # This is the only instance where the thread is started; since
            # we checked that it is not alive, it must be dead already due
            # to a run-time exception or error. Exit.
          end
        else
          @f_thread.reset
        end
      end
    end
    
    typesig { [] }
    # Hook that is called after the reconciler thread has been reset.
    def reconciler_reset
    end
    
    typesig { [] }
    # Tells whether the code is running in this reconciler's
    # background thread.
    # 
    # @return <code>true</code> if running in this reconciler's background thread
    # @since 3.4
    def is_running_in_reconciler_thread
      return (JavaThread.current_thread).equal?(@f_thread)
    end
    
    private
    alias_method :initialize__abstract_reconciler, :initialize
  end
  
end
