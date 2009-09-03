require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Templates
  module TemplateVariableResolverImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A <code>TemplateVariableResolver</code> resolves <code>TemplateVariables</code>
  # of a certain type inside a <code>TemplateContext</code>.
  # <p>
  # Clients may instantiate and extend this class.
  # </p>
  # 
  # @see TemplateVariable
  # @since 3.0
  class TemplateVariableResolver 
    include_class_members TemplateVariableResolverImports
    
    # Type of this resolver.
    attr_accessor :f_type
    alias_method :attr_f_type, :f_type
    undef_method :f_type
    alias_method :attr_f_type=, :f_type=
    undef_method :f_type=
    
    # Description of the type resolved by this resolver.
    attr_accessor :f_description
    alias_method :attr_f_description, :f_description
    undef_method :f_description
    alias_method :attr_f_description=, :f_description=
    undef_method :f_description=
    
    typesig { [String, String] }
    # Creates an instance of <code>TemplateVariableResolver</code>.
    # 
    # @param type the name of the type
    # @param description the description for the type
    def initialize(type, description)
      @f_type = nil
      @f_description = nil
      set_type(type)
      set_description(description)
    end
    
    typesig { [] }
    # Creates an empty instance.
    # <p>
    # This is a framework-only constructor that exists only so that resolvers
    # can be contributed via an extension point and that should not be called
    # in client code except for subclass constructors; use
    # {@link #TemplateVariableResolver(String, String)} instead.
    # </p>
    def initialize
      @f_type = nil
      @f_description = nil
    end
    
    typesig { [] }
    # Returns the type of this resolver.
    # 
    # @return the type
    def get_type
      return @f_type
    end
    
    typesig { [] }
    # Returns the description for the resolver.
    # 
    # @return the description for the resolver
    def get_description
      return @f_description
    end
    
    typesig { [TemplateContext] }
    # Returns an instance of the type resolved by the receiver available in <code>context</code>.
    # To resolve means to provide a binding to a concrete text object (a
    # <code>String</code>) in the given context.
    # <p>
    # The default implementation looks up the type in the context.</p>
    # 
    # @param context the context in which to resolve the type
    # @return the name of the text object of this type, or <code>null</code> if it cannot be determined
    def resolve(context)
      return context.get_variable(get_type)
    end
    
    typesig { [TemplateContext] }
    # Returns all possible bindings available in <code>context</code>. The default
    # implementation simply returns an array which contains the result of
    # {@link #resolve(TemplateContext)}, or an empty array if that call returns
    # <code>null</code>.
    # 
    # @param context the context in which to resolve the type
    # @return an array of possible bindings of this type in <code>context</code>
    def resolve_all(context)
      binding = resolve(context)
      if ((binding).nil?)
        return Array.typed(String).new(0) { nil }
      end
      return Array.typed(String).new([binding])
    end
    
    typesig { [TemplateVariable, TemplateContext] }
    # Resolves <code>variable</code> in <code>context</code>. To resolve
    # means to find a valid binding of the receiver's type in the given <code>TemplateContext</code>.
    # If the variable can be successfully resolved, its value is set using
    # {@link TemplateVariable#setValues(String[])}.
    # 
    # @param context the context in which variable is resolved
    # @param variable the variable to resolve
    def resolve(variable, context)
      bindings = resolve_all(context)
      if (!(bindings.attr_length).equal?(0))
        variable.set_values(bindings)
      end
      if (bindings.attr_length > 1)
        variable.set_unambiguous(false)
      else
        variable.set_unambiguous(is_unambiguous(context))
      end
      variable.set_resolved(true)
    end
    
    typesig { [TemplateContext] }
    # Returns whether this resolver is able to resolve unambiguously. When
    # resolving a <code>TemplateVariable</code>, its <code>isUmambiguous</code>
    # state is set to the one of this resolver. By default, this method
    # returns <code>false</code>. Clients can overwrite this method to give
    # a hint about whether there should be e.g. prompting for input values for
    # ambiguous variables.
    # 
    # @param context the context in which the resolved check should be
    # evaluated
    # @return <code>true</code> if the receiver is unambiguously resolvable
    # in <code>context</code>, <code>false</code> otherwise
    def is_unambiguous(context)
      return false
    end
    
    typesig { [String] }
    # Sets the description.
    # <p>
    # This is a framework-only method that exists only so that resolvers
    # can be contributed via an extension point and that should not be called
    # in client code; use {@link #TemplateVariableResolver(String, String)} instead.
    # </p>
    # 
    # @param description the description of this resolver
    def set_description(description)
      Assert.is_not_null(description)
      Assert.is_true((@f_description).nil?) # may only be called once when initialized
      @f_description = description
    end
    
    typesig { [String] }
    # Sets the type name.
    # <p>
    # This is a framework-only method that exists only so that resolvers
    # can be contributed via an extension point and that should not be called
    # in client code; use {@link #TemplateVariableResolver(String, String)} instead.
    # </p>
    # 
    # @param type the type name of this resolver
    def set_type(type)
      Assert.is_not_null(type)
      Assert.is_true((@f_type).nil?) # may only be called once when initialized
      @f_type = type
    end
    
    private
    alias_method :initialize__template_variable_resolver, :initialize
  end
  
end
