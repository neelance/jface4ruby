require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys
  module KeyBindingImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys
      include_const ::Org::Eclipse::Core::Commands, :ParameterizedCommand
      include_const ::Org::Eclipse::Jface::Bindings, :Binding
      include_const ::Org::Eclipse::Jface::Bindings, :TriggerSequence
    }
  end
  
  # <p>
  # A keyboard shortcut. This is a binding between some keyboard input and the
  # triggering of a command. This object is immutable.
  # </p>
  # 
  # @since 3.1
  class KeyBinding < KeyBindingImports.const_get :Binding
    include_class_members KeyBindingImports
    
    # The key sequence which triggers this binding. This sequence is never
    # <code>null</code>.
    attr_accessor :key_sequence
    alias_method :attr_key_sequence, :key_sequence
    undef_method :key_sequence
    alias_method :attr_key_sequence=, :key_sequence=
    undef_method :key_sequence=
    
    typesig { [KeySequence, ParameterizedCommand, String, String, String, String, String, ::Java::Int] }
    # Constructs a new instance of <code>KeyBinding</code>.
    # 
    # @param keySequence
    # The key sequence which should trigger this binding. This value
    # must not be <code>null</code>. It also must be a complete,
    # non-empty key sequence.
    # @param command
    # The parameterized command to which this binding applies; this
    # value may be <code>null</code> if the binding is meant to
    # "unbind" a previously defined binding.
    # @param schemeId
    # The scheme to which this binding belongs; this value must not
    # be <code>null</code>.
    # @param contextId
    # The context to which this binding applies; this value must not
    # be <code>null</code>.
    # @param locale
    # The locale to which this binding applies; this value may be
    # <code>null</code> if it applies to all locales.
    # @param platform
    # The platform to which this binding applies; this value may be
    # <code>null</code> if it applies to all platforms.
    # @param windowManager
    # The window manager to which this binding applies; this value
    # may be <code>null</code> if it applies to all window
    # managers. This value is currently ignored.
    # @param type
    # The type of binding. This should be either <code>SYSTEM</code>
    # or <code>USER</code>.
    def initialize(key_sequence, command, scheme_id, context_id, locale, platform, window_manager, type)
      @key_sequence = nil
      super(command, scheme_id, context_id, locale, platform, window_manager, type)
      if ((key_sequence).nil?)
        raise NullPointerException.new("The key sequence cannot be null") # $NON-NLS-1$
      end
      if (!key_sequence.is_complete)
        raise IllegalArgumentException.new("Cannot bind to an incomplete key sequence") # $NON-NLS-1$
      end
      if (key_sequence.is_empty)
        raise IllegalArgumentException.new("Cannot bind to an empty key sequence") # $NON-NLS-1$
      end
      @key_sequence = key_sequence
    end
    
    typesig { [] }
    # Returns the key sequence which triggers this binding. The key sequence
    # will not be <code>null</code>, empty or incomplete.
    # 
    # @return The key sequence; never <code>null</code>.
    def get_key_sequence
      return @key_sequence
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.bindings.Binding#getTriggerSequence()
    def get_trigger_sequence
      return get_key_sequence
    end
    
    private
    alias_method :initialize__key_binding, :initialize
  end
  
end
