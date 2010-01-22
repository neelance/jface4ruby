require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Wizard
  module ProgressMonitorPartImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Wizard
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitorWithBlocking
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Jface::Dialogs, :ProgressIndicator
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
    }
  end
  
  # A standard implementation of an IProgressMonitor. It consists
  # of a label displaying the task and subtask name, and a
  # progress indicator to show progress. In contrast to
  # <code>ProgressMonitorDialog</code> this class only implements
  # <code>IProgressMonitor</code>.
  class ProgressMonitorPart < ProgressMonitorPartImports.const_get :Composite
    include_class_members ProgressMonitorPartImports
    overload_protected {
      include IProgressMonitorWithBlocking
    }
    
    # the label
    attr_accessor :f_label
    alias_method :attr_f_label, :f_label
    undef_method :f_label
    alias_method :attr_f_label=, :f_label=
    undef_method :f_label=
    
    # the current task name
    attr_accessor :f_task_name
    alias_method :attr_f_task_name, :f_task_name
    undef_method :f_task_name
    alias_method :attr_f_task_name=, :f_task_name=
    undef_method :f_task_name=
    
    # the current sub task name
    attr_accessor :f_sub_task_name
    alias_method :attr_f_sub_task_name, :f_sub_task_name
    undef_method :f_sub_task_name
    alias_method :attr_f_sub_task_name=, :f_sub_task_name=
    undef_method :f_sub_task_name=
    
    # the progress indicator
    attr_accessor :f_progress_indicator
    alias_method :attr_f_progress_indicator, :f_progress_indicator
    undef_method :f_progress_indicator
    alias_method :attr_f_progress_indicator=, :f_progress_indicator=
    undef_method :f_progress_indicator=
    
    # the cancel component
    attr_accessor :f_cancel_component
    alias_method :attr_f_cancel_component, :f_cancel_component
    undef_method :f_cancel_component
    alias_method :attr_f_cancel_component=, :f_cancel_component=
    undef_method :f_cancel_component=
    
    # true if canceled
    attr_accessor :f_is_canceled
    alias_method :attr_f_is_canceled, :f_is_canceled
    undef_method :f_is_canceled
    alias_method :attr_f_is_canceled=, :f_is_canceled=
    undef_method :f_is_canceled=
    
    # current blocked status
    attr_accessor :blocked_status
    alias_method :attr_blocked_status, :blocked_status
    undef_method :blocked_status
    alias_method :attr_blocked_status=, :blocked_status=
    undef_method :blocked_status=
    
    # the cancel lister attached to the cancel component
    attr_accessor :f_cancel_listener
    alias_method :attr_f_cancel_listener, :f_cancel_listener
    undef_method :f_cancel_listener
    alias_method :attr_f_cancel_listener=, :f_cancel_listener=
    undef_method :f_cancel_listener=
    
    typesig { [Composite, Layout] }
    # Creates a ProgressMonitorPart.
    # @param parent The SWT parent of the part.
    # @param layout The SWT grid bag layout used by the part. A client
    # can supply the layout to control how the progress monitor part
    # is layed out. If null is passed the part uses its default layout.
    def initialize(parent, layout)
      initialize__progress_monitor_part(parent, layout, SWT::DEFAULT)
    end
    
    typesig { [Composite, Layout, ::Java::Int] }
    # Creates a ProgressMonitorPart.
    # @param parent The SWT parent of the part.
    # @param layout The SWT grid bag layout used by the part. A client
    # can supply the layout to control how the progress monitor part
    # is layed out. If null is passed the part uses its default layout.
    # @param progressIndicatorHeight The height of the progress indicator in pixel.
    def initialize(parent, layout, progress_indicator_height)
      @f_label = nil
      @f_task_name = nil
      @f_sub_task_name = nil
      @f_progress_indicator = nil
      @f_cancel_component = nil
      @f_is_canceled = false
      @blocked_status = nil
      @f_cancel_listener = nil
      super(parent, SWT::NONE)
      @f_cancel_listener = Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members ProgressMonitorPart
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |e|
          set_canceled(true)
          if (!(self.attr_f_cancel_component).nil?)
            self.attr_f_cancel_component.set_enabled(false)
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      initialize_(layout, progress_indicator_height)
    end
    
    typesig { [Control] }
    # Attaches the progress monitor part to the given cancel
    # component.
    # @param cancelComponent the control whose selection will
    # trigger a cancel
    def attach_to_cancel_component(cancel_component)
      Assert.is_not_null(cancel_component)
      @f_cancel_component = cancel_component
      @f_cancel_component.add_listener(SWT::Selection, @f_cancel_listener)
    end
    
    typesig { [String, ::Java::Int] }
    # Implements <code>IProgressMonitor.beginTask</code>.
    # @see IProgressMonitor#beginTask(java.lang.String, int)
    def begin_task(name, total_work)
      @f_task_name = name
      update_label
      if ((total_work).equal?(IProgressMonitor::UNKNOWN) || (total_work).equal?(0))
        @f_progress_indicator.begin_animated_task
      else
        @f_progress_indicator.begin_task(total_work)
      end
    end
    
    typesig { [] }
    # Implements <code>IProgressMonitor.done</code>.
    # @see IProgressMonitor#done()
    def done
      @f_label.set_text("") # $NON-NLS-1$
      @f_progress_indicator.send_remaining_work
      @f_progress_indicator.done
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Escapes any occurrence of '&' in the given String so that
      # it is not considered as a mnemonic
      # character in SWT ToolItems, MenuItems, Button and Labels.
      # @param in the original String
      # @return The converted String
      def escape_meta_characters(in_)
        if ((in_).nil? || in_.index_of(Character.new(?&.ord)) < 0)
          return in_
        end
        length_ = in_.length
        out = StringBuffer.new(length_ + 1)
        i = 0
        while i < length_
          c = in_.char_at(i)
          if ((c).equal?(Character.new(?&.ord)))
            out.append("&&") # $NON-NLS-1$
          else
            out.append(c)
          end
          i += 1
        end
        return out.to_s
      end
    }
    
    typesig { [Layout, ::Java::Int] }
    # Creates the progress monitor's UI parts and layouts them
    # according to the given layout. If the layout is <code>null</code>
    # the part's default layout is used.
    # @param layout The layout for the receiver.
    # @param progressIndicatorHeight The suggested height of the indicator
    def initialize_(layout, progress_indicator_height)
      if ((layout).nil?)
        l = GridLayout.new
        l.attr_margin_width = 0
        l.attr_margin_height = 0
        l.attr_num_columns = 1
        layout = l
      end
      set_layout(layout)
      @f_label = Label.new(self, SWT::LEFT)
      @f_label.set_layout_data(GridData.new(GridData::FILL_HORIZONTAL))
      if ((progress_indicator_height).equal?(SWT::DEFAULT))
        gc = SwtGC.new(@f_label)
        fm = gc.get_font_metrics
        gc.dispose
        progress_indicator_height = fm.get_height
      end
      @f_progress_indicator = ProgressIndicator.new(self)
      gd = GridData.new
      gd.attr_horizontal_alignment = GridData::FILL
      gd.attr_grab_excess_horizontal_space = true
      gd.attr_vertical_alignment = GridData::CENTER
      gd.attr_height_hint = progress_indicator_height
      @f_progress_indicator.set_layout_data(gd)
    end
    
    typesig { [::Java::Double] }
    # Implements <code>IProgressMonitor.internalWorked</code>.
    # @see IProgressMonitor#internalWorked(double)
    def internal_worked(work)
      @f_progress_indicator.worked(work)
    end
    
    typesig { [] }
    # Implements <code>IProgressMonitor.isCanceled</code>.
    # @see IProgressMonitor#isCanceled()
    def is_canceled
      return @f_is_canceled
    end
    
    typesig { [Control] }
    # Detach the progress monitor part from the given cancel
    # component
    # @param cc
    def remove_from_cancel_component(cc)
      Assert.is_true((@f_cancel_component).equal?(cc) && !(@f_cancel_component).nil?)
      @f_cancel_component.remove_listener(SWT::Selection, @f_cancel_listener)
      @f_cancel_component = nil
    end
    
    typesig { [::Java::Boolean] }
    # Implements <code>IProgressMonitor.setCanceled</code>.
    # @see IProgressMonitor#setCanceled(boolean)
    def set_canceled(b)
      @f_is_canceled = b
    end
    
    typesig { [Font] }
    # Sets the progress monitor part's font.
    def set_font(font)
      super(font)
      @f_label.set_font(font)
      @f_progress_indicator.set_font(font)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitor#setTaskName(java.lang.String)
    def set_task_name(name)
      @f_task_name = name
      update_label
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitor#subTask(java.lang.String)
    def sub_task(name)
      @f_sub_task_name = name
      update_label
    end
    
    typesig { [] }
    # Updates the label with the current task and subtask names.
    def update_label
      if ((@blocked_status).nil?)
        text = task_label
        @f_label.set_text(text)
      else
        @f_label.set_text(@blocked_status.get_message)
      end
      # Force an update as we are in the UI Thread
      @f_label.update
    end
    
    typesig { [] }
    # Return the label for showing tasks
    # @return String
    def task_label
      has_task = !(@f_task_name).nil? && @f_task_name.length > 0
      has_subtask = !(@f_sub_task_name).nil? && @f_sub_task_name.length > 0
      if (has_task)
        if (has_subtask)
          return escape_meta_characters(JFaceResources.format("Set_SubTask", Array.typed(Object).new([@f_task_name, @f_sub_task_name])))
        end # $NON-NLS-1$
        return escape_meta_characters(@f_task_name)
      else
        if (has_subtask)
          return escape_meta_characters(@f_sub_task_name)
        else
          return "" # $NON-NLS-1$
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Implements <code>IProgressMonitor.worked</code>.
    # @see IProgressMonitor#worked(int)
    def worked(work)
      internal_worked(work)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitorWithBlocking#clearBlocked()
    def clear_blocked
      @blocked_status = nil
      update_label
    end
    
    typesig { [IStatus] }
    # (non-Javadoc)
    # @see org.eclipse.core.runtime.IProgressMonitorWithBlocking#setBlocked(org.eclipse.core.runtime.IStatus)
    def set_blocked(reason)
      @blocked_status = reason
      update_label
    end
    
    private
    alias_method :initialize__progress_monitor_part, :initialize
  end
  
end
