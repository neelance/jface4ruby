require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Mark Siegel <mark.siegel@businessobjects.com> - Fix for Bug 184533
# [Progress] ProgressIndicator uses hardcoded style for ProgressBar
module Org::Eclipse::Jface::Dialogs
  module ProgressIndicatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StackLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :ProgressBar
    }
  end
  
  # A control for showing progress feedback for a long running operation. This
  # control supports both determinate and indeterminate SWT progress bars. For
  # indeterminate progress, we don't have to know the total amount of work in
  # advance and no <code>worked</code> method needs to be called.
  class ProgressIndicator < ProgressIndicatorImports.const_get :Composite
    include_class_members ProgressIndicatorImports
    
    class_module.module_eval {
      const_set_lazy(:PROGRESS_MAX) { 1000 }
      const_attr_reader  :PROGRESS_MAX
    }
    
    # value to use for max in
    # progress bar
    attr_accessor :animated
    alias_method :attr_animated, :animated
    undef_method :animated
    alias_method :attr_animated=, :animated=
    undef_method :animated=
    
    attr_accessor :layout
    alias_method :attr_layout, :layout
    undef_method :layout
    alias_method :attr_layout=, :layout=
    undef_method :layout=
    
    attr_accessor :determinate_progress_bar
    alias_method :attr_determinate_progress_bar, :determinate_progress_bar
    undef_method :determinate_progress_bar
    alias_method :attr_determinate_progress_bar=, :determinate_progress_bar=
    undef_method :determinate_progress_bar=
    
    attr_accessor :indeterminate_progress_bar
    alias_method :attr_indeterminate_progress_bar, :indeterminate_progress_bar
    undef_method :indeterminate_progress_bar
    alias_method :attr_indeterminate_progress_bar=, :indeterminate_progress_bar=
    undef_method :indeterminate_progress_bar=
    
    attr_accessor :total_work
    alias_method :attr_total_work, :total_work
    undef_method :total_work
    alias_method :attr_total_work=, :total_work=
    undef_method :total_work=
    
    attr_accessor :sum_worked
    alias_method :attr_sum_worked, :sum_worked
    undef_method :sum_worked
    alias_method :attr_sum_worked=, :sum_worked=
    undef_method :sum_worked=
    
    typesig { [Composite] }
    # Create a ProgressIndicator as a child under the given parent.
    # 
    # @param parent
    # The widgets parent
    def initialize(parent)
      initialize__progress_indicator(parent, SWT::NONE)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Create a ProgressIndicator as a child under the given parent.
    # 
    # @param parent
    # The widgets parent
    # @param style the SWT style constants for progress monitors created
    # by the receiver.
    # @since 3.4
    def initialize(parent, style)
      @animated = false
      @layout = nil
      @determinate_progress_bar = nil
      @indeterminate_progress_bar = nil
      @total_work = 0.0
      @sum_worked = 0.0
      super(parent, SWT::NULL)
      @animated = true
      # Enforce horizontal only if vertical isn't set
      if (((style & SWT::VERTICAL)).equal?(0))
        style |= SWT::HORIZONTAL
      end
      @determinate_progress_bar = ProgressBar.new(self, style)
      @indeterminate_progress_bar = ProgressBar.new(self, style | SWT::INDETERMINATE)
      @layout = StackLayout.new
      set_layout(@layout)
    end
    
    typesig { [] }
    # Initialize the progress bar to be animated.
    def begin_animated_task
      done
      @layout.attr_top_control = @indeterminate_progress_bar
      layout
      @animated = true
    end
    
    typesig { [::Java::Int] }
    # Initialize the progress bar.
    # 
    # @param max
    # The maximum value.
    def begin_task(max)
      done
      @total_work = max
      @sum_worked = 0
      @determinate_progress_bar.set_minimum(0)
      @determinate_progress_bar.set_maximum(PROGRESS_MAX)
      @determinate_progress_bar.set_selection(0)
      @layout.attr_top_control = @determinate_progress_bar
      layout
      @animated = false
    end
    
    typesig { [] }
    # Progress is done.
    def done
      if (!@animated)
        @determinate_progress_bar.set_minimum(0)
        @determinate_progress_bar.set_maximum(0)
        @determinate_progress_bar.set_selection(0)
      end
      @layout.attr_top_control = nil
      layout
    end
    
    typesig { [] }
    # Moves the progress indicator to the end.
    def send_remaining_work
      worked(@total_work - @sum_worked)
    end
    
    typesig { [::Java::Double] }
    # Moves the progress indicator by the given amount of work units
    # @param work the amount of work to increment by.
    def worked(work)
      if ((work).equal?(0) || @animated)
        return
      end
      @sum_worked += work
      if (@sum_worked > @total_work)
        @sum_worked = @total_work
      end
      if (@sum_worked < 0)
        @sum_worked = 0
      end
      value = RJava.cast_to_int((@sum_worked / @total_work * PROGRESS_MAX))
      if (@determinate_progress_bar.get_selection < value)
        @determinate_progress_bar.set_selection(value)
      end
    end
    
    typesig { [] }
    # Show the receiver as showing an error.
    # @since 3.4
    def show_error
      @determinate_progress_bar.set_state(SWT::ERROR)
      @indeterminate_progress_bar.set_state(SWT::ERROR)
    end
    
    typesig { [] }
    # Show the receiver as being paused.
    # @since 3.4
    def show_paused
      @determinate_progress_bar.set_state(SWT::PAUSED)
      @indeterminate_progress_bar.set_state(SWT::PAUSED)
    end
    
    typesig { [] }
    # Reset the progress bar to it's normal style.
    # @since 3.4
    def show_normal
      @determinate_progress_bar.set_state(SWT::NORMAL)
      @indeterminate_progress_bar.set_state(SWT::NORMAL)
    end
    
    private
    alias_method :initialize__progress_indicator, :initialize
  end
  
end
