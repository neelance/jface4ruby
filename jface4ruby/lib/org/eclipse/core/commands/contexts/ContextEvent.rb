require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands::Contexts
  module ContextEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands::Contexts
      include_const ::Org::Eclipse::Core::Commands::Common, :AbstractNamedHandleEvent
    }
  end
  
  # An instance of this class describes changes to an instance of
  # <code>IContext</code>.
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @since 3.1
  # @see IContextListener#contextChanged(ContextEvent)
  class ContextEvent < ContextEventImports.const_get :AbstractNamedHandleEvent
    include_class_members ContextEventImports
    
    class_module.module_eval {
      # The bit used to represent whether the context has changed its parent.
      const_set_lazy(:CHANGED_PARENT_ID) { LAST_USED_BIT << 1 }
      const_attr_reader  :CHANGED_PARENT_ID
    }
    
    # The context that has changed. This value is never <code>null</code>.
    attr_accessor :context
    alias_method :attr_context, :context
    undef_method :context
    alias_method :attr_context=, :context=
    undef_method :context=
    
    typesig { [Context, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Creates a new instance of this class.
    # 
    # @param context
    # the instance of the interface that changed; must not be
    # <code>null</code>.
    # @param definedChanged
    # <code>true</code>, iff the defined property changed.
    # @param nameChanged
    # <code>true</code>, iff the name property changed.
    # @param descriptionChanged
    # <code>true</code>, iff the description property changed.
    # @param parentIdChanged
    # <code>true</code>, iff the parentId property changed.
    def initialize(context, defined_changed, name_changed, description_changed, parent_id_changed)
      @context = nil
      super(defined_changed, description_changed, name_changed)
      if ((context).nil?)
        raise NullPointerException.new
      end
      @context = context
      if (parent_id_changed)
        self.attr_changed_values |= CHANGED_PARENT_ID
      end
    end
    
    typesig { [] }
    # Returns the instance of the interface that changed.
    # 
    # @return the instance of the interface that changed. Guaranteed not to be
    # <code>null</code>.
    def get_context
      return @context
    end
    
    typesig { [] }
    # Returns whether or not the parentId property changed.
    # 
    # @return <code>true</code>, iff the parentId property changed.
    def is_parent_id_changed
      return (!((self.attr_changed_values & CHANGED_PARENT_ID)).equal?(0))
    end
    
    private
    alias_method :initialize__context_event, :initialize
  end
  
end
