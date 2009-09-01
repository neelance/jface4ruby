require "rjava"

# Copyright (c) 2004, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module CommandImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Java::Io, :BufferedWriter
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :StringWriter
      include_const ::Org::Eclipse::Core::Commands::Common, :NotDefinedException
      include_const ::Org::Eclipse::Core::Commands::Util, :Tracing
      include_const ::Org::Eclipse::Core::Internal::Commands::Util, :Util
      include_const ::Org::Eclipse::Core::Runtime, :ISafeRunnable
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Core::Runtime, :SafeRunner
    }
  end
  
  # <p>
  # A command is an abstract representation for some semantic behaviour. It is
  # not the actual implementation of this behaviour, nor is it the visual
  # appearance of this behaviour in the user interface. Instead, it is a bridge
  # between the two.
  # </p>
  # <p>
  # The concept of a command is based on the command design pattern. The notable
  # difference is how the command delegates responsibility for execution. Rather
  # than allowing concrete subclasses, it uses a handler mechanism (see the
  # <code>handlers</code> extension point). This provides another level of
  # indirection.
  # </p>
  # <p>
  # A command will exist in two states: defined and undefined. A command is
  # defined if it is declared in the XML of a resolved plug-in. If the plug-in is
  # unloaded or the command is simply not declared, then it is undefined. Trying
  # to reference an undefined command will succeed, but trying to access any of
  # its functionality will fail with a <code>NotDefinedException</code>. If
  # you need to know when a command changes from defined to undefined (or vice
  # versa), then attach a command listener.
  # </p>
  # <p>
  # Commands are mutable and will change as their definition changes.
  # </p>
  # 
  # @since 3.1
  class Command < CommandImports.const_get :NamedHandleObjectWithState
    include_class_members CommandImports
    overload_protected {
      include JavaComparable
    }
    
    class_module.module_eval {
      # This flag can be set to <code>true</code> if commands should print
      # information to <code>System.out</code> when executing.
      
      def debug_command_execution
        defined?(@@debug_command_execution) ? @@debug_command_execution : @@debug_command_execution= false
      end
      alias_method :attr_debug_command_execution, :debug_command_execution
      
      def debug_command_execution=(value)
        @@debug_command_execution = value
      end
      alias_method :attr_debug_command_execution=, :debug_command_execution=
      
      # This flag can be set to <code>true</code> if commands should print
      # information to <code>System.out</code> when changing handlers.
      
      def debug_handlers
        defined?(@@debug_handlers) ? @@debug_handlers : @@debug_handlers= false
      end
      alias_method :attr_debug_handlers, :debug_handlers
      
      def debug_handlers=(value)
        @@debug_handlers = value
      end
      alias_method :attr_debug_handlers=, :debug_handlers=
      
      # This flag can be set to a particular command identifier if only that
      # command should print information to <code>System.out</code> when
      # changing handlers.
      
      def debug_handlers_command_id
        defined?(@@debug_handlers_command_id) ? @@debug_handlers_command_id : @@debug_handlers_command_id= nil
      end
      alias_method :attr_debug_handlers_command_id, :debug_handlers_command_id
      
      def debug_handlers_command_id=(value)
        @@debug_handlers_command_id = value
      end
      alias_method :attr_debug_handlers_command_id=, :debug_handlers_command_id=
    }
    
    # The category to which this command belongs. This value should not be
    # <code>null</code> unless the command is undefined.
    attr_accessor :category
    alias_method :attr_category, :category
    undef_method :category
    alias_method :attr_category=, :category=
    undef_method :category=
    
    # A collection of objects listening to the execution of this command. This
    # collection is <code>null</code> if there are no listeners.
    attr_accessor :execution_listeners
    alias_method :attr_execution_listeners, :execution_listeners
    undef_method :execution_listeners
    alias_method :attr_execution_listeners=, :execution_listeners=
    undef_method :execution_listeners=
    
    # The handler currently associated with this command. This value may be
    # <code>null</code> if there is no handler currently.
    attr_accessor :handler
    alias_method :attr_handler, :handler
    undef_method :handler
    alias_method :attr_handler=, :handler=
    undef_method :handler=
    
    # The help context identifier for this command. This can be
    # <code>null</code> if there is no help currently associated with the
    # command.
    # 
    # @since 3.2
    attr_accessor :help_context_id
    alias_method :attr_help_context_id, :help_context_id
    undef_method :help_context_id
    alias_method :attr_help_context_id=, :help_context_id=
    undef_method :help_context_id=
    
    # The ordered array of parameters understood by this command. This value
    # may be <code>null</code> if there are no parameters, or if the command
    # is undefined. It may also be empty.
    attr_accessor :parameters
    alias_method :attr_parameters, :parameters
    undef_method :parameters
    alias_method :attr_parameters=, :parameters=
    undef_method :parameters=
    
    # The type of the return value of this command. This value may be
    # <code>null</code> if the command does not declare a return type.
    # 
    # @since 3.2
    attr_accessor :return_type
    alias_method :attr_return_type, :return_type
    undef_method :return_type
    alias_method :attr_return_type=, :return_type=
    undef_method :return_type=
    
    # Our command will listen to the active handler for enablement changes so
    # that they can be fired from the command itself.
    # 
    # @since 3.3
    attr_accessor :handler_listener
    alias_method :attr_handler_listener, :handler_listener
    undef_method :handler_listener
    alias_method :attr_handler_listener=, :handler_listener=
    undef_method :handler_listener=
    
    typesig { [String] }
    # Constructs a new instance of <code>Command</code> based on the given
    # identifier. When a command is first constructed, it is undefined.
    # Commands should only be constructed by the <code>CommandManager</code>
    # to ensure that the identifier remains unique.
    # 
    # @param id
    # The identifier for the command. This value must not be
    # <code>null</code>, and must be unique amongst all commands.
    def initialize(id)
      @category = nil
      @execution_listeners = nil
      @handler = nil
      @help_context_id = nil
      @parameters = nil
      @return_type = nil
      @handler_listener = nil
      super(id)
      @category = nil
      @execution_listeners = nil
      @handler = nil
      @parameters = nil
      @return_type = nil
    end
    
    typesig { [ICommandListener] }
    # Adds a listener to this command that will be notified when this command's
    # state changes.
    # 
    # @param commandListener
    # The listener to be added; must not be <code>null</code>.
    def add_command_listener(command_listener)
      if ((command_listener).nil?)
        raise NullPointerException.new("Cannot add a null command listener") # $NON-NLS-1$
      end
      add_listener_object(command_listener)
    end
    
    typesig { [IExecutionListener] }
    # Adds a listener to this command that will be notified when this command
    # is about to execute.
    # 
    # @param executionListener
    # The listener to be added; must not be <code>null</code>.
    def add_execution_listener(execution_listener)
      if ((execution_listener).nil?)
        raise NullPointerException.new("Cannot add a null execution listener") # $NON-NLS-1$
      end
      if ((@execution_listeners).nil?)
        @execution_listeners = ListenerList.new(ListenerList::IDENTITY)
      end
      @execution_listeners.add(execution_listener)
    end
    
    typesig { [String, State] }
    # <p>
    # Adds a state to this command. This will add this state to the active
    # handler, if the active handler is an instance of {@link IObjectWithState}.
    # </p>
    # <p>
    # A single instance of {@link State} cannot be registered with multiple
    # commands. Each command requires its own unique instance.
    # </p>
    # 
    # @param id
    # The identifier of the state to add; must not be
    # <code>null</code>.
    # @param state
    # The state to add; must not be <code>null</code>.
    # @since 3.2
    def add_state(id, state)
      super(id, state)
      state.set_id(id)
      if (@handler.is_a?(IObjectWithState))
        (@handler).add_state(id, state)
      end
    end
    
    typesig { [Object] }
    # Compares this command with another command by comparing each of its
    # non-transient attributes.
    # 
    # @param object
    # The object with which to compare; must be an instance of
    # <code>Command</code>.
    # @return A negative integer, zero or a postivie integer, if the object is
    # greater than, equal to or less than this command.
    def compare_to(object)
      casted_object = object
      compare_to = Util.compare(@category, casted_object.attr_category)
      if ((compare_to).equal?(0))
        compare_to = Util.compare(self.attr_defined, casted_object.attr_defined)
        if ((compare_to).equal?(0))
          compare_to = Util.compare(self.attr_description, casted_object.attr_description)
          if ((compare_to).equal?(0))
            compare_to = Util.compare(@handler, casted_object.attr_handler)
            if ((compare_to).equal?(0))
              compare_to = Util.compare(self.attr_id, casted_object.attr_id)
              if ((compare_to).equal?(0))
                compare_to = Util.compare(self.attr_name, casted_object.attr_name)
                if ((compare_to).equal?(0))
                  compare_to = Util.compare(@parameters, casted_object.attr_parameters)
                end
              end
            end
          end
        end
      end
      return compare_to
    end
    
    typesig { [String, String, Category] }
    # <p>
    # Defines this command by giving it a name, and possibly a description as
    # well. The defined property automatically becomes <code>true</code>.
    # </p>
    # <p>
    # Notification is sent to all listeners that something has changed.
    # </p>
    # 
    # @param name
    # The name of this command; must not be <code>null</code>.
    # @param description
    # The description for this command; may be <code>null</code>.
    # @param category
    # The category for this command; must not be <code>null</code>.
    # @since 3.2
    def define(name, description, category)
      define(name, description, category, nil)
    end
    
    typesig { [String, String, Category, Array.typed(IParameter)] }
    # <p>
    # Defines this command by giving it a name, and possibly a description as
    # well. The defined property automatically becomes <code>true</code>.
    # </p>
    # <p>
    # Notification is sent to all listeners that something has changed.
    # </p>
    # 
    # @param name
    # The name of this command; must not be <code>null</code>.
    # @param description
    # The description for this command; may be <code>null</code>.
    # @param category
    # The category for this command; must not be <code>null</code>.
    # @param parameters
    # The parameters understood by this command. This value may be
    # either <code>null</code> or empty if the command does not
    # accept parameters.
    def define(name, description, category, parameters)
      define(name, description, category, parameters, nil)
    end
    
    typesig { [String, String, Category, Array.typed(IParameter), ParameterType] }
    # <p>
    # Defines this command by giving it a name, and possibly a description as
    # well. The defined property automatically becomes <code>true</code>.
    # </p>
    # <p>
    # Notification is sent to all listeners that something has changed.
    # </p>
    # 
    # @param name
    # The name of this command; must not be <code>null</code>.
    # @param description
    # The description for this command; may be <code>null</code>.
    # @param category
    # The category for this command; must not be <code>null</code>.
    # @param parameters
    # The parameters understood by this command. This value may be
    # either <code>null</code> or empty if the command does not
    # accept parameters.
    # @param returnType
    # The type of value returned by this command. This value may be
    # <code>null</code> if the command does not declare a return
    # type.
    # @since 3.2
    def define(name, description, category, parameters, return_type)
      define(name, description, category, parameters, return_type, nil)
    end
    
    typesig { [String, String, Category, Array.typed(IParameter), ParameterType, String] }
    # <p>
    # Defines this command by giving it a name, and possibly a description as
    # well. The defined property automatically becomes <code>true</code>.
    # </p>
    # <p>
    # Notification is sent to all listeners that something has changed.
    # </p>
    # 
    # @param name
    # The name of this command; must not be <code>null</code>.
    # @param description
    # The description for this command; may be <code>null</code>.
    # @param category
    # The category for this command; must not be <code>null</code>.
    # @param parameters
    # The parameters understood by this command. This value may be
    # either <code>null</code> or empty if the command does not
    # accept parameters.
    # @param returnType
    # The type of value returned by this command. This value may be
    # <code>null</code> if the command does not declare a return
    # type.
    # @param helpContextId
    # The identifier of the help context to associate with this
    # command; may be <code>null</code> if this command does not
    # have any help associated with it.
    # @since 3.2
    def define(name, description, category, parameters, return_type, help_context_id)
      if ((name).nil?)
        raise NullPointerException.new("The name of a command cannot be null") # $NON-NLS-1$
      end
      if ((category).nil?)
        raise NullPointerException.new("The category of a command cannot be null") # $NON-NLS-1$
      end
      defined_changed = !self.attr_defined
      self.attr_defined = true
      name_changed = !(Util == self.attr_name)
      self.attr_name = name
      description_changed = !(Util == self.attr_description)
      self.attr_description = description
      category_changed = !(Util == @category)
      @category = category
      parameters_changed = !(Util == @parameters)
      @parameters = parameters
      return_type_changed = !(Util == @return_type)
      @return_type = return_type
      help_context_id_changed = !(Util == @help_context_id)
      @help_context_id = help_context_id
      fire_command_changed(CommandEvent.new(self, category_changed, defined_changed, description_changed, false, name_changed, parameters_changed, return_type_changed, help_context_id_changed))
    end
    
    typesig { [ExecutionEvent] }
    # Executes this command by delegating to the current handler, if any. If
    # the debugging flag is set, then this method prints information about
    # which handler is selected for performing this command. This method will
    # succeed regardless of whether the command is enabled or defined. It is
    # generally preferred to call {@link #executeWithChecks(ExecutionEvent)}.
    # 
    # @param event
    # An event containing all the information about the current
    # state of the application; must not be <code>null</code>.
    # @return The result of the execution; may be <code>null</code>. This
    # result will be available to the client executing the command, and
    # execution listeners.
    # @throws ExecutionException
    # If the handler has problems executing this command.
    # @throws NotHandledException
    # If there is no handler.
    # @deprecated Please use {@link #executeWithChecks(ExecutionEvent)}
    # instead.
    def execute(event)
      fire_pre_execute(event)
      handler = @handler
      # Perform the execution, if there is a handler.
      if ((!(handler).nil?) && (handler.is_handled))
        begin
          return_value = handler.execute(event)
          fire_post_execute_success(return_value)
          return return_value
        rescue ExecutionException => e
          fire_post_execute_failure(e)
          raise e
        end
      end
      e = NotHandledException.new("There is no handler to execute. " + RJava.cast_to_string(get_id)) # $NON-NLS-1$
      fire_not_handled(e)
      raise e
    end
    
    typesig { [ExecutionEvent] }
    # Executes this command by delegating to the current handler, if any. If
    # the debugging flag is set, then this method prints information about
    # which handler is selected for performing this command. This does checks
    # to see if the command is enabled and defined. If it is not both enabled
    # and defined, then the execution listeners will be notified and an
    # exception thrown.
    # 
    # @param event
    # An event containing all the information about the current
    # state of the application; must not be <code>null</code>.
    # @return The result of the execution; may be <code>null</code>. This
    # result will be available to the client executing the command, and
    # execution listeners.
    # @throws ExecutionException
    # If the handler has problems executing this command.
    # @throws NotDefinedException
    # If the command you are trying to execute is not defined.
    # @throws NotEnabledException
    # If the command you are trying to execute is not enabled.
    # @throws NotHandledException
    # If there is no handler.
    # @since 3.2
    def execute_with_checks(event)
      fire_pre_execute(event)
      handler = @handler
      if (!is_defined)
        # $NON-NLS-1$
        exception = NotDefinedException.new("Trying to execute a command that is not defined. " + RJava.cast_to_string(get_id))
        fire_not_defined(exception)
        raise exception
      end
      # Perform the execution, if there is a handler.
      if ((!(handler).nil?) && (handler.is_handled))
        set_enabled(event.get_application_context)
        if (!is_enabled)
          exception = NotEnabledException.new("Trying to execute the disabled command " + RJava.cast_to_string(get_id)) # $NON-NLS-1$
          fire_not_enabled(exception)
          raise exception
        end
        begin
          return_value = handler.execute(event)
          fire_post_execute_success(return_value)
          return return_value
        rescue ExecutionException => e
          fire_post_execute_failure(e)
          raise e
        end
      end
      e = NotHandledException.new("There is no handler to execute for command " + RJava.cast_to_string(get_id)) # $NON-NLS-1$
      fire_not_handled(e)
      raise e
    end
    
    typesig { [CommandEvent] }
    # Notifies the listeners for this command that it has changed in some way.
    # 
    # @param commandEvent
    # The event to send to all of the listener; must not be
    # <code>null</code>.
    def fire_command_changed(command_event)
      if ((command_event).nil?)
        raise NullPointerException.new("Cannot fire a null event") # $NON-NLS-1$
      end
      listeners = get_listeners
      i = 0
      while i < listeners.attr_length
        listener = listeners[i]
        SafeRunner.run(Class.new(ISafeRunnable.class == Class ? ISafeRunnable : Object) do
          extend LocalClass
          include_class_members Command
          include ISafeRunnable if ISafeRunnable.class == Module
          
          typesig { [JavaThrowable] }
          define_method :handle_exception do |exception|
          end
          
          typesig { [] }
          define_method :run do
            listener.command_changed(command_event)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        i += 1
      end
    end
    
    typesig { [NotDefinedException] }
    # Notifies the execution listeners for this command that an attempt to
    # execute has failed because the command is not defined.
    # 
    # @param e
    # The exception that is about to be thrown; never
    # <code>null</code>.
    # @since 3.2
    def fire_not_defined(e)
      # Debugging output
      if (self.attr_debug_command_execution)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("COMMANDS", "execute" + RJava.cast_to_string(Tracing::SEPARATOR) + "not defined: id=" + RJava.cast_to_string(get_id) + "; exception=" + RJava.cast_to_string(e)) # $NON-NLS-1$ //$NON-NLS-2$
      end
      if (!(@execution_listeners).nil?)
        listeners = @execution_listeners.get_listeners
        i = 0
        while i < listeners.attr_length
          object = listeners[i]
          if (object.is_a?(IExecutionListenerWithChecks))
            listener = object
            listener.not_defined(get_id, e)
          end
          i += 1
        end
      end
    end
    
    typesig { [NotEnabledException] }
    # Notifies the execution listeners for this command that an attempt to
    # execute has failed because there is no handler.
    # 
    # @param e
    # The exception that is about to be thrown; never
    # <code>null</code>.
    # @since 3.2
    def fire_not_enabled(e)
      # Debugging output
      if (self.attr_debug_command_execution)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("COMMANDS", "execute" + RJava.cast_to_string(Tracing::SEPARATOR) + "not enabled: id=" + RJava.cast_to_string(get_id) + "; exception=" + RJava.cast_to_string(e)) # $NON-NLS-1$ //$NON-NLS-2$
      end
      if (!(@execution_listeners).nil?)
        listeners = @execution_listeners.get_listeners
        i = 0
        while i < listeners.attr_length
          object = listeners[i]
          if (object.is_a?(IExecutionListenerWithChecks))
            listener = object
            listener.not_enabled(get_id, e)
          end
          i += 1
        end
      end
    end
    
    typesig { [NotHandledException] }
    # Notifies the execution listeners for this command that an attempt to
    # execute has failed because there is no handler.
    # 
    # @param e
    # The exception that is about to be thrown; never
    # <code>null</code>.
    def fire_not_handled(e)
      # Debugging output
      if (self.attr_debug_command_execution)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("COMMANDS", "execute" + RJava.cast_to_string(Tracing::SEPARATOR) + "not handled: id=" + RJava.cast_to_string(get_id) + "; exception=" + RJava.cast_to_string(e)) # $NON-NLS-1$ //$NON-NLS-2$
      end
      if (!(@execution_listeners).nil?)
        listeners = @execution_listeners.get_listeners
        i = 0
        while i < listeners.attr_length
          listener = listeners[i]
          listener.not_handled(get_id, e)
          i += 1
        end
      end
    end
    
    typesig { [ExecutionException] }
    # Notifies the execution listeners for this command that an attempt to
    # execute has failed during the execution.
    # 
    # @param e
    # The exception that has been thrown; never <code>null</code>.
    # After this method completes, the exception will be thrown
    # again.
    def fire_post_execute_failure(e)
      # Debugging output
      if (self.attr_debug_command_execution)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("COMMANDS", "execute" + RJava.cast_to_string(Tracing::SEPARATOR) + "failure: id=" + RJava.cast_to_string(get_id) + "; exception=" + RJava.cast_to_string(e)) # $NON-NLS-1$ //$NON-NLS-2$
      end
      if (!(@execution_listeners).nil?)
        listeners = @execution_listeners.get_listeners
        i = 0
        while i < listeners.attr_length
          listener = listeners[i]
          listener.post_execute_failure(get_id, e)
          i += 1
        end
      end
    end
    
    typesig { [Object] }
    # Notifies the execution listeners for this command that an execution has
    # completed successfully.
    # 
    # @param returnValue
    # The return value from the command; may be <code>null</code>.
    def fire_post_execute_success(return_value)
      # Debugging output
      if (self.attr_debug_command_execution)
        # $NON-NLS-1$ //$NON-NLS-2$
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("COMMANDS", "execute" + RJava.cast_to_string(Tracing::SEPARATOR) + "success: id=" + RJava.cast_to_string(get_id) + "; returnValue=" + RJava.cast_to_string(return_value))
      end
      if (!(@execution_listeners).nil?)
        listeners = @execution_listeners.get_listeners
        i = 0
        while i < listeners.attr_length
          listener = listeners[i]
          listener.post_execute_success(get_id, return_value)
          i += 1
        end
      end
    end
    
    typesig { [ExecutionEvent] }
    # Notifies the execution listeners for this command that an attempt to
    # execute is about to start.
    # 
    # @param event
    # The execution event that will be used; never <code>null</code>.
    def fire_pre_execute(event)
      # Debugging output
      if (self.attr_debug_command_execution)
        # $NON-NLS-1$ //$NON-NLS-2$
        Tracing.print_trace("COMMANDS", "execute" + RJava.cast_to_string(Tracing::SEPARATOR) + "starting: id=" + RJava.cast_to_string(get_id) + "; event=" + RJava.cast_to_string(event)) # $NON-NLS-1$ //$NON-NLS-2$
      end
      if (!(@execution_listeners).nil?)
        listeners = @execution_listeners.get_listeners
        i = 0
        while i < listeners.attr_length
          listener = listeners[i]
          listener.pre_execute(get_id, event)
          i += 1
        end
      end
    end
    
    typesig { [] }
    # Returns the category for this command.
    # 
    # @return The category for this command; never <code>null</code>.
    # @throws NotDefinedException
    # If the handle is not currently defined.
    def get_category
      if (!is_defined)
        # $NON-NLS-1$
        raise NotDefinedException.new("Cannot get the category from an undefined command. " + RJava.cast_to_string(self.attr_id))
      end
      return @category
    end
    
    typesig { [] }
    # Returns the current handler for this command. This is used by the command
    # manager for determining the appropriate help context identifiers and by
    # the command service to allow handlers to update elements.
    # <p>
    # This value can change at any time and should never be cached.
    # </p>
    # 
    # @return The current handler for this command; may be <code>null</code>.
    # @since 3.3
    def get_handler
      return @handler
    end
    
    typesig { [] }
    # Returns the help context identifier associated with this command. This
    # method should not be called by clients. Clients should use
    # {@link CommandManager#getHelpContextId(Command)} instead.
    # 
    # @return The help context identifier for this command; may be
    # <code>null</code> if there is none.
    # @since 3.2
    def get_help_context_id
      return @help_context_id
    end
    
    typesig { [String] }
    # Returns the parameter with the provided id or <code>null</code> if this
    # command does not have a parameter with the id.
    # 
    # @param parameterId
    # The id of the parameter to retrieve.
    # @return The parameter with the provided id or <code>null</code> if this
    # command does not have a parameter with the id.
    # @throws NotDefinedException
    # If the handle is not currently defined.
    # @since 3.2
    def get_parameter(parameter_id)
      if (!is_defined)
        # $NON-NLS-1$
        raise NotDefinedException.new("Cannot get a parameter from an undefined command. " + RJava.cast_to_string(self.attr_id))
      end
      if ((@parameters).nil?)
        return nil
      end
      i = 0
      while i < @parameters.attr_length
        parameter = @parameters[i]
        if ((parameter.get_id == parameter_id))
          return parameter
        end
        i += 1
      end
      return nil
    end
    
    typesig { [] }
    # Returns the parameters for this command. This call triggers provides a
    # copy of the array, so excessive calls to this method should be avoided.
    # 
    # @return The parameters for this command. This value might be
    # <code>null</code>, if the command has no parameters.
    # @throws NotDefinedException
    # If the handle is not currently defined.
    def get_parameters
      if (!is_defined)
        # $NON-NLS-1$
        raise NotDefinedException.new("Cannot get the parameters from an undefined command. " + RJava.cast_to_string(self.attr_id))
      end
      if (((@parameters).nil?) || ((@parameters.attr_length).equal?(0)))
        return nil
      end
      return_value = Array.typed(IParameter).new(@parameters.attr_length) { nil }
      System.arraycopy(@parameters, 0, return_value, 0, @parameters.attr_length)
      return return_value
    end
    
    typesig { [String] }
    # Returns the {@link ParameterType} for the parameter with the provided id
    # or <code>null</code> if this command does not have a parameter type
    # with the id.
    # 
    # @param parameterId
    # The id of the parameter to retrieve the {@link ParameterType}
    # of.
    # @return The {@link ParameterType} for the parameter with the provided id
    # or <code>null</code> if this command does not have a parameter
    # type with the provided id.
    # @throws NotDefinedException
    # If the handle is not currently defined.
    # @since 3.2
    def get_parameter_type(parameter_id)
      parameter = get_parameter(parameter_id)
      if (parameter.is_a?(ITypedParameter))
        parameter_with_type = parameter
        return parameter_with_type.get_parameter_type
      end
      return nil
    end
    
    typesig { [] }
    # Returns the {@link ParameterType} for the return value of this command or
    # <code>null</code> if this command does not declare a return value
    # parameter type.
    # 
    # @return The {@link ParameterType} for the return value of this command or
    # <code>null</code> if this command does not declare a return
    # value parameter type.
    # @throws NotDefinedException
    # If the handle is not currently defined.
    # @since 3.2
    def get_return_type
      if (!is_defined)
        # $NON-NLS-1$
        raise NotDefinedException.new("Cannot get the return type of an undefined command. " + RJava.cast_to_string(self.attr_id))
      end
      return @return_type
    end
    
    typesig { [] }
    # Returns whether this command has a handler, and whether this handler is
    # also handled and enabled.
    # 
    # @return <code>true</code> if the command is handled; <code>false</code>
    # otherwise.
    def is_enabled
      if ((@handler).nil?)
        return false
      end
      begin
        return @handler.is_enabled
      rescue JavaException => e
        if (self.attr_debug_handlers)
          # since this has the ability to generate megs of logs, only
          # provide information if tracing
          # $NON-NLS-1$//$NON-NLS-2$ //$NON-NLS-3$
          Tracing.print_trace("HANDLERS", "Handler " + RJava.cast_to_string(@handler) + " for " + RJava.cast_to_string(self.attr_id) + " threw unexpected exception") # $NON-NLS-1$
          e.print_stack_trace(System.out)
        end
      end
      return false
    end
    
    typesig { [Object] }
    # Called be the framework to allow the handler to update its enabled state.
    # 
    # @param evaluationContext
    # the state to evaluate against. May be <code>null</code>
    # which indicates that the handler can query whatever model that
    # is necessary.  This context must not be cached.
    # @since 3.4
    def set_enabled(evaluation_context)
      if (@handler.is_a?(IHandler2))
        (@handler).set_enabled(evaluation_context)
      end
    end
    
    typesig { [] }
    # Returns whether this command has a handler, and whether this handler is
    # also handled.
    # 
    # @return <code>true</code> if the command is handled; <code>false</code>
    # otherwise.
    def is_handled
      if ((@handler).nil?)
        return false
      end
      return @handler.is_handled
    end
    
    typesig { [ICommandListener] }
    # Removes a listener from this command.
    # 
    # @param commandListener
    # The listener to be removed; must not be <code>null</code>.
    def remove_command_listener(command_listener)
      if ((command_listener).nil?)
        raise NullPointerException.new("Cannot remove a null command listener") # $NON-NLS-1$
      end
      remove_listener_object(command_listener)
    end
    
    typesig { [IExecutionListener] }
    # Removes a listener from this command.
    # 
    # @param executionListener
    # The listener to be removed; must not be <code>null</code>.
    def remove_execution_listener(execution_listener)
      if ((execution_listener).nil?)
        raise NullPointerException.new("Cannot remove a null execution listener") # $NON-NLS-1$
      end
      if (!(@execution_listeners).nil?)
        @execution_listeners.remove(execution_listener)
        if (@execution_listeners.is_empty)
          @execution_listeners = nil
        end
      end
    end
    
    typesig { [String] }
    # <p>
    # Removes a state from this command. This will remove the state from the
    # active handler, if the active handler is an instance of
    # {@link IObjectWithState}.
    # </p>
    # 
    # @param stateId
    # The identifier of the state to remove; must not be
    # <code>null</code>.
    # @since 3.2
    def remove_state(state_id)
      if (@handler.is_a?(IObjectWithState))
        (@handler).remove_state(state_id)
      end
      super(state_id)
    end
    
    typesig { [IHandler] }
    # Changes the handler for this command. This will remove all the state from
    # the currently active handler (if any), and add it to <code>handler</code>.
    # If debugging is turned on, then this will also print information about
    # the change to <code>System.out</code>.
    # 
    # @param handler
    # The new handler; may be <code>null</code> if none.
    # @return <code>true</code> if the handler changed; <code>false</code>
    # otherwise.
    def set_handler(handler)
      if ((Util == handler))
        return false
      end
      # Swap the state around.
      state_ids = get_state_ids
      if (!(state_ids).nil?)
        i = 0
        while i < state_ids.attr_length
          state_id = state_ids[i]
          if (@handler.is_a?(IObjectWithState))
            (@handler).remove_state(state_id)
          end
          if (handler.is_a?(IObjectWithState))
            state_to_add = get_state(state_id)
            (handler).add_state(state_id, state_to_add)
          end
          i += 1
        end
      end
      enabled = is_enabled
      if (!(@handler).nil?)
        @handler.remove_handler_listener(get_handler_listener)
      end
      # Update the handler, and flush the string representation.
      @handler = handler
      if (!(@handler).nil?)
        @handler.add_handler_listener(get_handler_listener)
      end
      self.attr_string = nil
      # Debugging output
      if ((self.attr_debug_handlers) && (((self.attr_debug_handlers_command_id).nil?) || ((self.attr_debug_handlers_command_id == self.attr_id))))
        buffer = StringBuffer.new("Command('") # $NON-NLS-1$
        buffer.append(self.attr_id)
        buffer.append("') has changed to ") # $NON-NLS-1$
        if ((handler).nil?)
          buffer.append("no handler") # $NON-NLS-1$
        else
          buffer.append(Character.new(?\'.ord))
          buffer.append(handler)
          buffer.append("' as its handler") # $NON-NLS-1$
        end
        Tracing.print_trace("HANDLERS", buffer.to_s) # $NON-NLS-1$
      end
      # Send notification
      fire_command_changed(CommandEvent.new(self, false, false, false, true, false, false, false, false, !(enabled).equal?(is_enabled)))
      return true
    end
    
    typesig { [] }
    # @return the handler listener
    def get_handler_listener
      if ((@handler_listener).nil?)
        @handler_listener = Class.new(IHandlerListener.class == Class ? IHandlerListener : Object) do
          extend LocalClass
          include_class_members Command
          include IHandlerListener if IHandlerListener.class == Module
          
          typesig { [HandlerEvent] }
          define_method :handler_changed do |handler_event|
            enabled_changed = handler_event.is_enabled_changed
            handled_changed = handler_event.is_handled_changed
            fire_command_changed(self.class::CommandEvent.new(@local_class_parent, false, false, false, handled_changed, false, false, false, false, enabled_changed))
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return @handler_listener
    end
    
    typesig { [] }
    # The string representation of this command -- for debugging purposes only.
    # This string should not be shown to an end user.
    # 
    # @return The string representation; never <code>null</code>.
    def to_s
      if ((self.attr_string).nil?)
        sw = StringWriter.new
        buffer = BufferedWriter.new(sw)
        begin
          buffer.write("Command(") # $NON-NLS-1$
          buffer.write(self.attr_id)
          buffer.write(Character.new(?,.ord))
          buffer.write((self.attr_name).nil? ? "" : self.attr_name) # $NON-NLS-1$
          buffer.write(Character.new(?,.ord))
          buffer.new_line
          buffer.write("\t\t") # $NON-NLS-1$
          buffer.write((self.attr_description).nil? ? "" : self.attr_description) # $NON-NLS-1$
          buffer.write(Character.new(?,.ord))
          buffer.new_line
          buffer.write("\t\t") # $NON-NLS-1$
          buffer.write((@category).nil? ? "" : @category.to_s) # $NON-NLS-1$
          buffer.write(Character.new(?,.ord))
          buffer.new_line
          buffer.write("\t\t") # $NON-NLS-1$
          buffer.write((@handler).nil? ? "" : @handler.to_s) # $NON-NLS-1$
          buffer.write(Character.new(?,.ord))
          buffer.new_line
          buffer.write("\t\t") # $NON-NLS-1$
          buffer.write((@parameters).nil? ? "" : @parameters.to_s) # $NON-NLS-1$
          buffer.write(Character.new(?,.ord))
          buffer.write((@return_type).nil? ? "" : @return_type.to_s) # $NON-NLS-1$
          buffer.write(Character.new(?,.ord))
          buffer.write("" + RJava.cast_to_string(self.attr_defined)) # $NON-NLS-1$
          buffer.write(Character.new(?).ord))
          buffer.flush
        rescue IOException => e
          # should never get this exception
        end
        self.attr_string = sw.to_s
      end
      return self.attr_string
    end
    
    typesig { [] }
    # Makes this command become undefined. This has the side effect of changing
    # the name and description to <code>null</code>. This also removes all
    # state and disposes of it. Notification is sent to all listeners.
    def undefine
      enabled_changed = is_enabled
      self.attr_string = nil
      defined_changed = self.attr_defined
      self.attr_defined = false
      name_changed = !(self.attr_name).nil?
      self.attr_name = nil
      description_changed = !(self.attr_description).nil?
      self.attr_description = nil
      category_changed = !(@category).nil?
      @category = nil
      parameters_changed = !(@parameters).nil?
      @parameters = nil
      return_type_changed = !(@return_type).nil?
      @return_type = nil
      state_ids = get_state_ids
      if (!(state_ids).nil?)
        if (@handler.is_a?(IObjectWithState))
          handler_with_state = @handler
          i = 0
          while i < state_ids.attr_length
            state_id = state_ids[i]
            handler_with_state.remove_state(state_id)
            state = get_state(state_id)
            remove_state(state_id)
            state.dispose
            i += 1
          end
        else
          i = 0
          while i < state_ids.attr_length
            state_id = state_ids[i]
            state = get_state(state_id)
            remove_state(state_id)
            state.dispose
            i += 1
          end
        end
      end
      fire_command_changed(CommandEvent.new(self, category_changed, defined_changed, description_changed, false, name_changed, parameters_changed, return_type_changed, false, enabled_changed))
    end
    
    private
    alias_method :initialize__command, :initialize
  end
  
end
