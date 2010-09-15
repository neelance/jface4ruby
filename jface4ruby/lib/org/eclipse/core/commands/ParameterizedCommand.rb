require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Benjamin Muskalla - bug 222861 [Commands] ParameterizedCommand#equals broken
module Org::Eclipse::Core::Commands
  module ParameterizedCommandImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Commands::Common, :NotDefinedException
      include_const ::Org::Eclipse::Core::Internal::Commands::Util, :Util
    }
  end
  
  # <p>
  # A command that has had one or more of its parameters specified. This class
  # serves as a utility class for developers that need to manipulate commands
  # with parameters. It handles the behaviour of generating a parameter map and a
  # human-readable name.
  # </p>
  # 
  # @since 3.1
  class ParameterizedCommand 
    include_class_members ParameterizedCommandImports
    include JavaComparable
    
    class_module.module_eval {
      # The constant integer hash code value meaning the hash code has not yet
      # been computed.
      const_set_lazy(:HASH_CODE_NOT_COMPUTED) { -1 }
      const_attr_reader  :HASH_CODE_NOT_COMPUTED
      
      # A factor for computing the hash code for all parameterized commands.
      const_set_lazy(:HASH_FACTOR) { 89 }
      const_attr_reader  :HASH_FACTOR
      
      # The seed for the hash code for all parameterized commands.
      const_set_lazy(:HASH_INITIAL) { ParameterizedCommand.get_name.hash_code }
      const_attr_reader  :HASH_INITIAL
      
      # The index of the parameter id in the parameter values.
      # 
      # @deprecated no longer used
      const_set_lazy(:INDEX_PARAMETER_ID) { 0 }
      const_attr_reader  :INDEX_PARAMETER_ID
      
      # The index of the human-readable name of the parameter itself, in the
      # parameter values.
      # 
      # @deprecated no longer used
      const_set_lazy(:INDEX_PARAMETER_NAME) { 1 }
      const_attr_reader  :INDEX_PARAMETER_NAME
      
      # The index of the human-readable name of the value of the parameter for
      # this command.
      # 
      # @deprecated no longer used
      const_set_lazy(:INDEX_PARAMETER_VALUE_NAME) { 2 }
      const_attr_reader  :INDEX_PARAMETER_VALUE_NAME
      
      # The index of the value of the parameter that the command can understand.
      # 
      # @deprecated no longer used
      const_set_lazy(:INDEX_PARAMETER_VALUE_VALUE) { 3 }
      const_attr_reader  :INDEX_PARAMETER_VALUE_VALUE
      
      typesig { [String] }
      # Escapes special characters in the command id, parameter ids and parameter
      # values for {@link #serialize()}. The special characters
      # {@link CommandManager#PARAMETER_START_CHAR},
      # {@link CommandManager#PARAMETER_END_CHAR},
      # {@link CommandManager#ID_VALUE_CHAR},
      # {@link CommandManager#PARAMETER_SEPARATOR_CHAR} and
      # {@link CommandManager#ESCAPE_CHAR} are escaped by prepending a
      # {@link CommandManager#ESCAPE_CHAR} character.
      # 
      # @param rawText
      # a <code>String</code> to escape special characters in for
      # serialization.
      # @return a <code>String</code> representing <code>rawText</code> with
      # special serialization characters escaped
      # @since 3.2
      def escape(raw_text)
        # defer initialization of a StringBuffer until we know we need one
        buffer = nil
        i = 0
        while i < raw_text.length
          c = raw_text.char_at(i)
          case (c)
          when CommandManager::PARAMETER_START_CHAR, CommandManager::PARAMETER_END_CHAR, CommandManager::ID_VALUE_CHAR, CommandManager::PARAMETER_SEPARATOR_CHAR, CommandManager::ESCAPE_CHAR
            if ((buffer).nil?)
              buffer = StringBuffer.new(raw_text.substring(0, i))
            end
            buffer.append(CommandManager::ESCAPE_CHAR)
            buffer.append(c)
          else
            if (!(buffer).nil?)
              buffer.append(c)
            end
          end
          i += 1
        end
        if ((buffer).nil?)
          return raw_text
        end
        return buffer.to_s
      end
      
      typesig { [::Java::Int, Array.typed(IParameter)] }
      # Generates every possible combination of parameter values for the given
      # parameters. Parameters values that cannot be initialized are just
      # ignored. Optional parameters are considered.
      # 
      # @param startIndex
      # The index in the <code>parameters</code> that we should
      # process. This must be a valid index.
      # @param parameters
      # The parameters in to process; must not be <code>null</code>.
      # @return A collection (<code>Collection</code>) of combinations (<code>List</code>
      # of <code>Parameterization</code>).
      def expand_parameters(start_index, parameters)
        next_index = start_index + 1
        no_more_parameters = (next_index >= parameters.attr_length)
        parameter = parameters[start_index]
        parameterizations = ArrayList.new
        if (parameter.is_optional)
          parameterizations.add(nil)
        end
        values = nil
        begin
          values = parameter.get_values
        rescue ParameterValuesException => e
          if (no_more_parameters)
            return parameterizations
          end
          # Make recursive call
          return expand_parameters(next_index, parameters)
        end
        parameter_values = values.get_parameter_values
        parameter_value_itr = parameter_values.entry_set.iterator
        while (parameter_value_itr.has_next)
          entry = parameter_value_itr.next_
          parameterization = Parameterization.new(parameter, entry.get_value)
          parameterizations.add(parameterization)
        end
        # Check if another iteration will produce any more names.
        parameterization_count = parameterizations.size
        if (no_more_parameters)
          # This is it, so just return the current parameterizations.
          i = 0
          while i < parameterization_count
            parameterization = parameterizations.get(i)
            combination = ArrayList.new(1)
            combination.add(parameterization)
            parameterizations.set(i, combination)
            i += 1
          end
          return parameterizations
        end
        # Make recursive call
        suffixes = expand_parameters(next_index, parameters)
        while (suffixes.remove(nil))
        end
        if (suffixes.is_empty)
          # This is it, so just return the current parameterizations.
          i = 0
          while i < parameterization_count
            parameterization = parameterizations.get(i)
            combination = ArrayList.new(1)
            combination.add(parameterization)
            parameterizations.set(i, combination)
            i += 1
          end
          return parameterizations
        end
        return_value = ArrayList.new
        suffix_itr = suffixes.iterator
        while (suffix_itr.has_next)
          combination = suffix_itr.next_
          combination_size = combination.size
          i = 0
          while i < parameterization_count
            parameterization = parameterizations.get(i)
            new_combination = ArrayList.new(combination_size + 1)
            new_combination.add(parameterization)
            new_combination.add_all(combination)
            return_value.add(new_combination)
            i += 1
          end
        end
        return return_value
      end
      
      typesig { [Command] }
      # <p>
      # Generates all the possible combinations of command parameterizations for
      # the given command. If the command has no parameters, then this is simply
      # a parameterized version of that command. If a parameter is optional, both
      # the included and not included cases are considered.
      # </p>
      # <p>
      # If one of the parameters cannot be loaded due to a
      # <code>ParameterValuesException</code>, then it is simply ignored.
      # </p>
      # 
      # @param command
      # The command for which the parameter combinations should be
      # generated; must not be <code>null</code>.
      # @return A collection of <code>ParameterizedCommand</code> instances
      # representing all of the possible combinations. This value is
      # never empty and it is never <code>null</code>.
      # @throws NotDefinedException
      # If the command is not defined.
      def generate_combinations(command)
        parameters = command.get_parameters
        if ((parameters).nil?)
          return Collections.singleton(ParameterizedCommand.new(command, nil))
        end
        expansion = expand_parameters(0, parameters)
        combinations = ArrayList.new(expansion.size)
        expansion_itr = expansion.iterator
        while (expansion_itr.has_next)
          combination = expansion_itr.next_
          if ((combination).nil?)
            combinations.add(ParameterizedCommand.new(command, nil))
          else
            while (combination.remove(nil))
            end
            if (combination.is_empty)
              combinations.add(ParameterizedCommand.new(command, nil))
            else
              parameterizations = combination.to_array(Array.typed(Parameterization).new(combination.size) { nil })
              combinations.add(ParameterizedCommand.new(command, parameterizations))
            end
          end
        end
        return combinations
      end
      
      typesig { [Command, Map] }
      # Take a command and a map of parameter IDs to values, and generate the
      # appropriate parameterized command.
      # 
      # @param command
      # The command object. Must not be <code>null</code>.
      # @param parameters
      # A map of String parameter ids to objects. May be
      # <code>null</code>.
      # @return the parameterized command, or <code>null</code> if it could not
      # be generated
      # @since 3.4
      def generate_command(command, parameters)
        # no parameters
        if ((parameters).nil? || parameters.is_empty)
          return ParameterizedCommand.new(command, nil)
        end
        begin
          parms = ArrayList.new
          i = parameters.key_set.iterator
          # iterate over given parameters
          while (i.has_next)
            key = i.next_
            parameter = nil
            # get the parameter from the command
            parameter = command.get_parameter(key)
            # if the parameter is defined add it to the parameter list
            if ((parameter).nil?)
              return nil
            end
            parameter_type = command.get_parameter_type(key)
            if ((parameter_type).nil?)
              parms.add(Parameterization.new(parameter, parameters.get(key)))
            else
              value_converter = parameter_type.get_value_converter
              if (!(value_converter).nil?)
                val = value_converter.convert_to_string(parameters.get(key))
                parms.add(Parameterization.new(parameter, val))
              else
                parms.add(Parameterization.new(parameter, parameters.get(key)))
              end
            end
          end
          # convert the parameters to an Parameterization array and create
          # the command
          return ParameterizedCommand.new(command, parms.to_array(Array.typed(Parameterization).new(parms.size) { nil }))
        rescue NotDefinedException => e
        rescue ParameterValueConversionException => e
        end
        return nil
      end
    }
    
    # The base command which is being parameterized. This value is never
    # <code>null</code>.
    attr_accessor :command
    alias_method :attr_command, :command
    undef_method :command
    alias_method :attr_command=, :command=
    undef_method :command=
    
    # The hash code for this object. This value is computed lazily, and marked
    # as invalid when one of the values on which it is based changes.
    attr_accessor :hash_code
    alias_method :attr_hash_code, :hash_code
    undef_method :hash_code
    alias_method :attr_hash_code=, :hash_code=
    undef_method :hash_code=
    
    # This is an array of parameterization defined for this command. This value
    # may be <code>null</code> if the command has no parameters.
    attr_accessor :parameterizations
    alias_method :attr_parameterizations, :parameterizations
    undef_method :parameterizations
    alias_method :attr_parameterizations=, :parameterizations=
    undef_method :parameterizations=
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [Command, Array.typed(Parameterization)] }
    # Constructs a new instance of <code>ParameterizedCommand</code> with
    # specific values for zero or more of its parameters.
    # 
    # @param command
    # The command that is parameterized; must not be
    # <code>null</code>.
    # @param parameterizations
    # An array of parameterizations binding parameters to values for
    # the command. This value may be <code>null</code>.
    def initialize(command, parameterizations)
      @command = nil
      @hash_code = HASH_CODE_NOT_COMPUTED
      @parameterizations = nil
      @name = nil
      if ((command).nil?)
        raise NullPointerException.new("A parameterized command cannot have a null command") # $NON-NLS-1$
      end
      @command = command
      parms = nil
      begin
        parms = command.get_parameters
      rescue NotDefinedException => e
        # This should not happen.
      end
      if (!(parameterizations).nil? && parameterizations.attr_length > 0 && !(parms).nil?)
        parm_index = 0
        params = Array.typed(Parameterization).new(parameterizations.attr_length) { nil }
        j = 0
        while j < parms.attr_length
          i = 0
          while i < parameterizations.attr_length
            pm = parameterizations[i]
            if ((parms[j] == pm.get_parameter))
              params[((parm_index += 1) - 1)] = pm
            end
            i += 1
          end
          j += 1
        end
        @parameterizations = params
      else
        @parameterizations = nil
      end
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see java.lang.Comparable#compareTo(java.lang.Object)
    def compare_to(object)
      command = object
      this_defined = @command.is_defined
      other_defined = command.attr_command.is_defined
      if (!this_defined || !other_defined)
        return Util.compare(this_defined, other_defined)
      end
      begin
        compare_to = (get_name <=> command.get_name)
        if ((compare_to).equal?(0))
          return (get_id <=> command.get_id)
        end
        return compare_to
      rescue NotDefinedException => e
        raise JavaError.new("Concurrent modification of a command's defined state") # $NON-NLS-1$
      end
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # 
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(object)
      if ((self).equal?(object))
        return true
      end
      if (!(object.is_a?(ParameterizedCommand)))
        return false
      end
      command = object
      if (!Util.==(@command, command.attr_command))
        return false
      end
      return Util.==(@parameterizations, command.attr_parameterizations)
    end
    
    typesig { [Object, Object] }
    # Executes this command with its parameters. This method will succeed
    # regardless of whether the command is enabled or defined. It is
    # preferrable to use {@link #executeWithChecks(Object, Object)}.
    # 
    # @param trigger
    # The object that triggered the execution; may be
    # <code>null</code>.
    # @param applicationContext
    # The state of the application at the time the execution was
    # triggered; may be <code>null</code>.
    # @return The result of the execution; may be <code>null</code>.
    # @throws ExecutionException
    # If the handler has problems executing this command.
    # @throws NotHandledException
    # If there is no handler.
    # @deprecated Please use {@link #executeWithChecks(Object, Object)}
    # instead.
    def execute(trigger, application_context)
      return @command.execute(ExecutionEvent.new(@command, get_parameter_map, trigger, application_context))
    end
    
    typesig { [Object, Object] }
    # Executes this command with its parameters. This does extra checking to
    # see if the command is enabled and defined. If it is not both enabled and
    # defined, then the execution listeners will be notified and an exception
    # thrown.
    # 
    # @param trigger
    # The object that triggered the execution; may be
    # <code>null</code>.
    # @param applicationContext
    # The state of the application at the time the execution was
    # triggered; may be <code>null</code>.
    # @return The result of the execution; may be <code>null</code>.
    # @throws ExecutionException
    # If the handler has problems executing this command.
    # @throws NotDefinedException
    # If the command you are trying to execute is not defined.
    # @throws NotEnabledException
    # If the command you are trying to execute is not enabled.
    # @throws NotHandledException
    # If there is no handler.
    # @since 3.2
    def execute_with_checks(trigger, application_context)
      return @command.execute_with_checks(ExecutionEvent.new(@command, get_parameter_map, trigger, application_context))
    end
    
    typesig { [] }
    # Returns the base command. It is possible for more than one parameterized
    # command to have the same identifier.
    # 
    # @return The command; never <code>null</code>, but may be undefined.
    def get_command
      return @command
    end
    
    typesig { [] }
    # Returns the command's base identifier. It is possible for more than one
    # parameterized command to have the same identifier.
    # 
    # @return The command id; never <code>null</code>.
    def get_id
      return @command.get_id
    end
    
    typesig { [] }
    # Returns a human-readable representation of this command with all of its
    # parameterizations.
    # 
    # @return The human-readable representation of this parameterized command;
    # never <code>null</code>.
    # @throws NotDefinedException
    # If the underlying command is not defined.
    def get_name
      if ((@name).nil?)
        name_buffer = StringBuffer.new
        name_buffer.append(@command.get_name)
        if (!(@parameterizations).nil?)
          name_buffer.append(" (") # $NON-NLS-1$
          parameterization_count = @parameterizations.attr_length
          i = 0
          while i < parameterization_count
            parameterization = @parameterizations[i]
            name_buffer.append(parameterization.get_parameter.get_name)
            name_buffer.append(": ") # $NON-NLS-1$
            begin
              name_buffer.append(parameterization.get_value_name)
            rescue ParameterValuesException => e
              # Just let it go for now. If someone complains we can
              # add more info later.
            end
            # If there is another item, append a separator.
            if (i + 1 < parameterization_count)
              name_buffer.append(", ") # $NON-NLS-1$
            end
            i += 1
          end
          name_buffer.append(Character.new(?).ord))
        end
        @name = RJava.cast_to_string(name_buffer.to_s)
      end
      return @name
    end
    
    typesig { [] }
    # Returns the parameter map, as can be used to construct an
    # <code>ExecutionEvent</code>.
    # 
    # @return The map of parameter ids (<code>String</code>) to parameter
    # values (<code>String</code>). This map is never
    # <code>null</code>, but may be empty.
    def get_parameter_map
      if (((@parameterizations).nil?) || ((@parameterizations.attr_length).equal?(0)))
        return Collections::EMPTY_MAP
      end
      parameter_map = HashMap.new
      i = 0
      while i < @parameterizations.attr_length
        parameterization = @parameterizations[i]
        parameter_map.put(parameterization.get_parameter.get_id, parameterization.get_value)
        i += 1
      end
      return parameter_map
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see java.lang.Object#hashCode()
    def hash_code
      if ((@hash_code).equal?(HASH_CODE_NOT_COMPUTED))
        @hash_code = HASH_INITIAL * HASH_FACTOR + Util.hash_code(@command)
        @hash_code = @hash_code * HASH_FACTOR
        if (!(@parameterizations).nil?)
          i = 0
          while i < @parameterizations.attr_length
            @hash_code += Util.hash_code(@parameterizations[i])
            i += 1
          end
        end
        if ((@hash_code).equal?(HASH_CODE_NOT_COMPUTED))
          @hash_code += 1
        end
      end
      return @hash_code
    end
    
    typesig { [] }
    # Returns a {@link String} containing the command id, parameter ids and
    # parameter values for this {@link ParameterizedCommand}. The returned
    # {@link String} can be stored by a client and later used to reconstruct an
    # equivalent {@link ParameterizedCommand} using the
    # {@link CommandManager#deserialize(String)} method.
    # <p>
    # The syntax of the returned {@link String} is as follows:
    # </p>
    # 
    # <blockquote>
    # <code>serialization = <u>commandId</u> [ '(' parameters ')' ]</code><br>
    # <code>parameters = parameter [ ',' parameters ]</code><br>
    # <code>parameter = <u>parameterId</u> [ '=' <u>parameterValue</u> ]</code>
    # </blockquote>
    # 
    # <p>
    # In the syntax above, sections inside square-brackets are optional. The
    # characters in single quotes (<code>(</code>, <code>)</code>,
    # <code>,</code> and <code>=</code>) indicate literal characters.
    # </p>
    # <p>
    # <code><u>commandId</u></code> represents the command id encoded with
    # separator characters escaped. <code><u>parameterId</u></code> and
    # <code><u>parameterValue</u></code> represent the parameter ids and
    # values encoded with separator characters escaped. The separator
    # characters <code>(</code>, <code>)</code>, <code>,</code> and
    # <code>=</code> are escaped by prepending a <code>%</code>. This
    # requires <code>%</code> to be escaped, which is also done by prepending
    # a <code>%</code>.
    # </p>
    # <p>
    # The order of the parameters is not defined (and not important). A missing
    # <code><u>parameterValue</u></code> indicates that the value of the
    # parameter is <code>null</code>.
    # </p>
    # <p>
    # For example, the string shown below represents a serialized parameterized
    # command that can be used to show the Resource perspective:
    # </p>
    # <p>
    # <code>org.eclipse.ui.perspectives.showPerspective(org.eclipse.ui.perspectives.showPerspective.perspectiveId=org.eclipse.ui.resourcePerspective)</code>
    # </p>
    # <p>
    # This example shows the more general form with multiple parameters,
    # <code>null</code> value parameters, and escaped <code>=</code> in the
    # third parameter value.
    # </p>
    # <p>
    # <code>command.id(param1.id=value1,param2.id,param3.id=esc%=val3)</code>
    # </p>
    # 
    # @return A string containing the escaped command id, parameter ids and
    # parameter values; never <code>null</code>.
    # @see CommandManager#deserialize(String)
    # @since 3.2
    def serialize
      escaped_id = escape(get_id)
      if (((@parameterizations).nil?) || ((@parameterizations.attr_length).equal?(0)))
        return escaped_id
      end
      buffer = StringBuffer.new(escaped_id)
      buffer.append(CommandManager::PARAMETER_START_CHAR)
      i = 0
      while i < @parameterizations.attr_length
        if (i > 0)
          # insert separator between parameters
          buffer.append(CommandManager::PARAMETER_SEPARATOR_CHAR)
        end
        parameterization = @parameterizations[i]
        parameter_id = parameterization.get_parameter.get_id
        escaped_parameter_id = escape(parameter_id)
        buffer.append(escaped_parameter_id)
        parameter_value = parameterization.get_value
        if (!(parameter_value).nil?)
          escaped_parameter_value = escape(parameter_value)
          buffer.append(CommandManager::ID_VALUE_CHAR)
          buffer.append(escaped_parameter_value)
        end
        i += 1
      end
      buffer.append(CommandManager::PARAMETER_END_CHAR)
      return buffer.to_s
    end
    
    typesig { [] }
    def to_s
      buffer = StringBuffer.new
      buffer.append("ParameterizedCommand(") # $NON-NLS-1$
      buffer.append(@command)
      buffer.append(Character.new(?,.ord))
      buffer.append(@parameterizations)
      buffer.append(Character.new(?).ord))
      return buffer.to_s
    end
    
    private
    alias_method :initialize__parameterized_command, :initialize
  end
  
end
