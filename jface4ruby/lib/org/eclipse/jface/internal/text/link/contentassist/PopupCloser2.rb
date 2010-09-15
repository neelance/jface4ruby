require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Link::Contentassist
  module PopupCloser2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Link::Contentassist
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Events, :ShellAdapter
      include_const ::Org::Eclipse::Swt::Events, :ShellEvent
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :ScrollBar
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Table
    }
  end
  
  # A generic closer class used to monitor various
  # interface events in order to determine whether
  # a content assistant should be terminated and all
  # associated windows be closed.
  class PopupCloser2 < PopupCloser2Imports.const_get :ShellAdapter
    include_class_members PopupCloser2Imports
    overload_protected {
      include FocusListener
      include SelectionListener
    }
    
    # The content assistant to be monitored
    attr_accessor :f_content_assistant
    alias_method :attr_f_content_assistant, :f_content_assistant
    undef_method :f_content_assistant
    alias_method :attr_f_content_assistant=, :f_content_assistant=
    undef_method :f_content_assistant=
    
    # The table of a selector popup opened by the content assistant
    attr_accessor :f_table
    alias_method :attr_f_table, :f_table
    undef_method :f_table
    alias_method :attr_f_table=, :f_table=
    undef_method :f_table=
    
    # The scrollbar of the table for the selector popup
    attr_accessor :f_scrollbar
    alias_method :attr_f_scrollbar, :f_scrollbar
    undef_method :f_scrollbar
    alias_method :attr_f_scrollbar=, :f_scrollbar=
    undef_method :f_scrollbar=
    
    # Indicates whether the scrollbar thumb has been grabbed.
    attr_accessor :f_scrollbar_clicked
    alias_method :attr_f_scrollbar_clicked, :f_scrollbar_clicked
    undef_method :f_scrollbar_clicked
    alias_method :attr_f_scrollbar_clicked=, :f_scrollbar_clicked=
    undef_method :f_scrollbar_clicked=
    
    # The shell on which some listeners are registered.
    attr_accessor :f_shell
    alias_method :attr_f_shell, :f_shell
    undef_method :f_shell
    alias_method :attr_f_shell=, :f_shell=
    undef_method :f_shell=
    
    typesig { [ContentAssistant2, Table] }
    # Installs this closer on the given table opened by the given content assistant.
    # 
    # @param contentAssistant the content assistant
    # @param table the table to be tracked
    def install(content_assistant, table)
      @f_content_assistant = content_assistant
      @f_table = table
      if (Helper2.ok_to_use(@f_table))
        shell = @f_table.get_shell
        if (Helper2.ok_to_use(shell))
          @f_shell = shell
          @f_shell.add_shell_listener(self)
        end
        @f_table.add_focus_listener(self)
        @f_scrollbar = @f_table.get_vertical_bar
        if (!(@f_scrollbar).nil?)
          @f_scrollbar.add_selection_listener(self)
        end
      end
    end
    
    typesig { [] }
    # Uninstalls this closer if previously installed.
    def uninstall
      @f_content_assistant = nil
      if (Helper2.ok_to_use(@f_shell))
        @f_shell.remove_shell_listener(self)
      end
      @f_shell = nil
      if (Helper2.ok_to_use(@f_scrollbar))
        @f_scrollbar.remove_selection_listener(self)
      end
      if (Helper2.ok_to_use(@f_table))
        @f_table.remove_focus_listener(self)
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
        local_class_in PopupCloser2
        include_class_members PopupCloser2
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          if (Helper2.ok_to_use(self.attr_f_table) && !self.attr_f_table.is_focus_control && !self.attr_f_scrollbar_clicked && !(self.attr_f_content_assistant).nil?)
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
      if (!(@f_content_assistant).nil?)
        @f_content_assistant.hide
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
    
    typesig { [] }
    def initialize
      @f_content_assistant = nil
      @f_table = nil
      @f_scrollbar = nil
      @f_scrollbar_clicked = false
      @f_shell = nil
      super()
      @f_scrollbar_clicked = false
    end
    
    private
    alias_method :initialize__popup_closer2, :initialize
  end
  
end
