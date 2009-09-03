require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Projection
  module SegmentUpdaterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Projection
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :DefaultPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  # The position updater used to adapt the segments of a projection document to
  # changes of the master document. Depending on the flags set on a segment, a
  # segment is either extended to shifted if an insertion happens at a segment's
  # offset. The last segment is extended if an insert operation happens at the
  # end of the segment.
  # 
  # @since 3.0
  class SegmentUpdater < SegmentUpdaterImports.const_get :DefaultPositionUpdater
    include_class_members SegmentUpdaterImports
    
    attr_accessor :f_next_segment
    alias_method :attr_f_next_segment, :f_next_segment
    undef_method :f_next_segment
    alias_method :attr_f_next_segment=, :f_next_segment=
    undef_method :f_next_segment=
    
    attr_accessor :f_is_projection_change
    alias_method :attr_f_is_projection_change, :f_is_projection_change
    undef_method :f_is_projection_change
    alias_method :attr_f_is_projection_change=, :f_is_projection_change=
    undef_method :f_is_projection_change=
    
    typesig { [String] }
    # Creates the segment updater for the given category.
    # 
    # @param segmentCategory the position category used for managing the segments of a projection document
    def initialize(segment_category)
      @f_next_segment = nil
      @f_is_projection_change = false
      super(segment_category)
      @f_next_segment = nil
      @f_is_projection_change = false
    end
    
    typesig { [DocumentEvent] }
    # @see org.eclipse.jface.text.IPositionUpdater#update(org.eclipse.jface.text.DocumentEvent)
    def update(event)
      Assert.is_true(event.is_a?(ProjectionDocumentEvent))
      @f_is_projection_change = ((event).get_change_type).equal?(ProjectionDocumentEvent::PROJECTION_CHANGE)
      begin
        category = event.get_document.get_positions(get_category)
        self.attr_f_offset = event.get_offset
        self.attr_f_length = event.get_length
        self.attr_f_replace_length = ((event.get_text).nil? ? 0 : event.get_text.length)
        self.attr_f_document = event.get_document
        i = 0
        while i < category.attr_length
          self.attr_f_position = category[i]
          Assert.is_true(self.attr_f_position.is_a?(Segment))
          if (i < category.attr_length - 1)
            @f_next_segment = category[i + 1]
          else
            @f_next_segment = nil
          end
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
      segment = self.attr_f_position
      my_start = segment.attr_offset
      my_end = segment.attr_offset + segment.attr_length - (segment.attr_is_marked_for_stretch || (@f_next_segment).nil? || is_affecting_replace ? 0 : 1)
      my_end = Math.max(my_start, my_end)
      yours_start = self.attr_f_offset
      begin
        if (my_end < yours_start)
          return
        end
        if (segment.attr_is_marked_for_stretch)
          Assert.is_true(@f_is_projection_change)
          segment.attr_is_marked_for_shift = false
          if (!(@f_next_segment).nil?)
            @f_next_segment.attr_is_marked_for_shift = true
            @f_next_segment.attr_is_marked_for_stretch = false
          end
        end
        if (self.attr_f_length <= 0)
          if (my_start < (yours_start + (segment.attr_is_marked_for_shift ? 0 : 1)))
            self.attr_f_position.attr_length += self.attr_f_replace_length
          else
            self.attr_f_position.attr_offset += self.attr_f_replace_length
          end
        else
          if (my_start <= yours_start && self.attr_f_original_position.attr_offset <= yours_start)
            self.attr_f_position.attr_length += self.attr_f_replace_length
          else
            self.attr_f_position.attr_offset += self.attr_f_replace_length
          end
        end
      ensure
        segment.clear_mark
      end
    end
    
    private
    alias_method :initialize__segment_updater, :initialize
  end
  
end
