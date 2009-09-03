require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DefaultPositionUpdaterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Default implementation of {@link org.eclipse.jface.text.IPositionUpdater}.
  # <p>
  # A default position updater must be configured with the position category whose positions it will
  # update. Other position categories are not affected by this updater.
  # </p>
  # <p>
  # This implementation follows the specification below:
  # </p>
  # <ul>
  # <li>Inserting or deleting text before the position shifts the position accordingly.</li>
  # <li>Inserting text at the position offset shifts the position accordingly.</li>
  # <li>Inserting or deleting text strictly contained by the position shrinks or stretches the
  # position.</li>
  # <li>Inserting or deleting text after a position does not affect the position.</li>
  # <li>Deleting text which strictly contains the position deletes the position. Note that the
  # position is not deleted if its only shrunken to length zero. To delete a position, the
  # modification must delete from <i>strictly before</i> to <i>strictly after</i> the position.</li>
  # <li>Replacing text overlapping with the position is considered as a sequence of first deleting
  # the replaced text and afterwards inserting the new text. Thus, a position might first be shifted
  # and shrunken and then be stretched.</li>
  # </ul>
  # This class can be used as is or be adapted by subclasses. Fields are protected to allow
  # subclasses direct access. Because of the frequency with which position updaters are used this is
  # a performance decision.
  class DefaultPositionUpdater 
    include_class_members DefaultPositionUpdaterImports
    include IPositionUpdater
    
    # The position category the updater draws responsible for
    attr_accessor :f_category
    alias_method :attr_f_category, :f_category
    undef_method :f_category
    alias_method :attr_f_category=, :f_category=
    undef_method :f_category=
    
    # Caches the currently investigated position
    attr_accessor :f_position
    alias_method :attr_f_position, :f_position
    undef_method :f_position
    alias_method :attr_f_position=, :f_position=
    undef_method :f_position=
    
    # Remembers the original state of the investigated position
    # @since 2.1
    attr_accessor :f_original_position
    alias_method :attr_f_original_position, :f_original_position
    undef_method :f_original_position
    alias_method :attr_f_original_position=, :f_original_position=
    undef_method :f_original_position=
    
    # Caches the offset of the replaced text
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    # Caches the length of the replaced text
    attr_accessor :f_length
    alias_method :attr_f_length, :f_length
    undef_method :f_length
    alias_method :attr_f_length=, :f_length=
    undef_method :f_length=
    
    # Caches the length of the newly inserted text
    attr_accessor :f_replace_length
    alias_method :attr_f_replace_length, :f_replace_length
    undef_method :f_replace_length
    alias_method :attr_f_replace_length=, :f_replace_length=
    undef_method :f_replace_length=
    
    # Catches the document
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    typesig { [String] }
    # Creates a new default position updater for the given category.
    # 
    # @param category the category the updater is responsible for
    def initialize(category)
      @f_category = nil
      @f_position = nil
      @f_original_position = Position.new(0, 0)
      @f_offset = 0
      @f_length = 0
      @f_replace_length = 0
      @f_document = nil
      @f_category = category
    end
    
    typesig { [] }
    # Returns the category this updater is responsible for.
    # 
    # @return the category this updater is responsible for
    def get_category
      return @f_category
    end
    
    typesig { [] }
    # Returns whether the current event describes a well formed replace
    # by which the current position is directly affected.
    # 
    # @return <code>true</code> the current position is directly affected
    # @since 3.0
    def is_affecting_replace
      return @f_length > 0 && @f_replace_length > 0 && @f_position.attr_length < @f_original_position.attr_length
    end
    
    typesig { [] }
    # Adapts the currently investigated position to an insertion.
    def adapt_to_insert
      my_start = @f_position.attr_offset
      my_end = @f_position.attr_offset + @f_position.attr_length - 1
      my_end = Math.max(my_start, my_end)
      yours_start = @f_offset
      yours_end = @f_offset + @f_replace_length - 1
      yours_end = Math.max(yours_start, yours_end)
      if (my_end < yours_start)
        return
      end
      if (@f_length <= 0)
        if (my_start < yours_start)
          @f_position.attr_length += @f_replace_length
        else
          @f_position.attr_offset += @f_replace_length
        end
      else
        if (my_start <= yours_start && @f_original_position.attr_offset <= yours_start)
          @f_position.attr_length += @f_replace_length
        else
          @f_position.attr_offset += @f_replace_length
        end
      end
    end
    
    typesig { [] }
    # Adapts the currently investigated position to a deletion.
    def adapt_to_remove
      my_start = @f_position.attr_offset
      my_end = @f_position.attr_offset + @f_position.attr_length - 1
      my_end = Math.max(my_start, my_end)
      yours_start = @f_offset
      yours_end = @f_offset + @f_length - 1
      yours_end = Math.max(yours_start, yours_end)
      if (my_end < yours_start)
        return
      end
      if (my_start <= yours_start)
        if (yours_end <= my_end)
          @f_position.attr_length -= @f_length
        else
          @f_position.attr_length -= (my_end - yours_start + 1)
        end
      else
        if (yours_start < my_start)
          if (yours_end < my_start)
            @f_position.attr_offset -= @f_length
          else
            @f_position.attr_offset -= (my_start - yours_start)
            @f_position.attr_length -= (yours_end - my_start + 1)
          end
        end
      end
      # validate position to allowed values
      if (@f_position.attr_offset < 0)
        @f_position.attr_offset = 0
      end
      if (@f_position.attr_length < 0)
        @f_position.attr_length = 0
      end
    end
    
    typesig { [] }
    # Adapts the currently investigated position to the replace operation.
    # First it checks whether the change replaces the whole range of the position.
    # If not, it performs first the deletion of the previous text and afterwards
    # the insertion of the new text.
    def adapt_to_replace
      if ((@f_position.attr_offset).equal?(@f_offset) && (@f_position.attr_length).equal?(@f_length) && @f_position.attr_length > 0)
        # replace the whole range of the position
        @f_position.attr_length += (@f_replace_length - @f_length)
        if (@f_position.attr_length < 0)
          @f_position.attr_offset += @f_position.attr_length
          @f_position.attr_length = 0
        end
      else
        if (@f_length > 0)
          adapt_to_remove
        end
        if (@f_replace_length > 0)
          adapt_to_insert
        end
      end
    end
    
    typesig { [] }
    # Determines whether the currently investigated position has been deleted by
    # the replace operation specified in the current event. If so, it deletes
    # the position and removes it from the document's position category.
    # 
    # @return <code>true</code> if position has not been deleted
    def not_deleted
      if (@f_offset < @f_position.attr_offset && (@f_position.attr_offset + @f_position.attr_length < @f_offset + @f_length))
        @f_position.delete
        begin
          @f_document.remove_position(@f_category, @f_position)
        rescue BadPositionCategoryException => x
        end
        return false
      end
      return true
    end
    
    typesig { [DocumentEvent] }
    # @see org.eclipse.jface.text.IPositionUpdater#update(org.eclipse.jface.text.DocumentEvent)
    def update(event)
      begin
        @f_offset = event.get_offset
        @f_length = event.get_length
        @f_replace_length = ((event.get_text).nil? ? 0 : event.get_text.length)
        @f_document = event.get_document
        category = @f_document.get_positions(@f_category)
        i = 0
        while i < category.attr_length
          @f_position = category[i]
          @f_original_position.attr_offset = @f_position.attr_offset
          @f_original_position.attr_length = @f_position.attr_length
          if (not_deleted)
            adapt_to_replace
          end
          i += 1
        end
      rescue BadPositionCategoryException => x
        # do nothing
      ensure
        @f_document = nil
      end
    end
    
    private
    alias_method :initialize__default_position_updater, :initialize
  end
  
end
