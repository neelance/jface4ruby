require "rjava"

# Copyright (c) 2004, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings
  module BindingImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings
      include_const ::Java::Io, :BufferedWriter
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :StringWriter
      include_const ::Org::Eclipse::Core::Commands, :ParameterizedCommand
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # <p>
  # A binding is a link between user input and the triggering of a particular
  # command. The most common example of a binding is a keyboard shortcut, but
  # there are also mouse and gesture bindings.
  # </p>
  # <p>
  # Bindings are linked to particular conditions within the application. Some of
  # these conditions change infrequently (e.g., locale, scheme), while some will
  # tend to change quite frequently (e.g., context). This allows the bindings to
  # be tailored to particular situations. For example, a set of bindings may be
  # appropriate only inside a text editor.  Or, perhaps, a set of bindings might
  # be appropriate only for a given locale, such as bindings that coexist with
  # the Input Method Editor (IME) on Chinese locales.
  # </p>
  # <p>
  # It is also possible to remove a particular binding. This is typically done as
  # part of user configuration (e.g., user changing keyboard shortcuts). However,
  # it can also be helpful when trying to change a binding on a particular locale
  # or platform. An "unbinding" is really just a binding with no command
  # identifier. For it to unbind a particular binding, it must match that binding
  # in its context identifier and scheme identifier. Subclasses (e.g.,
  # <code>KeyBinding</code>) may require other properties to match (e.g.,
  # <code>keySequence</code>). If these properties match, then this is an
  # unbinding. Note: the locale and platform can be different.
  # </p>
  # <p>
  # For example, imagine you have a key binding that looks like this:
  # </p>
  # <code><pre>
  # KeyBinding(command, scheme, context, &quot;Ctrl+Shift+F&quot;)
  # </pre></code>
  # <p>
  # On GTK+, the "Ctrl+Shift+F" interferes with some native behaviour. To change
  # the binding, we first unbind the "Ctrl+Shift+F" key sequence by
  # assigning it a null command on the gtk platform.  We then create a new binding
  # that maps the command to the "Esc Ctrl+F" key sequence.
  # </p>
  # <code><pre>
  # KeyBinding("Ctrl+Shift+F",null,scheme,context,null,gtk,null,SYSTEM)
  # KeyBinding("Esc Ctrl+F",parameterizedCommand,scheme,context,null,gtk,SYSTEM)
  # </pre></code>
  # <p>
  # Bindings are intended to be immutable objects.
  # </p>
  # 
  # @since 3.1
  class Binding 
    include_class_members BindingImports
    
    class_module.module_eval {
      # The constant integer hash code value meaning the hash code has not yet
      # been computed.
      const_set_lazy(:HASH_CODE_NOT_COMPUTED) { -1 }
      const_attr_reader  :HASH_CODE_NOT_COMPUTED
      
      # A factor for computing the hash code for all key bindings.
      const_set_lazy(:HASH_FACTOR) { 89 }
      const_attr_reader  :HASH_FACTOR
      
      # The seed for the hash code for all key bindings.
      const_set_lazy(:HASH_INITIAL) { Binding.get_name.hash_code }
      const_attr_reader  :HASH_INITIAL
      
      # The type of binding that is defined by the system (i.e., by the
      # application developer). In the case of an application based on the
      # Eclipse workbench, this is the registry.
      const_set_lazy(:SYSTEM) { 0 }
      const_attr_reader  :SYSTEM
      
      # The type of binding that is defined by the user (i.e., by the end user of
      # the application). In the case of an application based on the Eclipse
      # workbench, this is the preference store.
      const_set_lazy(:USER) { 1 }
      const_attr_reader  :USER
    }
    
    # The parameterized command to which this binding applies. This value may
    # be <code>null</code> if this binding is meant to "unbind" an existing
    # binding.
    attr_accessor :command
    alias_method :attr_command, :command
    undef_method :command
    alias_method :attr_command=, :command=
    undef_method :command=
    
    # The context identifier to which this binding applies. This context must
    # be active before this key binding becomes active. This value will never
    # be <code>null</code>.
    attr_accessor :context_id
    alias_method :attr_context_id, :context_id
    undef_method :context_id
    alias_method :attr_context_id=, :context_id=
    undef_method :context_id=
    
    # The hash code for this key binding. This value is computed lazily, and
    # marked as invalid when one of the values on which it is based changes.
    attr_accessor :hash_code
    alias_method :attr_hash_code, :hash_code
    undef_method :hash_code
    alias_method :attr_hash_code=, :hash_code=
    undef_method :hash_code=
    
    # The locale in which this binding applies. This value may be
    # <code>null</code> if this binding is meant to apply to all locales.
    # This string should be in the same format returned by
    # <code>Locale.getDefault().toString()</code>.
    attr_accessor :locale
    alias_method :attr_locale, :locale
    undef_method :locale
    alias_method :attr_locale=, :locale=
    undef_method :locale=
    
    # The platform on which this binding applies. This value may be
    # <code>null</code> if this binding is meant to apply to all platforms.
    # This string should be in the same format returned by
    # <code>SWT.getPlatform</code>.
    attr_accessor :platform
    alias_method :attr_platform, :platform
    undef_method :platform
    alias_method :attr_platform=, :platform=
    undef_method :platform=
    
    # The identifier of the scheme in which this binding applies. This value
    # will never be <code>null</code>.
    attr_accessor :scheme_id
    alias_method :attr_scheme_id, :scheme_id
    undef_method :scheme_id
    alias_method :attr_scheme_id=, :scheme_id=
    undef_method :scheme_id=
    
    # The string representation of this binding. This string is for debugging
    # purposes only, and is not meant to be displayed to the user. This value
    # is computed lazily.
    attr_accessor :string
    alias_method :attr_string, :string
    undef_method :string
    alias_method :attr_string=, :string=
    undef_method :string=
    
    # The type of binding this represents. This is used to distinguish between
    # different priority levels for bindings. For example, in our case,
    # <code>USER</code> bindings override <code>SYSTEM</code> bindings.
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    typesig { [ParameterizedCommand, String, String, String, String, String, ::Java::Int] }
    # Constructs a new instance of <code>Binding</code>.
    # 
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
    def initialize(command, scheme_id, context_id, locale, platform, window_manager, type)
      @command = nil
      @context_id = nil
      @hash_code = HASH_CODE_NOT_COMPUTED
      @locale = nil
      @platform = nil
      @scheme_id = nil
      @string = nil
      @type = 0
      if ((scheme_id).nil?)
        raise NullPointerException.new("The scheme cannot be null") # $NON-NLS-1$
      end
      if ((context_id).nil?)
        raise NullPointerException.new("The context cannot be null") # $NON-NLS-1$
      end
      if ((!(type).equal?(SYSTEM)) && (!(type).equal?(USER)))
        raise IllegalArgumentException.new("The type must be SYSTEM or USER") # $NON-NLS-1$
      end
      @command = command
      @scheme_id = scheme_id.intern
      @context_id = context_id.intern
      @locale = ((locale).nil?) ? nil : locale.intern
      @platform = ((platform).nil?) ? nil : platform.intern
      @type = type
    end
    
    typesig { [Binding] }
    # Tests whether this binding is intended to delete another binding. The
    # receiver must have a <code>null</code> command identifier.
    # 
    # @param binding
    # The binding to test; must not be <code>null</code>.
    # This binding must be a <code>SYSTEM</code> binding.
    # @return <code>true</code> if the receiver deletes the binding defined by
    # the argument.
    def deletes(binding)
      deletes = true
      deletes &= (Util == get_context_id)
      deletes &= (Util == get_trigger_sequence)
      if (!(get_locale).nil?)
        deletes &= !(Util == get_locale)
      end
      if (!(get_platform).nil?)
        deletes &= !(Util == get_platform)
      end
      deletes &= ((binding.get_type).equal?(SYSTEM))
      deletes &= (Util == get_parameterized_command)
      return deletes
    end
    
    typesig { [Object] }
    # Tests whether this binding is equal to another object. Bindings are only
    # equal to other bindings with equivalent values.
    # 
    # @param object
    # The object with which to compare; may be <code>null</code>.
    # @return <code>true</code> if the object is a binding with equivalent
    # values for all of its properties; <code>false</code> otherwise.
    def ==(object)
      if ((self).equal?(object))
        return true
      end
      if (!(object.is_a?(Binding)))
        return false
      end
      binding = object
      if (!(Util == get_parameterized_command))
        return false
      end
      if (!(Util == get_context_id))
        return false
      end
      if (!(Util == get_trigger_sequence))
        return false
      end
      if (!(Util == get_locale))
        return false
      end
      if (!(Util == get_platform))
        return false
      end
      if (!(Util == get_scheme_id))
        return false
      end
      return ((get_type).equal?(binding.get_type))
    end
    
    typesig { [] }
    # Returns the parameterized command to which this binding applies. If the
    # identifier is <code>null</code>, then this binding is "unbinding" an
    # existing binding.
    # 
    # @return The fully-parameterized command; may be <code>null</code>.
    def get_parameterized_command
      return @command
    end
    
    typesig { [] }
    # Returns the identifier of the context in which this binding applies.
    # 
    # @return The context identifier; never <code>null</code>.
    def get_context_id
      return @context_id
    end
    
    typesig { [] }
    # Returns the locale in which this binding applies. If the locale is
    # <code>null</code>, then this binding applies to all locales. This
    # string is the same format as returned by
    # <code>Locale.getDefault().toString()</code>.
    # 
    # @return The locale; may be <code>null</code>.
    def get_locale
      return @locale
    end
    
    typesig { [] }
    # Returns the platform on which this binding applies. If the platform is
    # <code>null</code>, then this binding applies to all platforms. This
    # string is the same format as returned by <code>SWT.getPlatform()</code>.
    # 
    # @return The platform; may be <code>null</code>.
    def get_platform
      return @platform
    end
    
    typesig { [] }
    # Returns the identifier of the scheme in which this binding applies.
    # 
    # @return The scheme identifier; never <code>null</code>.
    def get_scheme_id
      return @scheme_id
    end
    
    typesig { [] }
    # Returns the sequence of trigger for a given binding. The triggers can be
    # anything, but above all it must be hashable. This trigger sequence is
    # used by the binding manager to distinguish between different bindings.
    # 
    # @return The object representing an input event that will trigger this
    # binding; must not be <code>null</code>.
    def get_trigger_sequence
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the type for this binding. As it stands now, this value will
    # either be <code>SYSTEM</code> or <code>USER</code>. In the future,
    # more types might be added.
    # 
    # @return The type for this binding.
    def get_type
      return @type
    end
    
    typesig { [] }
    # Computes the hash code for this key binding based on all of its
    # attributes.
    # 
    # @return The hash code for this key binding.
    def hash_code
      if ((@hash_code).equal?(HASH_CODE_NOT_COMPUTED))
        @hash_code = HASH_INITIAL
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(get_parameterized_command)
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(get_context_id)
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(get_trigger_sequence)
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(get_locale)
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(get_platform)
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(get_scheme_id)
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(get_type)
        if ((@hash_code).equal?(HASH_CODE_NOT_COMPUTED))
          @hash_code += 1
        end
      end
      return @hash_code
    end
    
    typesig { [] }
    # The string representation of this binding -- for debugging purposes only.
    # This string should not be shown to an end user. This should be overridden
    # by subclasses that add properties.
    # 
    # @return The string representation; never <code>null</code>.
    def to_s
      if ((@string).nil?)
        sw = StringWriter.new
        string_buffer = BufferedWriter.new(sw)
        begin
          string_buffer.write("Binding(") # $NON-NLS-1$
          string_buffer.write(get_trigger_sequence.to_s)
          string_buffer.write(Character.new(?,.ord))
          string_buffer.new_line
          string_buffer.write(Character.new(?\t.ord))
          string_buffer.write((@command).nil? ? "" : @command.to_s) # $NON-NLS-1$
          string_buffer.write(Character.new(?,.ord))
          string_buffer.new_line
          string_buffer.write(Character.new(?\t.ord))
          string_buffer.write(@scheme_id)
          string_buffer.write(Character.new(?,.ord))
          string_buffer.new_line
          string_buffer.write(Character.new(?\t.ord))
          string_buffer.write(@context_id)
          string_buffer.write(Character.new(?,.ord))
          string_buffer.write((@locale).nil? ? "" : @locale) # $NON-NLS-1$
          string_buffer.write(Character.new(?,.ord))
          string_buffer.write((@platform).nil? ? "" : @platform) # $NON-NLS-1$
          string_buffer.write(Character.new(?,.ord))
          string_buffer.write(((@type).equal?(SYSTEM)) ? "system" : "user") # $NON-NLS-1$//$NON-NLS-2$
          string_buffer.write(Character.new(?).ord))
          string_buffer.flush
        rescue IOException => e
          # shouldn't get this
        end
        @string = RJava.cast_to_string(sw.to_s)
      end
      return @string
    end
    
    private
    alias_method :initialize__binding, :initialize
  end
  
end
