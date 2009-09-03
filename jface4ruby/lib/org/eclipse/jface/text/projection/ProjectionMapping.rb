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
  module ProjectionMappingImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Projection
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentInformationMapping
      include_const ::Org::Eclipse::Jface::Text, :IDocumentInformationMappingExtension
      include_const ::Org::Eclipse::Jface::Text, :IDocumentInformationMappingExtension2
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
    }
  end
  
  # Internal class. Do not use. Only public for testing purposes.
  # <p>
  # Implementation of {@link org.eclipse.jface.text.IDocumentInformationMapping}
  # for the projection mapping between a master and a slave document.
  # 
  # @since 3.0
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class ProjectionMapping 
    include_class_members ProjectionMappingImports
    include IDocumentInformationMapping
    include IDocumentInformationMappingExtension
    include IDocumentInformationMappingExtension2
    include IMinimalMapping
    
    class_module.module_eval {
      const_set_lazy(:LEFT) { -1 }
      const_attr_reader  :LEFT
      
      const_set_lazy(:NONE) { 0 }
      const_attr_reader  :NONE
      
      const_set_lazy(:RIGHT) { +1 }
      const_attr_reader  :RIGHT
    }
    
    # The master document
    attr_accessor :f_master_document
    alias_method :attr_f_master_document, :f_master_document
    undef_method :f_master_document
    alias_method :attr_f_master_document=, :f_master_document=
    undef_method :f_master_document=
    
    # The position category used to manage the projection fragments inside the master document
    attr_accessor :f_fragments_category
    alias_method :attr_f_fragments_category, :f_fragments_category
    undef_method :f_fragments_category
    alias_method :attr_f_fragments_category=, :f_fragments_category=
    undef_method :f_fragments_category=
    
    # The projection document
    attr_accessor :f_slave_document
    alias_method :attr_f_slave_document, :f_slave_document
    undef_method :f_slave_document
    alias_method :attr_f_slave_document=, :f_slave_document=
    undef_method :f_slave_document=
    
    # The position category to manage the projection segments inside the slave document.
    attr_accessor :f_segments_category
    alias_method :attr_f_segments_category, :f_segments_category
    undef_method :f_segments_category
    alias_method :attr_f_segments_category=, :f_segments_category=
    undef_method :f_segments_category=
    
    # Cached segments
    attr_accessor :f_cached_segments
    alias_method :attr_f_cached_segments, :f_cached_segments
    undef_method :f_cached_segments
    alias_method :attr_f_cached_segments=, :f_cached_segments=
    undef_method :f_cached_segments=
    
    # Cached fragments
    attr_accessor :f_cached_fragments
    alias_method :attr_f_cached_fragments, :f_cached_fragments
    undef_method :f_cached_fragments
    alias_method :attr_f_cached_fragments=, :f_cached_fragments=
    undef_method :f_cached_fragments=
    
    typesig { [IDocument, String, IDocument, String] }
    # Creates a new mapping between the given parent document and the given projection document.
    # 
    # @param masterDocument the master document
    # @param fragmentsCategory the position category of the parent document used to manage the projected regions
    # @param slaveDocument the slave document
    # @param segmentsCategory the position category of the projection document used to manage the fragments
    def initialize(master_document, fragments_category, slave_document, segments_category)
      @f_master_document = nil
      @f_fragments_category = nil
      @f_slave_document = nil
      @f_segments_category = nil
      @f_cached_segments = nil
      @f_cached_fragments = nil
      @f_master_document = master_document
      @f_fragments_category = fragments_category
      @f_slave_document = slave_document
      @f_segments_category = segments_category
    end
    
    typesig { [] }
    # Notifies this projection mapping that there was a projection change.
    def projection_changed
      @f_cached_segments = nil
      @f_cached_fragments = nil
    end
    
    typesig { [] }
    def get_segments
      if ((@f_cached_segments).nil?)
        begin
          @f_cached_segments = @f_slave_document.get_positions(@f_segments_category)
        rescue BadPositionCategoryException => e
          return Array.typed(Position).new(0) { nil }
        end
      end
      return @f_cached_segments
    end
    
    typesig { [] }
    def get_fragments
      if ((@f_cached_fragments).nil?)
        begin
          @f_cached_fragments = @f_master_document.get_positions(@f_fragments_category)
        rescue BadPositionCategoryException => e
          return Array.typed(Position).new(0) { nil }
        end
      end
      return @f_cached_fragments
    end
    
    typesig { [::Java::Int] }
    def find_segment_index(offset)
      segments = get_segments
      if ((segments.attr_length).equal?(0))
        if (offset > 0)
          raise BadLocationException.new
        end
        return -1
      end
      begin
        index = @f_slave_document.compute_index_in_category(@f_segments_category, offset)
        if ((index).equal?(segments.attr_length) && offset > exclusive_end(segments[index - 1]))
          raise BadLocationException.new
        end
        if (index < segments.attr_length && (offset).equal?(segments[index].attr_offset))
          return index
        end
        if (index > 0)
          index -= 1
        end
        return index
      rescue BadPositionCategoryException => e
        raise IllegalStateException.new
      end
    end
    
    typesig { [::Java::Int] }
    def find_segment(offset)
      check_image_offset(offset)
      index = find_segment_index(offset)
      if ((index).equal?(-1))
        s = Segment.new(0, 0)
        f = Fragment.new(0, 0)
        s.attr_fragment = f
        f.attr_segment = s
        return s
      end
      segments = get_segments
      return segments[index]
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Computes the fragment index given an origin offset. Returns the index of
    # the fragment that contains <code>offset</code>, or <code>-1</code>
    # if no fragment contains <code>offset</code>.
    # <p>
    # If <code>extensionDirection</code> is set to <code>RIGHT</code> or
    # <code>LEFT</code>, the next fragment in that direction is returned if
    # there is no fragment containing <code>offset</code>. Note that if
    # <code>offset</code> occurs before any fragment and
    # <code>extensionDirection</code> is <code>LEFT</code>,
    # <code>-1</code> is also returned. The same applies for an offset after
    # the last fragment and <code>extensionDirection</code> set to
    # <code>RIGHT</code>.
    # </p>
    # 
    # @param offset an origin offset
    # @param extensionDirection the direction in which to extend the search, or
    # <code>NONE</code>
    # @return the index of the fragment containing <code>offset</code>, or
    # <code>-1</code>
    # @throws BadLocationException if the index is not valid on the master
    # document
    def find_fragment_index(offset, extension_direction)
      begin
        fragments = get_fragments
        if ((fragments.attr_length).equal?(0))
          return -1
        end
        index = @f_master_document.compute_index_in_category(@f_fragments_category, offset)
        if (index < fragments.attr_length && (offset).equal?(fragments[index].attr_offset))
          return index
        end
        if (0 < index && index <= fragments.attr_length && fragments[index - 1].includes(offset))
          return index - 1
        end
        case (extension_direction)
        when LEFT
          return index - 1
        when RIGHT
          if (index < fragments.attr_length)
            return index
          end
        end
        return -1
      rescue BadPositionCategoryException => e
        raise IllegalStateException.new
      end
    end
    
    typesig { [::Java::Int] }
    def find_fragment(offset)
      check_origin_offset(offset)
      index = find_fragment_index(offset, NONE)
      fragments = get_fragments
      if ((index).equal?(-1))
        if (fragments.attr_length > 0)
          last = fragments[fragments.attr_length - 1]
          if ((exclusive_end(last)).equal?(offset))
            return last
          end
        end
        return nil
      end
      return fragments[index]
    end
    
    typesig { [IRegion, ::Java::Boolean, ::Java::Boolean] }
    # Returns the image region for <code>originRegion</code>.
    # 
    # @param originRegion the region to get the image for
    # @param exact if <code>true</code>, the begin and end offsets of
    # <code>originRegion</code> must be projected, otherwise
    # <code>null</code> is returned. If <code>false</code>, the
    # begin and end range that is not visible is simply clipped.
    # @param takeClosestImage if <code>false</code>, <code>null</code> is
    # returned if <code>originRegion</code> is completely invisible.
    # If <code>true</code>, the zero-length region is returned that
    # "covers" the hidden origin region
    # @return the image region of <code>originRegion</code>
    # @throws BadLocationException if the region is not a valid origin region
    def to_image_region(origin_region, exact, take_closest_image)
      if ((origin_region.get_length).equal?(0) && !take_closest_image)
        image_offset = to_image_offset(origin_region.get_offset)
        return (image_offset).equal?(-1) ? nil : Region.new(image_offset, 0)
      end
      fragments = find_fragments(origin_region, exact, take_closest_image)
      if ((fragments).nil?)
        if (take_closest_image)
          # originRegion may before the first or after the last fragment
          all_fragments = get_fragments
          if (all_fragments.attr_length > 0)
            # before the first
            if (exclusive_end(origin_region) <= all_fragments[0].get_offset)
              return Region.new(0, 0)
            end
            # after last
            last = all_fragments[all_fragments.attr_length - 1]
            if (origin_region.get_offset >= exclusive_end(last))
              return Region.new(exclusive_end((last).attr_segment), 0)
            end
          end
          return Region.new(0, 0)
        end
        return nil
      end
      image_offset = 0
      exclusive_image_end_offset = 0
      # translate start offset
      relative = origin_region.get_offset - fragments[0].get_offset
      if (relative < 0)
        Assert.is_true(!exact)
        relative = 0
      end
      image_offset = fragments[0].attr_segment.get_offset + relative
      # translate end offset
      relative = exclusive_end(origin_region) - fragments[1].get_offset
      if (relative > fragments[1].get_length)
        Assert.is_true(!exact)
        relative = fragments[1].get_length
      end
      exclusive_image_end_offset = fragments[1].attr_segment.get_offset + relative
      return Region.new(image_offset, exclusive_image_end_offset - image_offset)
    end
    
    typesig { [IRegion, ::Java::Boolean, ::Java::Boolean] }
    # Returns the two fragments containing the begin and end offsets of
    # <code>originRegion</code>.
    # 
    # @param originRegion the region to get the fragments for
    # @param exact if <code>true</code>, only the fragments that contain the
    # begin and end offsets are returned; if <code>false</code>, the
    # first fragment after the begin offset and the last fragment before
    # the end offset are returned if the offsets are not projected
    # @param takeClosestImage if <code>true</code>, the method will return
    # fragments also if <code>originRegion</code> completely lies in
    # an unprojected region.
    # @return the two fragments containing the begin and end offset of
    # <code>originRegion</code>, or <code>null</code> if these do
    # not exist
    # @throws BadLocationException if the region is not a valid origin region
    def find_fragments(origin_region, exact, take_closest_image)
      fragments = get_fragments
      if ((fragments.attr_length).equal?(0))
        return nil
      end
      check_origin_region(origin_region)
      start_fragment_idx = find_fragment_index(origin_region.get_offset, exact ? NONE : RIGHT)
      if ((start_fragment_idx).equal?(-1))
        return nil
      end
      end_fragment_idx = find_fragment_index(inclusive_end(origin_region), exact ? NONE : LEFT)
      if (!take_closest_image && start_fragment_idx > end_fragment_idx || (end_fragment_idx).equal?(-1))
        return nil
      end
      result = Array.typed(Fragment).new([fragments[start_fragment_idx], fragments[end_fragment_idx]])
      return result
    end
    
    typesig { [Segment, ::Java::Int] }
    def create_origin_start_region(image, offset_shift)
      return Region.new(image.attr_fragment.get_offset + offset_shift, image.attr_fragment.get_length - offset_shift)
    end
    
    typesig { [Segment] }
    def create_origin_region(image)
      return Region.new(image.attr_fragment.get_offset, image.attr_fragment.get_length)
    end
    
    typesig { [Segment, ::Java::Int] }
    def create_origin_end_region(image, length_reduction)
      return Region.new(image.attr_fragment.get_offset, image.attr_fragment.get_length - length_reduction)
    end
    
    typesig { [Fragment, ::Java::Int] }
    def create_image_start_region(origin, offset_shift)
      shift = offset_shift > 0 ? offset_shift : 0
      return Region.new(origin.attr_segment.get_offset + shift, origin.attr_segment.get_length - shift)
    end
    
    typesig { [Fragment] }
    def create_image_region(origin)
      return Region.new(origin.attr_segment.get_offset, origin.attr_segment.get_length)
    end
    
    typesig { [Fragment, ::Java::Int] }
    def create_image_end_region(origin, length_reduction)
      reduction = length_reduction > 0 ? length_reduction : 0
      return Region.new(origin.attr_segment.get_offset, origin.attr_segment.get_length - reduction)
    end
    
    typesig { [Fragment, ::Java::Int] }
    def create_origin_start_region(origin, offset_shift)
      shift = offset_shift > 0 ? offset_shift : 0
      return Region.new(origin.get_offset + shift, origin.get_length - shift)
    end
    
    typesig { [Fragment] }
    def create_origin_region(origin)
      return Region.new(origin.get_offset, origin.get_length)
    end
    
    typesig { [Fragment, ::Java::Int] }
    def create_origin_end_region(origin, length_reduction)
      reduction = length_reduction > 0 ? length_reduction : 0
      return Region.new(origin.get_offset, origin.get_length - reduction)
    end
    
    typesig { [IRegion, IRegion] }
    def get_intersecting_region(left, right)
      offset = Math.max(left.get_offset, right.get_offset)
      exclusive_end_offset = Math.min(exclusive_end(left), exclusive_end(right))
      if (exclusive_end_offset < offset)
        return nil
      end
      return Region.new(offset, exclusive_end_offset - offset)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentInformationMapping#getCoverage()
    def get_coverage
      fragments = get_fragments
      if (!(fragments).nil? && fragments.attr_length > 0)
        first = fragments[0]
        last = fragments[fragments.attr_length - 1]
        return Region.new(first.attr_offset, exclusive_end(last) - first.attr_offset)
      end
      return Region.new(0, 0)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocumentInformationMapping#toOriginOffset(int)
    def to_origin_offset(image_offset)
      segment = find_segment(image_offset)
      relative = image_offset - segment.attr_offset
      return segment.attr_fragment.attr_offset + relative
    end
    
    typesig { [IRegion] }
    # @see org.eclipse.jface.text.IDocumentInformationMapping#toOriginRegion(org.eclipse.jface.text.IRegion)
    def to_origin_region(image_region)
      image_offset = image_region.get_offset
      image_length = image_region.get_length
      if ((image_length).equal?(0))
        if ((image_offset).equal?(0))
          fragments = get_fragments
          if ((fragments.attr_length).equal?(0) || ((fragments.attr_length).equal?(1) && (fragments[0].get_offset).equal?(0) && (fragments[0].get_length).equal?(0)))
            return Region.new(0, @f_master_document.get_length)
          end
        end
        return Region.new(to_origin_offset(image_offset), 0)
      end
      origin_offset = to_origin_offset(image_offset)
      inclusive_image_end_offset = image_offset + image_length - 1
      inclusive_origin_end_offset = to_origin_offset(inclusive_image_end_offset)
      return Region.new(origin_offset, (inclusive_origin_end_offset + 1) - origin_offset)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocumentInformationMapping#toOriginLines(int)
    def to_origin_lines(image_line)
      image_region = @f_slave_document.get_line_information(image_line)
      origin_region = to_origin_region(image_region)
      origin_start_line = @f_master_document.get_line_of_offset(origin_region.get_offset)
      if ((origin_region.get_length).equal?(0))
        return Region.new(origin_start_line, 1)
      end
      origin_end_line = @f_master_document.get_line_of_offset(inclusive_end(origin_region))
      return Region.new(origin_start_line, (origin_end_line + 1) - origin_start_line)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocumentInformationMapping#toOriginLine(int)
    def to_origin_line(image_line)
      lines = to_origin_lines(image_line)
      return (lines.get_length > 1 ? -1 : lines.get_offset)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocumentInformationMapping#toImageOffset(int)
    def to_image_offset(origin_offset)
      fragment = find_fragment(origin_offset)
      if (!(fragment).nil?)
        relative = origin_offset - fragment.attr_offset
        return fragment.attr_segment.attr_offset + relative
      end
      return -1
    end
    
    typesig { [IRegion] }
    # @see org.eclipse.jface.text.IDocumentInformationMappingExtension#toExactImageRegion(org.eclipse.jface.text.IRegion)
    def to_exact_image_region(origin_region)
      return to_image_region(origin_region, true, false)
    end
    
    typesig { [IRegion] }
    # @see org.eclipse.jface.text.IDocumentInformationMapping#toImageRegion(org.eclipse.jface.text.IRegion)
    def to_image_region(origin_region)
      return to_image_region(origin_region, false, false)
    end
    
    typesig { [IRegion] }
    # @see org.eclipse.jface.text.IDocumentInformationMappingExtension2#toClosestImageRegion(org.eclipse.jface.text.IRegion)
    # @since 3.1
    def to_closest_image_region(origin_region)
      return to_image_region(origin_region, false, true)
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocumentInformationMapping#toImageLine(int)
    def to_image_line(origin_line)
      origin_region = @f_master_document.get_line_information(origin_line)
      image_region = to_image_region(origin_region)
      if ((image_region).nil?)
        image_offset = to_image_offset(origin_region.get_offset)
        if (image_offset > -1)
          image_region = Region.new(image_offset, 0)
        else
          return -1
        end
      end
      start_line = @f_slave_document.get_line_of_offset(image_region.get_offset)
      if ((image_region.get_length).equal?(0))
        return start_line
      end
      end_line = @f_slave_document.get_line_of_offset(image_region.get_offset + image_region.get_length)
      if (!(end_line).equal?(start_line))
        raise IllegalStateException.new
      end
      return start_line
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IDocumentInformationMapping#toClosestImageLine(int)
    def to_closest_image_line(origin_line)
      begin
        image_line = to_image_line(origin_line)
        if (image_line > -1)
          return image_line
        end
        fragments = get_fragments
        if ((fragments.attr_length).equal?(0))
          return -1
        end
        origin_line_region = @f_master_document.get_line_information(origin_line)
        index = @f_master_document.compute_index_in_category(@f_fragments_category, origin_line_region.get_offset)
        if (0 < index && index < fragments.attr_length)
          left = fragments[index - 1]
          left_distance = origin_line_region.get_offset - (exclusive_end(left))
          right = fragments[index]
          right_distance = right.get_offset - (exclusive_end(origin_line_region))
          if (left_distance <= right_distance)
            origin_line = @f_master_document.get_line_of_offset(left.get_offset + Math.max(left.get_length - 1, 0))
          else
            origin_line = @f_master_document.get_line_of_offset(right.get_offset)
          end
        else
          if ((index).equal?(0))
            right = fragments[index]
            origin_line = @f_master_document.get_line_of_offset(right.get_offset)
          else
            if ((index).equal?(fragments.attr_length))
              left = fragments[index - 1]
              origin_line = @f_master_document.get_line_of_offset(exclusive_end(left))
            end
          end
        end
        return to_image_line(origin_line)
      rescue BadPositionCategoryException => x
      end
      return -1
    end
    
    typesig { [IRegion] }
    # @see org.eclipse.jface.text.IDocumentInformationMappingExtension#toExactOriginRegions(org.eclipse.jface.text.IRegion)
    def to_exact_origin_regions(image_region)
      if ((image_region.get_length).equal?(0))
        return Array.typed(IRegion).new([Region.new(to_origin_offset(image_region.get_offset), 0)])
      end
      end_offset = exclusive_end(image_region)
      segments = get_segments
      first_index = find_segment_index(image_region.get_offset)
      last_index = find_segment_index(end_offset - 1)
      result_length = last_index - first_index + 1
      result = Array.typed(IRegion).new(result_length) { nil }
      # first
      result[0] = create_origin_start_region(segments[first_index], image_region.get_offset - segments[first_index].get_offset)
      # middles
      i = 1
      while i < result_length - 1
        result[i] = create_origin_region(segments[first_index + i])
        i += 1
      end
      # last
      last = segments[last_index]
      segment_end_offset = exclusive_end(last)
      last_region = create_origin_end_region(last, segment_end_offset - end_offset)
      if (result_length > 1)
        # first != last
        result[result_length - 1] = last_region
      else
        # merge first and last
        intersection = get_intersecting_region(result[0], last_region)
        if ((intersection).nil?)
          result = Array.typed(IRegion).new(0) { nil }
        else
          result[0] = intersection
        end
      end
      return result
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentInformationMappingExtension#getImageLength()
    def get_image_length
      segments = get_segments
      length = 0
      i = 0
      while i < segments.attr_length
        length += segments[i].attr_length
        i += 1
      end
      return length
    end
    
    typesig { [IRegion] }
    # @see org.eclipse.jface.text.IDocumentInformationMappingExtension#toExactImageRegions(org.eclipse.jface.text.IRegion)
    def to_exact_image_regions(origin_region)
      offset = origin_region.get_offset
      if ((origin_region.get_length).equal?(0))
        image_offset = to_image_offset(offset)
        return image_offset > -1 ? Array.typed(IRegion).new([Region.new(image_offset, 0)]) : nil
      end
      end_offset = exclusive_end(origin_region)
      fragments = get_fragments
      first_index = find_fragment_index(offset, RIGHT)
      last_index = find_fragment_index(end_offset - 1, LEFT)
      if ((first_index).equal?(-1) || first_index > last_index)
        return nil
      end
      result_length = last_index - first_index + 1
      result = Array.typed(IRegion).new(result_length) { nil }
      # first
      result[0] = create_image_start_region(fragments[first_index], offset - fragments[first_index].get_offset)
      # middles
      i = 1
      while i < result_length - 1
        result[i] = create_image_region(fragments[first_index + i])
        i += 1
      end
      # last
      last = fragments[last_index]
      fragment_end_offset = exclusive_end(last)
      last_region = create_image_end_region(last, fragment_end_offset - end_offset)
      if (result_length > 1)
        # first != last
        result[result_length - 1] = last_region
      else
        # merge first and last
        intersection = get_intersecting_region(result[0], last_region)
        if ((intersection).nil?)
          return nil
        end
        result[0] = intersection
      end
      return result
    end
    
    typesig { [IRegion] }
    # @see org.eclipse.jface.text.IDocumentInformationMappingExtension#getExactCoverage(org.eclipse.jface.text.IRegion)
    def get_exact_coverage(origin_region)
      origin_offset = origin_region.get_offset
      origin_length = origin_region.get_length
      if ((origin_length).equal?(0))
        image_offset = to_image_offset(origin_offset)
        return image_offset > -1 ? Array.typed(IRegion).new([Region.new(origin_offset, 0)]) : nil
      end
      end_offset = origin_offset + origin_length
      fragments = get_fragments
      first_index = find_fragment_index(origin_offset, RIGHT)
      last_index = find_fragment_index(end_offset - 1, LEFT)
      if ((first_index).equal?(-1) || first_index > last_index)
        return nil
      end
      result_length = last_index - first_index + 1
      result = Array.typed(IRegion).new(result_length) { nil }
      # first
      result[0] = create_origin_start_region(fragments[first_index], origin_offset - fragments[first_index].get_offset)
      # middles
      i = 1
      while i < result_length - 1
        result[i] = create_origin_region(fragments[first_index + i])
        i += 1
      end
      # last
      last = fragments[last_index]
      fragment_end_offset = exclusive_end(last)
      last_region = create_origin_end_region(last, fragment_end_offset - end_offset)
      if (result_length > 1)
        # first != last
        result[result_length - 1] = last_region
      else
        # merge first and last
        intersection = get_intersecting_region(result[0], last_region)
        if ((intersection).nil?)
          return nil
        end
        result[0] = intersection
      end
      return result
    end
    
    typesig { [IRegion] }
    def check_origin_region(origin_region)
      offset = origin_region.get_offset
      end_offset = inclusive_end(origin_region)
      max_ = @f_master_document.get_length
      if (offset < 0 || offset > max_ || end_offset < 0 || end_offset > max_)
        raise BadLocationException.new
      end
    end
    
    typesig { [::Java::Int] }
    def check_origin_offset(origin_offset)
      if (origin_offset < 0 || origin_offset > @f_master_document.get_length)
        raise BadLocationException.new
      end
    end
    
    typesig { [::Java::Int] }
    def check_image_offset(image_offset)
      if (image_offset < 0 || image_offset > get_image_length)
        raise BadLocationException.new
      end
    end
    
    typesig { [Position] }
    def exclusive_end(position)
      return position.attr_offset + position.attr_length
    end
    
    typesig { [IRegion] }
    def exclusive_end(region)
      return region.get_offset + region.get_length
    end
    
    typesig { [IRegion] }
    def inclusive_end(region)
      length = region.get_length
      if ((length).equal?(0))
        return region.get_offset
      end
      return region.get_offset + length - 1
    end
    
    private
    alias_method :initialize__projection_mapping, :initialize
  end
  
end
