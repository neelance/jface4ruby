require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Templates
  module TemplateVariableImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
    }
  end
  
  # A <code>TemplateVariable</code> represents a set of positions into a
  # <code>TemplateBuffer</code> with identical content each. <code>TemplateVariableResolver</code>s
  # can be used to resolve a template variable to a symbol available from the
  # <code>TemplateContext</code>. A resolved variable may have one or more possible
  # {@link #getValues() values} which may be presented to the user as choices. If there is no user
  # interaction the {@link #getDefaultValue() default value} is chosen as textual representation of
  # the variable.
  # <p>
  # Clients may instantiate and extend this class.
  # </p>
  # 
  # @see TemplateVariableResolver
  # @see TemplateBuffer
  # @since 3.0
  class TemplateVariable 
    include_class_members TemplateVariableImports
    
    # The type name of the variable
    attr_accessor :f_type
    alias_method :attr_f_type, :f_type
    undef_method :f_type
    alias_method :attr_f_type=, :f_type=
    undef_method :f_type=
    
    # The name of the variable.
    attr_accessor :f_name
    alias_method :attr_f_name, :f_name
    undef_method :f_name
    alias_method :attr_f_name=, :f_name=
    undef_method :f_name=
    
    # The initial length in the template pattern.
    attr_accessor :f_initial_length
    alias_method :attr_f_initial_length, :f_initial_length
    undef_method :f_initial_length
    alias_method :attr_f_initial_length=, :f_initial_length=
    undef_method :f_initial_length=
    
    # The offsets of the variable.
    attr_accessor :f_offsets
    alias_method :attr_f_offsets, :f_offsets
    undef_method :f_offsets
    alias_method :attr_f_offsets=, :f_offsets=
    undef_method :f_offsets=
    
    # Flag indicating if the variable has been resolved unambiguously.
    attr_accessor :f_is_unambiguous
    alias_method :attr_f_is_unambiguous, :f_is_unambiguous
    undef_method :f_is_unambiguous
    alias_method :attr_f_is_unambiguous=, :f_is_unambiguous=
    undef_method :f_is_unambiguous=
    
    # Flag indicating if the variable has been resolved by a resolver.
    attr_accessor :f_is_resolved
    alias_method :attr_f_is_resolved, :f_is_resolved
    undef_method :f_is_resolved
    alias_method :attr_f_is_resolved=, :f_is_resolved=
    undef_method :f_is_resolved=
    
    # The proposal strings available for this variable. The first string is
    # the default value.
    attr_accessor :f_values
    alias_method :attr_f_values, :f_values
    undef_method :f_values
    alias_method :attr_f_values=, :f_values=
    undef_method :f_values=
    
    typesig { [String, String, Array.typed(::Java::Int)] }
    # Creates a template variable. The type is used as the name of the
    # variable.
    # 
    # @param type the type of the variable
    # @param defaultValue the default value of the variable
    # @param offsets the array of offsets of the variable
    def initialize(type, default_value, offsets)
      initialize__template_variable(type, Array.typed(String).new([default_value]), offsets)
    end
    
    typesig { [String, String, String, Array.typed(::Java::Int)] }
    # Creates a template variable.
    # 
    # @param type the type of the variable
    # @param name the name of the variable
    # @param defaultValue the default value of the variable
    # @param offsets the array of offsets of the variable
    def initialize(type, name, default_value, offsets)
      initialize__template_variable(type, name, Array.typed(String).new([default_value]), offsets)
    end
    
    typesig { [TemplateVariableType, String, String, Array.typed(::Java::Int)] }
    # Creates a template variable.
    # 
    # @param type the type of the variable
    # @param name the name of the variable
    # @param defaultValue the default value of the variable
    # @param offsets the array of offsets of the variable
    # @since 3.3
    def initialize(type, name, default_value, offsets)
      initialize__template_variable(type, name, Array.typed(String).new([default_value]), offsets)
    end
    
    typesig { [String, Array.typed(String), Array.typed(::Java::Int)] }
    # Creates a template variable with multiple possible values. The type is
    # used as the name of the template.
    # 
    # @param type the type of the template variable
    # @param values the values available at this variable, non-empty
    # @param offsets the array of offsets of the variable
    def initialize(type, values, offsets)
      initialize__template_variable(type, type, values, offsets)
    end
    
    typesig { [String, String, Array.typed(String), Array.typed(::Java::Int)] }
    # Creates a template variable with multiple possible values.
    # 
    # @param type the type of the variable
    # @param name the name of the variable
    # @param values the values available at this variable, non-empty
    # @param offsets the array of offsets of the variable
    def initialize(type, name, values, offsets)
      initialize__template_variable(TemplateVariableType.new(type), name, values, offsets)
    end
    
    typesig { [TemplateVariableType, String, Array.typed(String), Array.typed(::Java::Int)] }
    # Creates a template variable with multiple possible values.
    # 
    # @param type the type of the variable
    # @param name the name of the variable
    # @param values the values available at this variable, non-empty
    # @param offsets the array of offsets of the variable
    # @since 3.3
    def initialize(type, name, values, offsets)
      @f_type = nil
      @f_name = nil
      @f_initial_length = 0
      @f_offsets = nil
      @f_is_unambiguous = false
      @f_is_resolved = false
      @f_values = nil
      Assert.is_not_null(type)
      Assert.is_not_null(name)
      @f_type = type
      @f_name = name
      set_values(values)
      set_offsets(offsets)
      set_unambiguous(false)
      set_resolved(false)
      @f_initial_length = values[0].length
    end
    
    typesig { [] }
    # Returns the type name of the variable.
    # 
    # @return the type name of the variable
    def get_type
      return @f_type.get_name
    end
    
    typesig { [] }
    # Returns the type of the variable.
    # 
    # @return the type of the variable
    # @since 3.3
    def get_variable_type
      return @f_type
    end
    
    typesig { [] }
    # Returns the name of the variable.
    # 
    # @return the name of the variable
    def get_name
      return @f_name
    end
    
    typesig { [] }
    # Returns the default value of the variable. Typically, this is the first of
    # the possible values (see {@link #getValues()}.
    # 
    # @return the default value of the variable
    def get_default_value
      return get_values[0]
    end
    
    typesig { [] }
    # Returns the possible values for this variable. The returned array is owned by this variable
    # and must not be modified. The array is not empty.
    # 
    # @return the possible values for this variable
    def get_values
      return @f_values
    end
    
    typesig { [] }
    # Returns the length of the variable's default value.
    # 
    # @return the length of the variable
    def get_length
      return get_default_value.length
    end
    
    typesig { [] }
    # Returns the initial length of the variable. The initial length is the lenght as it occurred
    # in the template pattern and is used when resolving a template to update the pattern with the
    # resolved values of the variable.
    # 
    # @return the initial length of the variable
    # @since 3.3
    def get_initial_length
      return @f_initial_length
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Sets the offsets of the variable.
    # 
    # @param offsets the new offsets of the variable
    def set_offsets(offsets)
      @f_offsets = TextUtilities.copy(offsets)
    end
    
    typesig { [] }
    # Returns the offsets of the variable. The returned array is
    # owned by this variable and must not be modified.
    # 
    # @return the length of the variable
    def get_offsets
      return @f_offsets
    end
    
    typesig { [String] }
    # Resolves the variable to a single value. This is a shortcut for
    # <code>setValues(new String[] { value })</code>.
    # 
    # @param value the new default value
    def set_value(value)
      set_values(Array.typed(String).new([value]))
    end
    
    typesig { [Array.typed(String)] }
    # Resolves the variable to several possible values for this variable, with the first being the
    # default value.
    # 
    # @param values a non-empty array of values
    def set_values(values)
      Assert.is_true(values.attr_length > 0)
      @f_values = TextUtilities.copy(values)
      set_resolved(true)
    end
    
    typesig { [::Java::Boolean] }
    # Sets the <em>isUnambiguous</em> flag of the variable.
    # 
    # @param unambiguous the new unambiguous state of the variable
    def set_unambiguous(unambiguous)
      @f_is_unambiguous = unambiguous
      if (unambiguous)
        set_resolved(true)
      end
    end
    
    typesig { [] }
    # Returns <code>true</code> if the variable is unambiguously resolved, <code>false</code> otherwise.
    # 
    # @return <code>true</code> if the variable is unambiguously resolved, <code>false</code> otherwise
    def is_unambiguous
      return @f_is_unambiguous
    end
    
    typesig { [::Java::Boolean] }
    # Sets the <em>resolved</em> flag of the variable.
    # 
    # @param resolved the new <em>resolved</em> state
    # @since 3.3
    def set_resolved(resolved)
      @f_is_resolved = resolved
    end
    
    typesig { [] }
    # Returns <code>true</code> if the variable has been resolved, <code>false</code>
    # otherwise.
    # 
    # @return <code>true</code> if the variable has been resolved, <code>false</code> otherwise
    # @since 3.3
    def is_resolved
      return @f_is_resolved
    end
    
    private
    alias_method :initialize__template_variable, :initialize
  end
  
end
