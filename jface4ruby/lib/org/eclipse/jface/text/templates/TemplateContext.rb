require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Templates
  module TemplateContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
    }
  end
  
  # Provides the context for a <code>Template</code> being resolved. Keeps track
  # of resolved variables.
  # <p>
  # Clients may extend this class.
  # </p>
  # 
  # @since 3.0
  class TemplateContext 
    include_class_members TemplateContextImports
    
    # The context type of this context
    attr_accessor :f_context_type
    alias_method :attr_f_context_type, :f_context_type
    undef_method :f_context_type
    alias_method :attr_f_context_type=, :f_context_type=
    undef_method :f_context_type=
    
    # Additional variables.
    attr_accessor :f_variables
    alias_method :attr_f_variables, :f_variables
    undef_method :f_variables
    alias_method :attr_f_variables=, :f_variables=
    undef_method :f_variables=
    
    # A flag to indicate that the context should not be modified.
    attr_accessor :f_read_only
    alias_method :attr_f_read_only, :f_read_only
    undef_method :f_read_only
    alias_method :attr_f_read_only=, :f_read_only=
    undef_method :f_read_only=
    
    typesig { [TemplateContextType] }
    # Creates a template context of a particular context type.
    # 
    # @param contextType the context type of this context
    def initialize(context_type)
      @f_context_type = nil
      @f_variables = HashMap.new
      @f_read_only = false
      @f_context_type = context_type
      @f_read_only = true
    end
    
    typesig { [] }
    # Returns the context type of this context.
    # 
    # @return the context type of this context
    def get_context_type
      return @f_context_type
    end
    
    typesig { [::Java::Boolean] }
    # Sets or clears the read-only flag.
    # 
    # @param readOnly the new read-only state
    def set_read_only(read_only)
      @f_read_only = read_only
    end
    
    typesig { [] }
    # Returns <code>true</code> if the receiver is read-only, <code>false</code> otherwise.
    # 
    # @return <code>true</code> if the receiver is read-only, <code>false</code> otherwise
    def is_read_only
      return @f_read_only
    end
    
    typesig { [String, String] }
    # Defines the value of a variable.
    # 
    # @param name the name of the variable
    # @param value the value of the variable, <code>null</code> to un-define a variable
    def set_variable(name, value)
      @f_variables.put(name, value)
    end
    
    typesig { [String] }
    # Returns the value of a defined variable.
    # 
    # @param name the name of the variable
    # @return returns the value of the variable, <code>null</code> if the variable was not defined
    def get_variable(name)
      return @f_variables.get(name)
    end
    
    typesig { [Template] }
    # Evaluates the template in this context and returns a template buffer.
    # <p>
    # Evaluation means translating the template into a <code>TemplateBuffer</code>,
    # resolving the defined variables in this context and possibly formatting
    # the resolved buffer.</p>
    # 
    # @param template the template to evaluate
    # @return returns the buffer with the evaluated template or <code>null</code> if the buffer could not be created
    # @throws BadLocationException if evaluation fails due to concurrently changed documents etc.
    # @throws TemplateException if the template specification is not valid
    def evaluate(template)
      raise NotImplementedError
    end
    
    typesig { [Template] }
    # Tests if the specified template can be evaluated in this context.
    # <p>Examples are templates defined for a different context (e.g. a javadoc
    # template cannot be evaluated in Java context).</p>
    # 
    # @param template the <code>Template</code> to check
    # @return <code>true</code> if <code>template</code> can be evaluated
    # in this context, <code>false</code> otherwise
    def can_evaluate(template)
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__template_context, :initialize
  end
  
end
