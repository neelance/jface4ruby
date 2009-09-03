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
  module ContextTypeRegistryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :LinkedHashMap
      include_const ::Java::Util, :Map
    }
  end
  
  # A registry for context types. Editor implementors will usually instantiate a
  # registry and configure the context types available in their editor.
  # <p>
  # In order to pick up templates contributed using the <code>org.eclipse.ui.editors.templates</code>
  # extension point, use a <code>ContributionContextTypeRegistry</code>.
  # </p>
  # 
  # @since 3.0
  class ContextTypeRegistry 
    include_class_members ContextTypeRegistryImports
    
    # all known context types
    attr_accessor :f_context_types
    alias_method :attr_f_context_types, :f_context_types
    undef_method :f_context_types
    alias_method :attr_f_context_types=, :f_context_types=
    undef_method :f_context_types=
    
    typesig { [TemplateContextType] }
    # Adds a context type to the registry. If there already is a context type
    # with the same ID registered, it is replaced.
    # 
    # @param contextType the context type to add
    def add_context_type(context_type)
      @f_context_types.put(context_type.get_id, context_type)
    end
    
    typesig { [String] }
    # Returns the context type if the id is valid, <code>null</code> otherwise.
    # 
    # @param id the id of the context type to retrieve
    # @return the context type if <code>name</code> is valid, <code>null</code> otherwise
    def get_context_type(id)
      return @f_context_types.get(id)
    end
    
    typesig { [] }
    # Returns an iterator over all registered context types.
    # 
    # @return an iterator over all registered context types
    def context_types
      return @f_context_types.values.iterator
    end
    
    typesig { [] }
    def initialize
      @f_context_types = LinkedHashMap.new
    end
    
    private
    alias_method :initialize__context_type_registry, :initialize
  end
  
end
