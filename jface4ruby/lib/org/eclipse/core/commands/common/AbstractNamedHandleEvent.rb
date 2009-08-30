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
  module AbstractNamedHandleEventImports #:nodoc:
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
  # @since 3.1
  class AbstractNamedHandleEvent < AbstractNamedHandleEventImports.const_get :AbstractHandleObjectEvent
    include_class_members AbstractNamedHandleEventImports
    
    class_module.module_eval {
      # The bit used to represent whether the category has changed its
      # description.
      const_set_lazy(:CHANGED_DESCRIPTION) { 1 << LAST_BIT_USED_ABSTRACT_HANDLE }
      const_attr_reader  :CHANGED_DESCRIPTION
      
      # The bit used to represent whether the category has changed its name.
      const_set_lazy(:CHANGED_NAME) { 1 << LAST_BIT_USED_ABSTRACT_HANDLE }
      const_attr_reader  :CHANGED_NAME
      
      # The last used bit so that subclasses can add more properties.
      const_set_lazy(:LAST_USED_BIT) { CHANGED_NAME }
      const_attr_reader  :LAST_USED_BIT
    }
    
    typesig { [::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Constructs a new instance of <code>AbstractHandleObjectEvent</code>.
    # 
    # @param definedChanged
    # <code>true</code>, iff the defined property changed.
    # @param descriptionChanged
    # <code>true</code>, iff the description property changed.
    # @param nameChanged
    # <code>true</code>, iff the name property changed.
    def initialize(defined_changed, description_changed, name_changed)
      super(defined_changed)
      if (description_changed)
        self.attr_changed_values |= CHANGED_DESCRIPTION
      end
      if (name_changed)
        self.attr_changed_values |= CHANGED_NAME
      end
    end
    
    typesig { [] }
    # Returns whether or not the description property changed.
    # 
    # @return <code>true</code>, iff the description property changed.
    def is_description_changed
      return (!((self.attr_changed_values & CHANGED_DESCRIPTION)).equal?(0))
    end
    
    typesig { [] }
    # Returns whether or not the name property changed.
    # 
    # @return <code>true</code>, iff the name property changed.
    def is_name_changed
      return (!((self.attr_changed_values & CHANGED_NAME)).equal?(0))
    end
    
    private
    alias_method :initialize__abstract_named_handle_event, :initialize
  end
  
end
