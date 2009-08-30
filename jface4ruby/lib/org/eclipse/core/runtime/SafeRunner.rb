require "rjava"

# Copyright (c) 2005, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module SafeRunnerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Org::Eclipse::Osgi::Util, :NLS
    }
  end
  
  # Runs the given ISafeRunnable in a protected mode: exceptions and certain
  # errors thrown in the runnable are logged and passed to the runnable's
  # exception handler.  Such exceptions are not rethrown by this method.
  # <p>
  # This class can be used without OSGi running.
  # </p>
  # @since org.eclipse.equinox.common 3.2
  class SafeRunner 
    include_class_members SafeRunnerImports
    
    class_module.module_eval {
      typesig { [ISafeRunnable] }
      # Runs the given runnable in a protected mode.   Exceptions
      # thrown in the runnable are logged and passed to the runnable's
      # exception handler.  Such exceptions are not rethrown by this method.
      # <p>
      # In addition to catching all {@link Exception} types, this method also catches certain {@link Error}
      # types that typically result from programming errors in the code being executed.
      # Severe errors that are not generally safe to catch are not caught by this method.
      # </p>
      # 
      # @param code the runnable to run
      def run(code)
        Assert.is_not_null(code)
        begin
          code.run
        rescue JavaException => e
          handle_exception(code, e)
        rescue LinkageError => e
          handle_exception(code, e)
        rescue AssertionError => e
          handle_exception(code, e)
        end
      end
      
      typesig { [ISafeRunnable, JavaThrowable] }
      def handle_exception(code, e)
        if (!(e.is_a?(OperationCanceledException)))
          # try to obtain the correct plug-in id for the bundle providing the safe runnable
          activator = Activator.get_default
          plugin_id = nil
          if (!(activator).nil?)
            plugin_id = RJava.cast_to_string(activator.get_bundle_id(code))
          end
          if ((plugin_id).nil?)
            plugin_id = RJava.cast_to_string(IRuntimeConstants::PI_COMMON)
          end
          message = NLS.bind(CommonMessages.attr_meta_plugin_problems, plugin_id)
          status = nil
          if (e.is_a?(CoreException))
            status = MultiStatus.new(plugin_id, IRuntimeConstants::PLUGIN_ERROR, message, e)
            (status).merge((e).get_status)
          else
            status = Status.new(IStatus::ERROR, plugin_id, IRuntimeConstants::PLUGIN_ERROR, message, e)
          end
          # Make sure user sees the exception: if the log is empty, log the exceptions on stderr
          if (!RuntimeLog.is_empty)
            RuntimeLog.log(status)
          else
            e.print_stack_trace
          end
        end
        code.handle_exception(e)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__safe_runner, :initialize
  end
  
end
