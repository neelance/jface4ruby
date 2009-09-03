require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Projection
  module FragmentUpdaterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Projection
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :DefaultPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  # The position updater used to adapt the fragments of a master document. If an
  # insertion happens at a fragment's offset, the fragment is extended rather
  # than shifted. Also, the last fragment is extended if an insert operation
  # happens at the end of the fragment.
  # 
  # @since 3.0
  class FragmentUpdater < FragmentUpdaterImports.const_get :DefaultPositionUpdater
    include_class_members FragmentUpdaterImports
    
    # Indicates whether the position being updated represents the last fragment.
    attr_accessor :f_is_last
    alias_method :attr_f_is_last, :f_is_last
    undef_method :f_is_last
    alias_method :attr_f_is_last=, :f_is_last=
    undef_method :f_is_last=
    
    typesig { [String] }
    # Creates the fragment updater for the given category.
    # 
    # @param fragmentCategory the position category used for managing the fragments of a document
    def initialize(fragment_category)
      @f_is_last = false
      super(fragment_category)
      @f_is_last = false
    end
    
    typesig { [DocumentEvent] }
    # @see org.eclipse.jface.text.IPositionUpdater#update(org.eclipse.jface.text.DocumentEvent)
    def update(event)
      begin
        category = event.get_document.get_positions(get_category)
        self.attr_f_offset = event.get_offset
        self.attr_f_length = event.get_length
        self.attr_f_replace_length = ((event.get_text).nil? ? 0 : event.get_text.length)
        self.attr_f_document = event.get_document
        i = 0
        while i < category.attr_length
          self.attr_f_position = category[i]
          @f_is_last = ((i).equal?(category.attr_length - 1))
          self.attr_f_original_position.attr_offset = self.attr_f_position.attr_offset
          self.attr_f_original_position.attr_length = self.attr_f_position.attr_length
          if (not_deleted)
            adapt_to_replace
          end
          i += 1
        end
      rescue BadPositionCategoryException => x
        # do nothing
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.DefaultPositionUpdater#adaptToInsert()
    def adapt_to_insert
      my_start = self.attr_f_position.attr_offset
      my_end = Math.max(my_start, self.attr_f_position.attr_offset + self.attr_f_position.attr_length - (@f_is_last || is_affecting_replace ? 0 : 1))
      if (my_end < self.attr_f_offset)
        return
      end
      if (self.attr_f_length <= 0)
        if (my_start <= self.attr_f_offset)
          self.attr_f_position.attr_length += self.attr_f_replace_length
        else
          self.attr_f_position.attr_offset += self.attr_f_replace_length
        end
      else
        if (my_start <= self.attr_f_offset && self.attr_f_original_position.attr_offset <= self.attr_f_offset)
          self.attr_f_position.attr_length += self.attr_f_replace_length
        else
          self.attr_f_position.attr_offset += self.attr_f_replace_length
        end
      end
    end
    
    typesig { [DocumentEvent] }
    # Returns whether this updater considers any position affected by the given document event. A
    # position is affected if <code>event</code> {@link Position#overlapsWith(int, int) overlaps}
    # with it but not if the position is only shifted.
    # 
    # @param event the event
    # @return <code>true</code> if there is any affected position, <code>false</code> otherwise
    def affects_positions(event)
      document = event.get_document
      begin
        index = document.compute_index_in_category(get_category, event.get_offset)
        fragments = document.get_positions(get_category)
        if (0 < index)
          fragment = fragments[index - 1]
          if (fragment.overlaps_with(event.get_offset, event.get_length))
            return true
          end
          if ((index).equal?(fragments.attr_length) && (fragment.attr_offset + fragment.attr_length).equal?(event.get_offset))
            return true
          end
        end
        if (index < fragments.attr_length)
          fragment = fragments[index]
          return fragment.overlaps_with(event.get_offset, event.get_length)
        end
      rescue BadLocationException => x
      rescue BadPositionCategoryException => x
      end
      return false
    end
    
    private
    alias_method :initialize__fragment_updater, :initialize
  end
  
end
