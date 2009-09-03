require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module AdditionalInfoControllerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Core::Runtime::Jobs, :Job
      include_const ::Org::Eclipse::Jface::Internal::Text, :InformationControlReplacer
      include_const ::Org::Eclipse::Jface::Text, :AbstractInformationControlManager
      include_const ::Org::Eclipse::Jface::Text, :AbstractReusableInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :DefaultInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension3
    }
  end
  
  # Displays the additional information available for a completion proposal.
  # 
  # @since 2.0
  class AdditionalInfoController < AdditionalInfoControllerImports.const_get :AbstractInformationControlManager
    include_class_members AdditionalInfoControllerImports
    
    class_module.module_eval {
      # A timer thread.
      # 
      # @since 3.2
      const_set_lazy(:Timer) { Class.new do
        include_class_members AdditionalInfoController
        
        class_module.module_eval {
          const_set_lazy(:DELAY_UNTIL_JOB_IS_SCHEDULED) { 50 }
          const_attr_reader  :DELAY_UNTIL_JOB_IS_SCHEDULED
          
          # A <code>Task</code> is {@link Task#run() run} when {@link #delay()} milliseconds have
          # elapsed after it was scheduled without a {@link #reset(ICompletionProposal) reset}
          # to occur.
          const_set_lazy(:Task) { Class.new do
            extend LocalClass
            include_class_members Timer
            include class_self::Runnable
            
            typesig { [] }
            # @return the delay in milliseconds before this task should be run
            def delay
              raise NotImplementedError
            end
            
            typesig { [] }
            # Runs this task.
            def run
              raise NotImplementedError
            end
            
            typesig { [] }
            # @return the task to be scheduled after this task has been run
            def next_task
              raise NotImplementedError
            end
            
            typesig { [] }
            def initialize
            end
            
            private
            alias_method :initialize__task, :initialize
          end }
        }
        
        # IDLE: the initial task, and active whenever the info has been shown. It cannot be run,
        # but specifies an infinite delay.
        attr_accessor :idle
        alias_method :attr_idle, :idle
        undef_method :idle
        alias_method :attr_idle=, :idle=
        undef_method :idle=
        
        # FIRST_WAIT: Schedules a platform {@link Job} to fetch additional info from an {@link ICompletionProposalExtension5}.
        attr_accessor :first_wait
        alias_method :attr_first_wait, :first_wait
        undef_method :first_wait
        alias_method :attr_first_wait=, :first_wait=
        undef_method :first_wait=
        
        # SECOND_WAIT: Allows display of additional info obtained from an
        # {@link ICompletionProposalExtension5}.
        attr_accessor :second_wait
        alias_method :attr_second_wait, :second_wait
        undef_method :second_wait
        alias_method :attr_second_wait=, :second_wait=
        undef_method :second_wait=
        
        # LEGACY_WAIT: Posts a runnable into the display thread to fetch additional info from non-{@link ICompletionProposalExtension5}s.
        attr_accessor :legacy_wait
        alias_method :attr_legacy_wait, :legacy_wait
        undef_method :legacy_wait
        alias_method :attr_legacy_wait=, :legacy_wait=
        undef_method :legacy_wait=
        
        # EXIT: The task that triggers termination of the timer thread.
        attr_accessor :exit
        alias_method :attr_exit, :exit
        undef_method :exit
        alias_method :attr_exit=, :exit=
        undef_method :exit=
        
        # The timer thread.
        attr_accessor :f_thread
        alias_method :attr_f_thread, :f_thread
        undef_method :f_thread
        alias_method :attr_f_thread=, :f_thread=
        undef_method :f_thread=
        
        # The currently waiting / active task.
        attr_accessor :f_task
        alias_method :attr_f_task, :f_task
        undef_method :f_task
        alias_method :attr_f_task=, :f_task=
        undef_method :f_task=
        
        # The next wake up time.
        attr_accessor :f_next_wakeup
        alias_method :attr_f_next_wakeup, :f_next_wakeup
        undef_method :f_next_wakeup
        alias_method :attr_f_next_wakeup=, :f_next_wakeup=
        undef_method :f_next_wakeup=
        
        attr_accessor :f_current_proposal
        alias_method :attr_f_current_proposal, :f_current_proposal
        undef_method :f_current_proposal
        alias_method :attr_f_current_proposal=, :f_current_proposal=
        undef_method :f_current_proposal=
        
        attr_accessor :f_current_info
        alias_method :attr_f_current_info, :f_current_info
        undef_method :f_current_info
        alias_method :attr_f_current_info=, :f_current_info=
        undef_method :f_current_info=
        
        attr_accessor :f_allow_showing
        alias_method :attr_f_allow_showing, :f_allow_showing
        undef_method :f_allow_showing
        alias_method :attr_f_allow_showing=, :f_allow_showing=
        undef_method :f_allow_showing=
        
        attr_accessor :f_display
        alias_method :attr_f_display, :f_display
        undef_method :f_display
        alias_method :attr_f_display=, :f_display=
        undef_method :f_display=
        
        attr_accessor :f_delay
        alias_method :attr_f_delay, :f_delay
        undef_method :f_delay
        alias_method :attr_f_delay=, :f_delay=
        undef_method :f_delay=
        
        typesig { [class_self::Display, ::Java::Int] }
        # Creates a new timer.
        # 
        # @param display the display to use for display thread posting.
        # @param delay the delay until to show additional info
        def initialize(display, delay)
          @idle = Class.new(self.class::Task.class == Class ? self.class::Task : Object) do
            extend LocalClass
            include_class_members Timer
            include class_self::Task if class_self::Task.class == Module
            
            typesig { [] }
            define_method :run do
              Assert.is_true(false)
            end
            
            typesig { [] }
            define_method :next_task do
              Assert.is_true(false)
              return nil
            end
            
            typesig { [] }
            define_method :delay do
              return Long::MAX_VALUE
            end
            
            typesig { [] }
            define_method :to_s do
              return "IDLE" # $NON-NLS-1$
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
          @first_wait = Class.new(self.class::Task.class == Class ? self.class::Task : Object) do
            extend LocalClass
            include_class_members Timer
            include class_self::Task if class_self::Task.class == Module
            
            typesig { [] }
            define_method :run do
              proposal = get_current_proposal_ex
              task_class = self.class # $NON-NLS-1$
              job = Class.new(self.class::Job.class == Class ? self.class::Job : Object) do
                extend LocalClass
                include_class_members task_class
                include class_self::Job if class_self::Job.class == Module
                
                typesig { [class_self::IProgressMonitor] }
                define_method :run do |monitor|
                  info = nil
                  begin
                    info = proposal.get_additional_proposal_info(monitor)
                  rescue self.class::RuntimeException => x
                    # XXX: This is the safest fix at this point so close to end of 3.2.
                    # Will be revisited when fixing https://bugs.eclipse.org/bugs/show_bug.cgi?id=101033
                    return self.class::Status.new(IStatus::WARNING, "org.eclipse.jface.text", IStatus::OK, "", x) # $NON-NLS-1$ //$NON-NLS-2$
                  end
                  set_info(proposal, info)
                  return self.class::Status.new(IStatus::OK, "org.eclipse.jface.text", IStatus::OK, "", nil) # $NON-NLS-1$ //$NON-NLS-2$
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self, JFaceTextMessages.get_string("AdditionalInfoController.job_name"))
              job.schedule
            end
            
            typesig { [] }
            define_method :next_task do
              return SECOND_WAIT
            end
            
            typesig { [] }
            define_method :delay do
              return self.class::DELAY_UNTIL_JOB_IS_SCHEDULED
            end
            
            typesig { [] }
            define_method :to_s do
              return "FIRST_WAIT" # $NON-NLS-1$
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
          @second_wait = Class.new(self.class::Task.class == Class ? self.class::Task : Object) do
            extend LocalClass
            include_class_members Timer
            include class_self::Task if class_self::Task.class == Module
            
            typesig { [] }
            define_method :run do
              # show the info
              allow_showing
            end
            
            typesig { [] }
            define_method :next_task do
              return IDLE
            end
            
            typesig { [] }
            define_method :delay do
              return self.attr_f_delay - self.class::DELAY_UNTIL_JOB_IS_SCHEDULED
            end
            
            typesig { [] }
            define_method :to_s do
              return "SECOND_WAIT" # $NON-NLS-1$
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
          @legacy_wait = Class.new(self.class::Task.class == Class ? self.class::Task : Object) do
            extend LocalClass
            include_class_members Timer
            include class_self::Task if class_self::Task.class == Module
            
            typesig { [] }
            define_method :run do
              proposal = get_current_proposal
              if (!self.attr_f_display.is_disposed)
                task_class = self.class
                self.attr_f_display.async_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
                  extend LocalClass
                  include_class_members task_class
                  include class_self::Runnable if class_self::Runnable.class == Module
                  
                  typesig { [] }
                  define_method :run do
                    synchronized((@local_class_parent.local_class_parent)) do
                      if ((proposal).equal?(get_current_proposal))
                        info = proposal.get_additional_proposal_info
                        show_information(proposal, info)
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
              end
            end
            
            typesig { [] }
            define_method :next_task do
              return IDLE
            end
            
            typesig { [] }
            define_method :delay do
              return self.attr_f_delay
            end
            
            typesig { [] }
            define_method :to_s do
              return "LEGACY_WAIT" # $NON-NLS-1$
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
          @exit = Class.new(self.class::Task.class == Class ? self.class::Task : Object) do
            extend LocalClass
            include_class_members Timer
            include class_self::Task if class_self::Task.class == Module
            
            typesig { [] }
            define_method :delay do
              return 1
            end
            
            typesig { [] }
            define_method :next_task do
              Assert.is_true(false)
              return EXIT
            end
            
            typesig { [] }
            define_method :run do
              Assert.is_true(false)
            end
            
            typesig { [] }
            define_method :to_s do
              return "EXIT" # $NON-NLS-1$
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
          @f_thread = nil
          @f_task = nil
          @f_next_wakeup = 0
          @f_current_proposal = nil
          @f_current_info = nil
          @f_allow_showing = false
          @f_display = nil
          @f_delay = 0
          @f_display = display
          @f_delay = delay
          current = System.current_time_millis
          schedule(@idle, current)
          @f_thread = self.class::JavaThread.new(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
            extend LocalClass
            include_class_members Timer
            include class_self::Runnable if class_self::Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              begin
                loop
              rescue self.class::InterruptedException => x
              end
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self), JFaceTextMessages.get_string("InfoPopup.info_delay_timer_name")) # $NON-NLS-1$
          @f_thread.start
        end
        
        typesig { [] }
        # Terminates the timer thread.
        def terminate
          synchronized(self) do
            schedule(@exit, System.current_time_millis)
            notify_all
          end
        end
        
        typesig { [class_self::ICompletionProposal] }
        # Resets the timer thread as the selection has changed to a new proposal.
        # 
        # @param p the new proposal
        def reset(p)
          synchronized(self) do
            if (!(@f_current_proposal).equal?(p))
              @f_current_proposal = p
              @f_current_info = nil
              @f_allow_showing = false
              old_wakeup = @f_next_wakeup
              task = task_on_reset(p)
              schedule(task, System.current_time_millis)
              if (@f_next_wakeup < old_wakeup)
                notify_all
              end
            end
          end
        end
        
        typesig { [class_self::ICompletionProposal] }
        def task_on_reset(p)
          if ((p).nil?)
            return @idle
          end
          if (is_ext5(p))
            return @first_wait
          end
          return @legacy_wait
        end
        
        typesig { [] }
        def loop
          synchronized(self) do
            current = System.current_time_millis
            task = current_task
            while (!(task).equal?(@exit))
              delay = @f_next_wakeup - current
              if (delay <= 0)
                task.run
                task = task.next_task
                schedule(task, current)
              else
                wait(delay)
                current = System.current_time_millis
                task = current_task
              end
            end
          end
        end
        
        typesig { [] }
        def current_task
          return @f_task
        end
        
        typesig { [class_self::Task, ::Java::Long] }
        def schedule(task, current)
          @f_task = task
          next_wakeup = current + task.delay
          if (next_wakeup <= current)
            @f_next_wakeup = Long::MAX_VALUE
          else
            @f_next_wakeup = next_wakeup
          end
        end
        
        typesig { [class_self::ICompletionProposal] }
        def is_ext5(p)
          return p.is_a?(self.class::ICompletionProposalExtension5)
        end
        
        typesig { [] }
        def get_current_proposal
          return @f_current_proposal
        end
        
        typesig { [] }
        def get_current_proposal_ex
          Assert.is_true(@f_current_proposal.is_a?(self.class::ICompletionProposalExtension5))
          return @f_current_proposal
        end
        
        typesig { [class_self::ICompletionProposal, Object] }
        def set_info(proposal, info)
          synchronized(self) do
            if ((proposal).equal?(@f_current_proposal))
              @f_current_info = info
              if (@f_allow_showing)
                trigger_showing
              end
            end
          end
        end
        
        typesig { [] }
        def trigger_showing
          info = @f_current_info
          if (!@f_display.is_disposed)
            @f_display.async_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              extend LocalClass
              include_class_members Timer
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                synchronized((@local_class_parent)) do
                  if ((info).equal?(self.attr_f_current_info))
                    show_information(self.attr_f_current_proposal, info)
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
          end
        end
        
        typesig { [class_self::ICompletionProposal, Object] }
        # Called in the display thread to show additional info.
        # 
        # @param proposal the proposal to show information about
        # @param info the information about <code>proposal</code>
        def show_information(proposal, info)
          raise NotImplementedError
        end
        
        typesig { [] }
        def allow_showing
          @f_allow_showing = true
          trigger_showing
        end
        
        private
        alias_method :initialize__timer, :initialize
      end }
      
      # Internal table selection listener.
      const_set_lazy(:TableSelectionListener) { Class.new do
        extend LocalClass
        include_class_members AdditionalInfoController
        include SelectionListener
        
        typesig { [class_self::SelectionEvent] }
        # @see SelectionListener#widgetSelected(SelectionEvent)
        def widget_selected(e)
          handle_table_selection_changed
        end
        
        typesig { [class_self::SelectionEvent] }
        # @see SelectionListener#widgetDefaultSelected(SelectionEvent)
        def widget_default_selected(e)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__table_selection_listener, :initialize
      end }
      
      # Default control creator for the information control replacer.
      # @since 3.4
      const_set_lazy(:DefaultPresenterControlCreator) { Class.new(AbstractReusableInformationControlCreator) do
        include_class_members AdditionalInfoController
        
        typesig { [class_self::Shell] }
        def do_create_information_control(shell)
          return self.class::DefaultInformationControl.new(shell, true)
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__default_presenter_control_creator, :initialize
      end }
    }
    
    # The proposal table.
    attr_accessor :f_proposal_table
    alias_method :attr_f_proposal_table, :f_proposal_table
    undef_method :f_proposal_table
    alias_method :attr_f_proposal_table=, :f_proposal_table=
    undef_method :f_proposal_table=
    
    # The table selection listener
    attr_accessor :f_selection_listener
    alias_method :attr_f_selection_listener, :f_selection_listener
    undef_method :f_selection_listener
    alias_method :attr_f_selection_listener=, :f_selection_listener=
    undef_method :f_selection_listener=
    
    # The delay after which additional information is displayed
    attr_accessor :f_delay
    alias_method :attr_f_delay, :f_delay
    undef_method :f_delay
    alias_method :attr_f_delay=, :f_delay=
    undef_method :f_delay=
    
    # The timer thread.
    # @since 3.2
    attr_accessor :f_timer
    alias_method :attr_f_timer, :f_timer
    undef_method :f_timer
    alias_method :attr_f_timer=, :f_timer=
    undef_method :f_timer=
    
    # The proposal most recently set by {@link #showInformation(ICompletionProposal, Object)},
    # possibly <code>null</code>.
    # @since 3.2
    attr_accessor :f_proposal
    alias_method :attr_f_proposal, :f_proposal
    undef_method :f_proposal
    alias_method :attr_f_proposal=, :f_proposal=
    undef_method :f_proposal=
    
    # The information most recently set by {@link #showInformation(ICompletionProposal, Object)},
    # possibly <code>null</code>.
    # @since 3.2
    attr_accessor :f_information
    alias_method :attr_f_information, :f_information
    undef_method :f_information
    alias_method :attr_f_information=, :f_information=
    undef_method :f_information=
    
    typesig { [IInformationControlCreator, ::Java::Int] }
    # Creates a new additional information controller.
    # 
    # @param creator the information control creator to be used by this controller
    # @param delay time in milliseconds after which additional info should be displayed
    def initialize(creator, delay)
      @f_proposal_table = nil
      @f_selection_listener = nil
      @f_delay = 0
      @f_timer = nil
      @f_proposal = nil
      @f_information = nil
      super(creator)
      @f_selection_listener = TableSelectionListener.new_local(self)
      @f_delay = delay
      set_anchor(ANCHOR_RIGHT)
      set_fallback_anchors(Array.typed(Anchor).new([ANCHOR_RIGHT, ANCHOR_LEFT, ANCHOR_BOTTOM]))
      # Adjust the location by one pixel towards the proposal popup, so that the single pixel
      # border of the additional info popup overlays with the border of the popup. This avoids
      # having a double black line.
      spacing = -1
      set_margins(spacing, spacing) # see also adjustment in #computeLocation
      replacer = InformationControlReplacer.new(DefaultPresenterControlCreator.new)
      get_internal_accessor.set_information_control_replacer(replacer)
    end
    
    typesig { [Control] }
    # @see AbstractInformationControlManager#install(Control)
    def install(control)
      if ((@f_proposal_table).equal?(control))
        # already installed
        return
      end
      super(control.get_shell)
      Assert.is_true(control.is_a?(Table))
      @f_proposal_table = control
      @f_proposal_table.add_selection_listener(@f_selection_listener)
      get_internal_accessor.get_information_control_replacer.install(@f_proposal_table)
      @f_timer = Class.new(Timer.class == Class ? Timer : Object) do
        extend LocalClass
        include_class_members AdditionalInfoController
        include Timer if Timer.class == Module
        
        typesig { [ICompletionProposal, Object] }
        define_method :show_information do |proposal, info|
          replacer = get_internal_accessor.get_information_control_replacer
          if (!(replacer).nil?)
            replacer.hide_information_control
          end
          @local_class_parent.show_information(proposal, info)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self, @f_proposal_table.get_display, @f_delay)
    end
    
    typesig { [] }
    # @see AbstractInformationControlManager#disposeInformationControl()
    def dispose_information_control
      if (!(@f_timer).nil?)
        @f_timer.terminate
        @f_timer = nil
      end
      @f_proposal = nil
      @f_information = nil
      if (!(@f_proposal_table).nil? && !@f_proposal_table.is_disposed)
        @f_proposal_table.remove_selection_listener(@f_selection_listener)
        @f_proposal_table = nil
      end
      super
    end
    
    typesig { [] }
    # Handles a change of the line selected in the associated selector.
    def handle_table_selection_changed
      if (!(@f_proposal_table).nil? && !@f_proposal_table.is_disposed && @f_proposal_table.is_visible)
        selection = @f_proposal_table.get_selection
        if (!(selection).nil? && selection.attr_length > 0)
          item = selection[0]
          d = item.get_data
          if (d.is_a?(ICompletionProposal))
            p = d
            @f_timer.reset(p)
          end
        end
      end
    end
    
    typesig { [ICompletionProposal, Object] }
    def show_information(proposal, info)
      if ((@f_proposal_table).nil? || @f_proposal_table.is_disposed)
        return
      end
      if ((@f_proposal).equal?(proposal) && (((info).nil? && (@f_information).nil?) || (!(info).nil? && (info == @f_information))))
        return
      end
      @f_information = info
      @f_proposal = proposal
      show_information
    end
    
    typesig { [] }
    # @see AbstractInformationControlManager#computeInformation()
    def compute_information
      if (@f_proposal.is_a?(ICompletionProposalExtension3))
        set_custom_information_control_creator((@f_proposal).get_information_control_creator)
      else
        set_custom_information_control_creator(nil)
      end
      # compute subject area
      size = @f_proposal_table.get_shell.get_size
      # set information & subject area
      set_information(@f_information, Rectangle.new(0, 0, size.attr_x, size.attr_y))
    end
    
    typesig { [Rectangle, Point, Anchor] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#computeLocation(org.eclipse.swt.graphics.Rectangle, org.eclipse.swt.graphics.Point, org.eclipse.jface.text.AbstractInformationControlManager.Anchor)
    def compute_location(subject_area, control_size, anchor)
      location = super(subject_area, control_size, anchor)
      # The location is computed using subjectControl.toDisplay(), which does not include the
      # trim of the subject control. As we want the additional info popup aligned with the outer
      # coordinates of the proposal popup, adjust this here
      trim = @f_proposal_table.get_shell.compute_trim(0, 0, 0, 0)
      location.attr_x += trim.attr_x
      location.attr_y += trim.attr_y
      return location
    end
    
    typesig { [Control, IInformationControl] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#computeSizeConstraints(Control, IInformationControl)
    def compute_size_constraints(subject_control, information_control)
      # at least as big as the proposal table
      size_constraint = super(subject_control, information_control)
      size = subject_control.get_shell.get_size
      # AbstractInformationControlManager#internalShowInformationControl(Rectangle, Object) adds trims
      # to the computed constraints. Need to remove them here, to make the outer bounds of the additional
      # info shell fit the bounds of the proposal shell:
      if (self.attr_f_information_control.is_a?(IInformationControlExtension3))
        shell_trim = (self.attr_f_information_control).compute_trim
        size.attr_x -= shell_trim.attr_width
        size.attr_y -= shell_trim.attr_height
      end
      if (size_constraint.attr_x < size.attr_x)
        size_constraint.attr_x = size.attr_x
      end
      if (size_constraint.attr_y < size.attr_y)
        size_constraint.attr_y = size.attr_y
      end
      return size_constraint
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#hideInformationControl()
    def hide_information_control
      super
    end
    
    typesig { [] }
    # @return the current information control, or <code>null</code> if none available
    def get_current_information_control2
      return get_internal_accessor.get_current_information_control
    end
    
    private
    alias_method :initialize__additional_info_controller, :initialize
  end
  
end
