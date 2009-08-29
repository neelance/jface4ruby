require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys
  module KeyLookupFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys
    }
  end
  
  # <p>
  # A factory class for <code>ILookup</code> instances. This factory can be
  # used to retrieve instances of look-ups defined by this package. It also
  # allows you to define your own look-up for use in the classes.
  # </p>
  # 
  # @since 3.1
  class KeyLookupFactory 
    include_class_members KeyLookupFactoryImports
    
    class_module.module_eval {
      # The SWT key look-up defined by this package.
      const_set_lazy(:SWT_KEY_LOOKUP) { SWTKeyLookup.new }
      const_attr_reader  :SWT_KEY_LOOKUP
      
      # The instance that should be used by <code>KeyStroke</code> in
      # converting string representations to instances.
      
      def default_lookup
        defined?(@@default_lookup) ? @@default_lookup : @@default_lookup= SWT_KEY_LOOKUP
      end
      alias_method :attr_default_lookup, :default_lookup
      
      def default_lookup=(value)
        @@default_lookup = value
      end
      alias_method :attr_default_lookup=, :default_lookup=
      
      typesig { [] }
      # Provides an instance of <code>SWTKeyLookup</code>.
      # 
      # @return The SWT look-up table for key stroke format information; never
      # <code>null</code>.
      def get_swtkey_lookup
        return SWT_KEY_LOOKUP
      end
      
      typesig { [] }
      # An accessor for the current default look-up.
      # 
      # @return The default look-up; never <code>null</code>.
      def get_default
        return self.attr_default_lookup
      end
      
      typesig { [IKeyLookup] }
      # Sets the default look-up.
      # 
      # @param defaultLookup
      # the default look-up. Must not be <code>null</code>.
      def set_default(default_lookup)
        if ((default_lookup).nil?)
          raise NullPointerException.new("The look-up must not be null") # $NON-NLS-1$
        end
        self.attr_default_lookup.attr_default_lookup = default_lookup
      end
    }
    
    typesig { [] }
    # This class should not be instantiated.
    def initialize
      # Not to be constructred.
    end
    
    private
    alias_method :initialize__key_lookup_factory, :initialize
  end
  
end
