require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Julian Chen - fix for bug #92572, jclRM
module Org::Eclipse::Core::Internal::Runtime
  module RuntimeLogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Internal::Runtime
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # NOT API!!!  This log infrastructure was split from the InternalPlatform.
  # 
  # @since org.eclipse.equinox.common 3.2
  # 
  # XXX this must be removed and replaced with something more reasonable
  class RuntimeLog 
    include_class_members RuntimeLogImports
    
    class_module.module_eval {
      
      def log_listeners
        defined?(@@log_listeners) ? @@log_listeners : @@log_listeners= ArrayList.new(5)
      end
      alias_method :attr_log_listeners, :log_listeners
      
      def log_listeners=(value)
        @@log_listeners = value
      end
      alias_method :attr_log_listeners=, :log_listeners=
      
      # Keep the messages until the first log listener is registered.
      # Once first log listeners is registred, it is going to receive
      # all status messages accumulated during the period when no log
      # listener was available.
      
      def queued_messages
        defined?(@@queued_messages) ? @@queued_messages : @@queued_messages= ArrayList.new(5)
      end
      alias_method :attr_queued_messages, :queued_messages
      
      def queued_messages=(value)
        @@queued_messages = value
      end
      alias_method :attr_queued_messages=, :queued_messages=
      
      typesig { [ILogListener] }
      # See org.eclipse.core.runtime.Platform#addLogListener(ILogListener)
      def add_log_listener(listener)
        synchronized((self.attr_log_listeners)) do
          first_listener = ((self.attr_log_listeners.size).equal?(0))
          # replace if already exists (Set behaviour but we use an array
          # since we want to retain order)
          self.attr_log_listeners.remove(listener)
          self.attr_log_listeners.add(listener)
          if (first_listener)
            i = self.attr_queued_messages.iterator
            while i.has_next
              begin
                recorded_message = i.next_
                listener.logging(recorded_message, IRuntimeConstants::PI_RUNTIME)
              rescue JavaException => e
                handle_exception(e)
              rescue LinkageError => e
                handle_exception(e)
              end
            end
            self.attr_queued_messages.clear
          end
        end
      end
      
      typesig { [ILogListener] }
      # See org.eclipse.core.runtime.Platform#removeLogListener(ILogListener)
      def remove_log_listener(listener)
        synchronized((self.attr_log_listeners)) do
          self.attr_log_listeners.remove(listener)
        end
      end
      
      typesig { [ILogListener] }
      # Checks if the given listener is present
      def contains(listener)
        synchronized((self.attr_log_listeners)) do
          return self.attr_log_listeners.contains(listener)
        end
      end
      
      typesig { [IStatus] }
      # Notifies all listeners of the platform log.
      def log(status)
        # create array to avoid concurrent access
        listeners = nil
        synchronized((self.attr_log_listeners)) do
          listeners = self.attr_log_listeners.to_array(Array.typed(ILogListener).new(self.attr_log_listeners.size) { nil })
          if ((listeners.attr_length).equal?(0))
            self.attr_queued_messages.add(status)
            return
          end
        end
        i = 0
        while i < listeners.attr_length
          begin
            listeners[i].logging(status, IRuntimeConstants::PI_RUNTIME)
          rescue JavaException => e
            handle_exception(e)
          rescue LinkageError => e
            handle_exception(e)
          end
          i += 1
        end
      end
      
      typesig { [JavaThrowable] }
      def handle_exception(e)
        if (!(e.is_a?(OperationCanceledException)))
          # Got a error while logging. Don't try to log again, just put it into stderr
          e.print_stack_trace
        end
      end
      
      typesig { [] }
      # Helps determine if any listeners are registered with the logging mechanism.
      # @return true if no listeners are registered
      def is_empty
        synchronized((self.attr_log_listeners)) do
          return ((self.attr_log_listeners.size).equal?(0))
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__runtime_log, :initialize
  end
  
end
