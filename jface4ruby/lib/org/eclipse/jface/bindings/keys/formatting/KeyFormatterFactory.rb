require "rjava"

# Copyright (c) 2004, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys::Formatting
  module KeyFormatterFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys::Formatting
    }
  end
  
  # <p>
  # A cache for formatters. It keeps a few instances of pre-defined instances of
  # <code>IKeyFormatter</code> available for use. It also allows the default
  # formatter to be changed.
  # </p>
  # 
  # @since 3.1
  # @see org.eclipse.jface.bindings.keys.formatting.IKeyFormatter
  class KeyFormatterFactory 
    include_class_members KeyFormatterFactoryImports
    
    class_module.module_eval {
      # The formatter that renders key bindings in a platform-dependent manner.
      const_set_lazy(:FORMAL_KEY_FORMATTER) { FormalKeyFormatter.new }
      const_attr_reader  :FORMAL_KEY_FORMATTER
      
      # The formatter that renders key bindings in a form similar to XEmacs
      const_set_lazy(:EMACS_KEY_FORMATTER) { EmacsKeyFormatter.new }
      const_attr_reader  :EMACS_KEY_FORMATTER
      
      # The default formatter. This is normally the formal key formatter, but can
      # be changed by users of this API.
      
      def default_key_formatter
        defined?(@@default_key_formatter) ? @@default_key_formatter : @@default_key_formatter= FORMAL_KEY_FORMATTER
      end
      alias_method :attr_default_key_formatter, :default_key_formatter
      
      def default_key_formatter=(value)
        @@default_key_formatter = value
      end
      alias_method :attr_default_key_formatter=, :default_key_formatter=
      
      typesig { [] }
      # An accessor for the current default key formatter.
      # 
      # @return The default formatter; never <code>null</code>.
      def get_default
        return self.attr_default_key_formatter
      end
      
      typesig { [] }
      # Provides an instance of <code>EmacsKeyFormatter</code>.
      # 
      # @return The Xemacs formatter; never <code>null</code>.
      def get_emacs_key_formatter
        return EMACS_KEY_FORMATTER
      end
      
      typesig { [] }
      # Provides an instance of <code>FormalKeyFormatter</code>.
      # 
      # @return The formal formatter; never <code>null</code>.
      def get_formal_key_formatter
        return FORMAL_KEY_FORMATTER
      end
      
      typesig { [IKeyFormatter] }
      # Sets the default key formatter.
      # 
      # @param defaultKeyFormatter
      # the default key formatter. Must not be <code>null</code>.
      def set_default(default_key_formatter)
        if ((default_key_formatter).nil?)
          raise NullPointerException.new
        end
        self.attr_default_key_formatter.attr_default_key_formatter = default_key_formatter
      end
    }
    
    typesig { [] }
    # This class should not be instantiated.
    def initialize
      # Not to be constructred.
    end
    
    private
    alias_method :initialize__key_formatter_factory, :initialize
  end
  
end
