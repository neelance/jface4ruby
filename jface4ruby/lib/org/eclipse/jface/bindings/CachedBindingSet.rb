require "rjava"

# Copyright (c) 2004, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings
  module CachedBindingSetImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # <p>
  # A resolution of bindings for a given state. To see if we already have a
  # cached binding set, just create one of these binding sets and then look it up
  # in a map. If it is not already there, then add it and set the cached binding
  # resolution.
  # </p>
  # 
  # @since 3.1
  class CachedBindingSet 
    include_class_members CachedBindingSetImports
    
    class_module.module_eval {
      # A factor for computing the hash code for all cached binding sets.
      const_set_lazy(:HASH_FACTOR) { 89 }
      const_attr_reader  :HASH_FACTOR
      
      # The seed for the hash code for all cached binding sets.
      const_set_lazy(:HASH_INITIAL) { CachedBindingSet.get_name.hash_code }
      const_attr_reader  :HASH_INITIAL
    }
    
    # <p>
    # A representation of the tree of active contexts at the time this cached
    # binding set was computed. It is a map of context id (<code>String</code>)
    # to context id (<code>String</code>). Each key represents one of the
    # active contexts or one of its ancestors, while each value represents its
    # parent. This is a way of perserving information about what the hierarchy
    # looked like.
    # </p>
    # <p>
    # This value will be <code>null</code> if the contexts were disregarded
    # in the computation. It may also be empty. All of the keys are guaranteed
    # to be non- <code>null</code>, but the values can be <code>null</code>
    # (i.e., no parent).
    # </p>
    attr_accessor :active_context_tree
    alias_method :attr_active_context_tree, :active_context_tree
    undef_method :active_context_tree
    alias_method :attr_active_context_tree=, :active_context_tree=
    undef_method :active_context_tree=
    
    # The map representing the resolved state of the bindings. This is a map of
    # a trigger (<code>TriggerSequence</code>) to binding (<code>Binding</code>).
    # This value may be <code>null</code> if it has not yet been initialized.
    attr_accessor :bindings_by_trigger
    alias_method :attr_bindings_by_trigger, :bindings_by_trigger
    undef_method :bindings_by_trigger
    alias_method :attr_bindings_by_trigger=, :bindings_by_trigger=
    undef_method :bindings_by_trigger=
    
    # A map of triggers to collections of bindings. If this binding set
    # contains conflicts, they are logged here.
    # 
    # @since 3.3
    attr_accessor :conflicts_by_trigger
    alias_method :attr_conflicts_by_trigger, :conflicts_by_trigger
    undef_method :conflicts_by_trigger
    alias_method :attr_conflicts_by_trigger=, :conflicts_by_trigger=
    undef_method :conflicts_by_trigger=
    
    # The hash code for this object. This value is computed lazily, and marked
    # as invalid when one of the values on which it is based changes.
    attr_accessor :hash_code
    alias_method :attr_hash_code, :hash_code
    undef_method :hash_code
    alias_method :attr_hash_code=, :hash_code=
    undef_method :hash_code=
    
    # Whether <code>hashCode</code> still contains a valid value.
    attr_accessor :hash_code_computed
    alias_method :attr_hash_code_computed, :hash_code_computed
    undef_method :hash_code_computed
    alias_method :attr_hash_code_computed=, :hash_code_computed=
    undef_method :hash_code_computed=
    
    # <p>
    # The list of locales that were active at the time this binding set was
    # computed. This list starts with the most specific representation of the
    # locale, and moves to more general representations. For example, this
    # array might look like ["en_US", "en", "", null].
    # </p>
    # <p>
    # This value will never be <code>null</code>, and it will never be
    # empty. It must contain at least one element, but its elements can be
    # <code>null</code>.
    # </p>
    attr_accessor :locales
    alias_method :attr_locales, :locales
    undef_method :locales
    alias_method :attr_locales=, :locales=
    undef_method :locales=
    
    # <p>
    # The list of platforms that were active at the time this binding set was
    # computed. This list starts with the most specific representation of the
    # platform, and moves to more general representations. For example, this
    # array might look like ["gtk", "", null].
    # </p>
    # <p>
    # This value will never be <code>null</code>, and it will never be
    # empty. It must contain at least one element, but its elements can be
    # <code>null</code>.
    # </p>
    attr_accessor :platforms
    alias_method :attr_platforms, :platforms
    undef_method :platforms
    alias_method :attr_platforms=, :platforms=
    undef_method :platforms=
    
    # A map of prefixes (<code>TriggerSequence</code>) to a map of
    # available completions (possibly <code>null</code>, which means there
    # is an exact match). The available completions is a map of trigger (<code>TriggerSequence</code>)
    # to command identifier (<code>String</code>). This value is
    # <code>null</code> if it has not yet been initialized.
    attr_accessor :prefix_table
    alias_method :attr_prefix_table, :prefix_table
    undef_method :prefix_table
    alias_method :attr_prefix_table=, :prefix_table=
    undef_method :prefix_table=
    
    # <p>
    # The list of schemes that were active at the time this binding set was
    # computed. This list starts with the active scheme, and then continues
    # with all of its ancestors -- in order. For example, this might look like
    # ["emacs", "default"].
    # </p>
    # <p>
    # This value will never be <code>null</code>, and it will never be
    # empty. It must contain at least one element. Its elements cannot be
    # <code>null</code>.
    # </p>
    attr_accessor :scheme_ids
    alias_method :attr_scheme_ids, :scheme_ids
    undef_method :scheme_ids
    alias_method :attr_scheme_ids=, :scheme_ids=
    undef_method :scheme_ids=
    
    # The map representing the resolved state of the bindings. This is a map of
    # a command id (<code>String</code>) to triggers (<code>Collection</code>
    # of <code>TriggerSequence</code>). This value may be <code>null</code>
    # if it has not yet been initialized.
    attr_accessor :triggers_by_command_id
    alias_method :attr_triggers_by_command_id, :triggers_by_command_id
    undef_method :triggers_by_command_id
    alias_method :attr_triggers_by_command_id=, :triggers_by_command_id=
    undef_method :triggers_by_command_id=
    
    typesig { [Map, Array.typed(String), Array.typed(String), Array.typed(String)] }
    # Constructs a new instance of <code>CachedBindingSet</code>.
    # 
    # @param activeContextTree
    # The set of context identifiers that were active when this
    # binding set was calculated; may be empty. If it is
    # <code>null</code>, then the contexts were disregarded in
    # the computation. This is a map of context id (
    # <code>String</code>) to parent context id (
    # <code>String</code>). This is a way of caching the look of
    # the context tree at the time the binding set was computed.
    # @param locales
    # The locales that were active when this binding set was
    # calculated. The first element is the currently active locale,
    # and it is followed by increasingly more general locales. This
    # must not be <code>null</code> and must contain at least one
    # element. The elements can be <code>null</code>, though.
    # @param platforms
    # The platform that were active when this binding set was
    # calculated. The first element is the currently active
    # platform, and it is followed by increasingly more general
    # platforms. This must not be <code>null</code> and must
    # contain at least one element. The elements can be
    # <code>null</code>, though.
    # @param schemeIds
    # The scheme that was active when this binding set was
    # calculated, followed by its ancestors. This may be
    # <code>null</code or empty. The
    # elements cannot be <code>null</code>.
    def initialize(active_context_tree, locales, platforms, scheme_ids)
      @active_context_tree = nil
      @bindings_by_trigger = nil
      @conflicts_by_trigger = nil
      @hash_code = 0
      @hash_code_computed = false
      @locales = nil
      @platforms = nil
      @prefix_table = nil
      @scheme_ids = nil
      @triggers_by_command_id = nil
      if ((locales).nil?)
        raise NullPointerException.new("The locales cannot be null.") # $NON-NLS-1$
      end
      if ((locales.attr_length).equal?(0))
        raise NullPointerException.new("The locales cannot be empty.") # $NON-NLS-1$
      end
      if ((platforms).nil?)
        raise NullPointerException.new("The platforms cannot be null.") # $NON-NLS-1$
      end
      if ((platforms.attr_length).equal?(0))
        raise NullPointerException.new("The platforms cannot be empty.") # $NON-NLS-1$
      end
      @active_context_tree = active_context_tree
      @locales = locales
      @platforms = platforms
      @scheme_ids = scheme_ids
    end
    
    typesig { [Object] }
    # Compares this binding set with another object. The objects will be equal
    # if they are both instance of <code>CachedBindingSet</code> and have
    # equivalent values for all of their properties.
    # 
    # @param object
    # The object with which to compare; may be <code>null</code>.
    # @return <code>true</code> if they are both instances of
    # <code>CachedBindingSet</code> and have the same values for all
    # of their properties; <code>false</code> otherwise.
    def ==(object)
      if (!(object.is_a?(CachedBindingSet)))
        return false
      end
      other = object
      if (!(Util == @active_context_tree))
        return false
      end
      if (!(Util == @locales))
        return false
      end
      if (!(Util == @platforms))
        return false
      end
      return (Util == @scheme_ids)
    end
    
    typesig { [] }
    # Returns the map of command identifiers indexed by trigger sequence.
    # 
    # @return A map of triggers (<code>TriggerSequence</code>) to bindings (<code>Binding</code>).
    # This value may be <code>null</code> if this was not yet
    # initialized.
    def get_bindings_by_trigger
      return @bindings_by_trigger
    end
    
    typesig { [] }
    # Returns a map of conflicts for this set of contexts.
    # 
    # @return A map of trigger to a collection of Bindings. May be
    # <code>null</code>.
    # @since 3.3
    def get_conflicts_by_trigger
      return @conflicts_by_trigger
    end
    
    typesig { [] }
    # Returns the map of prefixes to a map of trigger sequence to command
    # identifiers.
    # 
    # @return A map of prefixes (<code>TriggerSequence</code>) to a map of
    # available completions (possibly <code>null</code>, which means
    # there is an exact match). The available completions is a map of
    # trigger (<code>TriggerSequence</code>) to command identifier (<code>String</code>).
    # This value may be <code>null</code> if it has not yet been
    # initialized.
    def get_prefix_table
      return @prefix_table
    end
    
    typesig { [] }
    # Returns the map of triggers indexed by command identifiers.
    # 
    # @return A map of command identifiers (<code>String</code>) to
    # triggers (<code>Collection</code> of
    # <code>TriggerSequence</code>). This value may be
    # <code>null</code> if this was not yet initialized.
    def get_triggers_by_command_id
      return @triggers_by_command_id
    end
    
    typesig { [] }
    # Computes the hash code for this cached binding set. The hash code is
    # based only on the immutable values. This allows the set to be created and
    # checked for in a hashed collection <em>before</em> doing any
    # computation.
    # 
    # @return The hash code for this cached binding set.
    def hash_code
      if (!@hash_code_computed)
        @hash_code = HASH_INITIAL
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(@active_context_tree)
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(@locales)
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(@platforms)
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(@scheme_ids)
        @hash_code_computed = true
      end
      return @hash_code
    end
    
    typesig { [Map] }
    # Sets the map of command identifiers indexed by trigger.
    # 
    # @param commandIdsByTrigger
    # The map to set; must not be <code>null</code>. This is a
    # map of triggers (<code>TriggerSequence</code>) to binding (<code>Binding</code>).
    def set_bindings_by_trigger(command_ids_by_trigger)
      if ((command_ids_by_trigger).nil?)
        raise NullPointerException.new("Cannot set a null binding resolution") # $NON-NLS-1$
      end
      @bindings_by_trigger = command_ids_by_trigger
    end
    
    typesig { [Map] }
    # Sets the map of conflicting bindings by trigger.
    # 
    # @param conflicts
    # The map to set; must not be <code>null</code>.
    # @since 3.3
    def set_conflicts_by_trigger(conflicts)
      if ((conflicts).nil?)
        raise NullPointerException.new("Cannot set a null binding conflicts") # $NON-NLS-1$
      end
      @conflicts_by_trigger = conflicts
    end
    
    typesig { [Map] }
    # Sets the map of prefixes to a map of trigger sequence to command
    # identifiers.
    # 
    # @param prefixTable
    # A map of prefixes (<code>TriggerSequence</code>) to a map
    # of available completions (possibly <code>null</code>, which
    # means there is an exact match). The available completions is a
    # map of trigger (<code>TriggerSequence</code>) to command
    # identifier (<code>String</code>). Must not be
    # <code>null</code>.
    def set_prefix_table(prefix_table)
      if ((prefix_table).nil?)
        raise NullPointerException.new("Cannot set a null prefix table") # $NON-NLS-1$
      end
      @prefix_table = prefix_table
    end
    
    typesig { [Map] }
    # Sets the map of triggers indexed by command identifiers.
    # 
    # @param triggersByCommandId
    # The map to set; must not be <code>null</code>. This is a
    # map of command identifiers (<code>String</code>) to
    # triggers (<code>Collection</code> of
    # <code>TriggerSequence</code>).
    def set_triggers_by_command_id(triggers_by_command_id)
      if ((triggers_by_command_id).nil?)
        raise NullPointerException.new("Cannot set a null binding resolution") # $NON-NLS-1$
      end
      @triggers_by_command_id = triggers_by_command_id
    end
    
    private
    alias_method :initialize__cached_binding_set, :initialize
  end
  
end
