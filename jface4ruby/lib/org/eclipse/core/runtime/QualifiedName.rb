require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module QualifiedNameImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # Qualified names are two-part names: qualifier and local name.
  # The qualifier must be in URI form (see RFC2396).
  # Note however that the qualifier may be <code>null</code> if
  # the default name space is being used.  The empty string is not
  # a valid local name.
  # <p>
  # This class can be used without OSGi running.
  # </p><p>
  # This class is not intended to be subclassed by clients.
  # </p>
  class QualifiedName 
    include_class_members QualifiedNameImports
    
    # Qualifier part (potentially <code>null</code>).
    # package
    attr_accessor :qualifier
    alias_method :attr_qualifier, :qualifier
    undef_method :qualifier
    alias_method :attr_qualifier=, :qualifier=
    undef_method :qualifier=
    
    # Local name part.
    # package
    attr_accessor :local_name
    alias_method :attr_local_name, :local_name
    undef_method :local_name
    alias_method :attr_local_name=, :local_name=
    undef_method :local_name=
    
    typesig { [String, String] }
    # Creates and returns a new qualified name with the given qualifier
    # and local name.  The local name must not be the empty string.
    # The qualifier may be <code>null</code>.
    # <p>
    # Clients may instantiate.
    # </p>
    # @param qualifier the qualifier string, or <code>null</code>
    # @param localName the local name string
    def initialize(qualifier, local_name)
      @qualifier = nil
      @local_name = nil
      Assert.is_legal(!(local_name).nil? && !(local_name.length).equal?(0))
      @qualifier = qualifier
      @local_name = local_name
    end
    
    typesig { [Object] }
    # Returns whether this qualified name is equivalent to the given object.
    # <p>
    # Qualified names are equal if and only if they have the same
    # qualified parts and local parts.
    # Qualified names are not equal to objects other than qualified names.
    # </p>
    # 
    # @param obj the object to compare to
    # @return <code>true</code> if these are equivalent qualified
    # names, and <code>false</code> otherwise
    def ==(obj)
      if ((obj).equal?(self))
        return true
      end
      if (!(obj.is_a?(QualifiedName)))
        return false
      end
      q_name = obj
      # There may or may not be a qualifier
      if ((@qualifier).nil? && !(q_name.get_qualifier).nil?)
        return false
      end
      if (!(@qualifier).nil? && !(@qualifier == q_name.get_qualifier))
        return false
      end
      return (@local_name == q_name.get_local_name)
    end
    
    typesig { [] }
    # Returns the local part of this name.
    # 
    # @return the local name string
    def get_local_name
      return @local_name
    end
    
    typesig { [] }
    # Returns the qualifier part for this qualified name, or <code>null</code>
    # if none.
    # 
    # @return the qualifier string, or <code>null</code>
    def get_qualifier
      return @qualifier
    end
    
    typesig { [] }
    # (Intentionally omitted from javadoc)
    # Implements the method <code>Object.hashCode</code>.
    # 
    # Returns the hash code for this qualified name.
    def hash_code
      return ((@qualifier).nil? ? 0 : @qualifier.hash_code) + @local_name.hash_code
    end
    
    typesig { [] }
    # Converts this qualified name into a string, suitable for
    # debug purposes only.
    def to_s
      return ((get_qualifier).nil? ? "" : get_qualifier + Character.new(?:.ord)) + get_local_name # $NON-NLS-1$
    end
    
    private
    alias_method :initialize__qualified_name, :initialize
  end
  
end
