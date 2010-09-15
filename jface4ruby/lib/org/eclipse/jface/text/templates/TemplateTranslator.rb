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
  module TemplateTranslatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :LinkedHashMap
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Java::Util::Regex, :Matcher
      include_const ::Java::Util::Regex, :Pattern
    }
  end
  
  # The template translator translates a string into a template buffer. Regions marked as variables
  # are translated into <code>TemplateVariable</code>s.
  # <p>
  # The EBNF grammar of a valid string is as follows:
  # </p>
  # <pre> template := (text | escape)*.
  # text := character - dollar.
  # escape := dollar ('{' variable '}' | dollar).
  # dollar := '$'.
  # variable := identifier | identifier ':' type.
  # type := qualifiedname | qualifiedname '(' arguments ')'.
  # arguments := (argument ',')* argument.
  # argument := qualifiedname | argumenttext.
  # qualifiedname := (identifier '.')* identifier.
  # argumenttext := "'" (character - "'" | "'" "'")* "'".</pre>
  # <p>
  # Clients may only replace the <code>createVariable</code> method of this class.
  # </p>
  # 
  # @since 3.0
  class TemplateTranslator 
    include_class_members TemplateTranslatorImports
    
    class_module.module_eval {
      # Regex pattern for qualifiedname
      # @since 3.4
      const_set_lazy(:QUALIFIED_NAME) { "(?:\\w++\\.)*+\\w++" }
      const_attr_reader  :QUALIFIED_NAME
      
      # $NON-NLS-1$
      # 
      # Regex pattern for argumenttext
      # @since 3.4
      const_set_lazy(:ARGUMENT_TEXT) { "'(?:(?:'')|(?:[^']))*+'" }
      const_attr_reader  :ARGUMENT_TEXT
      
      # $NON-NLS-1$
      # 
      # Regex pattern for argument
      # @since 3.4
      const_set_lazy(:ARGUMENT) { "(?:" + QUALIFIED_NAME + ")|(?:" + ARGUMENT_TEXT + ")" }
      const_attr_reader  :ARGUMENT
      
      # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
      # 
      # Regex pattern for whitespace
      # @since 3.5
      const_set_lazy(:SPACES) { "\\s*+" }
      const_attr_reader  :SPACES
      
      # $NON-NLS-1$
      # 
      # Precompiled regex pattern for qualified names.
      # @since 3.3
      const_set_lazy(:PARAM_PATTERN) { Pattern.compile(ARGUMENT) }
      const_attr_reader  :PARAM_PATTERN
      
      # Precompiled regex pattern for valid dollar escapes (dollar literals and variables) and
      # (invalid) single dollars.
      # @since 3.3
      # 
      # $$|${											//$NON-NLS-1$
      # variable id group (1)								//$NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      # variable type group (2)			//$NON-NLS-1$ //$NON-NLS-2$
      # $NON-NLS-1$
      # (												//$NON-NLS-1$
      # arguments group (3)	//$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$
      # )												//$NON-NLS-1$
      # $NON-NLS-1$
      # $NON-NLS-1$
      const_set_lazy(:ESCAPE_PATTERN) { Pattern.compile("\\$\\$|\\$\\{" + SPACES + "(\\w*+)" + SPACES + "(?:" + ":" + SPACES + "(" + QUALIFIED_NAME + ")" + SPACES + "(?:" + "\\(" + SPACES + "((?:(?:" + ARGUMENT + ")" + SPACES + "," + SPACES + ")*+(?:" + ARGUMENT + "))" + SPACES + "\\)" + ")?" + SPACES + ")?" + "\\}|\\$") }
      const_attr_reader  :ESCAPE_PATTERN
      
      # }|$													//$NON-NLS-1$
      # 
      # @since 3.3
      const_set_lazy(:VariableDescription) { Class.new do
        local_class_in TemplateTranslator
        include_class_members TemplateTranslator
        
        attr_accessor :f_offsets
        alias_method :attr_f_offsets, :f_offsets
        undef_method :f_offsets
        alias_method :attr_f_offsets=, :f_offsets=
        undef_method :f_offsets=
        
        attr_accessor :f_name
        alias_method :attr_f_name, :f_name
        undef_method :f_name
        alias_method :attr_f_name=, :f_name=
        undef_method :f_name=
        
        attr_accessor :f_type
        alias_method :attr_f_type, :f_type
        undef_method :f_type
        alias_method :attr_f_type=, :f_type=
        undef_method :f_type=
        
        typesig { [String, class_self::TemplateVariableType] }
        def initialize(name, type)
          @f_offsets = self.class::ArrayList.new(5)
          @f_name = nil
          @f_type = nil
          @f_name = name
          @f_type = type
        end
        
        typesig { [class_self::TemplateVariableType] }
        def merge_type(type)
          if ((type).nil?)
            return
          end
          if ((@f_type).nil?)
            @f_type = type
          end
          if (!(type == @f_type))
            fail(TextTemplateMessages.get_formatted_string("TemplateTranslator.error.incompatible.type", @f_name))
          end # $NON-NLS-1$
        end
        
        private
        alias_method :initialize__variable_description, :initialize
      end }
    }
    
    # Last translation error.
    attr_accessor :f_error_message
    alias_method :attr_f_error_message, :f_error_message
    undef_method :f_error_message
    alias_method :attr_f_error_message=, :f_error_message=
    undef_method :f_error_message=
    
    # Used to ensure compatibility with subclasses overriding
    # {@link #createVariable(String, String, int[])}.
    # @since 3.3
    attr_accessor :f_current_type
    alias_method :attr_f_current_type, :f_current_type
    undef_method :f_current_type
    alias_method :attr_f_current_type=, :f_current_type=
    undef_method :f_current_type=
    
    typesig { [] }
    # Returns an error message if an error occurred for the last translation, <code>null</code>
    # otherwise.
    # 
    # @return the error message if an error occurred during the most recent translation,
    # <code>null</code> otherwise
    def get_error_message
      return @f_error_message
    end
    
    typesig { [Template] }
    # Translates a template to a <code>TemplateBuffer</code>. <code>null</code> is returned if
    # there was an error. <code>getErrorMessage()</code> retrieves the associated error message.
    # 
    # @param template the template to translate.
    # @return returns the template buffer corresponding to the string
    # @see #getErrorMessage()
    # @throws TemplateException if translation failed
    def translate(template)
      return parse(template.get_pattern)
    end
    
    typesig { [String] }
    # Translates a template string to <code>TemplateBuffer</code>. <code>null</code> is
    # returned if there was an error. <code>getErrorMessage()</code> retrieves the associated
    # error message.
    # 
    # @param string the string to translate.
    # @return returns the template buffer corresponding to the string
    # @see #getErrorMessage()
    # @throws TemplateException if translation failed
    def translate(string)
      return parse(string)
    end
    
    typesig { [String] }
    # Internal parser.
    # 
    # @param string the string to parse
    # @return the parsed <code>TemplateBuffer</code>
    # @throws TemplateException if the string does not conform to the template format
    def parse(string)
      @f_error_message = RJava.cast_to_string(nil)
      buffer = StringBuffer.new(string.length)
      matcher_ = ESCAPE_PATTERN.matcher(string)
      variables = LinkedHashMap.new
      complete = 0
      while (matcher_.find)
        # append any verbatim text
        buffer.append(string.substring(complete, matcher_.start))
        # check the escaped sequence
        if (("$" == matcher_.group))
          # $NON-NLS-1$
          fail(TextTemplateMessages.get_string("TemplateTranslator.error.incomplete.variable")) # $NON-NLS-1$
        else
          if (("$$" == matcher_.group))
            # $NON-NLS-1$
            # escaped $
            buffer.append(Character.new(?$.ord))
          else
            # parse variable
            name = matcher_.group(1)
            type_name = matcher_.group(2)
            params = matcher_.group(3)
            type = create_type(type_name, params)
            update_or_create_variable(variables, name, type, buffer.length)
            buffer.append(name)
          end
        end
        complete = matcher_.end_
      end
      # append remaining verbatim text
      buffer.append(string.substring(complete))
      vars = create_variables(variables)
      return TemplateBuffer.new(buffer.to_s, vars)
    end
    
    typesig { [String, String] }
    def create_type(type_name, param_string)
      if ((type_name).nil?)
        return nil
      end
      if ((param_string).nil?)
        return TemplateVariableType.new(type_name)
      end
      matcher_ = PARAM_PATTERN.matcher(param_string)
      params = ArrayList.new(5)
      while (matcher_.find)
        argument = matcher_.group
        if ((argument.char_at(0)).equal?(Character.new(?\'.ord)))
          # argumentText
          argument = RJava.cast_to_string(argument.substring(1, argument.length - 1).replace_all("''", "'")) # $NON-NLS-1$ //$NON-NLS-2$
        end
        params.add(argument)
      end
      return TemplateVariableType.new(type_name, params.to_array(Array.typed(String).new(params.size) { nil }))
    end
    
    typesig { [String] }
    def fail(message)
      @f_error_message = message
      raise TemplateException.new(message)
    end
    
    typesig { [Map, String, TemplateVariableType, ::Java::Int] }
    # If there is no variable named <code>name</code>, a new variable with the given type, name
    # and offset is created. If one exists, the offset is added to the variable and the type is
    # merged with the existing type.
    # 
    # @param variables the variables by variable name
    # @param name the name of the variable
    # @param type the variable type, <code>null</code> for not defined
    # @param offset the buffer offset of the variable
    # @throws TemplateException if merging the type fails
    # @since 3.3
    def update_or_create_variable(variables, name, type, offset)
      var_desc = variables.get(name)
      if ((var_desc).nil?)
        var_desc = VariableDescription.new_local(self, name, type)
        variables.put(name, var_desc)
      else
        var_desc.merge_type(type)
      end
      var_desc.attr_f_offsets.add(offset)
    end
    
    typesig { [Map] }
    # Creates proper {@link TemplateVariable}s from the variable descriptions.
    # 
    # @param variables the variable descriptions by variable name
    # @return the corresponding variables
    # @since 3.3
    def create_variables(variables)
      result = Array.typed(TemplateVariable).new(variables.size) { nil }
      idx = 0
      it = variables.values.iterator
      while it.has_next
        desc = it.next_
        type = (desc.attr_f_type).nil? ? TemplateVariableType.new(desc.attr_f_name) : desc.attr_f_type
        offsets = Array.typed(::Java::Int).new(desc.attr_f_offsets.size) { 0 }
        i = 0
        int_it = desc.attr_f_offsets.iterator
        while int_it.has_next
          offset = int_it.next_
          offsets[i] = offset.int_value
          i += 1
        end
        @f_current_type = type
        # Call the deprecated version of createVariable. When not overridden, it will delegate
        # to the new version using fCurrentType.
        var = create_variable(type.get_name, desc.attr_f_name, offsets)
        result[idx] = var
        idx += 1
      end
      @f_current_type = nil # avoid dangling reference
      return result
    end
    
    typesig { [String, String, Array.typed(::Java::Int)] }
    # Hook method to create new variables. Subclasses may override to supply their custom variable
    # type.
    # <p>
    # Clients may replace this method.
    # </p>
    # 
    # @param type the type of the new variable.
    # @param name the name of the new variable.
    # @param offsets the offsets where the variable occurs in the template
    # @return a new instance of <code>TemplateVariable</code>
    # @deprecated as of 3.3 use {@link #createVariable(TemplateVariableType, String, int[])} instead
    def create_variable(type, name, offsets)
      return create_variable(@f_current_type, name, offsets)
    end
    
    typesig { [TemplateVariableType, String, Array.typed(::Java::Int)] }
    # Hook method to create new variables. Subclasses may override to supply their custom variable
    # type.
    # <p>
    # Clients may replace this method.
    # </p>
    # 
    # @param type the type of the new variable.
    # @param name the name of the new variable.
    # @param offsets the offsets where the variable occurs in the template
    # @return a new instance of <code>TemplateVariable</code>
    # @since 3.3
    def create_variable(type, name, offsets)
      return TemplateVariable.new(type, name, name, offsets)
    end
    
    typesig { [] }
    def initialize
      @f_error_message = nil
      @f_current_type = nil
    end
    
    private
    alias_method :initialize__template_translator, :initialize
  end
  
end
