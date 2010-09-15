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
  module PopupCloserImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Events, :ShellAdapter
      include_const ::Org::Eclipse::Swt::Events, :ShellEvent
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :ScrollBar
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Jface::Internal::Text, :DelayedInputChangeListener
      include_const ::Org::Eclipse::Jface::Internal::Text, :InformationControlReplacer
      include_const ::Org::Eclipse::Jface::Text, :IDelayedInputChangeProvider
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension5
      include_const ::Org::Eclipse::Jface::Text, :IInputChangedListener
    }
  end
  
  # A generic closer class used to monitor various
  # interface events in order to determine whether
  # a content assistant should be terminated and all
  # associated windows be closed.
  class PopupCloser < PopupCloserImports.const_get :ShellAdapter
    include_class_members PopupCloserImports
    overload_protected {
      include FocusListener
      include SelectionListener
      include Listener
    }
    
    # The content assistant to be monitored.
    attr_accessor :f_content_assistant
    alias_method :attr_f_content_assistant, :f_content_assistant
    undef_method :f_content_assistant
    alias_method :attr_f_content_assistant=, :f_content_assistant=
    undef_method :f_content_assistant=
    
    # The table of a selector popup opened by the content assistant.
    attr_accessor :f_table
    alias_method :attr_f_table, :f_table
    undef_method :f_table
    alias_method :attr_f_table=, :f_table=
    undef_method :f_table=
    
    # The scroll bar of the table for the selector popup.
    attr_accessor :f_scrollbar
    alias_method :attr_f_scrollbar, :f_scrollbar
    undef_method :f_scrollbar
    alias_method :attr_f_scrollbar=, :f_scrollbar=
    undef_method :f_scrollbar=
    
    # Indicates whether the scroll bar thumb has been grabbed.
    attr_accessor :f_scrollbar_clicked
    alias_method :attr_f_scrollbar_clicked, :f_scrollbar_clicked
    undef_method :f_scrollbar_clicked
    alias_method :attr_f_scrollbar_clicked=, :f_scrollbar_clicked=
    undef_method :f_scrollbar_clicked=
    
    # The shell on which some listeners are registered.
    # @since 3.1
    attr_accessor :f_shell
    alias_method :attr_f_shell, :f_shell
    undef_method :f_shell
    alias_method :attr_f_shell=, :f_shell=
    undef_method :f_shell=
    
    # The display on which some filters are registered.
    # @since 3.4
    attr_accessor :f_display
    alias_method :attr_f_display, :f_display
    undef_method :f_display
    alias_method :attr_f_display=, :f_display=
    undef_method :f_display=
    
    # The additional info controller, or <code>null</code>.
    # @since 3.4
    attr_accessor :f_additional_info_controller
    alias_method :attr_f_additional_info_controller, :f_additional_info_controller
    undef_method :f_additional_info_controller
    alias_method :attr_f_additional_info_controller=, :f_additional_info_controller=
    undef_method :f_additional_info_controller=
    
    typesig { [ContentAssistant, Table] }
    # Installs this closer on the given table opened by the given content assistant.
    # 
    # @param contentAssistant the content assistant
    # @param table the table to be tracked
    def install(content_assistant, table)
      install(content_assistant, table, nil)
    end
    
    typesig { [ContentAssistant, Table, AdditionalInfoController] }
    # Installs this closer on the given table opened by the given content assistant.
    # 
    # @param contentAssistant the content assistant
    # @param table the table to be tracked
    # @param additionalInfoController the additional info controller, or <code>null</code>
    # @since 3.4
    def install(content_assistant, table, additional_info_controller)
      @f_content_assistant = content_assistant
      @f_table = table
      @f_additional_info_controller = additional_info_controller
      if (Helper.ok_to_use(@f_table))
        @f_shell = @f_table.get_shell
        @f_display = @f_shell.get_display
        @f_shell.add_shell_listener(self)
        @f_table.add_focus_listener(self)
        @f_scrollbar = @f_table.get_vertical_bar
        if (!(@f_scrollbar).nil?)
          @f_scrollbar.add_selection_listener(self)
        end
        @f_display.add_filter(SWT::Activate, self)
        @f_display.add_filter(SWT::MouseWheel, self)
        @f_display.add_filter(SWT::Deactivate, self)
        @f_display.add_filter(SWT::MouseUp, self)
      end
    end
    
    typesig { [] }
    # Uninstalls this closer if previously installed.
    def uninstall
      @f_content_assistant = nil
      if (Helper.ok_to_use(@f_shell))
        @f_shell.remove_shell_listener(self)
      end
      @f_shell = nil
      if (Helper.ok_to_use(@f_scrollbar))
        @f_scrollbar.remove_selection_listener(self)
      end
      if (Helper.ok_to_use(@f_table))
        @f_table.remove_focus_listener(self)
      end
      if (!(@f_display).nil? && !@f_display.is_disposed)
        @f_display.remove_filter(SWT::Activate, self)
        @f_display.remove_filter(SWT::MouseWheel, self)
        @f_display.remove_filter(SWT::Deactivate, self)
        @f_display.remove_filter(SWT::MouseUp, self)
      end
    end
    
    typesig { [SelectionEvent] }
    # @see org.eclipse.swt.events.SelectionListener#widgetSelected(org.eclipse.swt.events.SelectionEvent)
    def widget_selected(e)
      @f_scrollbar_clicked = true
    end
    
    typesig { [SelectionEvent] }
    # @see org.eclipse.swt.events.SelectionListener#widgetDefaultSelected(org.eclipse.swt.events.SelectionEvent)
    def widget_default_selected(e)
      @f_scrollbar_clicked = true
    end
    
    typesig { [FocusEvent] }
    # @see org.eclipse.swt.events.FocusListener#focusGained(org.eclipse.swt.events.FocusEvent)
    def focus_gained(e)
    end
    
    typesig { [FocusEvent] }
    # @see org.eclipse.swt.events.FocusListener#focusLost(org.eclipse.swt.events.FocusEvent)
    def focus_lost(e)
      @f_scrollbar_clicked = false
      d = @f_table.get_display
      d.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in PopupCloser
        include_class_members PopupCloser
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          if (Helper.ok_to_use(self.attr_f_table) && !self.attr_f_table.is_focus_control && !self.attr_f_scrollbar_clicked && !(self.attr_f_content_assistant).nil?)
            self.attr_f_content_assistant.popup_focus_lost(e)
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
    
    typesig { [ShellEvent] }
    # @see org.eclipse.swt.events.ShellAdapter#shellDeactivated(org.eclipse.swt.events.ShellEvent)
    # @since 3.1
    def shell_deactivated(e)
      if (!(@f_content_assistant).nil? && !(@f_display).nil?)
        @f_display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in PopupCloser
          include_class_members PopupCloser
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            # The asyncExec is a workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=235556 :
            # fContentAssistant.hasProposalPopupFocus() is still true during the shellDeactivated(..) event.
            if (!(self.attr_f_content_assistant).nil? && !self.attr_f_content_assistant.has_proposal_popup_focus)
              self.attr_f_content_assistant.hide
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
    
    typesig { [ShellEvent] }
    # @see org.eclipse.swt.events.ShellAdapter#shellClosed(org.eclipse.swt.events.ShellEvent)
    # @since 3.1
    def shell_closed(e)
      if (!(@f_content_assistant).nil?)
        @f_content_assistant.hide
      end
    end
    
    typesig { [Event] }
    # @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
    # @since 3.4
    def handle_event(event)
      catch(:break_case) do
        case (event.attr_type)
        when SWT::Activate, SWT::MouseWheel
          if ((@f_additional_info_controller).nil?)
            return
          end
          if ((event.attr_widget).equal?(@f_shell) || (event.attr_widget).equal?(@f_table) || (event.attr_widget).equal?(@f_scrollbar))
            return
          end
          if ((@f_additional_info_controller.get_internal_accessor.get_information_control_replacer).nil?)
            @f_additional_info_controller.hide_information_control
          else
            if (!@f_additional_info_controller.get_internal_accessor.is_replace_in_progress)
              info_control = @f_additional_info_controller.get_current_information_control2
              # During isReplaceInProgress(), events can come from the replacing information control
              if (event.attr_widget.is_a?(Control) && info_control.is_a?(IInformationControlExtension5))
                control = event.attr_widget
                i_control5 = info_control
                if (!(i_control5.contains_control(control)))
                  @f_additional_info_controller.hide_information_control
                else
                  if ((event.attr_type).equal?(SWT::MouseWheel))
                    @f_additional_info_controller.get_internal_accessor.replace_information_control(false)
                  end
                end
              else
                if (!(info_control).nil? && info_control.is_focus_control)
                  @f_additional_info_controller.get_internal_accessor.replace_information_control(true)
                end
              end
            end
          end
        when SWT::MouseUp
          if ((@f_additional_info_controller).nil? || @f_additional_info_controller.get_internal_accessor.is_replace_in_progress)
            throw :break_case, :thrown
          end
          if (event.attr_widget.is_a?(Control))
            control = event.attr_widget
            info_control = @f_additional_info_controller.get_current_information_control2
            if (info_control.is_a?(IInformationControlExtension5))
              i_control5 = info_control
              if (i_control5.contains_control(control))
                if (info_control.is_a?(IDelayedInputChangeProvider))
                  delayed_icp = info_control
                  input_change_listener = DelayedInputChangeListener.new(delayed_icp, @f_additional_info_controller.get_internal_accessor.get_information_control_replacer)
                  delayed_icp.set_delayed_input_change_listener(input_change_listener)
                  control.get_shell.get_display.timer_exec(1000, # cancel automatic input updating after a small timeout:
                  Class.new(Runnable.class == Class ? Runnable : Object) do
                    local_class_in PopupCloser
                    include_class_members PopupCloser
                    include Runnable if Runnable.class == Module
                    
                    typesig { [] }
                    define_method :run do
                      delayed_icp.set_delayed_input_change_listener(nil)
                    end
                    
                    typesig { [Vararg.new(Object)] }
                    define_method :initialize do |*args|
                      super(*args)
                    end
                    
                    private
                    alias_method :initialize_anonymous, :initialize
                  end.new_local(self))
                end
                control.get_shell.get_display.async_exec(# XXX: workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=212392 :
                Class.new(Runnable.class == Class ? Runnable : Object) do
                  local_class_in PopupCloser
                  include_class_members PopupCloser
                  include Runnable if Runnable.class == Module
                  
                  typesig { [] }
                  define_method :run do
                    self.attr_f_additional_info_controller.get_internal_accessor.replace_information_control(true)
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
          end
        when SWT::Deactivate
          if ((@f_additional_info_controller).nil?)
            throw :break_case, :thrown
          end
          replacer = @f_additional_info_controller.get_internal_accessor.get_information_control_replacer
          if (!(replacer).nil? && !(@f_content_assistant).nil?)
            i_control = replacer.get_current_information_control2
            if (event.attr_widget.is_a?(Control) && i_control.is_a?(IInformationControlExtension5))
              control = event.attr_widget
              i_control5 = i_control
              if (i_control5.contains_control(control))
                control.get_display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
                  local_class_in PopupCloser
                  include_class_members PopupCloser
                  include Runnable if Runnable.class == Module
                  
                  typesig { [] }
                  define_method :run do
                    if (!(self.attr_f_content_assistant).nil? && !self.attr_f_content_assistant.has_proposal_popup_focus)
                      self.attr_f_content_assistant.hide
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
          end
        end
      end
    end
    
    typesig { [] }
    def initialize
      @f_content_assistant = nil
      @f_table = nil
      @f_scrollbar = nil
      @f_scrollbar_clicked = false
      @f_shell = nil
      @f_display = nil
      @f_additional_info_controller = nil
      super()
      @f_scrollbar_clicked = false
    end
    
    private
    alias_method :initialize__popup_closer, :initialize
  end
  
end
