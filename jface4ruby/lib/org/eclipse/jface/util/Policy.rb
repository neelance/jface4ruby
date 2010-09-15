require "rjava"

# Copyright (c) 2004, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Chris Gross (schtoo@schtoo.com) - support for ILogger added
# (bug 49497 [RCP] JFace dependency on org.eclipse.core.runtime enlarges standalone JFace applications)
module Org::Eclipse::Jface::Util
  module PolicyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Java::Util, :Comparator
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Dialogs, :AnimatorFactory
      include_const ::Org::Eclipse::Jface::Dialogs, :ErrorSupportProvider
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # The Policy class handles settings for behaviour, debug flags and logging
  # within JFace.
  # 
  # @since 3.0
  class Policy 
    include_class_members PolicyImports
    
    class_module.module_eval {
      # Constant for the the default setting for debug options.
      const_set_lazy(:DEFAULT) { false }
      const_attr_reader  :DEFAULT
      
      # The unique identifier of the JFace plug-in.
      const_set_lazy(:JFACE) { "org.eclipse.jface" }
      const_attr_reader  :JFACE
      
      # $NON-NLS-1$
      
      def log
        defined?(@@log) ? @@log : @@log= nil
      end
      alias_method :attr_log, :log
      
      def log=(value)
        @@log = value
      end
      alias_method :attr_log=, :log=
      
      
      def viewer_comparator
        defined?(@@viewer_comparator) ? @@viewer_comparator : @@viewer_comparator= nil
      end
      alias_method :attr_viewer_comparator, :viewer_comparator
      
      def viewer_comparator=(value)
        @@viewer_comparator = value
      end
      alias_method :attr_viewer_comparator=, :viewer_comparator=
      
      
      def animator_factory
        defined?(@@animator_factory) ? @@animator_factory : @@animator_factory= nil
      end
      alias_method :attr_animator_factory, :animator_factory
      
      def animator_factory=(value)
        @@animator_factory = value
      end
      alias_method :attr_animator_factory=, :animator_factory=
      
      # A flag to indicate whether unparented dialogs should be checked.
      
      def debug_dialog_no_parent
        defined?(@@debug_dialog_no_parent) ? @@debug_dialog_no_parent : @@debug_dialog_no_parent= DEFAULT
      end
      alias_method :attr_debug_dialog_no_parent, :debug_dialog_no_parent
      
      def debug_dialog_no_parent=(value)
        @@debug_dialog_no_parent = value
      end
      alias_method :attr_debug_dialog_no_parent=, :debug_dialog_no_parent=
      
      # A flag to indicate whether actions are being traced.
      
      def trace_actions
        defined?(@@trace_actions) ? @@trace_actions : @@trace_actions= DEFAULT
      end
      alias_method :attr_trace_actions, :trace_actions
      
      def trace_actions=(value)
        @@trace_actions = value
      end
      alias_method :attr_trace_actions=, :trace_actions=
      
      # A flag to indicate whether toolbars are being traced.
      
      def trace_toolbar
        defined?(@@trace_toolbar) ? @@trace_toolbar : @@trace_toolbar= DEFAULT
      end
      alias_method :attr_trace_toolbar, :trace_toolbar
      
      def trace_toolbar=(value)
        @@trace_toolbar = value
      end
      alias_method :attr_trace_toolbar=, :trace_toolbar=
      
      
      def error_support_provider
        defined?(@@error_support_provider) ? @@error_support_provider : @@error_support_provider= nil
      end
      alias_method :attr_error_support_provider, :error_support_provider
      
      def error_support_provider=(value)
        @@error_support_provider = value
      end
      alias_method :attr_error_support_provider=, :error_support_provider=
      
      
      def status_handler
        defined?(@@status_handler) ? @@status_handler : @@status_handler= nil
      end
      alias_method :attr_status_handler, :status_handler
      
      def status_handler=(value)
        @@status_handler = value
      end
      alias_method :attr_status_handler=, :status_handler=
      
      typesig { [] }
      # Returns the dummy log to use if none has been set
      def get_dummy_log
        return Class.new(ILogger.class == Class ? ILogger : Object) do
          local_class_in Policy
          include_class_members Policy
          include ILogger if ILogger.class == Module
          
          typesig { [IStatus] }
          define_method :log do |status|
            System.err.println(status.get_message)
            if (!(status.get_exception).nil?)
              status.get_exception.print_stack_trace(System.err)
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      typesig { [ILogger] }
      # Sets the logger used by JFace to log errors.
      # 
      # @param logger
      # the logger to use, or <code>null</code> to use the default
      # logger
      # @since 3.1
      def set_log(logger)
        self.attr_log = logger
      end
      
      typesig { [] }
      # Returns the logger used by JFace to log errors.
      # <p>
      # The default logger prints the status to <code>System.err</code>.
      # </p>
      # 
      # @return the logger
      # @since 3.1
      def get_log
        if ((self.attr_log).nil?)
          self.attr_log = get_dummy_log
        end
        return self.attr_log
      end
      
      typesig { [StatusHandler] }
      # Sets the status handler used by JFace to handle statuses.
      # 
      # @param status
      # the handler to use, or <code>null</code> to use the default
      # one
      # @since 3.4
      def set_status_handler(status)
        self.attr_status_handler = status
      end
      
      typesig { [] }
      # Returns the status handler used by JFace to handle statuses.
      # 
      # @return the status handler
      # @since 3.4
      def get_status_handler
        if ((self.attr_status_handler).nil?)
          self.attr_status_handler = get_dummy_status_handler
        end
        return self.attr_status_handler
      end
      
      typesig { [] }
      def get_dummy_status_handler
        return Class.new(StatusHandler.class == Class ? StatusHandler : Object) do
          local_class_in Policy
          include_class_members Policy
          include StatusHandler if StatusHandler.class == Module
          
          attr_accessor :dialog
          alias_method :attr_dialog, :dialog
          undef_method :dialog
          alias_method :attr_dialog=, :dialog=
          undef_method :dialog=
          
          typesig { [IStatus, String] }
          define_method :show do |status, title|
            status_handler_class = self.class
            runnable = Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              local_class_in status_handler_class
              include_class_members status_handler_class
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                if ((self.attr_dialog).nil? || self.attr_dialog.get_shell.is_disposed)
                  self.attr_dialog = self.class::SafeRunnableDialog.new(status)
                  self.attr_dialog.create
                  runnable_class = self.class
                  self.attr_dialog.get_shell.add_dispose_listener(Class.new(self.class::DisposeListener.class == Class ? self.class::DisposeListener : Object) do
                    local_class_in runnable_class
                    include_class_members runnable_class
                    include class_self::DisposeListener if class_self::DisposeListener.class == Module
                    
                    typesig { [class_self::DisposeEvent] }
                    define_method :widget_disposed do |e|
                      self.attr_dialog = nil
                    end
                    
                    typesig { [Vararg.new(Object)] }
                    define_method :initialize do |*args|
                      super(*args)
                    end
                    
                    private
                    alias_method :initialize_anonymous, :initialize
                  end.new_local(self))
                  self.attr_dialog.open
                else
                  self.attr_dialog.add_status(status)
                  self.attr_dialog.refresh
                end
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
            if (!(Display.get_current).nil?)
              runnable.run
            else
              Display.get_default.async_exec(runnable)
            end
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            @dialog = nil
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      typesig { [] }
      # Return the default comparator used by JFace to sort strings.
      # 
      # @return a default comparator used by JFace to sort strings
      def get_default_comparator
        return Class.new(Comparator.class == Class ? Comparator : Object) do
          local_class_in Policy
          include_class_members Policy
          include Comparator if Comparator.class == Module
          
          typesig { [Object, Object] }
          # Compares string s1 to string s2.
          # 
          # @param s1
          # string 1
          # @param s2
          # string 2
          # @return Returns an integer value. Value is less than zero if
          # source is less than target, value is zero if source and
          # target are equal, value is greater than zero if source is
          # greater than target.
          # @exception ClassCastException
          # the arguments cannot be cast to Strings.
          define_method :compare do |s1, s2|
            return ((s1) <=> s2)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      typesig { [] }
      # Return the comparator used by JFace to sort strings.
      # 
      # @return the comparator used by JFace to sort strings
      # @since 3.2
      def get_comparator
        if ((self.attr_viewer_comparator).nil?)
          self.attr_viewer_comparator = get_default_comparator
        end
        return self.attr_viewer_comparator
      end
      
      typesig { [Comparator] }
      # Sets the comparator used by JFace to sort strings.
      # 
      # @param comparator
      # comparator used by JFace to sort strings
      # @since 3.2
      def set_comparator(comparator)
        Org::Eclipse::Core::Runtime::Assert.is_true((self.attr_viewer_comparator).nil?)
        self.attr_viewer_comparator = comparator
      end
      
      typesig { [AnimatorFactory] }
      # Sets the animator factory used by JFace to create control animator
      # instances.
      # 
      # @param factory
      # the AnimatorFactory to use.
      # @since 3.2
      # @deprecated this is no longer in use as of 3.3
      def set_animator_factory(factory)
        self.attr_animator_factory = factory
      end
      
      typesig { [] }
      # Returns the animator factory used by JFace to create control animator
      # instances.
      # 
      # @return the animator factory used to create control animator instances.
      # @since 3.2
      # @deprecated this is no longer in use as of 3.3
      def get_animator_factory
        if ((self.attr_animator_factory).nil?)
          self.attr_animator_factory = AnimatorFactory.new
        end
        return self.attr_animator_factory
      end
      
      typesig { [ErrorSupportProvider] }
      # Set the error support provider for error dialogs.
      # 
      # @param provider
      # @since 3.3
      def set_error_support_provider(provider)
        self.attr_error_support_provider = provider
      end
      
      typesig { [] }
      # Return the ErrorSupportProvider for the receiver.
      # 
      # @return ErrorSupportProvider or <code>null</code> if this has not been
      # set
      # @since 3.3
      def get_error_support_provider
        return self.attr_error_support_provider
      end
      
      typesig { [JavaException] }
      # Log the Exception to the logger.
      # 
      # @param exception
      # @since 3.4
      def log_exception(exception)
        get_log.log(Status.new(IStatus::ERROR, JFACE, exception.get_localized_message, exception))
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__policy, :initialize
  end
  
end
