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
  module ProjectionDocumentImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Projection
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Jface::Text, :AbstractDocument
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :DefaultLineTracker
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentExtension
      include_const ::Org::Eclipse::Jface::Text, :IDocumentInformationMapping
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :ILineTracker
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextStore
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
    }
  end
  
  # A <code>ProjectionDocument</code> represents a projection of its master
  # document. The contents of a projection document is a sequence of fragments of
  # the master document, i.e. the projection document can be thought as being
  # constructed from the master document by not copying the whole master document
  # but omitting several ranges of the master document.
  # <p>
  # The projection document indirectly utilizes its master document as
  # <code>ITextStore</code> by means of a <code>ProjectionTextStore</code>.
  # <p>
  # The content of a projection document can be changed in two ways. Either by a
  # text replace applied to the master document or the projection document. Or by
  # changing the projection between the master document and the projection
  # document. For the latter the two methods <code>addMasterDocumentRange</code>
  # and <code>removeMasterDocumentRange</code> are provided. For any
  # manipulation, the projection document sends out a
  # {@link org.eclipse.jface.text.projection.ProjectionDocumentEvent} describing
  # the change.
  # <p>
  # Clients are not supposed to directly instantiate this class. In order to
  # obtain a projection document, a
  # {@link org.eclipse.jface.text.projection.ProjectionDocumentManager}should be
  # used. This class is not intended to be subclassed outside of its origin
  # package.</p>
  # 
  # @since 3.0
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class ProjectionDocument < ProjectionDocumentImports.const_get :AbstractDocument
    include_class_members ProjectionDocumentImports
    
    class_module.module_eval {
      # Prefix of the name of the position category used to keep track of the master
      # document's fragments that correspond to the segments of the projection
      # document.
      const_set_lazy(:FRAGMENTS_CATEGORY_PREFIX) { "__fragmentsCategory" }
      const_attr_reader  :FRAGMENTS_CATEGORY_PREFIX
      
      # $NON-NLS-1$
      # 
      # Name of the position category used to keep track of the project
      # document's segments that correspond to the fragments of the master
      # document.
      const_set_lazy(:SEGMENTS_CATEGORY) { "__segmentsCategory" }
      const_attr_reader  :SEGMENTS_CATEGORY
    }
    
    # $NON-NLS-1$
    # The master document
    attr_accessor :f_master_document
    alias_method :attr_f_master_document, :f_master_document
    undef_method :f_master_document
    alias_method :attr_f_master_document=, :f_master_document=
    undef_method :f_master_document=
    
    # The master document as document extension
    attr_accessor :f_master_document_extension
    alias_method :attr_f_master_document_extension, :f_master_document_extension
    undef_method :f_master_document_extension
    alias_method :attr_f_master_document_extension=, :f_master_document_extension=
    undef_method :f_master_document_extension=
    
    # The fragments' position category
    attr_accessor :f_fragments_category
    alias_method :attr_f_fragments_category, :f_fragments_category
    undef_method :f_fragments_category
    alias_method :attr_f_fragments_category=, :f_fragments_category=
    undef_method :f_fragments_category=
    
    # The segment's position category
    attr_accessor :f_segments_category
    alias_method :attr_f_segments_category, :f_segments_category
    undef_method :f_segments_category
    alias_method :attr_f_segments_category=, :f_segments_category=
    undef_method :f_segments_category=
    
    # The document event issued by the master document
    attr_accessor :f_master_event
    alias_method :attr_f_master_event, :f_master_event
    undef_method :f_master_event
    alias_method :attr_f_master_event=, :f_master_event=
    undef_method :f_master_event=
    
    # The document event to be issued by the projection document
    attr_accessor :f_slave_event
    alias_method :attr_f_slave_event, :f_slave_event
    undef_method :f_slave_event
    alias_method :attr_f_slave_event=, :f_slave_event=
    undef_method :f_slave_event=
    
    # The original document event generated by a direct manipulation of this projection document
    attr_accessor :f_original_event
    alias_method :attr_f_original_event, :f_original_event
    undef_method :f_original_event
    alias_method :attr_f_original_event=, :f_original_event=
    undef_method :f_original_event=
    
    # Indicates whether the projection document initiated a master document update or not
    attr_accessor :f_is_updating
    alias_method :attr_f_is_updating, :f_is_updating
    undef_method :f_is_updating
    alias_method :attr_f_is_updating=, :f_is_updating=
    undef_method :f_is_updating=
    
    # Indicated whether the projection document is in auto expand mode nor not
    attr_accessor :f_is_auto_expanding
    alias_method :attr_f_is_auto_expanding, :f_is_auto_expanding
    undef_method :f_is_auto_expanding
    alias_method :attr_f_is_auto_expanding=, :f_is_auto_expanding=
    undef_method :f_is_auto_expanding=
    
    # The position updater for the segments
    attr_accessor :f_segment_updater
    alias_method :attr_f_segment_updater, :f_segment_updater
    undef_method :f_segment_updater
    alias_method :attr_f_segment_updater=, :f_segment_updater=
    undef_method :f_segment_updater=
    
    # The position updater for the fragments
    attr_accessor :f_fragments_updater
    alias_method :attr_f_fragments_updater, :f_fragments_updater
    undef_method :f_fragments_updater
    alias_method :attr_f_fragments_updater=, :f_fragments_updater=
    undef_method :f_fragments_updater=
    
    # The projection mapping
    attr_accessor :f_mapping
    alias_method :attr_f_mapping, :f_mapping
    undef_method :f_mapping
    alias_method :attr_f_mapping=, :f_mapping=
    undef_method :f_mapping=
    
    typesig { [IDocument] }
    # Creates a projection document for the given master document.
    # 
    # @param masterDocument the master document
    def initialize(master_document)
      @f_master_document = nil
      @f_master_document_extension = nil
      @f_fragments_category = nil
      @f_segments_category = nil
      @f_master_event = nil
      @f_slave_event = nil
      @f_original_event = nil
      @f_is_updating = false
      @f_is_auto_expanding = false
      @f_segment_updater = nil
      @f_fragments_updater = nil
      @f_mapping = nil
      super()
      @f_is_updating = false
      @f_is_auto_expanding = false
      @f_master_document = master_document
      if (@f_master_document.is_a?(IDocumentExtension))
        @f_master_document_extension = @f_master_document
      end
      @f_segments_category = SEGMENTS_CATEGORY
      @f_fragments_category = FRAGMENTS_CATEGORY_PREFIX + RJava.cast_to_string(hash_code)
      @f_master_document.add_position_category(@f_fragments_category)
      @f_fragments_updater = FragmentUpdater.new(@f_fragments_category)
      @f_master_document.add_position_updater(@f_fragments_updater)
      @f_mapping = ProjectionMapping.new(master_document, @f_fragments_category, self, @f_segments_category)
      s = ProjectionTextStore.new(master_document, @f_mapping)
      tracker = DefaultLineTracker.new
      set_text_store(s)
      set_line_tracker(tracker)
      complete_initialization
      initialize_projection
      tracker.set(s.get(0, s.get_length))
    end
    
    typesig { [] }
    # Disposes this projection document.
    def dispose
      @f_master_document.remove_position_updater(@f_fragments_updater)
      begin
        @f_master_document.remove_position_category(@f_fragments_category)
      rescue BadPositionCategoryException => x
        # allow multiple dispose calls
      end
    end
    
    typesig { [] }
    def internal_error
      raise IllegalStateException.new
    end
    
    typesig { [] }
    # Returns the fragments of the master documents.
    # 
    # @return the fragment of the master document
    def get_fragments
      begin
        return @f_master_document.get_positions(@f_fragments_category)
      rescue BadPositionCategoryException => e
        internal_error
      end
      # unreachable
      return nil
    end
    
    typesig { [] }
    # Returns the segments of this projection document.
    # 
    # @return the segments of this projection document
    def get_segments
      begin
        return get_positions(@f_segments_category)
      rescue BadPositionCategoryException => e
        internal_error
      end
      # unreachable
      return nil
    end
    
    typesig { [] }
    # Returns the projection mapping used by this document.
    # 
    # @return the projection mapping used by this document
    # @deprecated As of 3.4, replaced by {@link #getDocumentInformationMapping()}
    def get_projection_mapping
      return @f_mapping
    end
    
    typesig { [] }
    # Returns the projection mapping used by this document.
    # 
    # @return the projection mapping used by this document
    # @since 3.4
    def get_document_information_mapping
      return @f_mapping
    end
    
    typesig { [] }
    # Returns the master document of this projection document.
    # 
    # @return the master document of this projection document
    def get_master_document
      return @f_master_document
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentExtension4#getDefaultLineDelimiter()
    # @since 3.1
    def get_default_line_delimiter
      return TextUtilities.get_default_line_delimiter(@f_master_document)
    end
    
    typesig { [] }
    # Initializes the projection document from the master document based on
    # the master's fragments.
    def initialize_projection
      begin
        add_position_category(@f_segments_category)
        @f_segment_updater = SegmentUpdater.new(@f_segments_category)
        add_position_updater(@f_segment_updater)
        offset = 0
        fragments = get_fragments
        i = 0
        while i < fragments.attr_length
          fragment = fragments[i]
          segment = Segment.new(offset, fragment.get_length)
          segment.attr_fragment = fragment
          add_position(@f_segments_category, segment)
          offset += fragment.attr_length
          i += 1
        end
      rescue BadPositionCategoryException => x
        internal_error
      rescue BadLocationException => x
        internal_error
      end
    end
    
    typesig { [Fragment, ::Java::Int] }
    # Creates a segment for the given fragment at the given position inside the list of segments.
    # 
    # @param fragment the corresponding fragment
    # @param index the index in the list of segments
    # @return the created segment
    # @throws BadLocationException in case the fragment is invalid
    # @throws BadPositionCategoryException in case the segment category is invalid
    def create_segment_for(fragment, index)
      offset = 0
      if (index > 0)
        segments = get_segments
        segment = segments[index - 1]
        offset = segment.get_offset + segment.get_length
      end
      segment = Segment.new(offset, 0)
      segment.attr_fragment = fragment
      fragment.attr_segment = segment
      add_position(@f_segments_category, segment)
      return segment
    end
    
    typesig { [::Java::Int, ::Java::Int, DocumentEvent] }
    # Adds the given range of the master document to this projection document.
    # 
    # @param offsetInMaster offset of the master document range
    # @param lengthInMaster length of the master document range
    # @param masterDocumentEvent the master document event that causes this
    # projection change or <code>null</code> if none
    # @throws BadLocationException if the given range is invalid in the master
    # document
    def internal_add_master_document_range(offset_in_master, length_in_master, master_document_event)
      if ((length_in_master).equal?(0))
        return
      end
      begin
        fragments = get_fragments
        index = @f_master_document.compute_index_in_category(@f_fragments_category, offset_in_master)
        left = nil
        right = nil
        if (index < fragments.attr_length)
          fragment = fragments[index]
          if ((offset_in_master).equal?(fragment.attr_offset))
            if ((fragment.attr_length).equal?(0))
              # the fragment does not overlap - it is a zero-length fragment at the same offset
              left = fragment
            else
              raise IllegalArgumentException.new("overlaps with existing fragment")
            end
          end # $NON-NLS-1$
          if ((offset_in_master + length_in_master).equal?(fragment.attr_offset))
            right = fragment
          end
        end
        if (0 < index && index <= fragments.attr_length)
          fragment = fragments[index - 1]
          if (fragment.includes(offset_in_master))
            raise IllegalArgumentException.new("overlaps with existing fragment")
          end # $NON-NLS-1$
          if ((fragment.get_offset + fragment.get_length).equal?(offset_in_master))
            left = fragment
          end
        end
        offset_in_slave = 0
        if (index > 0)
          fragment = fragments[index - 1]
          segment = fragment.attr_segment
          offset_in_slave = segment.get_offset + segment.get_length
        end
        event = ProjectionDocumentEvent.new(self, offset_in_slave, 0, @f_master_document.get(offset_in_master, length_in_master), offset_in_master, length_in_master, master_document_event)
        AbstractDocument.instance_method(:fire_document_about_to_be_changed).bind(self).call(event)
        # check for neighboring fragment
        if (!(left).nil? && !(right).nil?)
          end_offset = right.get_offset + right.get_length
          left.set_length(end_offset - left.get_offset)
          left.attr_segment.set_length(left.attr_segment.get_length + right.attr_segment.get_length)
          remove_position(@f_segments_category, right.attr_segment)
          @f_master_document.remove_position(@f_fragments_category, right)
        else
          if (!(left).nil?)
            end_offset = offset_in_master + length_in_master
            left.set_length(end_offset - left.get_offset)
            left.attr_segment.mark_for_stretch
          else
            if (!(right).nil?)
              right.set_offset(right.get_offset - length_in_master)
              right.set_length(right.get_length + length_in_master)
              right.attr_segment.mark_for_stretch
            else
              # create a new segment
              fragment = Fragment.new(offset_in_master, length_in_master)
              @f_master_document.add_position(@f_fragments_category, fragment)
              segment = create_segment_for(fragment, index)
              segment.mark_for_stretch
            end
          end
        end
        get_tracker.replace(event.get_offset, event.get_length, event.get_text)
        AbstractDocument.instance_method(:fire_document_changed).bind(self).call(event)
      rescue BadPositionCategoryException => x
        internal_error
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Finds the fragment of the master document that represents the given range.
    # 
    # @param offsetInMaster the offset of the range in the master document
    # @param lengthInMaster the length of the range in the master document
    # @return the fragment representing the given master document range
    def find_fragment(offset_in_master, length_in_master)
      fragments = get_fragments
      i = 0
      while i < fragments.attr_length
        f = fragments[i]
        if (f.get_offset <= offset_in_master && offset_in_master + length_in_master <= f.get_offset + f.get_length)
          return f
        end
        i += 1
      end
      return nil
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Removes the given range of the master document from this projection
    # document.
    # 
    # @param offsetInMaster the offset of the range in the master document
    # @param lengthInMaster the length of the range in the master document
    # 
    # @throws BadLocationException if the given range is not valid in the
    # master document
    # @throws IllegalArgumentException if the given range is not projected in
    # this projection document or is not completely comprised by
    # an existing fragment
    def internal_remove_master_document_range(offset_in_master, length_in_master)
      begin
        image_region = @f_mapping.to_exact_image_region(Region.new(offset_in_master, length_in_master))
        if ((image_region).nil?)
          raise IllegalArgumentException.new
        end
        fragment = find_fragment(offset_in_master, length_in_master)
        if ((fragment).nil?)
          raise IllegalArgumentException.new
        end
        event = ProjectionDocumentEvent.new(self, image_region.get_offset, image_region.get_length, "", offset_in_master, length_in_master) # $NON-NLS-1$
        AbstractDocument.instance_method(:fire_document_about_to_be_changed).bind(self).call(event)
        if ((fragment.get_offset).equal?(offset_in_master))
          fragment.set_offset(offset_in_master + length_in_master)
          fragment.set_length(fragment.get_length - length_in_master)
        else
          if ((fragment.get_offset + fragment.get_length).equal?(offset_in_master + length_in_master))
            fragment.set_length(fragment.get_length - length_in_master)
          else
            # split fragment into three fragments, let position updater remove it
            # add fragment for the region to be removed
            new_fragment = Fragment.new(offset_in_master, length_in_master)
            segment = Segment.new(image_region.get_offset, image_region.get_length)
            new_fragment.attr_segment = segment
            segment.attr_fragment = new_fragment
            @f_master_document.add_position(@f_fragments_category, new_fragment)
            add_position(@f_segments_category, segment)
            # add fragment for the remainder right of the deleted range in the original fragment
            offset = offset_in_master + length_in_master
            new_fragment = Fragment.new(offset, fragment.get_offset + fragment.get_length - offset)
            offset = image_region.get_offset + image_region.get_length
            segment = Segment.new(offset, fragment.attr_segment.get_offset + fragment.attr_segment.get_length - offset)
            new_fragment.attr_segment = segment
            segment.attr_fragment = new_fragment
            @f_master_document.add_position(@f_fragments_category, new_fragment)
            add_position(@f_segments_category, segment)
            # adjust length of initial fragment (the left one)
            fragment.set_length(offset_in_master - fragment.get_offset)
            fragment.attr_segment.set_length(image_region.get_offset - fragment.attr_segment.get_offset)
          end
        end
        get_tracker.replace(event.get_offset, event.get_length, event.get_text)
        AbstractDocument.instance_method(:fire_document_changed).bind(self).call(event)
      rescue BadPositionCategoryException => x
        internal_error
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the sequence of all master document regions which are contained
    # in the given master document range and which are not yet part of this
    # projection document.
    # 
    # @param offsetInMaster the range offset in the master document
    # @param lengthInMaster the range length in the master document
    # @return the sequence of regions which are not yet part of the projection
    # document
    # @throws BadLocationException in case the given range is invalid in the
    # master document
    def compute_unprojected_master_regions(offset_in_master, length_in_master)
      fragments = nil
      image_region = @f_mapping.to_image_region(Region.new(offset_in_master, length_in_master))
      if (!(image_region).nil?)
        fragments = @f_mapping.to_exact_origin_regions(image_region)
      end
      if ((fragments).nil? || (fragments.attr_length).equal?(0))
        return Array.typed(IRegion).new([Region.new(offset_in_master, length_in_master)])
      end
      gaps = ArrayList.new
      region = fragments[0]
      if (offset_in_master < region.get_offset)
        gaps.add(Region.new(offset_in_master, region.get_offset - offset_in_master))
      end
      i = 0
      while i < fragments.attr_length - 1
        left = fragments[i]
        right = fragments[i + 1]
        left_end = left.get_offset + left.get_length
        if (left_end < right.get_offset)
          gaps.add(Region.new(left_end, right.get_offset - left_end))
        end
        i += 1
      end
      region = fragments[fragments.attr_length - 1]
      left_end = region.get_offset + region.get_length
      right_end = offset_in_master + length_in_master
      if (left_end < right_end)
        gaps.add(Region.new(left_end, right_end - left_end))
      end
      result = Array.typed(IRegion).new(gaps.size) { nil }
      gaps.to_array(result)
      return result
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the first master document region which is contained in the given
    # master document range and which is not yet part of this projection
    # document.
    # 
    # @param offsetInMaster the range offset in the master document
    # @param lengthInMaster the range length in the master document
    # @return the first region that is not yet part of the projection document
    # @throws BadLocationException in case the given range is invalid in the
    # master document
    # @since 3.1
    def compute_first_unprojected_master_region(offset_in_master, length_in_master)
      fragments = nil
      image_region = @f_mapping.to_image_region(Region.new(offset_in_master, length_in_master))
      if (!(image_region).nil?)
        fragments = @f_mapping.to_exact_origin_regions(image_region)
      end
      if ((fragments).nil? || (fragments.attr_length).equal?(0))
        return Region.new(offset_in_master, length_in_master)
      end
      region = fragments[0]
      if (offset_in_master < region.get_offset)
        return Region.new(offset_in_master, region.get_offset - offset_in_master)
      end
      i = 0
      while i < fragments.attr_length - 1
        left = fragments[i]
        right = fragments[i + 1]
        left_end = left.get_offset + left.get_length
        if (left_end < right.get_offset)
          return Region.new(left_end, right.get_offset - left_end)
        end
        i += 1
      end
      region = fragments[fragments.attr_length - 1]
      left_end = region.get_offset + region.get_length
      right_end = offset_in_master + length_in_master
      if (left_end < right_end)
        return Region.new(left_end, right_end - left_end)
      end
      return nil
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Ensures that the given range of the master document is part of this
    # projection document.
    # 
    # @param offsetInMaster the offset of the master document range
    # @param lengthInMaster the length of the master document range
    # @throws BadLocationException in case the master event is not valid
    def add_master_document_range(offset_in_master, length_in_master)
      add_master_document_range(offset_in_master, length_in_master, nil)
    end
    
    typesig { [::Java::Int, ::Java::Int, DocumentEvent] }
    # Ensures that the given range of the master document is part of this
    # projection document.
    # 
    # @param offsetInMaster the offset of the master document range
    # @param lengthInMaster the length of the master document range
    # @param masterDocumentEvent the master document event which causes this
    # projection change, or <code>null</code> if none
    # @throws BadLocationException in case the master event is not valid
    def add_master_document_range(offset_in_master, length_in_master, master_document_event)
      # Calling internalAddMasterDocumentRange may cause other master ranges
      # to become unfolded, resulting in re-entrant calls to this method. In
      # order to not add a region twice, we have to compute the next region
      # to add in every iteration.
      # 
      # To place an upper bound on the number of iterations, we use the number
      # of fragments * 2 as the limit.
      limit = Math.max(get_fragments.attr_length * 2, 20)
      while (true)
        if (((limit -= 1) + 1) < 0)
          raise IllegalArgumentException.new("safety loop termination")
        end # $NON-NLS-1$
        gap = compute_first_unprojected_master_region(offset_in_master, length_in_master)
        if ((gap).nil?)
          return
        end
        internal_add_master_document_range(gap.get_offset, gap.get_length, master_document_event)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Ensures that the given range of the master document is not part of this
    # projection document.
    # 
    # @param offsetInMaster the offset of the master document range
    # @param lengthInMaster the length of the master document range
    # @throws BadLocationException in case the master event is not valid
    def remove_master_document_range(offset_in_master, length_in_master)
      fragments = compute_projected_master_regions(offset_in_master, length_in_master)
      if ((fragments).nil? || (fragments.attr_length).equal?(0))
        return
      end
      i = 0
      while i < fragments.attr_length
        fragment = fragments[i]
        internal_remove_master_document_range(fragment.get_offset, fragment.get_length)
        i += 1
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the sequence of all master document regions with are contained in the given master document
    # range and which are part of this projection document. May return <code>null</code> if no such
    # regions exist.
    # 
    # @param offsetInMaster the range offset in the master document
    # @param lengthInMaster the range length in the master document
    # @return the sequence of regions which are part of the projection document or <code>null</code>
    # @throws BadLocationException in case the given range is invalid in the master document
    def compute_projected_master_regions(offset_in_master, length_in_master)
      image_region = @f_mapping.to_image_region(Region.new(offset_in_master, length_in_master))
      return !(image_region).nil? ? @f_mapping.to_exact_origin_regions(image_region) : nil
    end
    
    typesig { [] }
    # Returns whether this projection is being updated.
    # 
    # @return <code>true</code> if the document is updating
    def is_updating
      return @f_is_updating
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @see org.eclipse.jface.text.IDocument#replace(int, int, java.lang.String)
    def replace(offset, length, text)
      begin
        @f_is_updating = true
        if (!(@f_master_document_extension).nil?)
          @f_master_document_extension.stop_post_notification_processing
        end
        super(offset, length, text)
      ensure
        @f_is_updating = false
        if (!(@f_master_document_extension).nil?)
          @f_master_document_extension.resume_post_notification_processing
        end
      end
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.IDocument#set(java.lang.String)
    def set(text)
      begin
        @f_is_updating = true
        if (!(@f_master_document_extension).nil?)
          @f_master_document_extension.stop_post_notification_processing
        end
        super(text)
      ensure
        @f_is_updating = false
        if (!(@f_master_document_extension).nil?)
          @f_master_document_extension.resume_post_notification_processing
        end
      end
    end
    
    typesig { [DocumentEvent] }
    # Transforms a document event of the master document into a projection
    # document based document event.
    # 
    # @param masterEvent the master document event
    # @return the slave document event
    # @throws BadLocationException in case the master event is not valid
    def normalize(master_event)
      if (!is_updating)
        image_region = @f_mapping.to_exact_image_region(Region.new(master_event.get_offset, master_event.get_length))
        if (!(image_region).nil?)
          return ProjectionDocumentEvent.new(self, image_region.get_offset, image_region.get_length, master_event.get_text, master_event)
        end
        return nil
      end
      event = ProjectionDocumentEvent.new(self, @f_original_event.get_offset, @f_original_event.get_length, @f_original_event.get_text, master_event)
      @f_original_event = nil
      return event
    end
    
    typesig { [DocumentEvent] }
    # Ensures that when the master event affects this projection document, that the whole region described by the
    # event is part of this projection document.
    # 
    # @param masterEvent the master document event
    # @return <code>true</code> if masterEvent affects this projection document
    # @throws BadLocationException in case the master event is not valid
    def adapt_projection_to_master_change(master_event)
      if (!is_updating && @f_fragments_updater.affects_positions(master_event) || @f_is_auto_expanding && master_event.get_length > 0)
        add_master_document_range(master_event.get_offset, master_event.get_length, master_event)
        return true
      else
        if ((@f_mapping.get_image_length).equal?(0) && (master_event.get_length).equal?(0))
          fragments = get_fragments
          if ((fragments.attr_length).equal?(0))
            # there is no segment in this projection document, thus one must be created
            # need to bypass the usual infrastructure as the new segment/fragment would be of length 0 and thus the segmentation be not well formed
            begin
              fragment = Fragment.new(0, 0)
              @f_master_document.add_position(@f_fragments_category, fragment)
              create_segment_for(fragment, 0)
            rescue BadPositionCategoryException => x
              internal_error
            end
          end
        end
      end
      return is_updating
    end
    
    typesig { [DocumentEvent] }
    # When called, this projection document is informed about a forthcoming
    # change of its master document. This projection document checks whether
    # the master document change affects it and if so informs all document
    # listeners.
    # 
    # @param masterEvent the master document event
    def master_document_about_to_be_changed(master_event)
      begin
        assert_not_null = adapt_projection_to_master_change(master_event)
        @f_slave_event = normalize(master_event)
        if (assert_not_null && (@f_slave_event).nil?)
          internal_error
        end
        @f_master_event = master_event
        if (!(@f_slave_event).nil?)
          delayed_fire_document_about_to_be_changed
        end
      rescue BadLocationException => e
        internal_error
      end
    end
    
    typesig { [DocumentEvent] }
    # When called, this projection document is informed about a change of its
    # master document. If this projection document is affected it informs all
    # of its document listeners.
    # 
    # @param masterEvent the master document event
    def master_document_changed(master_event)
      if (!is_updating && (master_event).equal?(@f_master_event))
        if (!(@f_slave_event).nil?)
          begin
            get_tracker.replace(@f_slave_event.get_offset, @f_slave_event.get_length, @f_slave_event.get_text)
            fire_document_changed(@f_slave_event)
          rescue BadLocationException => e
            internal_error
          end
        else
          if (ensure_well_formed_segmentation(master_event.get_offset))
            @f_mapping.projection_changed
          end
        end
      end
    end
    
    typesig { [DocumentEvent] }
    # @see org.eclipse.jface.text.AbstractDocument#fireDocumentAboutToBeChanged(org.eclipse.jface.text.DocumentEvent)
    def fire_document_about_to_be_changed(event)
      @f_original_event = event
      # delay it until there is a notification from the master document
      # at this point, it is expensive to construct the master document information
    end
    
    typesig { [] }
    # Fires the slave document event as about-to-be-changed event to all registered listeners.
    def delayed_fire_document_about_to_be_changed
      AbstractDocument.instance_method(:fire_document_about_to_be_changed).bind(self).call(@f_slave_event)
    end
    
    typesig { [DocumentEvent] }
    # Ignores the given event and sends the semantically equal slave document event instead.
    # 
    # @param event the event to be ignored
    def fire_document_changed(event)
      super(@f_slave_event)
    end
    
    typesig { [DocumentEvent] }
    # @see org.eclipse.jface.text.AbstractDocument#updateDocumentStructures(org.eclipse.jface.text.DocumentEvent)
    def update_document_structures(event)
      super(event)
      ensure_well_formed_segmentation(compute_anchor(event))
      @f_mapping.projection_changed
    end
    
    typesig { [DocumentEvent] }
    def compute_anchor(event)
      if (event.is_a?(ProjectionDocumentEvent))
        slave = event
        change_type = slave.get_change_type
        if ((ProjectionDocumentEvent::CONTENT_CHANGE).equal?(change_type))
          master = slave.get_master_event
          if (!(master).nil?)
            return master.get_offset
          end
        else
          if ((ProjectionDocumentEvent::PROJECTION_CHANGE).equal?(change_type))
            return slave.get_master_offset
          end
        end
      end
      return -1
    end
    
    typesig { [::Java::Int] }
    def ensure_well_formed_segmentation(anchor_offset)
      changed = false
      segments = get_segments
      i = 0
      while i < segments.attr_length
        segment = segments[i]
        if (segment.is_deleted || (segment.get_length).equal?(0))
          begin
            remove_position(@f_segments_category, segment)
            @f_master_document.remove_position(@f_fragments_category, segment.attr_fragment)
            changed = true
          rescue BadPositionCategoryException => e
            internal_error
          end
        else
          if (i < segments.attr_length - 1)
            next_ = segments[i + 1]
            if (next_.is_deleted || (next_.get_length).equal?(0))
              i += 1
              next
            end
            fragment = segment.attr_fragment
            if ((fragment.get_offset + fragment.get_length).equal?(next_.attr_fragment.get_offset))
              # join fragments and their corresponding segments
              segment.set_length(segment.get_length + next_.get_length)
              fragment.set_length(fragment.get_length + next_.attr_fragment.get_length)
              next_.delete
            end
          end
        end
        i += 1
      end
      if (changed && !(anchor_offset).equal?(-1))
        changed_segments = get_segments
        if ((changed_segments).nil? || (changed_segments.attr_length).equal?(0))
          fragment = Fragment.new(anchor_offset, 0)
          begin
            @f_master_document.add_position(@f_fragments_category, fragment)
            create_segment_for(fragment, 0)
          rescue BadLocationException => e
            internal_error
          rescue BadPositionCategoryException => e
            internal_error
          end
        end
      end
      return changed
    end
    
    typesig { [IDocumentListener, IDocumentExtension::IReplace] }
    # @see IDocumentExtension#registerPostNotificationReplace(IDocumentListener, IDocumentExtension.IReplace)
    def register_post_notification_replace(owner, replace)
      if (!is_updating)
        raise UnsupportedOperationException.new
      end
      super(owner, replace)
    end
    
    typesig { [::Java::Boolean] }
    # Sets the auto expand mode for this document.
    # 
    # @param autoExpandMode <code>true</code> if auto-expanding
    def set_auto_expand_mode(auto_expand_mode)
      @f_is_auto_expanding = auto_expand_mode
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Replaces all master document ranges with the given master document range.
    # 
    # @param offsetInMaster the offset in the master document
    # @param lengthInMaster the length in the master document
    # @throws BadLocationException if the given range of the master document is not valid
    def replace_master_document_ranges(offset_in_master, length_in_master)
      begin
        event = ProjectionDocumentEvent.new(self, 0, @f_mapping.get_image_length, @f_master_document.get(offset_in_master, length_in_master), offset_in_master, length_in_master)
        AbstractDocument.instance_method(:fire_document_about_to_be_changed).bind(self).call(event)
        fragments = get_fragments
        i = 0
        while i < fragments.attr_length
          fragment = fragments[i]
          @f_master_document.remove_position(@f_fragments_category, fragment)
          remove_position(@f_segments_category, fragment.attr_segment)
          i += 1
        end
        fragment = Fragment.new(offset_in_master, length_in_master)
        segment = Segment.new(0, 0)
        segment.attr_fragment = fragment
        fragment.attr_segment = segment
        @f_master_document.add_position(@f_fragments_category, fragment)
        add_position(@f_segments_category, segment)
        get_tracker.set(@f_master_document.get(offset_in_master, length_in_master))
        AbstractDocument.instance_method(:fire_document_changed).bind(self).call(event)
      rescue BadPositionCategoryException => x
        internal_error
      end
    end
    
    private
    alias_method :initialize__projection_document, :initialize
  end
  
end
