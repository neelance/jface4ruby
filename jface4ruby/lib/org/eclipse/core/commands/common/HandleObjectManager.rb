require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Common
  module HandleObjectManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Common
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
    }
  end
  
  # <p>
  # A manager of {@link HandleObject} instances. This has some common behaviour
  # which is shared between all such managers.
  # </p>
  # <p>
  # Clients may extend.
  # </p>
  # 
  # @since 3.2
  class HandleObjectManager < HandleObjectManagerImports.const_get :EventManager
    include_class_members HandleObjectManagerImports
    
    # The set of handle objects that are defined. This value may be empty, but
    # it is never <code>null</code>.
    attr_accessor :defined_handle_objects
    alias_method :attr_defined_handle_objects, :defined_handle_objects
    undef_method :defined_handle_objects
    alias_method :attr_defined_handle_objects=, :defined_handle_objects=
    undef_method :defined_handle_objects=
    
    # The map of identifiers (<code>String</code>) to handle objects (
    # <code>HandleObject</code>). This collection may be empty, but it is
    # never <code>null</code>.
    attr_accessor :handle_objects_by_id
    alias_method :attr_handle_objects_by_id, :handle_objects_by_id
    undef_method :handle_objects_by_id
    alias_method :attr_handle_objects_by_id=, :handle_objects_by_id=
    undef_method :handle_objects_by_id=
    
    typesig { [String] }
    # Verifies that the identifier is valid. Exceptions will be thrown if the
    # identifier is invalid in some way.
    # 
    # @param id
    # The identifier to validate; may be anything.
    def check_id(id)
      if ((id).nil?)
        raise NullPointerException.new("A handle object may not have a null identifier") # $NON-NLS-1$
      end
      if (id.length < 1)
        raise IllegalArgumentException.new("The handle object must not have a zero-length identifier") # $NON-NLS-1$
      end
    end
    
    typesig { [] }
    # Returns the set of identifiers for those handle objects that are defined.
    # 
    # @return The set of defined handle object identifiers; this value may be
    # empty, but it is never <code>null</code>.
    def get_defined_handle_object_ids
      defined_handle_object_ids = HashSet.new(@defined_handle_objects.size)
      handle_object_itr = @defined_handle_objects.iterator
      while (handle_object_itr.has_next)
        handle_object = handle_object_itr.next_
        id = handle_object.get_id
        defined_handle_object_ids.add(id)
      end
      return defined_handle_object_ids
    end
    
    typesig { [] }
    def initialize
      @defined_handle_objects = nil
      @handle_objects_by_id = nil
      super()
      @defined_handle_objects = HashSet.new
      @handle_objects_by_id = HashMap.new
    end
    
    private
    alias_method :initialize__handle_object_manager, :initialize
  end
  
end
