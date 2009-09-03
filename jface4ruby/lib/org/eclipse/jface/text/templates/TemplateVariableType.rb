require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Templates
  module TemplateVariableTypeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Value object that represents the type of a template variable. A type is defined by its name and
  # may have parameters.
  # 
  # @since 3.3
  # @noinstantiate This class is not intended to be instantiated by clients.
  class TemplateVariableType 
    include_class_members TemplateVariableTypeImports
    
    # The name of the type.
    attr_accessor :f_name
    alias_method :attr_f_name, :f_name
    undef_method :f_name
    alias_method :attr_f_name=, :f_name=
    undef_method :f_name=
    
    # The parameter list.
    attr_accessor :f_params
    alias_method :attr_f_params, :f_params
    undef_method :f_params
    alias_method :attr_f_params=, :f_params=
    undef_method :f_params=
    
    typesig { [String] }
    def initialize(name)
      initialize__template_variable_type(name, Array.typed(String).new(0) { nil })
    end
    
    typesig { [String, Array.typed(String)] }
    def initialize(name, params)
      @f_name = nil
      @f_params = nil
      Assert.is_legal(!(name).nil?)
      Assert.is_legal(!(params).nil?)
      @f_name = name
      @f_params = Collections.unmodifiable_list(ArrayList.new(Arrays.as_list(params)))
    end
    
    typesig { [] }
    # Returns the type name of this variable type.
    # 
    # @return the type name of this variable type
    def get_name
      return @f_name
    end
    
    typesig { [] }
    # Returns the unmodifiable and possibly empty list of parameters (element type: {@link String})
    # 
    # @return the list of parameters
    def get_params
      return @f_params
    end
    
    typesig { [Object] }
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(obj)
      if (obj.is_a?(TemplateVariableType))
        other = obj
        return (other.attr_f_name == @f_name) && (other.attr_f_params == @f_params)
      end
      return false
    end
    
    typesig { [] }
    # @see java.lang.Object#hashCode()
    def hash_code
      return @f_name.hash_code + @f_params.hash_code
    end
    
    typesig { [] }
    # @see java.lang.Object#toString()
    # @since 3.3
    def to_s
      return @f_name + RJava.cast_to_string(@f_params.to_s)
    end
    
    private
    alias_method :initialize__template_variable_type, :initialize
  end
  
end
