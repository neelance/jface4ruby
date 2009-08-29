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
  module TriggerSequenceImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings
      include_const ::Org::Eclipse::Jface::Util, :Util
    }
  end
  
  # <p>
  # A sequence of one or more triggers. None of these triggers may be
  # <code>null</code>.
  # </p>
  # 
  # @since 3.1
  class TriggerSequence 
    include_class_members TriggerSequenceImports
    
    class_module.module_eval {
      # The value to see that hash code to if the hash code is not yet computed.
      const_set_lazy(:HASH_CODE_NOT_COMPUTED) { -1 }
      const_attr_reader  :HASH_CODE_NOT_COMPUTED
      
      # A factor for computing the hash code for all trigger sequences.
      const_set_lazy(:HASH_FACTOR) { 89 }
      const_attr_reader  :HASH_FACTOR
      
      # An internal constant used only in this object's hash code algorithm.
      const_set_lazy(:HASH_INITIAL) { TriggerSequence.get_name.hash_code }
      const_attr_reader  :HASH_INITIAL
    }
    
    # The hash code for this object. This value is computed lazily, and marked
    # as invalid when one of the values on which it is based changes.  This
    # values is <code>HASH_CODE_NOT_COMPUTED</code> iff the hash code has not
    # yet been computed.
    attr_accessor :hash_code
    alias_method :attr_hash_code, :hash_code
    undef_method :hash_code
    alias_method :attr_hash_code=, :hash_code=
    undef_method :hash_code=
    
    # The list of trigger in this sequence. This value is never
    # <code>null</code>, and never contains <code>null</code> elements.
    attr_accessor :triggers
    alias_method :attr_triggers, :triggers
    undef_method :triggers
    alias_method :attr_triggers=, :triggers=
    undef_method :triggers=
    
    typesig { [Array.typed(Trigger)] }
    # Constructs a new instance of <code>TriggerSequence</code>.
    # 
    # @param triggers
    # The triggers contained within this sequence; must not be
    # <code>null</code> or contain <code>null</code> elements.
    # May be empty.
    def initialize(triggers)
      @hash_code = HASH_CODE_NOT_COMPUTED
      @triggers = nil
      if ((triggers).nil?)
        raise NullPointerException.new("The triggers cannot be null") # $NON-NLS-1$
      end
      i = 0
      while i < triggers.attr_length
        if ((triggers[i]).nil?)
          raise IllegalArgumentException.new("All triggers in a trigger sequence must be an instance of Trigger") # $NON-NLS-1$
        end
        i += 1
      end
      trigger_length = triggers.attr_length
      @triggers = Array.typed(Trigger).new(trigger_length) { nil }
      System.arraycopy(triggers, 0, @triggers, 0, trigger_length)
    end
    
    typesig { [TriggerSequence, ::Java::Boolean] }
    # Returns whether or not this key sequence ends with the given key
    # sequence.
    # 
    # @param triggerSequence
    # a trigger sequence. Must not be <code>null</code>.
    # @param equals
    # whether or not an identical trigger sequence should be
    # considered as a possible match.
    # @return <code>true</code>, iff the given trigger sequence ends with
    # this trigger sequence.
    def ends_with(trigger_sequence, equals)
      if ((trigger_sequence).nil?)
        raise NullPointerException.new("Cannot end with a null trigger sequence") # $NON-NLS-1$
      end
      return Util.ends_with(@triggers, trigger_sequence.attr_triggers, equals)
    end
    
    typesig { [Object] }
    def ==(object)
      # Check if they're the same.
      if ((object).equal?(self))
        return true
      end
      # Check if they're the same type.
      if (!(object.is_a?(TriggerSequence)))
        return false
      end
      trigger_sequence = object
      return (Util == @triggers)
    end
    
    typesig { [] }
    # Formats this trigger sequence into the current default look.
    # 
    # @return A string representation for this trigger sequence using the
    # default look; never <code>null</code>.
    def format
      raise NotImplementedError
    end
    
    typesig { [] }
    # <p>
    # Returns a list of prefixes for the current sequence. A prefix is any
    # leading subsequence in a <code>TriggerSequence</code>. A prefix is
    # also an instance of <code>TriggerSequence</code>.
    # </p>
    # <p>
    # For example, consider a trigger sequence that consists of four triggers:
    # A, B, C and D. The prefixes would be "", "A", "A B", and "A B C". The
    # list of prefixes must always be the same as the size of the trigger list.
    # </p>
    # 
    # @return The array of possible prefixes for this sequence. This array must
    # not be <code>null</code>, but may be empty. It must only
    # contains instances of <code>TriggerSequence</code>.
    def get_prefixes
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the list of triggers.
    # 
    # @return The triggers; never <code>null</code> and guaranteed to only
    # contain instances of <code>Trigger</code>.
    def get_triggers
      trigger_length = @triggers.attr_length
      trigger_copy = Array.typed(Trigger).new(trigger_length) { nil }
      System.arraycopy(@triggers, 0, trigger_copy, 0, trigger_length)
      return trigger_copy
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see java.lang.Object#hashCode()
    def hash_code
      if ((@hash_code).equal?(HASH_CODE_NOT_COMPUTED))
        @hash_code = HASH_INITIAL
        @hash_code = @hash_code * HASH_FACTOR + Util.hash_code(@triggers)
        if ((@hash_code).equal?(HASH_CODE_NOT_COMPUTED))
          @hash_code += 1
        end
      end
      return @hash_code
    end
    
    typesig { [] }
    # Returns whether or not this trigger sequence is empty.
    # 
    # @return <code>true</code>, iff the trigger sequence is empty.
    def is_empty
      return ((@triggers.attr_length).equal?(0))
    end
    
    typesig { [TriggerSequence, ::Java::Boolean] }
    # Returns whether or not this trigger sequence starts with the given
    # trigger sequence.
    # 
    # @param triggerSequence
    # a trigger sequence. Must not be <code>null</code>.
    # @param equals
    # whether or not an identical trigger sequence should be
    # considered as a possible match.
    # @return <code>true</code>, iff the given trigger sequence starts with
    # this key sequence.
    def starts_with(trigger_sequence, equals)
      if ((trigger_sequence).nil?)
        raise NullPointerException.new("A trigger sequence cannot start with null") # $NON-NLS-1$
      end
      return Util.starts_with(@triggers, trigger_sequence.attr_triggers, equals)
    end
    
    private
    alias_method :initialize__trigger_sequence, :initialize
  end
  
end
