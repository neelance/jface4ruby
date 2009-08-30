require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module ParameterTypeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Org::Eclipse::Core::Commands::Common, :HandleObject
      include_const ::Org::Eclipse::Core::Commands::Common, :NotDefinedException
      include_const ::Org::Eclipse::Core::Internal::Commands::Util, :Util
    }
  end
  
  # <p>
  # Provides information about the type of a command parameter. Clients can use a
  # parameter type to check if an object matches the type of the parameter with
  # {@link #isCompatible(Object)} and can get an
  # {@link AbstractParameterValueConverter} to convert between objects matching
  # the parameter type and strings that encode the object's identity.
  # </p>
  # <p>
  # A command parameter is not required to declare a type. To determine if a
  # given parameter has a type, check if an {@link IParameter} implements
  # {@link ITypedParameter} and if so, use
  # {@link ITypedParameter#getParameterType()} like this:
  # </p>
  # 
  # <pre>
  # IParameter parameter = // ... get IParameter from Command
  # if (parameter instanceof ITypedParameter) {
  # ParameterType type = ((ITypedParameter)parameter).getParameterType();
  # if (type != null) {
  # // this parameter has a ParameterType
  # }
  # }
  # </pre>
  # 
  # @see IParameter
  # @see ITypedParameter#getParameterType()
  # @since 3.2
  class ParameterType < ParameterTypeImports.const_get :HandleObject
    include_class_members ParameterTypeImports
    overload_protected {
      include JavaComparable
    }
    
    class_module.module_eval {
      typesig { [Object, String] }
      # TODO: this was copied from
      # org.eclipse.core.internal.expressions.Expressions is there a better place
      # to reference this?
      # 
      # @param element
      # The element to test; may be <code>null</code>.
      # @param type
      # The type against which we are testing;may be <code>null</code>.
      # @return <code>true</code> if the <code>element</code> is an instance
      # of <code>type</code>; <code>false</code> otherwise.
      def is_instance_of(element, type)
        # null isn't an instanceof of anything.
        if ((element).nil?)
          return false
        end
        return is_subtype(element.get_class, type)
      end
      
      typesig { [Class, String] }
      # TODO: this was copied from
      # org.eclipse.core.internal.expressions.Expressions is there a better place
      # to reference this?
      # 
      # @param clazz
      # The class to match; may be <code>null</code>.
      # @param type
      # The type against which we are testing;may be <code>null</code>.
      # @return <code>true</code> if the <code>element</code> is an instance
      # of <code>type</code>; <code>false</code> otherwise.
      def is_subtype(clazz, type)
        if ((clazz.get_name == type))
          return true
        end
        super_class = clazz.get_superclass
        if (!(super_class).nil? && is_subtype(super_class, type))
          return true
        end
        interfaces = clazz.get_interfaces
        i = 0
        while i < interfaces.attr_length
          if (is_subtype(interfaces[i], type))
            return true
          end
          i += 1
        end
        return false
      end
    }
    
    # An {@link AbstractParameterValueConverter} for converting parameter
    # values between objects and strings. This may be <code>null</code>.
    attr_accessor :parameter_type_converter
    alias_method :attr_parameter_type_converter, :parameter_type_converter
    undef_method :parameter_type_converter
    alias_method :attr_parameter_type_converter=, :parameter_type_converter=
    undef_method :parameter_type_converter=
    
    # A string specifying the object type of this parameter type. This will be
    # <code>null</code> when the parameter type is undefined but never null
    # when it is defined.
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    typesig { [String] }
    # Constructs a new instance based on the given identifier. When a parameter
    # type is first constructed, it is undefined. Parameter types should only
    # be constructed by the {@link CommandManager} to ensure that the
    # identifier remains unique.
    # 
    # @param id
    # The identifier for this type. This value must not be
    # <code>null</code>, and must be unique amongst all parameter
    # types.
    def initialize(id)
      @parameter_type_converter = nil
      @type = nil
      super(id)
      @type = nil
    end
    
    typesig { [IParameterTypeListener] }
    # Adds a listener to this parameter type that will be notified when its
    # state changes.
    # 
    # @param listener
    # The listener to be added; must not be <code>null</code>.
    def add_listener(listener)
      add_listener_object(listener)
    end
    
    typesig { [Object] }
    # Compares this parameter type with another object by comparing each of the
    # non-transient attributes.
    # 
    # @param object
    # The object with which to compare; must be an instance of
    # {@link ParameterType}.
    # @return A negative integer, zero or a positive integer, if the object is
    # greater than, equal to or less than this parameter type.
    def compare_to(object)
      casted_object = object
      compare_to = Util.compare(self.attr_defined, casted_object.attr_defined)
      if ((compare_to).equal?(0))
        compare_to = Util.compare(self.attr_id, casted_object.attr_id)
      end
      return compare_to
    end
    
    typesig { [String, AbstractParameterValueConverter] }
    # <p>
    # Defines this parameter type, setting the defined property to
    # <code>true</code>.
    # </p>
    # <p>
    # Notification is sent to all listeners that something has changed.
    # </p>
    # 
    # @param type
    # a string identifying the Java object type for this parameter
    # type; <code>null</code> is interpreted as
    # <code>"java.lang.Object"</code>
    # @param parameterTypeConverter
    # an {@link AbstractParameterValueConverter} to perform
    # string/object conversions for parameter values; may be
    # <code>null</code>
    def define(type, parameter_type_converter)
      defined_changed = !self.attr_defined
      self.attr_defined = true
      @type = ((type).nil?) ? Object.get_name : type
      @parameter_type_converter = parameter_type_converter
      fire_parameter_type_changed(ParameterTypeEvent.new(self, defined_changed))
    end
    
    typesig { [ParameterTypeEvent] }
    # Notifies all listeners that this parameter type has changed. This sends
    # the given event to all of the listeners, if any.
    # 
    # @param event
    # The event to send to the listeners; must not be
    # <code>null</code>.
    def fire_parameter_type_changed(event)
      if ((event).nil?)
        raise NullPointerException.new("Cannot send a null event to listeners.") # $NON-NLS-1$
      end
      if (!is_listener_attached)
        return
      end
      listeners = get_listeners
      i = 0
      while i < listeners.attr_length
        listener = listeners[i]
        listener.parameter_type_changed(event)
        i += 1
      end
    end
    
    typesig { [] }
    # Returns the value converter associated with this parameter, if any.
    # 
    # @return The parameter value converter, or <code>null</code> if there is
    # no value converter for this parameter.
    # @throws NotDefinedException
    # if the parameter type is not currently defined
    def get_value_converter
      if (!is_defined)
        raise NotDefinedException.new("Cannot use getValueConverter() with an undefined ParameterType") # $NON-NLS-1$
      end
      return @parameter_type_converter
    end
    
    typesig { [Object] }
    # Returns whether the provided value is compatible with this parameter
    # type. An object is compatible with a parameter type if the object is an
    # instance of the class defined as the parameter's type class.
    # 
    # @param value
    # an object to check for compatibility with this parameter type;
    # may be <code>null</code>.
    # @return <code>true</code> if the value is compatible with this type,
    # <code>false</code> otherwise
    # @throws NotDefinedException
    # if the parameter type is not currently defined
    def is_compatible(value)
      if (!is_defined)
        raise NotDefinedException.new("Cannot use isCompatible() with an undefined ParameterType") # $NON-NLS-1$
      end
      return is_instance_of(value, @type)
    end
    
    typesig { [IParameterTypeListener] }
    # Unregisters listener for changes to properties of this parameter type.
    # 
    # @param listener
    # the instance to unregister. Must not be <code>null</code>.
    # If an attempt is made to unregister an instance which is not
    # already registered with this instance, no operation is
    # performed.
    def remove_listener(listener)
      remove_listener_object(listener)
    end
    
    typesig { [] }
    # The string representation of this parameter type. For debugging purposes
    # only. This string should not be shown to an end user.
    # 
    # @return The string representation; never <code>null</code>.
    def to_s
      if ((self.attr_string).nil?)
        string_buffer = StringBuffer.new
        string_buffer.append("ParameterType(") # $NON-NLS-1$
        string_buffer.append(self.attr_id)
        string_buffer.append(Character.new(?,.ord))
        string_buffer.append(self.attr_defined)
        string_buffer.append(Character.new(?).ord))
        self.attr_string = string_buffer.to_s
      end
      return self.attr_string
    end
    
    typesig { [] }
    # Makes this parameter type become undefined. Notification is sent to all
    # listeners.
    def undefine
      self.attr_string = nil
      defined_changed = self.attr_defined
      self.attr_defined = false
      @type = RJava.cast_to_string(nil)
      @parameter_type_converter = nil
      fire_parameter_type_changed(ParameterTypeEvent.new(self, defined_changed))
    end
    
    private
    alias_method :initialize__parameter_type, :initialize
  end
  
end
