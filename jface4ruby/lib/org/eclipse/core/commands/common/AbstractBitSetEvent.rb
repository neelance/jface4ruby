require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Common
  module AbstractBitSetEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Common
    }
  end
  
  # <p>
  # An event that carries with it two or more boolean values.  This provides a
  # single integer value which can then be used as a bit set.
  # </p>
  # 
  # @since 3.1
  class AbstractBitSetEvent 
    include_class_members AbstractBitSetEventImports
    
    # A collection of bits representing whether certain values have changed. A
    # bit is set (i.e., <code>1</code>) if the corresponding property has
    # changed. It can be assumed that this value will be correctly initialized
    # by the superconstructor.
    attr_accessor :changed_values
    alias_method :attr_changed_values, :changed_values
    undef_method :changed_values
    alias_method :attr_changed_values=, :changed_values=
    undef_method :changed_values=
    
    typesig { [] }
    def initialize
      @changed_values = 0
    end
    
    private
    alias_method :initialize__abstract_bit_set_event, :initialize
  end
  
end
