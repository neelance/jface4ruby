require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings
  module SchemeEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings
      include_const ::Org::Eclipse::Core::Commands::Common, :AbstractNamedHandleEvent
    }
  end
  
  # An instance of this class describes changes to an instance of
  # <code>IScheme</code>.
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @since 3.1
  # @see ISchemeListener#schemeChanged(SchemeEvent)
  class SchemeEvent < SchemeEventImports.const_get :AbstractNamedHandleEvent
    include_class_members SchemeEventImports
    
    class_module.module_eval {
      # The bit used to represent whether the scheme has changed its parent.
      const_set_lazy(:CHANGED_PARENT_ID) { LAST_USED_BIT << 1 }
      const_attr_reader  :CHANGED_PARENT_ID
    }
    
    # The scheme that has changed; this value is never <code>null</code>.
    attr_accessor :scheme
    alias_method :attr_scheme, :scheme
    undef_method :scheme
    alias_method :attr_scheme=, :scheme=
    undef_method :scheme=
    
    typesig { [Scheme, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Creates a new instance of this class.
    # 
    # @param scheme
    # the instance of the interface that changed; must not be
    # <code>null</code>.
    # @param definedChanged
    # true, iff the defined property changed.
    # @param nameChanged
    # true, iff the name property changed.
    # @param descriptionChanged
    # <code>true</code> if the description property changed;
    # <code>false</code> otherwise.
    # @param parentIdChanged
    # true, iff the parentId property changed.
    def initialize(scheme, defined_changed, name_changed, description_changed, parent_id_changed)
      @scheme = nil
      super(defined_changed, description_changed, name_changed)
      if ((scheme).nil?)
        raise NullPointerException.new
      end
      @scheme = scheme
      if (parent_id_changed)
        self.attr_changed_values |= CHANGED_PARENT_ID
      end
    end
    
    typesig { [] }
    # Returns the instance of the scheme that changed.
    # 
    # @return the instance of the scheme that changed. Guaranteed not to be
    # <code>null</code>.
    def get_scheme
      return @scheme
    end
    
    typesig { [] }
    # Returns whether or not the parentId property changed.
    # 
    # @return true, iff the parentId property changed.
    def is_parent_id_changed
      return (!((self.attr_changed_values & CHANGED_PARENT_ID)).equal?(0))
    end
    
    private
    alias_method :initialize__scheme_event, :initialize
  end
  
end
