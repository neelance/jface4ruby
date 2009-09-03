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
  module TemplateImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A template consisting of a name and a pattern.
  # <p>
  # Clients may instantiate this class. May become final in the future.
  # </p>
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class Template 
    include_class_members TemplateImports
    
    # The name of this template
    # final
    attr_accessor :f_name
    alias_method :attr_f_name, :f_name
    undef_method :f_name
    alias_method :attr_f_name=, :f_name=
    undef_method :f_name=
    
    # A description of this template
    # final
    attr_accessor :f_description
    alias_method :attr_f_description, :f_description
    undef_method :f_description
    alias_method :attr_f_description=, :f_description=
    undef_method :f_description=
    
    # The name of the context type of this template
    # final
    attr_accessor :f_context_type_id
    alias_method :attr_f_context_type_id, :f_context_type_id
    undef_method :f_context_type_id
    alias_method :attr_f_context_type_id=, :f_context_type_id=
    undef_method :f_context_type_id=
    
    # The template pattern.
    # final
    attr_accessor :f_pattern
    alias_method :attr_f_pattern, :f_pattern
    undef_method :f_pattern
    alias_method :attr_f_pattern=, :f_pattern=
    undef_method :f_pattern=
    
    # The auto insertable property.
    # @since 3.1
    attr_accessor :f_is_auto_insertable
    alias_method :attr_f_is_auto_insertable, :f_is_auto_insertable
    undef_method :f_is_auto_insertable
    alias_method :attr_f_is_auto_insertable=, :f_is_auto_insertable=
    undef_method :f_is_auto_insertable=
    
    typesig { [] }
    # Creates an empty template.
    def initialize
      initialize__template("", "", "", "", true) # $NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$
    end
    
    typesig { [Template] }
    # Creates a copy of a template.
    # 
    # @param template the template to copy
    def initialize(template)
      initialize__template(template.get_name, template.get_description, template.get_context_type_id, template.get_pattern, template.is_auto_insertable)
    end
    
    typesig { [String, String, String, String] }
    # Creates a template.
    # 
    # @param name the name of the template
    # @param description the description of the template
    # @param contextTypeId the id of the context type in which the template can be applied
    # @param pattern the template pattern
    # @deprecated as of 3.1 replaced by {@link #Template(String, String, String, String, boolean)}
    def initialize(name, description, context_type_id, pattern)
      initialize__template(name, description, context_type_id, pattern, true) # templates are auto insertable per default
    end
    
    typesig { [String, String, String, String, ::Java::Boolean] }
    # Creates a template.
    # 
    # @param name the name of the template
    # @param description the description of the template
    # @param contextTypeId the id of the context type in which the template can be applied
    # @param pattern the template pattern
    # @param isAutoInsertable the auto insertable property of the template
    # @since 3.1
    def initialize(name, description, context_type_id, pattern, is_auto_insertable_)
      @f_name = nil
      @f_description = nil
      @f_context_type_id = nil
      @f_pattern = nil
      @f_is_auto_insertable = false
      Assert.is_not_null(description)
      @f_description = description
      @f_name = name
      Assert.is_not_null(context_type_id)
      @f_context_type_id = context_type_id
      @f_pattern = pattern
      @f_is_auto_insertable = is_auto_insertable_
    end
    
    typesig { [] }
    # @see Object#hashCode()
    def hash_code
      return @f_name.hash_code ^ @f_pattern.hash_code ^ @f_context_type_id.hash_code
    end
    
    typesig { [String] }
    # Sets the description of the template.
    # 
    # @param description the new description
    # @deprecated Templates should never be modified
    def set_description(description)
      Assert.is_not_null(description)
      @f_description = description
    end
    
    typesig { [] }
    # Returns the description of the template.
    # 
    # @return the description of the template
    def get_description
      return @f_description
    end
    
    typesig { [String] }
    # Sets the name of the context type in which the template can be applied.
    # 
    # @param contextTypeId the new context type name
    # @deprecated Templates should never be modified
    def set_context_type_id(context_type_id)
      Assert.is_not_null(context_type_id)
      @f_context_type_id = context_type_id
    end
    
    typesig { [] }
    # Returns the id of the context type in which the template can be applied.
    # 
    # @return the id of the context type in which the template can be applied
    def get_context_type_id
      return @f_context_type_id
    end
    
    typesig { [String] }
    # Sets the name of the template.
    # 
    # @param name the name of the template
    # @deprecated Templates should never be modified
    def set_name(name)
      @f_name = name
    end
    
    typesig { [] }
    # Returns the name of the template.
    # 
    # @return the name of the template
    def get_name
      return @f_name
    end
    
    typesig { [String] }
    # Sets the pattern of the template.
    # 
    # @param pattern the new pattern of the template
    # @deprecated Templates should never be modified
    def set_pattern(pattern)
      @f_pattern = pattern
    end
    
    typesig { [] }
    # Returns the template pattern.
    # 
    # @return the template pattern
    def get_pattern
      return @f_pattern
    end
    
    typesig { [String, String] }
    # Returns <code>true</code> if template is enabled and matches the context,
    # <code>false</code> otherwise.
    # 
    # @param prefix the prefix (e.g. inside a document) to match
    # @param contextTypeId the context type id to match
    # @return <code>true</code> if template is enabled and matches the context,
    # <code>false</code> otherwise
    def matches(prefix, context_type_id)
      return (@f_context_type_id == context_type_id)
    end
    
    typesig { [Object] }
    # @see java.lang.Object#equals(java.lang.Object)
    def ==(o)
      if (!(o.is_a?(Template)))
        return false
      end
      t = o
      if ((t).equal?(self))
        return true
      end
      return (t.attr_f_name == @f_name) && (t.attr_f_pattern == @f_pattern) && (t.attr_f_context_type_id == @f_context_type_id) && (t.attr_f_description == @f_description) && (t.attr_f_is_auto_insertable).equal?(@f_is_auto_insertable)
    end
    
    typesig { [] }
    # Returns the auto insertable property of the template.
    # 
    # @return the auto insertable property of the template
    # @since 3.1
    def is_auto_insertable
      return @f_is_auto_insertable
    end
    
    private
    alias_method :initialize__template, :initialize
  end
  
end
