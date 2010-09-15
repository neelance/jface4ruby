require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module ParameterizationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Internal::Commands::Util, :Util
    }
  end
  
  # <p>
  # A parameter with a specific value. This is usually a part of a
  # <code>ParameterizedCommand</code>, which is used to refer to a command
  # with a collection of parameterizations.
  # </p>
  # 
  # @since 3.1
  class Parameterization 
    include_class_members ParameterizationImports
    
    class_module.module_eval {
      # The constant integer hash code value meaning the hash code has not yet
      # been computed.
      const_set_lazy(:HASH_CODE_NOT_COMPUTED) { -1 }
      const_attr_reader  :HASH_CODE_NOT_COMPUTED
      
      # A factor for computing the hash code for all parameterized commands.
      const_set_lazy(:HASH_FACTOR) { 89 }
      const_attr_reader  :HASH_FACTOR
      
      # The seed for the hash code for all parameterized commands.
      const_set_lazy(:HASH_INITIAL) { Parameterization.get_name.hash_code }
      const_attr_reader  :HASH_INITIAL
    }
    
    # The hash code for this object. This value is computed lazily, and marked
    # as invalid when one of the values on which it is based changes.
    attr_accessor :hash_code
    alias_method :attr_hash_code, :hash_code
    undef_method :hash_code
    alias_method :attr_hash_code=, :hash_code=
    undef_method :hash_code=
    
    # The parameter that is being parameterized. This value is never
    # <code>null</code>.
    attr_accessor :parameter
    alias_method :attr_parameter, :parameter
    undef_method :parameter
    alias_method :attr_parameter=, :parameter=
    undef_method :parameter=
    
    # The value that defines the parameterization. This value may be
    # <code>null</code>.
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    typesig { [IParameter, String] }
    # Constructs a new instance of <code>Parameterization</code>.
    # 
    # @param parameter
    # The parameter that is being parameterized; must not be
    # <code>null</code>.
    # @param value
    # The value for the parameter; may be <code>null</code>.
    def initialize(parameter, value)
      @hash_code = HASH_CODE_NOT_COMPUTED
      @parameter = nil
      @value = nil
      if ((parameter).nil?)
        raise NullPointerException.new("You cannot parameterize a null parameter") # $NON-NLS-1$
      end
      @parameter = parameter
      @value = value
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(object)
      if ((self).equal?(object))
        return true
      end
      if (!(object.is_a?(Parameterization)))
        return false
      end
      parameterization = object
      if (!(Util.==(@parameter.get_id, parameterization.attr_parameter.get_id)))
        return false
      end
      return Util.==(@value, parameterization.attr_value)
    end
    
    typesig { [] }
    # Returns the parameter that is being parameterized.
    # 
    # @return The parameter; never <code>null</code>.
    def get_parameter
      return @parameter
    end
    
    typesig { [] }
    # Returns the value for the parameter in this parameterization.
    # 
    # @return The value; may be <code>null</code>.
    def get_value
      return @value
    end
    
    typesig { [] }
    # Returns the human-readable name for the current value, if any. If the
    # name cannot be found, then it simply returns the value. It also ensures
    # that any <code>null</code> values are converted into an empty string.
    # 
    # @return The human-readable name of the value; never <code>null</code>.
    # @throws ParameterValuesException
    # If the parameter needed to be initialized, but couldn't be.
    def get_value_name
      parameter_values = @parameter.get_values.get_parameter_values
      parameter_value_itr = parameter_values.entry_set.iterator
      return_value = nil
      while (parameter_value_itr.has_next)
        entry = parameter_value_itr.next_
        current_value = entry.get_value
        if (Util.==(@value, current_value))
          return_value = RJava.cast_to_string(entry.get_key)
          break
        end
      end
      if ((return_value).nil?)
        return Util::ZERO_LENGTH_STRING
      end
      return return_value
    end
    
    typesig { [] }
    # (non-Javadoc)
    # @see java.lang.Object#hashCode()
    def hash_code
      if ((@hash_code).equal?(HASH_CODE_NOT_COMPUTED))
        @hash_code = HASH_INITIAL * HASH_FACTOR + Util.hash_code(@parameter)
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(@value)
        if ((@hash_code).equal?(HASH_CODE_NOT_COMPUTED))
          @hash_code += 1
        end
      end
      return @hash_code
    end
    
    private
    alias_method :initialize__parameterization, :initialize
  end
  
end
