require "rjava"

# Copyright (c) 2005, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Common
  module NamedHandleObjectComparatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Common
      include_const ::Java::Util, :Comparator
      include_const ::Org::Eclipse::Core::Internal::Commands::Util, :Util
    }
  end
  
  # Comparator for instances of <code>NamedHandleObject</code> for display to
  # an end user. The comparison is based on the name of the instances.
  # 
  # @since 3.2
  class NamedHandleObjectComparator 
    include_class_members NamedHandleObjectComparatorImports
    include Comparator
    
    typesig { [Object, Object] }
    # Compares to instances of NamedHandleObject based on their names. This is
    # useful is they are display to an end user.
    # 
    # @param left
    # The first obect to compare; may be <code>null</code>.
    # @param right
    # The second object to compare; may be <code>null</code>.
    # @return <code>-1</code> if <code>left</code> is <code>null</code>
    # and <code>right</code> is not <code>null</code>;
    # <code>0</code> if they are both <code>null</code>;
    # <code>1</code> if <code>left</code> is not <code>null</code>
    # and <code>right</code> is <code>null</code>. Otherwise, the
    # result of <code>left.compareTo(right)</code>.
    def compare(left, right)
      a = left
      b = right
      a_name = nil
      begin
        a_name = RJava.cast_to_string(a.get_name)
      rescue NotDefinedException => e
        # Leave aName as null.
      end
      b_name = nil
      begin
        b_name = RJava.cast_to_string(b.get_name)
      rescue NotDefinedException => e
        # Leave bName as null.
      end
      return Util.compare(a_name, b_name)
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__named_handle_object_comparator, :initialize
  end
  
end
