require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Link
  module TabStopIteratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Link
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Comparator
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :NoSuchElementException
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  # Iterator that leaps over the double occurrence of an element when switching from forward
  # to backward iteration that is shown by <code>ListIterator</code>.
  # <p>
  # Package private, only for use by LinkedModeUI.
  # </p>
  # @since 3.0
  class TabStopIterator 
    include_class_members TabStopIteratorImports
    
    class_module.module_eval {
      # Comparator for <code>LinkedPosition</code>s. If the sequence number of two positions is equal, the
      # offset is used.
      const_set_lazy(:SequenceComparator) { Class.new do
        include_class_members TabStopIterator
        include Comparator
        
        typesig { [Object, Object] }
        # {@inheritDoc}
        # 
        # <p><code>o1</code> and <code>o2</code> are required to be instances
        # of <code>LinkedPosition</code>.</p>
        def compare(o1, o2)
          p1 = o1
          p2 = o2
          i = p1.get_sequence_number - p2.get_sequence_number
          if (!(i).equal?(0))
            return i
          end
          return p1.get_offset - p2.get_offset
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__sequence_comparator, :initialize
      end }
      
      # The comparator to sort the list of positions.
      const_set_lazy(:F_Comparator) { SequenceComparator.new }
      const_attr_reader  :F_Comparator
    }
    
    # The iteration sequence.
    attr_accessor :f_list
    alias_method :attr_f_list, :f_list
    undef_method :f_list
    alias_method :attr_f_list=, :f_list=
    undef_method :f_list=
    
    # The size of <code>fList</code>.
    attr_accessor :f_size
    alias_method :attr_f_size, :f_size
    undef_method :f_size
    alias_method :attr_f_size=, :f_size=
    undef_method :f_size=
    
    # Index of the current element, to the first one initially.
    attr_accessor :f_index
    alias_method :attr_f_index, :f_index
    undef_method :f_index
    alias_method :attr_f_index=, :f_index=
    undef_method :f_index=
    
    # Cycling property.
    attr_accessor :f_is_cycling
    alias_method :attr_f_is_cycling, :f_is_cycling
    undef_method :f_is_cycling
    alias_method :attr_f_is_cycling=, :f_is_cycling=
    undef_method :f_is_cycling=
    
    typesig { [JavaList] }
    def initialize(position_sequence)
      @f_list = nil
      @f_size = 0
      @f_index = 0
      @f_is_cycling = false
      Assert.is_not_null(position_sequence)
      @f_list = ArrayList.new(position_sequence)
      Collections.sort(@f_list, F_Comparator)
      @f_size = @f_list.size
      @f_index = -1
      Assert.is_true(@f_size > 0)
    end
    
    typesig { [LinkedPosition] }
    def has_next(current)
      return !(get_next_index(current)).equal?(@f_size)
    end
    
    typesig { [LinkedPosition] }
    def get_next_index(current)
      if (!(current).nil? && !(@f_list.get(@f_index)).equal?(current))
        return find_next(current)
      else
        if (@f_is_cycling && (@f_index).equal?(@f_size - 1))
          return 0
        else
          # default: increase
          return @f_index + 1
        end
      end
    end
    
    typesig { [LinkedPosition] }
    # Finds the closest position in the iteration set that follows after
    # <code>current</code> and sets <code>fIndex</code> accordingly. If <code>current</code>
    # is in the iteration set, the next in turn is chosen.
    # 
    # @param current the current position
    # @return <code>true</code> if there is a next position, <code>false</code> otherwise
    def find_next(current)
      Assert.is_not_null(current)
      # if the position is in the iteration set, jump to the next one
      index = @f_list.index_of(current)
      if (!(index).equal?(-1))
        if (@f_is_cycling && (index).equal?(@f_size - 1))
          return 0
        end
        return index + 1
      end
      # index == -1
      # find the position that follows closest to the current position
      found = nil
      it = @f_list.iterator
      while it.has_next
        p = it.next_
        if (p.attr_offset > current.attr_offset)
          if ((found).nil? || found.attr_offset > p.attr_offset)
            found = p
          end
        end
      end
      if (!(found).nil?)
        return @f_list.index_of(found)
      else
        if (@f_is_cycling)
          return 0
        else
          return @f_size
        end
      end
    end
    
    typesig { [LinkedPosition] }
    def has_previous(current)
      return !(get_previous_index(current)).equal?(-1)
    end
    
    typesig { [LinkedPosition] }
    def get_previous_index(current)
      if (!(current).nil? && !(@f_list.get(@f_index)).equal?(current))
        return find_previous(current)
      else
        if (@f_is_cycling && (@f_index).equal?(0))
          return @f_size - 1
        else
          return @f_index - 1
        end
      end
    end
    
    typesig { [LinkedPosition] }
    # Finds the closest position in the iteration set that precedes
    # <code>current</code>. If <code>current</code>
    # is in the iteration set, the previous in turn is chosen.
    # 
    # @param current the current position
    # @return the index of the previous position
    def find_previous(current)
      Assert.is_not_null(current)
      # if the position is in the iteration set, jump to the next one
      index = @f_list.index_of(current)
      if (!(index).equal?(-1))
        if (@f_is_cycling && (index).equal?(0))
          return @f_size - 1
        end
        return index - 1
      end
      # index == -1
      # find the position that follows closest to the current position
      found = nil
      it = @f_list.iterator
      while it.has_next
        p = it.next_
        if (p.attr_offset < current.attr_offset)
          if ((found).nil? || found.attr_offset < p.attr_offset)
            found = p
          end
        end
      end
      if (!(found).nil?)
        return @f_list.index_of(found)
      else
        if (@f_is_cycling)
          return @f_size - 1
        else
          return -1
        end
      end
    end
    
    typesig { [LinkedPosition] }
    def next_(current)
      if (!has_next(current))
        raise NoSuchElementException.new
      end
      return @f_list.get(@f_index = get_next_index(current))
    end
    
    typesig { [LinkedPosition] }
    def previous(current)
      if (!has_previous(current))
        raise NoSuchElementException.new
      end
      return @f_list.get(@f_index = get_previous_index(current))
    end
    
    typesig { [::Java::Boolean] }
    def set_cycling(mode)
      @f_is_cycling = mode
    end
    
    typesig { [Position] }
    def add_position(position)
      @f_list.add(((@f_size += 1) - 1), position)
      Collections.sort(@f_list, F_Comparator)
    end
    
    typesig { [Position] }
    def remove_position(position)
      if (@f_list.remove(position))
        @f_size -= 1
      end
    end
    
    typesig { [] }
    # @return Returns the isCycling.
    def is_cycling
      return @f_is_cycling
    end
    
    typesig { [] }
    def get_positions
      return @f_list.to_array(Array.typed(LinkedPosition).new(@f_size) { nil })
    end
    
    private
    alias_method :initialize__tab_stop_iterator, :initialize
  end
  
end
