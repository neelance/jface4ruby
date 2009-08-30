require "rjava"

# Copyright (c) 2005, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module ExecutionEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Commands::Common, :NotDefinedException
    }
  end
  
  # <p>
  # The data object to pass to the command (and its handler) as it executes. This
  # carries information about the current state of the application, and the
  # application context in which the command was executed.
  # </p>
  # <p>
  # An execution event carries three blocks of data: the parameters, the trigger,
  # and the application context. How these blocks are used is application
  # dependent. In the Eclipse workbench, the trigger is an SWT event, and the
  # application context contains information about the selection and active part.
  # </p>
  # 
  # @since 3.1
  class ExecutionEvent 
    include_class_members ExecutionEventImports
    
    # The state of the application at the time the execution was triggered. In
    # the Eclipse workbench, this might contain information about the active
    # part of the active selection (for example). This value may be
    # <code>null</code>.
    attr_accessor :application_context
    alias_method :attr_application_context, :application_context
    undef_method :application_context
    alias_method :attr_application_context=, :application_context=
    undef_method :application_context=
    
    # The command being executed. This value may be <code>null</code>.
    attr_accessor :command
    alias_method :attr_command, :command
    undef_method :command
    alias_method :attr_command=, :command=
    undef_method :command=
    
    # The parameters to qualify the execution. For handlers that normally
    # prompt for additional information, these can be used to avoid prompting.
    # This value may be empty, but it is never <code>null</code>.
    attr_accessor :parameters
    alias_method :attr_parameters, :parameters
    undef_method :parameters
    alias_method :attr_parameters=, :parameters=
    undef_method :parameters=
    
    # The object that triggered the execution. In an event-driven architecture,
    # this is typically just another event. In the Eclipse workbench, this is
    # typically an SWT event. This value may be <code>null</code>.
    attr_accessor :trigger
    alias_method :attr_trigger, :trigger
    undef_method :trigger
    alias_method :attr_trigger=, :trigger=
    undef_method :trigger=
    
    typesig { [] }
    # Constructs a new instance of <code>ExecutionEvent</code> with no
    # parameters, no trigger and no application context. This is just a
    # convenience method.
    # 
    # @since 3.2
    def initialize
      initialize__execution_event(nil, Collections::EMPTY_MAP, nil, nil)
    end
    
    typesig { [Map, Object, Object] }
    # Constructs a new instance of <code>ExecutionEvent</code>.
    # 
    # @param parameters
    # The parameters to qualify the execution; must not be
    # <code>null</code>. This must be a map of parameter ids (<code>String</code>)
    # to parameter values (<code>String</code>).
    # @param trigger
    # The object that triggered the execution; may be
    # <code>null</code>.
    # @param applicationContext
    # The state of the application at the time the execution was
    # triggered; may be <code>null</code>.
    # @deprecated use
    # {@link ExecutionEvent#ExecutionEvent(Command, Map, Object, Object)}
    def initialize(parameters, trigger, application_context)
      initialize__execution_event(nil, parameters, trigger, application_context)
    end
    
    typesig { [Command, Map, Object, Object] }
    # Constructs a new instance of <code>ExecutionEvent</code>.
    # 
    # @param command
    # The command being executed; may be <code>null</code>.
    # @param parameters
    # The parameters to qualify the execution; must not be
    # <code>null</code>. This must be a map of parameter ids (<code>String</code>)
    # to parameter values (<code>String</code>).
    # @param trigger
    # The object that triggered the execution; may be
    # <code>null</code>.
    # @param applicationContext
    # The state of the application at the time the execution was
    # triggered; may be <code>null</code>.
    # @since 3.2
    def initialize(command, parameters, trigger, application_context)
      @application_context = nil
      @command = nil
      @parameters = nil
      @trigger = nil
      if ((parameters).nil?)
        raise NullPointerException.new("An execution event must have a non-null map of parameters") # $NON-NLS-1$
      end
      @command = command
      @parameters = parameters
      @trigger = trigger
      @application_context = application_context
    end
    
    typesig { [] }
    # Returns the state of the application at the time the execution was
    # triggered.
    # 
    # @return The application context; may be <code>null</code>.
    def get_application_context
      return @application_context
    end
    
    typesig { [] }
    # Returns the command being executed.
    # 
    # @return The command being executed.
    # @since 3.2
    def get_command
      return @command
    end
    
    typesig { [String] }
    # Returns the object represented by the string value of the parameter with
    # the provided id.
    # <p>
    # This is intended to be used in the scope of an
    # {@link IHandler#execute(ExecutionEvent)} method, so any problem getting
    # the object value causes <code>ExecutionException</code> to be thrown.
    # </p>
    # 
    # @param parameterId
    # The id of a parameter to retrieve the object value of.
    # @return The object value of the parameter with the provided id.
    # @throws ExecutionException
    # if the parameter object value could not be obtained for any
    # reason
    # @since 3.2
    def get_object_parameter_for_execution(parameter_id)
      if ((@command).nil?)
        raise ExecutionException.new("No command is associated with this execution event") # $NON-NLS-1$
      end
      begin
        parameter_type = @command.get_parameter_type(parameter_id)
        if ((parameter_type).nil?)
          raise ExecutionException.new("Command does not have a parameter type for the given parameter") # $NON-NLS-1$
        end
        value_converter = parameter_type.get_value_converter
        if ((value_converter).nil?)
          raise ExecutionException.new("Command does not have a value converter") # $NON-NLS-1$
        end
        string_value = get_parameter(parameter_id)
        object_value = value_converter.convert_to_object(string_value)
        return object_value
      rescue NotDefinedException => e
        raise ExecutionException.new("Command is not defined", e) # $NON-NLS-1$
      rescue ParameterValueConversionException => e
        raise ExecutionException.new("The parameter string could not be converted to an object", e) # $NON-NLS-1$
      end
    end
    
    typesig { [String] }
    # Returns the value of the parameter with the given id.
    # 
    # @param parameterId
    # The id of the parameter to retrieve; may be <code>null</code>.
    # @return The parameter value; <code>null</code> if the parameter cannot
    # be found.
    def get_parameter(parameter_id)
      return @parameters.get(parameter_id)
    end
    
    typesig { [] }
    # Returns all of the parameters.
    # 
    # @return The parameters; never <code>null</code>, but may be empty.
    def get_parameters
      return @parameters
    end
    
    typesig { [] }
    # Returns the object that triggered the execution
    # 
    # @return The trigger; <code>null</code> if there was no trigger.
    def get_trigger
      return @trigger
    end
    
    typesig { [] }
    # The string representation of this execution event -- for debugging
    # purposes only. This string should not be shown to an end user.
    # 
    # @return The string representation; never <code>null</code>.
    def to_s
      string_buffer = StringBuffer.new
      string_buffer.append("ExecutionEvent(") # $NON-NLS-1$
      string_buffer.append(@command)
      string_buffer.append(Character.new(?,.ord))
      string_buffer.append(@parameters)
      string_buffer.append(Character.new(?,.ord))
      string_buffer.append(@trigger)
      string_buffer.append(Character.new(?,.ord))
      string_buffer.append(@application_context)
      string_buffer.append(Character.new(?).ord))
      return string_buffer.to_s
    end
    
    private
    alias_method :initialize__execution_event, :initialize
  end
  
end
