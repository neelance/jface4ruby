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
  module TemplateContextTypeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Text::Edits, :MalformedTreeException
      include_const ::Org::Eclipse::Text::Edits, :MultiTextEdit
      include_const ::Org::Eclipse::Text::Edits, :RangeMarker
      include_const ::Org::Eclipse::Text::Edits, :ReplaceEdit
      include_const ::Org::Eclipse::Text::Edits, :TextEdit
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :Document
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # A context type defines a context within which templates are resolved. It
  # stores a number of <code>TemplateVariableResolver</code>s. A
  # <code>TemplateBuffer</code> can be resolved in a
  # <code>TemplateContext</code> using the
  # {@link #resolve(TemplateBuffer, TemplateContext)} method.
  # <p>
  # Clients may extend this class.
  # </p>
  # 
  # @since 3.0
  class TemplateContextType 
    include_class_members TemplateContextTypeImports
    
    # The id of the context type.
    # final
    attr_accessor :f_id
    alias_method :attr_f_id, :f_id
    undef_method :f_id
    alias_method :attr_f_id=, :f_id=
    undef_method :f_id=
    
    # Variable resolvers used by this content type.
    attr_accessor :f_resolvers
    alias_method :attr_f_resolvers, :f_resolvers
    undef_method :f_resolvers
    alias_method :attr_f_resolvers=, :f_resolvers=
    undef_method :f_resolvers=
    
    # The name of the context type.
    attr_accessor :f_name
    alias_method :attr_f_name, :f_name
    undef_method :f_name
    alias_method :attr_f_name=, :f_name=
    undef_method :f_name=
    
    typesig { [String] }
    # Creates a context type with an identifier. The identifier must be unique,
    # a qualified name is suggested. The id is also used as name.
    # 
    # @param id the unique identifier of the context type
    def initialize(id)
      initialize__template_context_type(id, id)
    end
    
    typesig { [String, String] }
    # Creates a context type with an identifier. The identifier must be unique, a qualified name is suggested.
    # 
    # @param id the unique identifier of the context type
    # @param name the name of the context type
    def initialize(id, name)
      @f_id = nil
      @f_resolvers = HashMap.new
      @f_name = nil
      Assert.is_not_null(id)
      Assert.is_not_null(name)
      @f_id = id
      @f_name = name
    end
    
    typesig { [] }
    # Returns the id of the context type.
    # 
    # @return the id of the receiver
    def get_id
      return @f_id
    end
    
    typesig { [] }
    # Returns the name of the context type.
    # 
    # @return the name of the context type
    def get_name
      return @f_name
    end
    
    typesig { [] }
    # Creates a context type with a <code>null</code> identifier.
    # <p>
    # This is a framework-only constructor that exists only so that context
    # types can be contributed via an extension point and that should not be
    # called in client code except for subclass constructors; use
    # {@link #TemplateContextType(String)} instead.
    # </p>
    def initialize
      @f_id = nil
      @f_resolvers = HashMap.new
      @f_name = nil
    end
    
    typesig { [String] }
    # Sets the id of this context.
    # <p>
    # This is a framework-only method that exists solely so that context types
    # can be contributed via an extension point and that should not be called
    # in client code; use {@link #TemplateContextType(String)} instead.
    # </p>
    # 
    # @param id the identifier of this context
    # @throws RuntimeException an unspecified exception if the id has already
    # been set on this context type
    def set_id(id)
      Assert.is_not_null(id)
      Assert.is_true((@f_id).nil?) # may only be called once when the context is instantiated
      @f_id = id
    end
    
    typesig { [String] }
    # Sets the name of the context type.
    # 
    # <p>
    # This is a framework-only method that exists solely so that context types
    # can be contributed via an extension point and that should not be called
    # in client code; use {@link #TemplateContextType(String, String)} instead.
    # </p>
    # 
    # @param name the name of the context type
    def set_name(name)
      Assert.is_true((@f_name).nil?) # only initialized by extension code
      @f_name = name
    end
    
    typesig { [TemplateVariableResolver] }
    # Adds a variable resolver to the context type. If there already is a resolver
    # for the same type, the previous one gets replaced by <code>resolver</code>.
    # 
    # @param resolver the resolver to be added under its name
    def add_resolver(resolver)
      Assert.is_not_null(resolver)
      @f_resolvers.put(resolver.get_type, resolver)
    end
    
    typesig { [TemplateVariableResolver] }
    # Removes a template variable from the context type.
    # 
    # @param resolver the variable to be removed
    def remove_resolver(resolver)
      Assert.is_not_null(resolver)
      @f_resolvers.remove(resolver.get_type)
    end
    
    typesig { [] }
    # Removes all template variables from the context type.
    def remove_all_resolvers
      @f_resolvers.clear
    end
    
    typesig { [] }
    # Returns an iterator for the variables known to the context type.
    # 
    # @return an iterator over the variables in this context type
    def resolvers
      return Collections.unmodifiable_map(@f_resolvers).values.iterator
    end
    
    typesig { [String] }
    # Returns the resolver for the given type.
    # 
    # @param type the type for which a resolver is needed
    # @return a resolver for the given type, or <code>null</code> if none is registered
    def get_resolver(type)
      return @f_resolvers.get(type)
    end
    
    typesig { [String] }
    # Validates a pattern, a <code>TemplateException</code> is thrown if
    # validation fails.
    # 
    # @param pattern the template pattern to validate
    # @throws TemplateException if the pattern is invalid
    def validate(pattern)
      translator = TemplateTranslator.new
      buffer = translator.translate(pattern)
      validate_variables(buffer.get_variables)
    end
    
    typesig { [Array.typed(TemplateVariable)] }
    # Validates the variables in this context type. If a variable is not valid,
    # e.g. if its type is not known in this context type, a
    # <code>TemplateException</code> is thrown.
    # <p>
    # The default implementation does nothing.
    # </p>
    # 
    # @param variables the variables to validate
    # @throws TemplateException if one of the variables is not valid in this
    # context type
    def validate_variables(variables)
    end
    
    typesig { [TemplateBuffer, TemplateContext] }
    # Resolves the variables in <code>buffer</code> within <code>context</code>
    # and edits the template buffer to reflect the resolved variables.
    # 
    # @param buffer the template buffer
    # @param context the template context
    # @throws MalformedTreeException if the positions in the buffer overlap
    # @throws BadLocationException if the buffer cannot be successfully modified
    def resolve(buffer, context)
      Assert.is_not_null(context)
      variables = buffer.get_variables
      positions = variables_to_positions(variables)
      edits = ArrayList.new(5)
      # iterate over all variables and try to resolve them
      i = 0
      while !(i).equal?(variables.attr_length)
        variable = variables[i]
        if (!variable.is_resolved)
          resolve(variable, context)
        end
        value = variable.get_default_value
        offsets = variable.get_offsets
        # update buffer to reflect new value
        k = 0
        while !(k).equal?(offsets.attr_length)
          edits.add(ReplaceEdit.new(offsets[k], variable.get_initial_length, value))
          k += 1
        end
        i += 1
      end
      document = Document.new(buffer.get_string)
      edit = MultiTextEdit.new(0, document.get_length)
      edit.add_children(positions.to_array(Array.typed(TextEdit).new(positions.size) { nil }))
      edit.add_children(edits.to_array(Array.typed(TextEdit).new(edits.size) { nil }))
      edit.apply(document, TextEdit::UPDATE_REGIONS)
      positions_to_variables(positions, variables)
      buffer.set_content(document.get, variables)
    end
    
    typesig { [TemplateVariable, TemplateContext] }
    # Resolves a single variable in a context. Resolving is delegated to the registered resolver.
    # 
    # @param variable the variable to resolve
    # @param context the context in which to resolve the variable
    # @since 3.3
    def resolve(variable, context)
      type = variable.get_type
      resolver = @f_resolvers.get(type)
      if ((resolver).nil?)
        resolver = TemplateVariableResolver.new(type, "")
      end # $NON-NLS-1$
      resolver.resolve(variable, context)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(TemplateVariable)] }
      def variables_to_positions(variables)
        positions = ArrayList.new(5)
        i = 0
        while !(i).equal?(variables.attr_length)
          offsets = variables[i].get_offsets
          j = 0
          while !(j).equal?(offsets.attr_length)
            positions.add(RangeMarker.new(offsets[j], 0))
            j += 1
          end
          i += 1
        end
        return positions
      end
      
      typesig { [JavaList, Array.typed(TemplateVariable)] }
      def positions_to_variables(positions, variables)
        iterator_ = positions.iterator
        i = 0
        while !(i).equal?(variables.attr_length)
          variable = variables[i]
          offsets = Array.typed(::Java::Int).new(variable.get_offsets.attr_length) { 0 }
          j = 0
          while !(j).equal?(offsets.attr_length)
            offsets[j] = (iterator_.next_).get_offset
            j += 1
          end
          variable.set_offsets(offsets)
          i += 1
        end
      end
    }
    
    private
    alias_method :initialize__template_context_type, :initialize
  end
  
end
