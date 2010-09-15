require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Link::Contentassist
  module AdditionalInfoController2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Link::Contentassist
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :AbstractInformationControlManager
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposal
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :ICompletionProposalExtension3
    }
  end
  
  # Displays the additional information available for a completion proposal.
  # 
  # @since 2.0
  class AdditionalInfoController2 < AdditionalInfoController2Imports.const_get :AbstractInformationControlManager
    include_class_members AdditionalInfoController2Imports
    overload_protected {
      include Runnable
    }
    
    class_module.module_eval {
      # Internal table selection listener.
      const_set_lazy(:TableSelectionListener) { Class.new do
        local_class_in AdditionalInfoController2
        include_class_members AdditionalInfoController2
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
    }
    
    # The proposal table
    attr_accessor :f_proposal_table
    alias_method :attr_f_proposal_table, :f_proposal_table
    undef_method :f_proposal_table
    alias_method :attr_f_proposal_table=, :f_proposal_table=
    undef_method :f_proposal_table=
    
    # The thread controlling the delayed display of the additional info
    attr_accessor :f_thread
    alias_method :attr_f_thread, :f_thread
    undef_method :f_thread
    alias_method :attr_f_thread=, :f_thread=
    undef_method :f_thread=
    
    # Indicates whether the display delay has been reset
    attr_accessor :f_is_reset
    alias_method :attr_f_is_reset, :f_is_reset
    undef_method :f_is_reset
    alias_method :attr_f_is_reset=, :f_is_reset=
    undef_method :f_is_reset=
    
    # Object to synchronize display thread and table selection changes
    attr_accessor :f_mutex
    alias_method :attr_f_mutex, :f_mutex
    undef_method :f_mutex
    alias_method :attr_f_mutex=, :f_mutex=
    undef_method :f_mutex=
    
    # Thread access lock.
    attr_accessor :f_thread_access
    alias_method :attr_f_thread_access, :f_thread_access
    undef_method :f_thread_access
    alias_method :attr_f_thread_access=, :f_thread_access=
    undef_method :f_thread_access=
    
    # Object to synchronize initial display of additional info
    attr_accessor :f_start_signal
    alias_method :attr_f_start_signal, :f_start_signal
    undef_method :f_start_signal
    alias_method :attr_f_start_signal=, :f_start_signal=
    undef_method :f_start_signal=
    
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
    
    typesig { [IInformationControlCreator, ::Java::Int] }
    # Creates a new additional information controller.
    # 
    # @param creator the information control creator to be used by this controller
    # @param delay time in milliseconds after which additional info should be displayed
    def initialize(creator, delay)
      @f_proposal_table = nil
      @f_thread = nil
      @f_is_reset = false
      @f_mutex = nil
      @f_thread_access = nil
      @f_start_signal = nil
      @f_selection_listener = nil
      @f_delay = 0
      super(creator)
      @f_is_reset = false
      @f_mutex = Object.new
      @f_thread_access = Object.new
      @f_selection_listener = TableSelectionListener.new_local(self)
      @f_delay = delay
      set_anchor(ANCHOR_RIGHT)
      set_fallback_anchors(Array.typed(Anchor).new([ANCHOR_RIGHT, ANCHOR_LEFT, ANCHOR_BOTTOM]))
    end
    
    typesig { [Control] }
    # @see AbstractInformationControlManager#install(Control)
    def install(control)
      if ((@f_proposal_table).equal?(control))
        # already installed
        return
      end
      super(control)
      Assert.is_true(control.is_a?(Table))
      @f_proposal_table = control
      @f_proposal_table.add_selection_listener(@f_selection_listener)
      synchronized((@f_thread_access)) do
        if (!(@f_thread).nil?)
          @f_thread.interrupt
        end
        @f_thread = JavaThread.new(self, ContentAssistMessages.get_string("InfoPopup.info_delay_timer_name")) # $NON-NLS-1$
        @f_start_signal = Object.new
        synchronized((@f_start_signal)) do
          @f_thread.start
          begin
            # wait until thread is ready
            @f_start_signal.wait
          rescue InterruptedException => x
          end
        end
      end
    end
    
    typesig { [] }
    # @see AbstractInformationControlManager#disposeInformationControl()
    def dispose_information_control
      synchronized((@f_thread_access)) do
        if (!(@f_thread).nil?)
          @f_thread.interrupt
          @f_thread = nil
        end
      end
      if (!(@f_proposal_table).nil? && !@f_proposal_table.is_disposed)
        @f_proposal_table.remove_selection_listener(@f_selection_listener)
        @f_proposal_table = nil
      end
      super
    end
    
    typesig { [] }
    # @see java.lang.Runnable#run()
    def run
      begin
        while (true)
          synchronized((@f_mutex)) do
            if (!(@f_start_signal).nil?)
              synchronized((@f_start_signal)) do
                @f_start_signal.notify_all
                @f_start_signal = nil
              end
            end
            # Wait for a selection event to occur.
            @f_mutex.wait
            while (true)
              @f_is_reset = false
              # Delay before showing the popup.
              @f_mutex.wait(@f_delay)
              if (!@f_is_reset)
                break
              end
            end
          end
          if (!(@f_proposal_table).nil? && !@f_proposal_table.is_disposed)
            @f_proposal_table.get_display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
              local_class_in AdditionalInfoController2
              include_class_members AdditionalInfoController2
              include Runnable if Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                if (!self.attr_f_is_reset)
                  show_information
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
      rescue InterruptedException => e
      end
      synchronized((@f_thread_access)) do
        # only null fThread if it is us!
        if ((JavaThread.current_thread).equal?(@f_thread))
          @f_thread = nil
        end
      end
    end
    
    typesig { [] }
    # Handles a change of the line selected in the associated selector.
    def handle_table_selection_changed
      if (!(@f_proposal_table).nil? && !@f_proposal_table.is_disposed && @f_proposal_table.is_visible)
        synchronized((@f_mutex)) do
          @f_is_reset = true
          @f_mutex.notify_all
        end
      end
    end
    
    typesig { [] }
    # @see AbstractInformationControlManager#computeInformation()
    def compute_information
      if ((@f_proposal_table).nil? || @f_proposal_table.is_disposed)
        return
      end
      selection = @f_proposal_table.get_selection
      if (!(selection).nil? && selection.attr_length > 0)
        item = selection[0]
        # compute information
        information = nil
        d = item.get_data
        if (d.is_a?(ICompletionProposal))
          p = d
          information = RJava.cast_to_string(p.get_additional_proposal_info)
        end
        if (d.is_a?(ICompletionProposalExtension3))
          set_custom_information_control_creator((d).get_information_control_creator)
        else
          set_custom_information_control_creator(nil)
        end
        # compute subject area
        set_margins(4, -1)
        area = @f_proposal_table.get_bounds
        area.attr_x = 0 # subject area is the whole subject control
        area.attr_y = 0
        # set information & subject area
        set_information(information, area)
      end
    end
    
    typesig { [Control, IInformationControl] }
    # @see org.eclipse.jface.text.AbstractInformationControlManager#computeSizeConstraints(Control, IInformationControl)
    def compute_size_constraints(subject_control, information_control)
      # at least as big as the proposal table
      size_constraint = super(subject_control, information_control)
      size = subject_control.get_size
      if (size_constraint.attr_x < size.attr_x)
        size_constraint.attr_x = size.attr_x
      end
      if (size_constraint.attr_y < size.attr_y)
        size_constraint.attr_y = size.attr_y
      end
      return size_constraint
    end
    
    private
    alias_method :initialize__additional_info_controller2, :initialize
  end
  
end
