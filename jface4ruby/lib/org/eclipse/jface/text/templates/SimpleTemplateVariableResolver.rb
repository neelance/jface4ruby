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
  module SimpleTemplateVariableResolverImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
    }
  end
  
  # A simple template variable resolver, which always evaluates to a defined string.
  # <p>
  # Clients may instantiate and extend this class.
  # </p>
  # 
  # @since 3.0
  class SimpleTemplateVariableResolver < SimpleTemplateVariableResolverImports.const_get :TemplateVariableResolver
    include_class_members SimpleTemplateVariableResolverImports
    
    # The string to which this variable evaluates.
    attr_accessor :f_evaluation_string
    alias_method :attr_f_evaluation_string, :f_evaluation_string
    undef_method :f_evaluation_string
    alias_method :attr_f_evaluation_string=, :f_evaluation_string=
    undef_method :f_evaluation_string=
    
    typesig { [String, String] }
    # @see TemplateVariableResolver#TemplateVariableResolver(String, String)
    def initialize(type, description)
      @f_evaluation_string = nil
      super(type, description)
    end
    
    typesig { [String] }
    # Sets the string to which this variable evaluates.
    # 
    # @param evaluationString the evaluation string, may be <code>null</code>.
    def set_evaluation_string(evaluation_string)
      @f_evaluation_string = evaluation_string
    end
    
    typesig { [TemplateContext] }
    # @see TemplateVariableResolver#evaluate(TemplateContext)
    def resolve(context)
      return @f_evaluation_string
    end
    
    typesig { [TemplateContext] }
    # Returns always <code>true</code>, since simple variables are normally
    # unambiguous.
    # 
    # @param context {@inheritDoc}
    # @return <code>true</code>
    def is_unambiguous(context)
      return true
    end
    
    private
    alias_method :initialize__simple_template_variable_resolver, :initialize
  end
  
end
