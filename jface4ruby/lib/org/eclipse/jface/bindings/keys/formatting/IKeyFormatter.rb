require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys::Formatting
  module IKeyFormatterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys::Formatting
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeySequence
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyStroke
    }
  end
  
  # <p>
  # Any formatter capable of taking a key sequence or a key stroke and converting
  # it into a string. These formatters are used to produce the strings that the
  # user sees in the keys preference page and the menus, as well as the strings
  # that are used for persistent storage.
  # </p>
  # 
  # @since 3.1
  module IKeyFormatter
    include_class_members IKeyFormatterImports
    
    typesig { [::Java::Int] }
    # Formats an individual key into a human readable format. This uses an
    # internationalization resource bundle to look up the key. This does not do
    # any platform-specific formatting (e.g., Carbon's command character).
    # 
    # @param key
    # The key to format.
    # @return The key formatted as a string; should not be <code>null</code>.
    def format(key)
      raise NotImplementedError
    end
    
    typesig { [KeySequence] }
    # Format the given key sequence into a string. The manner of the conversion
    # is dependent on the formatter. It is required that unequal key sequences
    # return unequal strings.
    # 
    # @param keySequence
    # The key sequence to convert; must not be <code>null</code>.
    # @return A string representation of the key sequence; must not be
    # <code>null</code>.
    def format(key_sequence)
      raise NotImplementedError
    end
    
    typesig { [KeyStroke] }
    # Format the given key strokes into a string. The manner of the conversion
    # is dependent on the formatter. It is required that unequal key strokes
    # return unequal strings.
    # 
    # @param keyStroke
    # The key stroke to convert; must not be <Code>null</code>.
    # @return A string representation of the key stroke; must not be <code>
    # null</code>
    def format(key_stroke)
      raise NotImplementedError
    end
  end
  
end
