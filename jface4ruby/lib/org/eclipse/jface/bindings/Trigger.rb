require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings
  module TriggerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings
    }
  end
  
  # <p>
  # The abstract class for any object that can be used as a trigger for a binding.
  # This ensures that trigger conform to certain minimum requirements. Namely, triggers
  # need to be hashable.
  # </p>
  # 
  # @since 3.1
  class Trigger 
    include_class_members TriggerImports
    include JavaComparable
    
    typesig { [Object] }
    # Tests whether this object is equal to another object. A handle object is
    # only equal to another trigger with the same properties.
    # 
    # @param object
    # The object with which to compare; may be <code>null</code>.
    # @return <code>true</code> if the objects are equal; <code>false</code>
    # otherwise.
    def ==(object)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Computes the hash code for this object.
    # 
    # @return The hash code for this object.
    def hash_code
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__trigger, :initialize
  end
  
end
