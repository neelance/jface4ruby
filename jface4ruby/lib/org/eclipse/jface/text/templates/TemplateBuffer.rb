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
  module TemplateBufferImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A template buffer is a container for a string and variables.
  # <p>
  # Clients may instantiate this class.
  # </p>
  # 
  # @since 3.0
  class TemplateBuffer 
    include_class_members TemplateBufferImports
    
    # The string of the template buffer
    attr_accessor :f_string
    alias_method :attr_f_string, :f_string
    undef_method :f_string
    alias_method :attr_f_string=, :f_string=
    undef_method :f_string=
    
    # The variable positions of the template buffer
    attr_accessor :f_variables
    alias_method :attr_f_variables, :f_variables
    undef_method :f_variables
    alias_method :attr_f_variables=, :f_variables=
    undef_method :f_variables=
    
    typesig { [String, Array.typed(TemplateVariable)] }
    # Creates a template buffer.
    # 
    # @param string the string
    # @param variables the variable positions
    def initialize(string, variables)
      @f_string = nil
      @f_variables = nil
      set_content(string, variables)
    end
    
    typesig { [String, Array.typed(TemplateVariable)] }
    # Sets the content of the template buffer.
    # 
    # @param string the string
    # @param variables the variable positions
    def set_content(string, variables)
      Assert.is_not_null(string)
      Assert.is_not_null(variables)
      # XXX: assert non-overlapping variable properties
      @f_string = string
      @f_variables = copy(variables)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(TemplateVariable)] }
      # Returns a copy of the given array.
      # 
      # @param array the array to be copied
      # @return a copy of the given array or <code>null</code> when <code>array</code> is <code>null</code>
      # @since 3.1
      def copy(array)
        if (!(array).nil?)
          copy_ = Array.typed(TemplateVariable).new(array.attr_length) { nil }
          System.arraycopy(array, 0, copy_, 0, array.attr_length)
          return copy_
        end
        return nil
      end
    }
    
    typesig { [] }
    # Returns the string of the template buffer.
    # 
    # @return the string representation of the template buffer
    def get_string
      return @f_string
    end
    
    typesig { [] }
    # Returns the variable positions of the template buffer. The returned array is
    # owned by this variable and must not be modified.
    # 
    # @return the variable positions of the template buffer
    def get_variables
      return @f_variables
    end
    
    private
    alias_method :initialize__template_buffer, :initialize
  end
  
end
