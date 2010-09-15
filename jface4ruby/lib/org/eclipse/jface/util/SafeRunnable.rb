require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Chris Gross (schtoo@schtoo.com) - support for ISafeRunnableRunner added
# (bug 49497 [RCP] JFace dependency on org.eclipse.core.runtime enlarges standalone JFace applications)
module Org::Eclipse::Jface::Util
  module SafeRunnableImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Org::Eclipse::Core::Runtime, :ISafeRunnable
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :OperationCanceledException
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
    }
  end
  
  # Implements a default implementation of ISafeRunnable. The default
  # implementation of <code>handleException</code> opens a dialog to show any
  # errors as they accumulate.
  # <p>
  # This may be executed on any thread.
  class SafeRunnable 
    include_class_members SafeRunnableImports
    include ISafeRunnable
    
    class_module.module_eval {
      
      def ignore_errors
        defined?(@@ignore_errors) ? @@ignore_errors : @@ignore_errors= false
      end
      alias_method :attr_ignore_errors, :ignore_errors
      
      def ignore_errors=(value)
        @@ignore_errors = value
      end
      alias_method :attr_ignore_errors=, :ignore_errors=
      
      
      def runner
        defined?(@@runner) ? @@runner : @@runner= nil
      end
      alias_method :attr_runner, :runner
      
      def runner=(value)
        @@runner = value
      end
      alias_method :attr_runner=, :runner=
    }
    
    attr_accessor :message
    alias_method :attr_message, :message
    undef_method :message
    alias_method :attr_message=, :message=
    undef_method :message=
    
    typesig { [] }
    # Creates a new instance of SafeRunnable with a default error message.
    def initialize
      @message = nil
      # do nothing
    end
    
    typesig { [String] }
    # Creates a new instance of SafeRunnable with the given error message.
    # 
    # @param message
    # the error message to use
    def initialize(message)
      @message = nil
      @message = message
    end
    
    typesig { [JavaThrowable] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.runtime.ISafeRunnable#handleException(java.lang.Throwable)
    def handle_exception(e)
      # Workaround to avoid interactive error dialogs during
      # automated testing
      if (self.attr_ignore_errors)
        return
      end
      if ((@message).nil?)
        @message = RJava.cast_to_string(JFaceResources.get_string("SafeRunnable.errorMessage"))
      end # $NON-NLS-1$
      Policy.get_status_handler.show(Status.new(IStatus::ERROR, Policy::JFACE, @message, e), JFaceResources.get_string("SafeRunnable.errorMessage")) # $NON-NLS-1$
    end
    
    class_module.module_eval {
      typesig { [::Java::Boolean] }
      # Flag to avoid interactive error dialogs during automated testing.
      # 
      # @param flag
      # @return true if errors should be ignored
      # @deprecated use getIgnoreErrors()
      def get_ignore_errors(flag)
        return self.attr_ignore_errors
      end
      
      typesig { [] }
      # Flag to avoid interactive error dialogs during automated testing.
      # 
      # @return true if errors should be ignored
      # 
      # @since 3.0
      def get_ignore_errors
        return self.attr_ignore_errors
      end
      
      typesig { [::Java::Boolean] }
      # Flag to avoid interactive error dialogs during automated testing.
      # 
      # @param flag
      # set to true if errors should be ignored
      def set_ignore_errors(flag)
        self.attr_ignore_errors = flag
      end
      
      typesig { [] }
      # Returns the safe runnable runner.
      # 
      # @return the safe runnable runner
      # 
      # @since 3.1
      def get_runner
        if ((self.attr_runner).nil?)
          self.attr_runner = create_default_runner
        end
        return self.attr_runner
      end
      
      typesig { [] }
      # Creates the default safe runnable runner.
      # 
      # @return the default safe runnable runner
      # @since 3.1
      def create_default_runner
        return Class.new(ISafeRunnableRunner.class == Class ? ISafeRunnableRunner : Object) do
          local_class_in SafeRunnable
          include_class_members SafeRunnable
          include ISafeRunnableRunner if ISafeRunnableRunner.class == Module
          
          typesig { [ISafeRunnable] }
          define_method :run do |code|
            begin
              code.run
            rescue self.class::JavaException => e
              handle_exception(code, e)
            rescue self.class::LinkageError => e
              handle_exception(code, e)
            end
          end
          
          typesig { [ISafeRunnable, JavaThrowable] }
          define_method :handle_exception do |code, e|
            if (!(e.is_a?(self.class::OperationCanceledException)))
              begin
                Policy.get_log.log(self.class::Status.new(IStatus::ERROR, Policy::JFACE, IStatus::ERROR, "Exception occurred", e)) # $NON-NLS-1$
              rescue self.class::JavaException => ex
                e.print_stack_trace
              end
            end
            code.handle_exception(e)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      typesig { [ISafeRunnableRunner] }
      # Sets the safe runnable runner.
      # 
      # @param runner
      # the runner to set, or <code>null</code> to reset to the
      # default runner
      # @since 3.1
      def set_runner(runner)
        self.attr_runner = runner
      end
      
      typesig { [ISafeRunnable] }
      # Runs the given safe runnable using the safe runnable runner. This is a
      # convenience method, equivalent to:
      # <code>SafeRunnable.getRunner().run(runnable)</code>.
      # 
      # @param runnable
      # the runnable to run
      # @since 3.1
      def run(runnable)
        get_runner.run(runnable)
      end
    }
    
    private
    alias_method :initialize__safe_runnable, :initialize
  end
  
end
