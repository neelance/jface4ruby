require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Common
  module NamedHandleObjectImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Common
    }
  end
  
  # A handle object that carries with it a name and a description. This type of
  # handle object is quite common across the commands code base. For example,
  # <code>Command</code>, <code>Context</code> and <code>Scheme</code>.
  # 
  # @since 3.1
  class NamedHandleObject < NamedHandleObjectImports.const_get :HandleObject
    include_class_members NamedHandleObjectImports
    
    # The description for this handle. This value may be <code>null</code> if
    # the handle is undefined or has no description.
    attr_accessor :description
    alias_method :attr_description, :description
    undef_method :description
    alias_method :attr_description=, :description=
    undef_method :description=
    
    # The name of this handle. This valud should not be <code>null</code>
    # unless the handle is undefined.
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [String] }
    # Constructs a new instance of <code>NamedHandleObject</code>.
    # 
    # @param id
    # The identifier for this handle; must not be <code>null</code>.
    def initialize(id)
      @description = nil
      @name = nil
      super(id)
      @description = nil
      @name = nil
    end
    
    typesig { [] }
    # Returns the description for this handle.
    # 
    # @return The description; may be <code>null</code> if there is no
    # description.
    # @throws NotDefinedException
    # If the handle is not currently defined.
    def get_description
      if (!is_defined)
        # $NON-NLS-1$
        raise NotDefinedException.new("Cannot get a description from an undefined object. " + RJava.cast_to_string(self.attr_id))
      end
      return @description
    end
    
    typesig { [] }
    # Returns the name for this handle.
    # 
    # @return The name for this handle; never <code>null</code>.
    # @throws NotDefinedException
    # If the handle is not currently defined.
    def get_name
      if (!is_defined)
        # $NON-NLS-1$
        raise NotDefinedException.new("Cannot get the name from an undefined object. " + RJava.cast_to_string(self.attr_id))
      end
      return @name
    end
    
    private
    alias_method :initialize__named_handle_object, :initialize
  end
  
end
