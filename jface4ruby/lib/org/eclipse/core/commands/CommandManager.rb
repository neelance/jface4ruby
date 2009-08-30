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
  module CommandManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :WeakHashMap
      include_const ::Org::Eclipse::Core::Commands::Common, :HandleObjectManager
      include_const ::Org::Eclipse::Core::Commands::Common, :NotDefinedException
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
    }
  end
  
  # <p>
  # A central repository for commands -- both in the defined and undefined
  # states. Commands can be created and retrieved using this manager. It is
  # possible to listen to changes in the collection of commands by attaching a
  # listener to the manager.
  # </p>
  # 
  # @see CommandManager#getCommand(String)
  # @since 3.1
  class CommandManager < CommandManagerImports.const_get :HandleObjectManager
    include_class_members CommandManagerImports
    overload_protected {
      include ICategoryListener
      include ICommandListener
      include IParameterTypeListener
    }
    
    class_module.module_eval {
      # A listener that forwards incoming execution events to execution listeners
      # on this manager. The execution events will come from any command on this
      # manager.
      # 
      # @since 3.1
      const_set_lazy(:ExecutionListener) { Class.new do
        extend LocalClass
        include_class_members CommandManager
        include IExecutionListenerWithChecks
        
        typesig { [String, class_self::NotDefinedException] }
        def not_defined(command_id, exception)
          if (!(self.attr_execution_listeners).nil?)
            listeners = self.attr_execution_listeners.get_listeners
            i = 0
            while i < listeners.attr_length
              object = listeners[i]
              if (object.is_a?(self.class::IExecutionListenerWithChecks))
                listener = object
                listener.not_defined(command_id, exception)
              end
              i += 1
            end
          end
        end
        
        typesig { [String, class_self::NotEnabledException] }
        def not_enabled(command_id, exception)
          if (!(self.attr_execution_listeners).nil?)
            listeners = self.attr_execution_listeners.get_listeners
            i = 0
            while i < listeners.attr_length
              object = listeners[i]
              if (object.is_a?(self.class::IExecutionListenerWithChecks))
                listener = object
                listener.not_enabled(command_id, exception)
              end
              i += 1
            end
          end
        end
        
        typesig { [String, class_self::NotHandledException] }
        def not_handled(command_id, exception)
          if (!(self.attr_execution_listeners).nil?)
            listeners = self.attr_execution_listeners.get_listeners
            i = 0
            while i < listeners.attr_length
              object = listeners[i]
              if (object.is_a?(self.class::IExecutionListener))
                listener = object
                listener.not_handled(command_id, exception)
              end
              i += 1
            end
          end
        end
        
        typesig { [String, class_self::ExecutionException] }
        def post_execute_failure(command_id, exception)
          if (!(self.attr_execution_listeners).nil?)
            listeners = self.attr_execution_listeners.get_listeners
            i = 0
            while i < listeners.attr_length
              object = listeners[i]
              if (object.is_a?(self.class::IExecutionListener))
                listener = object
                listener.post_execute_failure(command_id, exception)
              end
              i += 1
            end
          end
        end
        
        typesig { [String, Object] }
        def post_execute_success(command_id, return_value)
          if (!(self.attr_execution_listeners).nil?)
            listeners = self.attr_execution_listeners.get_listeners
            i = 0
            while i < listeners.attr_length
              object = listeners[i]
              if (object.is_a?(self.class::IExecutionListener))
                listener = object
                listener.post_execute_success(command_id, return_value)
              end
              i += 1
            end
          end
        end
        
        typesig { [String, class_self::ExecutionEvent] }
        def pre_execute(command_id, event)
          if (!(self.attr_execution_listeners).nil?)
            listeners = self.attr_execution_listeners.get_listeners
            i = 0
            while i < listeners.attr_length
              object = listeners[i]
              if (object.is_a?(self.class::IExecutionListener))
                listener = object
                listener.pre_execute(command_id, event)
              end
              i += 1
            end
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__execution_listener, :initialize
      end }
      
      # The identifier of the category in which all auto-generated commands will
      # appear. This value must never be <code>null</code>.
      # 
      # @since 3.2
      const_set_lazy(:AUTOGENERATED_CATEGORY_ID) { "org.eclipse.core.commands.categories.autogenerated" }
      const_attr_reader  :AUTOGENERATED_CATEGORY_ID
      
      # $NON-NLS-1$
      # 
      # The escape character to use for serialization and deserialization of
      # parameterized commands.
      const_set_lazy(:ESCAPE_CHAR) { Character.new(?%.ord) }
      const_attr_reader  :ESCAPE_CHAR
      
      # The character that separates a parameter id from its value.
      const_set_lazy(:ID_VALUE_CHAR) { Character.new(?=.ord) }
      const_attr_reader  :ID_VALUE_CHAR
      
      # The character that indicates the end of a list of parameters.
      const_set_lazy(:PARAMETER_END_CHAR) { Character.new(?).ord) }
      const_attr_reader  :PARAMETER_END_CHAR
      
      # The character that separators parameters from each other.
      const_set_lazy(:PARAMETER_SEPARATOR_CHAR) { Character.new(?,.ord) }
      const_attr_reader  :PARAMETER_SEPARATOR_CHAR
      
      # The character that indicates the start of a list of parameters.
      const_set_lazy(:PARAMETER_START_CHAR) { Character.new(?(.ord) }
      const_attr_reader  :PARAMETER_START_CHAR
      
      typesig { [String] }
      # Unescapes special characters in the command id, parameter ids and
      # parameter values for {@link #deserialize(String)}. The special characters
      # {@link #PARAMETER_START_CHAR}, {@link #PARAMETER_END_CHAR},
      # {@link #ID_VALUE_CHAR}, {@link #PARAMETER_SEPARATOR_CHAR} and
      # {@link #ESCAPE_CHAR} are escaped by prepending an {@link #ESCAPE_CHAR}
      # character.
      # <p>
      # See also ParameterizedCommand.escape(String)
      # </p>
      # 
      # @param escapedText
      # a <code>String</code> that may contain escaped special
      # characters for command serialization.
      # @return a <code>String</code> representing <code>escapedText</code>
      # with any escaped characters replaced by their literal values
      # @throws SerializationException
      # if <code>escapedText</code> contains an invalid escape
      # sequence
      # @since 3.2
      def unescape(escaped_text)
        # defer initialization of a StringBuffer until we know we need one
        buffer = nil
        i = 0
        while i < escaped_text.length
          c = escaped_text.char_at(i)
          if (!(c).equal?(ESCAPE_CHAR))
            # normal unescaped character
            if (!(buffer).nil?)
              buffer.append(c)
            end
          else
            if ((buffer).nil?)
              buffer = StringBuffer.new(escaped_text.substring(0, i))
            end
            if ((i += 1) < escaped_text.length)
              c = escaped_text.char_at(i)
              case (c)
              when PARAMETER_START_CHAR, PARAMETER_END_CHAR, ID_VALUE_CHAR, PARAMETER_SEPARATOR_CHAR, ESCAPE_CHAR
                buffer.append(c)
              else
                raise SerializationException.new("Invalid character '" + RJava.cast_to_string(c) + "' in escape sequence")
              end # $NON-NLS-1$ //$NON-NLS-2$
            else
              raise SerializationException.new("Unexpected termination of escape sequence") # $NON-NLS-1$
            end
          end
          i += 1
        end
        if ((buffer).nil?)
          return escaped_text
        end
        return buffer.to_s
      end
    }
    
    # The map of category identifiers (<code>String</code>) to categories (
    # <code>Category</code>). This collection may be empty, but it is never
    # <code>null</code>.
    attr_accessor :categories_by_id
    alias_method :attr_categories_by_id, :categories_by_id
    undef_method :categories_by_id
    alias_method :attr_categories_by_id=, :categories_by_id=
    undef_method :categories_by_id=
    
    # The set of identifiers for those categories that are defined. This value
    # may be empty, but it is never <code>null</code>.
    attr_accessor :defined_category_ids
    alias_method :attr_defined_category_ids, :defined_category_ids
    undef_method :defined_category_ids
    alias_method :attr_defined_category_ids=, :defined_category_ids=
    undef_method :defined_category_ids=
    
    # The set of identifiers for those command parameter types that are
    # defined. This value may be empty, but it is never <code>null</code>.
    # 
    # @since 3.2
    attr_accessor :defined_parameter_type_ids
    alias_method :attr_defined_parameter_type_ids, :defined_parameter_type_ids
    undef_method :defined_parameter_type_ids
    alias_method :attr_defined_parameter_type_ids=, :defined_parameter_type_ids=
    undef_method :defined_parameter_type_ids=
    
    # The execution listener for this command manager. This just forwards
    # events from commands controlled by this manager to listeners on this
    # manager.
    attr_accessor :execution_listener
    alias_method :attr_execution_listener, :execution_listener
    undef_method :execution_listener
    alias_method :attr_execution_listener=, :execution_listener=
    undef_method :execution_listener=
    
    # The collection of execution listeners. This collection is
    # <code>null</code> if there are no listeners.
    attr_accessor :execution_listeners
    alias_method :attr_execution_listeners, :execution_listeners
    undef_method :execution_listeners
    alias_method :attr_execution_listeners=, :execution_listeners=
    undef_method :execution_listeners=
    
    # The help context identifiers ({@link String}) for a handler ({@link IHandler}).
    # This map may be empty, but it is never <code>null</code>. Entries are
    # removed if all strong references to the handler are removed.
    # 
    # @since 3.2
    attr_accessor :help_context_ids_by_handler
    alias_method :attr_help_context_ids_by_handler, :help_context_ids_by_handler
    undef_method :help_context_ids_by_handler
    alias_method :attr_help_context_ids_by_handler=, :help_context_ids_by_handler=
    undef_method :help_context_ids_by_handler=
    
    # The map of parameter type identifiers (<code>String</code>) to
    # parameter types ( <code>ParameterType</code>). This collection may be
    # empty, but it is never <code>null</code>.
    # 
    # @since 3.2
    attr_accessor :parameter_types_by_id
    alias_method :attr_parameter_types_by_id, :parameter_types_by_id
    undef_method :parameter_types_by_id
    alias_method :attr_parameter_types_by_id=, :parameter_types_by_id=
    undef_method :parameter_types_by_id=
    
    typesig { [ICommandManagerListener] }
    # Adds a listener to this command manager. The listener will be notified
    # when the set of defined commands changes. This can be used to track the
    # global appearance and disappearance of commands.
    # 
    # @param listener
    # The listener to attach; must not be <code>null</code>.
    def add_command_manager_listener(listener)
      add_listener_object(listener)
    end
    
    typesig { [IExecutionListener] }
    # Adds an execution listener to this manager. This listener will be
    # notified if any of the commands controlled by this manager execute. This
    # can be used to support macros and instrumentation of commands.
    # 
    # @param listener
    # The listener to attach; must not be <code>null</code>.
    def add_execution_listener(listener)
      if ((listener).nil?)
        raise NullPointerException.new("Cannot add a null execution listener") # $NON-NLS-1$
      end
      if ((@execution_listeners).nil?)
        @execution_listeners = ListenerList.new(ListenerList::IDENTITY)
        # Add an execution listener to every command.
        @execution_listener = ExecutionListener.new_local(self)
        command_itr = self.attr_handle_objects_by_id.values.iterator
        while (command_itr.has_next)
          command = command_itr.next_
          command.add_execution_listener(@execution_listener)
        end
      end
      @execution_listeners.add(listener)
    end
    
    typesig { [CategoryEvent] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.core.commands.ICategoryListener#categoryChanged(org.eclipse.core.commands.CategoryEvent)
    def category_changed(category_event)
      if (category_event.is_defined_changed)
        category = category_event.get_category
        category_id = category.get_id
        category_id_added = category.is_defined
        if (category_id_added)
          @defined_category_ids.add(category_id)
        else
          @defined_category_ids.remove(category_id)
        end
        if (is_listener_attached)
          fire_command_manager_changed(CommandManagerEvent.new(self, nil, false, false, category_id, category_id_added, true))
        end
      end
    end
    
    typesig { [CommandEvent] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.commands.ICommandListener#commandChanged(org.eclipse.commands.CommandEvent)
    def command_changed(command_event)
      if (command_event.is_defined_changed)
        command = command_event.get_command
        command_id = command.get_id
        command_id_added = command.is_defined
        if (command_id_added)
          self.attr_defined_handle_objects.add(command)
        else
          self.attr_defined_handle_objects.remove(command)
        end
        if (is_listener_attached)
          fire_command_manager_changed(CommandManagerEvent.new(self, command_id, command_id_added, true, nil, false, false))
        end
      end
    end
    
    typesig { [String, String] }
    # Sets the name and description of the category for uncategorized commands.
    # This is the category that will be returned if
    # {@link #getCategory(String)} is called with <code>null</code>.
    # 
    # @param name
    # The name of the category for uncategorized commands; must not
    # be <code>null</code>.
    # @param description
    # The description of the category for uncategorized commands;
    # may be <code>null</code>.
    # @since 3.2
    def define_uncategorized_category(name, description)
      category = get_category(AUTOGENERATED_CATEGORY_ID)
      category.define(name, description)
    end
    
    typesig { [String] }
    # <p>
    # Returns a {@link ParameterizedCommand} with a command and
    # parameterizations as specified in the provided
    # <code>serializedParameterizedCommand</code> string. The
    # <code>serializedParameterizedCommand</code> must use the format
    # returned by {@link ParameterizedCommand#serialize()} and described in the
    # Javadoc for that method.
    # </p>
    # <p>
    # If a parameter id encoded in the
    # <code>serializedParameterizedCommand</code> does not exist in the
    # encoded command, that parameter id and value are ignored. A given
    # parameter id should not be used more than once in
    # <code>serializedParameterizedCommand</code>. This will not result in
    # an exception, but in this case the value of the parameter when the
    # command is executed is unspecified.
    # </p>
    # <p>
    # This method will never return <code>null</code>, however it may throw
    # an exception if there is a problem processing the serialization string or
    # the encoded command is undefined.
    # </p>
    # 
    # @param serializedParameterizedCommand
    # a string representing a command id and parameter ids and
    # values; must not be <code>null</code>
    # @return a {@link ParameterizedCommand} with the command and
    # parameterizations encoded in the
    # <code>serializedParameterizedCommand</code>; never
    # <code>null</code>.
    # @throws NotDefinedException
    # if the command indicated in
    # <code>serializedParameterizedCommand</code> is not defined
    # @throws SerializationException
    # if there is an error deserializing
    # <code>serializedParameterizedCommand</code>
    # @see ParameterizedCommand#serialize()
    # @since 3.2
    def deserialize(serialized_parameterized_command)
      lparen_position = unescaped_index_of(serialized_parameterized_command, PARAMETER_START_CHAR)
      command_id_escaped = nil
      serialized_parameters = nil
      if ((lparen_position).equal?(-1))
        command_id_escaped = serialized_parameterized_command
        serialized_parameters = RJava.cast_to_string(nil)
      else
        command_id_escaped = RJava.cast_to_string(serialized_parameterized_command.substring(0, lparen_position))
        if (!(serialized_parameterized_command.char_at(serialized_parameterized_command.length - 1)).equal?(PARAMETER_END_CHAR))
          raise SerializationException.new("Parentheses must be balanced in serialized ParameterizedCommand") # $NON-NLS-1$
        end
        # skip PARAMETER_START_CHAR
        serialized_parameters = RJava.cast_to_string(serialized_parameterized_command.substring(lparen_position + 1, serialized_parameterized_command.length - 1)) # skip
        # PARAMETER_END_CHAR
      end
      command_id = unescape(command_id_escaped)
      command = get_command(command_id)
      parameters = command.get_parameters
      parameterizations = get_parameterizations(serialized_parameters, parameters)
      return ParameterizedCommand.new(command, parameterizations)
    end
    
    typesig { [CommandManagerEvent] }
    # Notifies all of the listeners to this manager that the set of defined
    # command identifiers has changed.
    # 
    # @param event
    # The event to send to all of the listeners; must not be
    # <code>null</code>.
    def fire_command_manager_changed(event)
      if ((event).nil?)
        raise NullPointerException.new
      end
      listeners = get_listeners
      i = 0
      while i < listeners.attr_length
        listener = listeners[i]
        listener.command_manager_changed(event)
        i += 1
      end
    end
    
    typesig { [] }
    # Returns all of the commands known by this manager -- defined and
    # undefined.
    # 
    # @return All of the commands; may be empty, but never <code>null</code>.
    # @since 3.2
    def get_all_commands
      return self.attr_handle_objects_by_id.values.to_array(Array.typed(Command).new(self.attr_handle_objects_by_id.size) { nil })
    end
    
    typesig { [String] }
    # Gets the category with the given identifier. If no such category
    # currently exists, then the category will be created (but be undefined).
    # 
    # @param categoryId
    # The identifier to find; must not be <code>null</code>. If
    # the category is <code>null</code>, then a category suitable
    # for uncategorized items is defined and returned.
    # @return The category with the given identifier; this value will never be
    # <code>null</code>, but it might be undefined.
    # @see Category
    def get_category(category_id)
      if ((category_id).nil?)
        return get_category(AUTOGENERATED_CATEGORY_ID)
      end
      check_id(category_id)
      category = @categories_by_id.get(category_id)
      if ((category).nil?)
        category = Category.new(category_id)
        @categories_by_id.put(category_id, category)
        category.add_category_listener(self)
      end
      return category
    end
    
    typesig { [String] }
    # Gets the command with the given identifier. If no such command currently
    # exists, then the command will be created (but will be undefined).
    # 
    # @param commandId
    # The identifier to find; must not be <code>null</code> and
    # must not be zero-length.
    # @return The command with the given identifier; this value will never be
    # <code>null</code>, but it might be undefined.
    # @see Command
    def get_command(command_id)
      check_id(command_id)
      command = self.attr_handle_objects_by_id.get(command_id)
      if ((command).nil?)
        command = Command.new(command_id)
        self.attr_handle_objects_by_id.put(command_id, command)
        command.add_command_listener(self)
        if (!(@execution_listener).nil?)
          command.add_execution_listener(@execution_listener)
        end
      end
      return command
    end
    
    typesig { [] }
    # Returns the categories that are defined.
    # 
    # @return The defined categories; this value may be empty, but it is never
    # <code>null</code>.
    # @since 3.2
    def get_defined_categories
      categories = Array.typed(Category).new(@defined_category_ids.size) { nil }
      category_id_itr = @defined_category_ids.iterator
      i = 0
      while (category_id_itr.has_next)
        category_id = category_id_itr.next_
        categories[((i += 1) - 1)] = get_category(category_id)
      end
      return categories
    end
    
    typesig { [] }
    # Returns the set of identifiers for those category that are defined.
    # 
    # @return The set of defined category identifiers; this value may be empty,
    # but it is never <code>null</code>.
    def get_defined_category_ids
      return Collections.unmodifiable_set(@defined_category_ids)
    end
    
    typesig { [] }
    # Returns the set of identifiers for those commands that are defined.
    # 
    # @return The set of defined command identifiers; this value may be empty,
    # but it is never <code>null</code>.
    def get_defined_command_ids
      return get_defined_handle_object_ids
    end
    
    typesig { [] }
    # Returns the commands that are defined.
    # 
    # @return The defined commands; this value may be empty, but it is never
    # <code>null</code>.
    # @since 3.2
    def get_defined_commands
      return self.attr_defined_handle_objects.to_array(Array.typed(Command).new(self.attr_defined_handle_objects.size) { nil })
    end
    
    typesig { [] }
    # Returns the set of identifiers for those parameter types that are
    # defined.
    # 
    # @return The set of defined command parameter type identifiers; this value
    # may be empty, but it is never <code>null</code>.
    # @since 3.2
    def get_defined_parameter_type_ids
      return Collections.unmodifiable_set(@defined_parameter_type_ids)
    end
    
    typesig { [] }
    # Returns the command parameter types that are defined.
    # 
    # @return The defined command parameter types; this value may be empty, but
    # it is never <code>null</code>.
    # @since 3.2
    def get_defined_parameter_types
      parameter_types = Array.typed(ParameterType).new(@defined_parameter_type_ids.size) { nil }
      iterator_ = @defined_parameter_type_ids.iterator
      i = 0
      while (iterator_.has_next)
        parameter_type_id = iterator_.next_
        parameter_types[((i += 1) - 1)] = get_parameter_type(parameter_type_id)
      end
      return parameter_types
    end
    
    typesig { [Command] }
    # Gets the help context identifier for a particular command. The command's
    # handler is first checked for a help context identifier. If the handler
    # does not have a help context identifier, then the help context identifier
    # for the command is returned. If neither has a help context identifier,
    # then <code>null</code> is returned.
    # 
    # @param command
    # The command for which the help context should be retrieved;
    # must not be <code>null</code>.
    # @return The help context identifier to use for the given command; may be
    # <code>null</code>.
    # @throws NotDefinedException
    # If the given command is not defined.
    # @since 3.2
    def get_help_context_id(command)
      # Check if the command is defined.
      if (!command.is_defined)
        # $NON-NLS-1$
        raise NotDefinedException.new("The command is not defined. " + RJava.cast_to_string(command.get_id))
      end
      # Check the handler.
      handler = command.get_handler
      if (!(handler).nil?)
        help_context_id = @help_context_ids_by_handler.get(handler)
        if (!(help_context_id).nil?)
          return help_context_id
        end
      end
      # Simply return whatever the command has as a help context identifier.
      return command.get_help_context_id
    end
    
    typesig { [String, Array.typed(IParameter)] }
    # Returns an array of parameterizations for the provided command by
    # deriving the parameter ids and values from the provided
    # <code>serializedParameters</code> string.
    # 
    # @param serializedParameters
    # a String encoding parameter ids and values; must not be
    # <code>null</code>.
    # @param parameters
    # array of parameters of the command being deserialized; may be
    # <code>null</code>.
    # @return an array of parameterizations; may be <code>null</code>.
    # @throws SerializationException
    # if there is an error deserializing the parameters
    # @since 3.2
    def get_parameterizations(serialized_parameters, parameters)
      if ((serialized_parameters).nil? || ((serialized_parameters.length).equal?(0)))
        return nil
      end
      if (((parameters).nil?) || ((parameters.attr_length).equal?(0)))
        return nil
      end
      param_list = ArrayList.new
      comma_position = 0 # split off each param by looking for ','
      begin
        comma_position = unescaped_index_of(serialized_parameters, Character.new(?,.ord))
        id_equals_value = nil
        if ((comma_position).equal?(-1))
          # no more parameters after this
          id_equals_value = serialized_parameters
        else
          # take the first parameter...
          id_equals_value = RJava.cast_to_string(serialized_parameters.substring(0, comma_position))
          # ... and put the rest back into serializedParameters
          serialized_parameters = RJava.cast_to_string(serialized_parameters.substring(comma_position + 1))
        end
        equals_position = unescaped_index_of(id_equals_value, Character.new(?=.ord))
        parameter_id = nil
        parameter_value = nil
        if ((equals_position).equal?(-1))
          # missing values are null
          parameter_id = RJava.cast_to_string(unescape(id_equals_value))
          parameter_value = RJava.cast_to_string(nil)
        else
          parameter_id = RJava.cast_to_string(unescape(id_equals_value.substring(0, equals_position)))
          parameter_value = RJava.cast_to_string(unescape(id_equals_value.substring(equals_position + 1)))
        end
        i = 0
        while i < parameters.attr_length
          parameter = parameters[i]
          if ((parameter.get_id == parameter_id))
            param_list.add(Parameterization.new(parameter, parameter_value))
            break
          end
          i += 1
        end
      end while (!(comma_position).equal?(-1))
      return param_list.to_array(Array.typed(Parameterization).new(param_list.size) { nil })
    end
    
    typesig { [String] }
    # Gets the command {@link ParameterType} with the given identifier. If no
    # such command parameter type currently exists, then the command parameter
    # type will be created (but will be undefined).
    # 
    # @param parameterTypeId
    # The identifier to find; must not be <code>null</code> and
    # must not be zero-length.
    # @return The {@link ParameterType} with the given identifier; this value
    # will never be <code>null</code>, but it might be undefined.
    # @since 3.2
    def get_parameter_type(parameter_type_id)
      check_id(parameter_type_id)
      parameter_type = @parameter_types_by_id.get(parameter_type_id)
      if ((parameter_type).nil?)
        parameter_type = ParameterType.new(parameter_type_id)
        @parameter_types_by_id.put(parameter_type_id, parameter_type)
        parameter_type.add_listener(self)
      end
      return parameter_type
    end
    
    typesig { [ParameterTypeEvent] }
    # {@inheritDoc}
    # 
    # @since 3.2
    def parameter_type_changed(parameter_type_event)
      if (parameter_type_event.is_defined_changed)
        parameter_type = parameter_type_event.get_parameter_type
        parameter_type_id = parameter_type.get_id
        parameter_type_id_added = parameter_type.is_defined
        if (parameter_type_id_added)
          @defined_parameter_type_ids.add(parameter_type_id)
        else
          @defined_parameter_type_ids.remove(parameter_type_id)
        end
        fire_command_manager_changed(CommandManagerEvent.new(self, parameter_type_id, parameter_type_id_added, true))
      end
    end
    
    typesig { [ICommandManagerListener] }
    # Removes a listener from this command manager.
    # 
    # @param listener
    # The listener to be removed; must not be <code>null</code>.
    def remove_command_manager_listener(listener)
      remove_listener_object(listener)
    end
    
    typesig { [IExecutionListener] }
    # Removes an execution listener from this command manager.
    # 
    # @param listener
    # The listener to be removed; must not be <code>null</code>.
    def remove_execution_listener(listener)
      if ((listener).nil?)
        raise NullPointerException.new("Cannot remove a null listener") # $NON-NLS-1$
      end
      if ((@execution_listeners).nil?)
        return
      end
      @execution_listeners.remove(listener)
      if (@execution_listeners.is_empty)
        @execution_listeners = nil
        # Remove the execution listener to every command.
        command_itr = self.attr_handle_objects_by_id.values.iterator
        while (command_itr.has_next)
          command = command_itr.next_
          command.remove_execution_listener(@execution_listener)
        end
        @execution_listener = nil
      end
    end
    
    typesig { [Map] }
    # Block updates all of the handlers for all of the commands. If the handler
    # is <code>null</code> or the command id does not exist in the map, then
    # the command becomes unhandled. Otherwise, the handler is set to the
    # corresponding value in the map.
    # 
    # @param handlersByCommandId
    # A map of command identifiers (<code>String</code>) to
    # handlers (<code>IHandler</code>). This map may be
    # <code>null</code> if all handlers should be cleared.
    # Similarly, if the map is empty, then all commands will become
    # unhandled.
    def set_handlers_by_command_id(handlers_by_command_id)
      # Make that all the reference commands are created.
      command_id_itr = handlers_by_command_id.key_set.iterator
      while (command_id_itr.has_next)
        get_command(command_id_itr.next_)
      end
      # Now, set-up the handlers on all of the existing commands.
      command_itr = self.attr_handle_objects_by_id.values.iterator
      while (command_itr.has_next)
        command = command_itr.next_
        command_id = command.get_id
        value = handlers_by_command_id.get(command_id)
        if (value.is_a?(IHandler))
          command.set_handler(value)
        else
          command.set_handler(nil)
        end
      end
    end
    
    typesig { [IHandler, String] }
    # Sets the help context identifier to associate with a particular handler.
    # 
    # @param handler
    # The handler with which to register a help context identifier;
    # must not be <code>null</code>.
    # @param helpContextId
    # The help context identifier to register; may be
    # <code>null</code> if the help context identifier should be
    # removed.
    # @since 3.2
    def set_help_context_id(handler, help_context_id)
      if ((handler).nil?)
        raise NullPointerException.new("The handler cannot be null") # $NON-NLS-1$
      end
      if ((help_context_id).nil?)
        @help_context_ids_by_handler.remove(handler)
      else
        @help_context_ids_by_handler.put(handler, help_context_id)
      end
    end
    
    typesig { [String, ::Java::Char] }
    # Searches for the index of a <code>char</code> in a <code>String</code>
    # but disregards characters prefixed with the {@link #ESCAPE_CHAR} escape
    # character. This is used by {@link #deserialize(String)} and
    # {@link #getParameterizations(String, IParameter[])} to parse the
    # serialized parameterized command string.
    # 
    # @param escapedText
    # the string to search for the index of <code>ch</code> in
    # @param ch
    # a character to search for in <code>escapedText</code>
    # @return the index of the first unescaped occurrence of the character in
    # <code>escapedText</code>, or <code>-1</code> if the
    # character does not occur unescaped.
    # @see String#indexOf(int)
    def unescaped_index_of(escaped_text, ch)
      pos = escaped_text.index_of(ch)
      # first char can't be escaped
      if ((pos).equal?(0))
        return pos
      end
      while (!(pos).equal?(-1))
        # look back for the escape character
        if (!(escaped_text.char_at(pos - 1)).equal?(ESCAPE_CHAR))
          return pos
        end
        # scan for the next instance of ch
        pos = escaped_text.index_of(ch, pos + 1)
      end
      return pos
    end
    
    typesig { [String, NotEnabledException] }
    # Fires the <code>notEnabled</code> event for
    # <code>executionListeners</code>.
    # <p>
    # <b>Note:</b> This supports bridging actions to the command framework,
    # and should not be used outside the framework.
    # </p>
    # 
    # @param commandId
    # The command id of the command about to execute, never
    # <code>null</code>.
    # @param exception
    # The exception, never <code>null</code>.
    # @since 3.4
    def fire_not_enabled(command_id, exception)
      if (!(@execution_listener).nil?)
        @execution_listener.not_enabled(command_id, exception)
      end
    end
    
    typesig { [String, NotDefinedException] }
    # Fires the <code>notDefined</code> event for
    # <code>executionListeners</code>.
    # <p>
    # <b>Note:</b> This supports bridging actions to the command framework,
    # and should not be used outside the framework.
    # </p>
    # 
    # @param commandId
    # The command id of the command about to execute, never
    # <code>null</code>.
    # @param exception
    # The exception, never <code>null</code>.
    # @since 3.4
    def fire_not_defined(command_id, exception)
      if (!(@execution_listener).nil?)
        @execution_listener.not_defined(command_id, exception)
      end
    end
    
    typesig { [String, ExecutionEvent] }
    # Fires the <code>preExecute</code> event for
    # <code>executionListeners</code>.
    # <p>
    # <b>Note:</b> This supports bridging actions to the command framework,
    # and should not be used outside the framework.
    # </p>
    # 
    # @param commandId
    # The command id of the command about to execute, never
    # <code>null</code>.
    # @param event
    # The event that triggered the command, may be <code>null</code>.
    # @since 3.4
    def fire_pre_execute(command_id, event)
      if (!(@execution_listener).nil?)
        @execution_listener.pre_execute(command_id, event)
      end
    end
    
    typesig { [String, Object] }
    # Fires the <code>postExecuteSuccess</code> event for
    # <code>executionListeners</code>.
    # <p>
    # <b>Note:</b> This supports bridging actions to the command framework,
    # and should not be used outside the framework.
    # </p>
    # 
    # @param commandId
    # The command id of the command executed, never
    # <code>null</code>.
    # @param returnValue
    # The value returned from the command, may be <code>null</code>.
    # @since 3.4
    def fire_post_execute_success(command_id, return_value)
      if (!(@execution_listener).nil?)
        @execution_listener.post_execute_success(command_id, return_value)
      end
    end
    
    typesig { [String, ExecutionException] }
    # Fires the <code>postExecuteFailure</code> event for
    # <code>executionListeners</code>.
    # <p>
    # <b>Note:</b> This supports bridging actions to the command framework,
    # and should not be used outside the framework.
    # </p>
    # 
    # @param commandId
    # The command id of the command executed, never
    # <code>null</code>.
    # @param exception
    # The exception, never <code>null</code>.
    # @since 3.4
    def fire_post_execute_failure(command_id, exception)
      if (!(@execution_listener).nil?)
        @execution_listener.post_execute_failure(command_id, exception)
      end
    end
    
    typesig { [] }
    def initialize
      @categories_by_id = nil
      @defined_category_ids = nil
      @defined_parameter_type_ids = nil
      @execution_listener = nil
      @execution_listeners = nil
      @help_context_ids_by_handler = nil
      @parameter_types_by_id = nil
      super()
      @categories_by_id = HashMap.new
      @defined_category_ids = HashSet.new
      @defined_parameter_type_ids = HashSet.new
      @execution_listener = nil
      @execution_listeners = nil
      @help_context_ids_by_handler = WeakHashMap.new
      @parameter_types_by_id = HashMap.new
    end
    
    private
    alias_method :initialize__command_manager, :initialize
  end
  
end
