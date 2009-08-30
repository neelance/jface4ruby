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
  module AbstractHandleObjectEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Common
    }
  end
  
  # <p>
  # An event fired from a <code>NamedHandleObject</code>. This provides
  # notification of changes to the defined state, the name and the description.
  # </p>
  # 
  # @since 3.2
  class AbstractHandleObjectEvent < AbstractHandleObjectEventImports.const_get :AbstractBitSetEvent
    include_class_members AbstractHandleObjectEventImports
    
    class_module.module_eval {
      # The bit used to represent whether the category has changed its defined
      # state.
      const_set_lazy(:CHANGED_DEFINED) { 1 }
      const_attr_reader  :CHANGED_DEFINED
      
      # The last used bit so that subclasses can add more properties.
      const_set_lazy(:LAST_BIT_USED_ABSTRACT_HANDLE) { CHANGED_DEFINED }
      const_attr_reader  :LAST_BIT_USED_ABSTRACT_HANDLE
    }
    
    typesig { [::Java::Boolean] }
    # Constructs a new instance of <code>AbstractHandleObjectEvent</code>.
    # 
    # @param definedChanged
    # <code>true</code>, iff the defined property changed.
    def initialize(defined_changed)
      super()
      if (defined_changed)
        self.attr_changed_values |= CHANGED_DEFINED
      end
    end
    
    typesig { [] }
    # Returns whether or not the defined property changed.
    # 
    # @return <code>true</code>, iff the defined property changed.
    def is_defined_changed
      return (!((self.attr_changed_values & CHANGED_DEFINED)).equal?(0))
    end
    
    private
    alias_method :initialize__abstract_handle_object_event, :initialize
  end
  
end
