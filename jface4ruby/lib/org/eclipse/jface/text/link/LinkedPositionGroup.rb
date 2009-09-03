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
  module LinkedPositionGroupImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Link
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Text::Edits, :MalformedTreeException
      include_const ::Org::Eclipse::Text::Edits, :MultiTextEdit
      include_const ::Org::Eclipse::Text::Edits, :ReplaceEdit
      include_const ::Org::Eclipse::Text::Edits, :TextEdit
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
    }
  end
  
  # A group of positions in multiple documents that are simultaneously modified -
  # if one gets edited, all other positions in a group are edited the same way.
  # All linked positions in a group have the same content.
  # <p>
  # Normally, new positions are given a tab stop weight which can be used by
  # clients, e.g. the UI. If no weight is given, a position will not be visited.
  # If no weights are used at all, the first position in a document is taken as
  # the only stop as to comply with the behavior of the old linked position
  # infrastructure.
  # </p>
  # <p>
  # Clients may instantiate this class.
  # </p>
  # 
  # @since 3.0
  # @noextend This class is not intended to be subclassed by clients.
  class LinkedPositionGroup 
    include_class_members LinkedPositionGroupImports
    
    class_module.module_eval {
      # Sequence constant declaring that a position should not be stopped by.
      const_set_lazy(:NO_STOP) { -1 }
      const_attr_reader  :NO_STOP
    }
    
    # members
    # The linked positions of this group.
    attr_accessor :f_positions
    alias_method :attr_f_positions, :f_positions
    undef_method :f_positions
    alias_method :attr_f_positions=, :f_positions=
    undef_method :f_positions=
    
    # Whether we are sealed or not.
    attr_accessor :f_is_sealed
    alias_method :attr_f_is_sealed, :f_is_sealed
    undef_method :f_is_sealed
    alias_method :attr_f_is_sealed=, :f_is_sealed=
    undef_method :f_is_sealed=
    
    # <code>true</code> if there are custom iteration weights. For backward
    # compatibility.
    attr_accessor :f_has_custom_iteration
    alias_method :attr_f_has_custom_iteration, :f_has_custom_iteration
    undef_method :f_has_custom_iteration
    alias_method :attr_f_has_custom_iteration=, :f_has_custom_iteration=
    undef_method :f_has_custom_iteration=
    
    # iteration variables, set to communicate state between isLegalEvent and
    # handleEvent
    # 
    # The position including the most recent <code>DocumentEvent</code>.
    attr_accessor :f_last_position
    alias_method :attr_f_last_position, :f_last_position
    undef_method :f_last_position
    alias_method :attr_f_last_position=, :f_last_position=
    undef_method :f_last_position=
    
    # The region covered by <code>fLastPosition</code> before the document
    # change.
    attr_accessor :f_last_region
    alias_method :attr_f_last_region, :f_last_region
    undef_method :f_last_region
    alias_method :attr_f_last_region=, :f_last_region=
    undef_method :f_last_region=
    
    typesig { [LinkedPosition] }
    # Adds a position to this group. The document region defined by the
    # position must contain the same content (and thus have the same length) as
    # any of the other positions already in this group. Additionally, all
    # positions added must be disjoint; otherwise a
    # <code>BadLocationException</code> is thrown.
    # <p>
    # Positions added using this method are owned by this group afterwards and
    # may not be updated or modified thereafter.
    # </p>
    # <p>
    # Once a group has been added to a <code>LinkedModeModel</code>, it
    # becomes <em>sealed</em> and no positions may be added any more.
    # </p>
    # 
    # @param position the position to add
    # @throws BadLocationException if the position is invalid or conflicts with
    # other positions in the group
    # @throws IllegalStateException if the group has already been added to a
    # model
    def add_position(position)
      # Enforces constraints and sets the custom iteration flag. If the
      # position is already in this group, nothing happens.
      Assert.is_not_null(position)
      if (@f_is_sealed)
        raise IllegalStateException.new("cannot add positions after the group is added to an model")
      end # $NON-NLS-1$
      if (!@f_positions.contains(position))
        enforce_disjoint(position)
        enforce_equal_content(position)
        @f_positions.add(position)
        @f_has_custom_iteration |= !(position.get_sequence_number).equal?(LinkedPositionGroup::NO_STOP)
      else
        return
      end # nothing happens
    end
    
    typesig { [LinkedPosition] }
    # Enforces the invariant that all positions must contain the same string.
    # 
    # @param position the position to check
    # @throws BadLocationException if the equal content check fails
    def enforce_equal_content(position)
      if (@f_positions.size > 0)
        group_position = @f_positions.get(0)
        group_content = group_position.get_content
        position_content = position.get_content
        if (!(group_content == position_content))
          # $NON-NLS-1$ //$NON-NLS-2$
          raise BadLocationException.new("First position: '" + group_content + "' at " + RJava.cast_to_string(group_position.get_offset) + ", this position: '" + position_content + "' at " + RJava.cast_to_string(position.get_offset))
        end # $NON-NLS-1$ //$NON-NLS-2$
      end
    end
    
    typesig { [LinkedPosition] }
    # Enforces the invariant that all positions must be disjoint.
    # 
    # @param position the position to check
    # @throws BadLocationException if the disjointness check fails
    def enforce_disjoint(position)
      it = @f_positions.iterator
      while it.has_next
        p = it.next_
        if (p.overlaps_with(position))
          raise BadLocationException.new
        end
      end
    end
    
    typesig { [LinkedPositionGroup] }
    # Enforces the disjointness for another group
    # 
    # @param group the group to check
    # @throws BadLocationException if the disjointness check fails
    def enforce_disjoint(group)
      Assert.is_not_null(group)
      it = group.attr_f_positions.iterator
      while it.has_next
        p = it.next_
        enforce_disjoint(p)
      end
    end
    
    typesig { [DocumentEvent] }
    # Checks whether <code>event</code> is a legal event for this group. An
    # event is legal if it touches at most one position contained within this
    # group.
    # 
    # @param event the document event to check
    # @return <code>true</code> if <code>event</code> is legal
    def is_legal_event(event)
      @f_last_position = nil
      @f_last_region = nil
      it = @f_positions.iterator
      while it.has_next
        pos = it.next_
        if (overlaps_or_touches(pos, event))
          if (!(@f_last_position).nil?)
            @f_last_position = nil
            @f_last_region = nil
            return false
          end
          @f_last_position = pos
          @f_last_region = Region.new(pos.get_offset, pos.get_length)
        end
      end
      return true
    end
    
    typesig { [LinkedPosition, DocumentEvent] }
    # Checks whether the given event touches the given position. To touch means
    # to overlap or come up to the borders of the position.
    # 
    # @param position the position
    # @param event the event
    # @return <code>true</code> if <code>position</code> and
    # <code>event</code> are not absolutely disjoint
    # @since 3.1
    def overlaps_or_touches(position, event)
      return (position.get_document == event.get_document) && position.get_offset <= event.get_offset + event.get_length && position.get_offset + position.get_length >= event.get_offset
    end
    
    typesig { [DocumentEvent] }
    # Creates an edition of a document change that will forward any
    # modification in one position to all linked siblings. The return value is
    # a map from <code>IDocument</code> to <code>TextEdit</code>.
    # 
    # @param event the document event to check
    # @return a map of edits, grouped by edited document, or <code>null</code>
    # if there are no edits
    def handle_event(event)
      if (!(@f_last_position).nil?)
        map = HashMap.new
        relative_offset = event.get_offset - @f_last_region.get_offset
        if (relative_offset < 0)
          relative_offset = 0
        end
        event_end = event.get_offset + event.get_length
        last_end = @f_last_region.get_offset + @f_last_region.get_length
        length = 0
        if (event_end > last_end)
          length = last_end - relative_offset - @f_last_region.get_offset
        else
          length = event_end - relative_offset - @f_last_region.get_offset
        end
        text = event.get_text
        if ((text).nil?)
          text = ""
        end # $NON-NLS-1$
        it = @f_positions.iterator
        while it.has_next
          p = it.next_
          if ((p).equal?(@f_last_position) || p.is_deleted)
            next
          end # don't re-update the origin of the change
          edits = map.get(p.get_document)
          if ((edits).nil?)
            edits = ArrayList.new
            map.put(p.get_document, edits)
          end
          edits.add(ReplaceEdit.new(p.get_offset + relative_offset, length, text))
        end
        begin
          it_ = map.key_set.iterator
          while it_.has_next
            d = it_.next_
            edit = MultiTextEdit.new(0, d.get_length)
            edit.add_children((map.get(d)).to_array(Array.typed(TextEdit).new(0) { nil }))
            map.put(d, edit)
          end
          return map
        rescue MalformedTreeException => x
          # may happen during undo, as LinkedModeModel does not know
          # that the changes technically originate from a parent environment
          # if this happens, post notification changes are not accepted anyway and
          # we can simply return null - any changes will be undone by the undo
          # manager
          return nil
        end
      end
      return nil
    end
    
    typesig { [] }
    # Sets the model of this group. Once a model has been set, no
    # more positions can be added and the model cannot be changed.
    def seal
      Assert.is_true(!@f_is_sealed)
      @f_is_sealed = true
      if ((@f_has_custom_iteration).equal?(false) && @f_positions.size > 0)
        (@f_positions.get(0)).set_sequence_number(0)
      end
    end
    
    typesig { [] }
    def get_documents
      docs = Array.typed(IDocument).new(@f_positions.size) { nil }
      i = 0
      it = @f_positions.iterator
      while it.has_next
        pos = it.next_
        docs[i] = pos.get_document
        i += 1
      end
      return docs
    end
    
    typesig { [LinkedModeModel] }
    def register(model)
      it = @f_positions.iterator
      while it.has_next
        pos = it.next_
        model.register(pos)
      end
    end
    
    typesig { [LinkedPositionGroup] }
    # Returns the position in this group that encompasses all positions in
    # <code>group</code>.
    # 
    # @param group the group to be adopted
    # @return a position in the receiver that contains all positions in <code>group</code>,
    # or <code>null</code> if none can be found
    # @throws BadLocationException if more than one position are affected by
    # <code>group</code>
    def adopt(group)
      found = nil
      it = group.attr_f_positions.iterator
      while it.has_next
        pos = it.next_
        local_found = nil
        it2 = @f_positions.iterator
        while it2.has_next
          my_pos = it2.next_
          if (my_pos.includes(pos))
            if ((found).nil?)
              found = my_pos
            else
              if (!(found).equal?(my_pos))
                raise BadLocationException.new
              end
            end
            if ((local_found).nil?)
              local_found = my_pos
            end
          end
        end
        if (!(local_found).equal?(found))
          raise BadLocationException.new
        end
      end
      return found
    end
    
    typesig { [LinkedPosition] }
    # Finds the closest position to <code>toFind</code>.
    # 
    # @param toFind the linked position for which to find the closest position
    # @return the closest position to <code>toFind</code>.
    def get_position(to_find)
      it = @f_positions.iterator
      while it.has_next
        p = it.next_
        if (p.includes(to_find))
          return p
        end
      end
      return nil
    end
    
    typesig { [::Java::Int] }
    # Returns <code>true</code> if <code>offset</code> is contained in any
    # position in this group.
    # 
    # @param offset the offset to check
    # @return <code>true</code> if offset is contained by this group
    def contains(offset)
      it = @f_positions.iterator
      while it.has_next
        pos = it.next_
        if (pos.includes(offset))
          return true
        end
      end
      return false
    end
    
    typesig { [] }
    # Returns whether this group contains any positions.
    # 
    # @return <code>true</code> if this group is empty, <code>false</code> otherwise
    # @since 3.1
    def is_empty
      return (@f_positions.size).equal?(0)
    end
    
    typesig { [] }
    # Returns whether this group contains any positions.
    # 
    # @return <code>true</code> if this group is empty, <code>false</code> otherwise
    # @deprecated As of 3.1, replaced by {@link #isEmpty()}
    def is_emtpy
      return is_empty
    end
    
    typesig { [] }
    # Returns the positions contained in the receiver as an array. The
    # positions are the actual positions and must not be modified; the array
    # is a copy of internal structures.
    # 
    # @return the positions of this group in no particular order
    def get_positions
      return @f_positions.to_array(Array.typed(LinkedPosition).new(0) { nil })
    end
    
    typesig { [Position] }
    # Returns <code>true</code> if the receiver contains <code>position</code>.
    # 
    # @param position the position to check
    # @return <code>true</code> if the receiver contains <code>position</code>
    def contains(position)
      it = @f_positions.iterator
      while it.has_next
        p = it.next_
        if ((position == p))
          return true
        end
      end
      return false
    end
    
    typesig { [] }
    def initialize
      @f_positions = LinkedList.new
      @f_is_sealed = false
      @f_has_custom_iteration = false
      @f_last_position = nil
      @f_last_region = nil
    end
    
    private
    alias_method :initialize__linked_position_group, :initialize
  end
  
end
