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
  module HandleObjectImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Common
      include_const ::Org::Eclipse::Core::Internal::Commands::Util, :Util
    }
  end
  
  # <p>
  # An object that can exist in one of two states: defined and undefined. This is
  # used by APIs that want to give a handle to an object, even though the object
  # does not fully exist yet. This way, users can attach listeners to objects
  # before they come into existence. It also protects the API from users that do
  # not release references when they should.
  # </p>
  # <p>
  # To enforce good coding practice, all handle objects must implement
  # <code>equals</code> and <code>toString</code>. Please use
  # <code>string</code> to cache the result for <code>toString</code> once
  # calculated.
  # </p>
  # <p>
  # All handle objects are referred to using a single identifier. This identifier
  # is a instance of <code>String</code>. It is important that this identifier
  # remain unique within whatever context that handle object is being used. For
  # example, there should only ever be one instance of <code>Command</code>
  # with a given identifier.
  # </p>
  # 
  # @since 3.1
  class HandleObject < HandleObjectImports.const_get :EventManager
    include_class_members HandleObjectImports
    overload_protected {
      include IIdentifiable
    }
    
    class_module.module_eval {
      # The constant integer hash code value meaning the hash code has not yet
      # been computed.
      const_set_lazy(:HASH_CODE_NOT_COMPUTED) { -1 }
      const_attr_reader  :HASH_CODE_NOT_COMPUTED
      
      # A factor for computing the hash code for all schemes.
      const_set_lazy(:HASH_FACTOR) { 89 }
      const_attr_reader  :HASH_FACTOR
      
      # The seed for the hash code for all schemes.
      const_set_lazy(:HASH_INITIAL) { HandleObject.get_name.hash_code }
      const_attr_reader  :HASH_INITIAL
    }
    
    # Whether this object is defined. A defined object is one that has been
    # fully initialized. By default, all objects start as undefined.
    attr_accessor :defined
    alias_method :attr_defined, :defined
    undef_method :defined
    alias_method :attr_defined=, :defined=
    undef_method :defined=
    
    # The hash code for this object. This value is computed lazily, and marked
    # as invalid when one of the values on which it is based changes.
    attr_accessor :hash_code
    alias_method :attr_hash_code, :hash_code
    undef_method :hash_code
    alias_method :attr_hash_code=, :hash_code=
    undef_method :hash_code=
    
    # The identifier for this object. This identifier should be unique across
    # all objects of the same type and should never change. This value will
    # never be <code>null</code>.
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    # The string representation of this object. This string is for debugging
    # purposes only, and is not meant to be displayed to the user. This value
    # is computed lazily, and is cleared if one of its dependent values
    # changes.
    attr_accessor :string
    alias_method :attr_string, :string
    undef_method :string
    alias_method :attr_string=, :string=
    undef_method :string=
    
    typesig { [String] }
    # Constructs a new instance of <code>HandleObject</code>.
    # 
    # @param id
    # The id of this handle; must not be <code>null</code>.
    def initialize(id)
      @defined = false
      @hash_code = 0
      @id = nil
      @string = nil
      super()
      @defined = false
      @hash_code = HASH_CODE_NOT_COMPUTED
      @string = nil
      if ((id).nil?)
        raise NullPointerException.new("Cannot create a handle with a null id") # $NON-NLS-1$
      end
      @id = id
    end
    
    typesig { [Object] }
    # Tests whether this object is equal to another object. A handle object is
    # only equal to another handle object with the same id and the same class.
    # 
    # @param object
    # The object with which to compare; may be <code>null</code>.
    # @return <code>true</code> if the objects are equal; <code>false</code>
    # otherwise.
    def ==(object)
      # Check if they're the same.
      if ((object).equal?(self))
        return true
      end
      # Check if they're the same type.
      if (!(object.is_a?(HandleObject)))
        return false
      end
      # Check each property in turn.
      handle = object
      return (Util == @id) && ((self.get_class).equal?(handle.get_class))
    end
    
    typesig { [] }
    def get_id
      return @id
    end
    
    typesig { [] }
    # Computes the hash code for this object based on the id.
    # 
    # @return The hash code for this object.
    def hash_code
      if ((@hash_code).equal?(HASH_CODE_NOT_COMPUTED))
        @hash_code = HASH_INITIAL * HASH_FACTOR + Util.hash_code(@id)
        if ((@hash_code).equal?(HASH_CODE_NOT_COMPUTED))
          @hash_code += 1
        end
      end
      return @hash_code
    end
    
    typesig { [] }
    # Whether this instance is defined. A defined instance is one that has been
    # fully initialized. This allows objects to effectively disappear even
    # though other objects may still have references to them.
    # 
    # @return <code>true</code> if this object is defined; <code>false</code>
    # otherwise.
    def is_defined
      return @defined
    end
    
    typesig { [] }
    # The string representation of this object -- for debugging purposes only.
    # This string should not be shown to an end user.
    # 
    # @return The string representation; never <code>null</code>.
    def to_s
      raise NotImplementedError
    end
    
    typesig { [] }
    # Makes this object becomes undefined. This method should make any defined
    # properties <code>null</code>. It should also send notification to any
    # listeners that these properties have changed.
    def undefine
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__handle_object, :initialize
  end
  
end
