require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Rules
  module DefaultPartitionerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :DefaultPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :DocumentRewriteSession
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentPartitioner
      include_const ::Org::Eclipse::Jface::Text, :IDocumentPartitionerExtension
      include_const ::Org::Eclipse::Jface::Text, :IDocumentPartitionerExtension2
      include_const ::Org::Eclipse::Jface::Text, :IDocumentPartitionerExtension3
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITypedRegion
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
      include_const ::Org::Eclipse::Jface::Text, :TypedPosition
      include_const ::Org::Eclipse::Jface::Text, :TypedRegion
    }
  end
  
  # A standard implementation of a document partitioner. It uses a partition
  # token scanner to scan the document and to determine the document's
  # partitioning. The tokens returned by the scanner are supposed to return the
  # partition type as their data. The partitioner remembers the document's
  # partitions in the document itself rather than maintaining its own data
  # structure.
  # 
  # @see IPartitionTokenScanner
  # @since 2.0
  # @deprecated As of 3.1, replaced by {@link org.eclipse.jface.text.rules.FastPartitioner} instead
  class DefaultPartitioner 
    include_class_members DefaultPartitionerImports
    include IDocumentPartitioner
    include IDocumentPartitionerExtension
    include IDocumentPartitionerExtension2
    include IDocumentPartitionerExtension3
    
    class_module.module_eval {
      # The position category this partitioner uses to store the document's partitioning information.
      # @deprecated As of 3.0, use <code>getManagingPositionCategories()</code> instead.
      const_set_lazy(:CONTENT_TYPES_CATEGORY) { "__content_types_category" }
      const_attr_reader  :CONTENT_TYPES_CATEGORY
    }
    
    # $NON-NLS-1$
    # The partitioner's scanner
    attr_accessor :f_scanner
    alias_method :attr_f_scanner, :f_scanner
    undef_method :f_scanner
    alias_method :attr_f_scanner=, :f_scanner=
    undef_method :f_scanner=
    
    # The legal content types of this partitioner
    attr_accessor :f_legal_content_types
    alias_method :attr_f_legal_content_types, :f_legal_content_types
    undef_method :f_legal_content_types
    alias_method :attr_f_legal_content_types=, :f_legal_content_types=
    undef_method :f_legal_content_types=
    
    # The partitioner's document
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The document length before a document change occurred
    attr_accessor :f_previous_document_length
    alias_method :attr_f_previous_document_length, :f_previous_document_length
    undef_method :f_previous_document_length
    alias_method :attr_f_previous_document_length=, :f_previous_document_length=
    undef_method :f_previous_document_length=
    
    # The position updater used to for the default updating of partitions
    attr_accessor :f_position_updater
    alias_method :attr_f_position_updater, :f_position_updater
    undef_method :f_position_updater
    alias_method :attr_f_position_updater=, :f_position_updater=
    undef_method :f_position_updater=
    
    # The offset at which the first changed partition starts
    attr_accessor :f_start_offset
    alias_method :attr_f_start_offset, :f_start_offset
    undef_method :f_start_offset
    alias_method :attr_f_start_offset=, :f_start_offset=
    undef_method :f_start_offset=
    
    # The offset at which the last changed partition ends
    attr_accessor :f_end_offset
    alias_method :attr_f_end_offset, :f_end_offset
    undef_method :f_end_offset
    alias_method :attr_f_end_offset=, :f_end_offset=
    undef_method :f_end_offset=
    
    # The offset at which a partition has been deleted
    attr_accessor :f_delete_offset
    alias_method :attr_f_delete_offset, :f_delete_offset
    undef_method :f_delete_offset
    alias_method :attr_f_delete_offset=, :f_delete_offset=
    undef_method :f_delete_offset=
    
    # The position category this partitioner uses to store the document's partitioning information.
    # @since 3.0
    attr_accessor :f_position_category
    alias_method :attr_f_position_category, :f_position_category
    undef_method :f_position_category
    alias_method :attr_f_position_category=, :f_position_category=
    undef_method :f_position_category=
    
    # The active document rewrite session.
    # @since 3.1
    attr_accessor :f_active_rewrite_session
    alias_method :attr_f_active_rewrite_session, :f_active_rewrite_session
    undef_method :f_active_rewrite_session
    alias_method :attr_f_active_rewrite_session=, :f_active_rewrite_session=
    undef_method :f_active_rewrite_session=
    
    # Flag indicating whether this partitioner has been initialized.
    # @since 3.1
    attr_accessor :f_is_initialized
    alias_method :attr_f_is_initialized, :f_is_initialized
    undef_method :f_is_initialized
    alias_method :attr_f_is_initialized=, :f_is_initialized=
    undef_method :f_is_initialized=
    
    typesig { [IPartitionTokenScanner, Array.typed(String)] }
    # Creates a new partitioner that uses the given scanner and may return
    # partitions of the given legal content types.
    # 
    # @param scanner the scanner this partitioner is supposed to use
    # @param legalContentTypes the legal content types of this partitioner
    def initialize(scanner, legal_content_types)
      @f_scanner = nil
      @f_legal_content_types = nil
      @f_document = nil
      @f_previous_document_length = 0
      @f_position_updater = nil
      @f_start_offset = 0
      @f_end_offset = 0
      @f_delete_offset = 0
      @f_position_category = nil
      @f_active_rewrite_session = nil
      @f_is_initialized = false
      @f_scanner = scanner
      @f_legal_content_types = TextUtilities.copy(legal_content_types)
      @f_position_category = CONTENT_TYPES_CATEGORY + RJava.cast_to_string(hash_code)
      @f_position_updater = DefaultPositionUpdater.new(@f_position_category)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentPartitionerExtension2#getManagingPositionCategories()
    # @since 3.0
    def get_managing_position_categories
      return Array.typed(String).new([@f_position_category])
    end
    
    typesig { [IDocument] }
    # @see org.eclipse.jface.text.IDocumentPartitioner#connect(org.eclipse.jface.text.IDocument)
    def connect(document)
      connect(document, false)
    end
    
    typesig { [IDocument, ::Java::Boolean] }
    # @see org.eclipse.jface.text.IDocumentPartitionerExtension3#connect(org.eclipse.jface.text.IDocument, boolean)
    # @since 3.1
    def connect(document, delay_initialization)
      Assert.is_not_null(document)
      Assert.is_true(!document.contains_position_category(@f_position_category))
      @f_document = document
      @f_document.add_position_category(@f_position_category)
      @f_is_initialized = false
      if (!delay_initialization)
        check_initialization
      end
    end
    
    typesig { [] }
    # @since 3.1
    def check_initialization
      if (!@f_is_initialized)
        initialize_
      end
    end
    
    typesig { [] }
    # Performs the initial partitioning of the partitioner's document.
    def initialize_
      @f_is_initialized = true
      @f_scanner.set_range(@f_document, 0, @f_document.get_length)
      begin
        token = @f_scanner.next_token
        while (!token.is_eof)
          content_type = get_token_content_type(token)
          if (is_supported_content_type(content_type))
            p = TypedPosition.new(@f_scanner.get_token_offset, @f_scanner.get_token_length, content_type)
            @f_document.add_position(@f_position_category, p)
          end
          token = @f_scanner.next_token
        end
      rescue BadLocationException => x
        # cannot happen as offsets come from scanner
      rescue BadPositionCategoryException => x
        # cannot happen if document has been connected before
      end
    end
    
    typesig { [] }
    # @see IDocumentPartitioner#disconnect()
    def disconnect
      Assert.is_true(@f_document.contains_position_category(@f_position_category))
      begin
        @f_document.remove_position_category(@f_position_category)
      rescue BadPositionCategoryException => x
        # can not happen because of Assert
      end
    end
    
    typesig { [DocumentEvent] }
    # @see IDocumentPartitioner#documentAboutToBeChanged(DocumentEvent)
    def document_about_to_be_changed(e)
      if (@f_is_initialized)
        Assert.is_true((e.get_document).equal?(@f_document))
        @f_previous_document_length = e.get_document.get_length
        @f_start_offset = -1
        @f_end_offset = -1
        @f_delete_offset = -1
      end
    end
    
    typesig { [DocumentEvent] }
    # @see IDocumentPartitioner#documentChanged(DocumentEvent)
    def document_changed(e)
      if (@f_is_initialized)
        region = document_changed2(e)
        return (!(region).nil?)
      end
      return false
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Helper method for tracking the minimal region containing all partition changes.
    # If <code>offset</code> is smaller than the remembered offset, <code>offset</code>
    # will from now on be remembered. If <code>offset  + length</code> is greater than
    # the remembered end offset, it will be remembered from now on.
    # 
    # @param offset the offset
    # @param length the length
    def remember_region(offset, length)
      # remember start offset
      if ((@f_start_offset).equal?(-1))
        @f_start_offset = offset
      else
        if (offset < @f_start_offset)
          @f_start_offset = offset
        end
      end
      # remember end offset
      end_offset = offset + length
      if ((@f_end_offset).equal?(-1))
        @f_end_offset = end_offset
      else
        if (end_offset > @f_end_offset)
          @f_end_offset = end_offset
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Remembers the given offset as the deletion offset.
    # 
    # @param offset the offset
    def remember_deleted_offset(offset)
      @f_delete_offset = offset
    end
    
    typesig { [] }
    # Creates the minimal region containing all partition changes using the
    # remembered offset, end offset, and deletion offset.
    # 
    # @return the minimal region containing all the partition changes
    def create_region
      if ((@f_delete_offset).equal?(-1))
        if ((@f_start_offset).equal?(-1) || (@f_end_offset).equal?(-1))
          return nil
        end
        return Region.new(@f_start_offset, @f_end_offset - @f_start_offset)
      else
        if ((@f_start_offset).equal?(-1) || (@f_end_offset).equal?(-1))
          return Region.new(@f_delete_offset, 0)
        else
          offset = Math.min(@f_delete_offset, @f_start_offset)
          end_offset = Math.max(@f_delete_offset, @f_end_offset)
          return Region.new(offset, end_offset - offset)
        end
      end
    end
    
    typesig { [DocumentEvent] }
    # @see IDocumentPartitionerExtension#documentChanged2(DocumentEvent)
    # @since 2.0
    def document_changed2(e)
      if (!@f_is_initialized)
        return nil
      end
      begin
        d = e.get_document
        category = d.get_positions(@f_position_category)
        line = d.get_line_information_of_offset(e.get_offset)
        reparse_start = line.get_offset
        partition_start = -1
        content_type = nil
        new_length = (e.get_text).nil? ? 0 : e.get_text.length
        first = d.compute_index_in_category(@f_position_category, reparse_start)
        if (first > 0)
          partition = category[first - 1]
          if (partition.includes(reparse_start))
            partition_start = partition.get_offset
            content_type = RJava.cast_to_string(partition.get_type)
            if ((e.get_offset).equal?(partition.get_offset + partition.get_length))
              reparse_start = partition_start
            end
            (first -= 1)
          else
            if ((reparse_start).equal?(e.get_offset) && (reparse_start).equal?(partition.get_offset + partition.get_length))
              partition_start = partition.get_offset
              content_type = RJava.cast_to_string(partition.get_type)
              reparse_start = partition_start
              (first -= 1)
            else
              partition_start = partition.get_offset + partition.get_length
              content_type = RJava.cast_to_string(IDocument::DEFAULT_CONTENT_TYPE)
            end
          end
        end
        @f_position_updater.update(e)
        i = first
        while i < category.attr_length
          p = category[i]
          if (p.attr_is_deleted)
            remember_deleted_offset(e.get_offset)
            break
          end
          i += 1
        end
        category = d.get_positions(@f_position_category)
        @f_scanner.set_partial_range(d, reparse_start, d.get_length - reparse_start, content_type, partition_start)
        last_scanned_position = reparse_start
        token = @f_scanner.next_token
        while (!token.is_eof)
          content_type = RJava.cast_to_string(get_token_content_type(token))
          if (!is_supported_content_type(content_type))
            token = @f_scanner.next_token
            next
          end
          start = @f_scanner.get_token_offset
          length = @f_scanner.get_token_length
          last_scanned_position = start + length - 1
          # remove all affected positions
          while (first < category.attr_length)
            p = category[first]
            if (last_scanned_position >= p.attr_offset + p.attr_length || (p.overlaps_with(start, length) && (!d.contains_position(@f_position_category, start, length) || !(content_type == p.get_type))))
              remember_region(p.attr_offset, p.attr_length)
              d.remove_position(@f_position_category, p)
              (first += 1)
            else
              break
            end
          end
          # if position already exists and we have scanned at least the
          # area covered by the event, we are done
          if (d.contains_position(@f_position_category, start, length))
            if (last_scanned_position >= e.get_offset + new_length)
              return create_region
            end
            (first += 1)
          else
            # insert the new type position
            begin
              d.add_position(@f_position_category, TypedPosition.new(start, length, content_type))
              remember_region(start, length)
            rescue BadPositionCategoryException => x
            rescue BadLocationException => x
            end
          end
          token = @f_scanner.next_token
        end
        # remove all positions behind lastScannedPosition since there aren't any further types
        if (!(last_scanned_position).equal?(reparse_start))
          # if this condition is not met, nothing has been scanned because of a deletion
          (last_scanned_position += 1)
        end
        first = d.compute_index_in_category(@f_position_category, last_scanned_position)
        category = d.get_positions(@f_position_category)
        p = nil
        while (first < category.attr_length)
          p = category[((first += 1) - 1)]
          d.remove_position(@f_position_category, p)
          remember_region(p.attr_offset, p.attr_length)
        end
      rescue BadPositionCategoryException => x
        # should never happen on connected documents
      rescue BadLocationException => x
      end
      return create_region
    end
    
    typesig { [::Java::Int] }
    # Returns the position in the partitoner's position category which is
    # close to the given offset. This is, the position has either an offset which
    # is the same as the given offset or an offset which is smaller than the given
    # offset. This method profits from the knowledge that a partitioning is
    # a ordered set of disjoint position.
    # 
    # @param offset the offset for which to search the closest position
    # @return the closest position in the partitioner's category
    def find_closest_position(offset)
      begin
        index = @f_document.compute_index_in_category(@f_position_category, offset)
        category = @f_document.get_positions(@f_position_category)
        if ((category.attr_length).equal?(0))
          return nil
        end
        if (index < category.attr_length)
          if ((offset).equal?(category[index].attr_offset))
            return category[index]
          end
        end
        if (index > 0)
          index -= 1
        end
        return category[index]
      rescue BadPositionCategoryException => x
      rescue BadLocationException => x
      end
      return nil
    end
    
    typesig { [::Java::Int] }
    # @see IDocumentPartitioner#getContentType(int)
    def get_content_type(offset)
      check_initialization
      p = find_closest_position(offset)
      if (!(p).nil? && p.includes(offset))
        return p.get_type
      end
      return IDocument::DEFAULT_CONTENT_TYPE
    end
    
    typesig { [::Java::Int] }
    # @see IDocumentPartitioner#getPartition(int)
    def get_partition(offset)
      check_initialization
      begin
        category = @f_document.get_positions(@f_position_category)
        if ((category).nil? || (category.attr_length).equal?(0))
          return TypedRegion.new(0, @f_document.get_length, IDocument::DEFAULT_CONTENT_TYPE)
        end
        index = @f_document.compute_index_in_category(@f_position_category, offset)
        if (index < category.attr_length)
          next_ = category[index]
          if ((offset).equal?(next_.attr_offset))
            return TypedRegion.new(next_.get_offset, next_.get_length, next_.get_type)
          end
          if ((index).equal?(0))
            return TypedRegion.new(0, next_.attr_offset, IDocument::DEFAULT_CONTENT_TYPE)
          end
          previous = category[index - 1]
          if (previous.includes(offset))
            return TypedRegion.new(previous.get_offset, previous.get_length, previous.get_type)
          end
          end_offset = previous.get_offset + previous.get_length
          return TypedRegion.new(end_offset, next_.get_offset - end_offset, IDocument::DEFAULT_CONTENT_TYPE)
        end
        previous = category[category.attr_length - 1]
        if (previous.includes(offset))
          return TypedRegion.new(previous.get_offset, previous.get_length, previous.get_type)
        end
        end_offset = previous.get_offset + previous.get_length
        return TypedRegion.new(end_offset, @f_document.get_length - end_offset, IDocument::DEFAULT_CONTENT_TYPE)
      rescue BadPositionCategoryException => x
      rescue BadLocationException => x
      end
      return TypedRegion.new(0, @f_document.get_length, IDocument::DEFAULT_CONTENT_TYPE)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see IDocumentPartitioner#computePartitioning(int, int)
    def compute_partitioning(offset, length)
      return compute_partitioning(offset, length, false)
    end
    
    typesig { [] }
    # @see IDocumentPartitioner#getLegalContentTypes()
    def get_legal_content_types
      return TextUtilities.copy(@f_legal_content_types)
    end
    
    typesig { [String] }
    # Returns whether the given type is one of the legal content types.
    # 
    # @param contentType the content type to check
    # @return <code>true</code> if the content type is a legal content type
    def is_supported_content_type(content_type)
      if (!(content_type).nil?)
        i = 0
        while i < @f_legal_content_types.attr_length
          if ((@f_legal_content_types[i] == content_type))
            return true
          end
          i += 1
        end
      end
      return false
    end
    
    typesig { [IToken] }
    # Returns a content type encoded in the given token. If the token's
    # data is not <code>null</code> and a string it is assumed that
    # it is the encoded content type.
    # 
    # @param token the token whose content type is to be determined
    # @return the token's content type
    def get_token_content_type(token)
      data = token.get_data
      if (data.is_a?(String))
        return data
      end
      return nil
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # zero-length partition support
    # 
    # @see org.eclipse.jface.text.IDocumentPartitionerExtension2#getContentType(int)
    # @since 3.0
    def get_content_type(offset, prefer_open_partitions)
      return get_partition(offset, prefer_open_partitions).get_type
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # @see org.eclipse.jface.text.IDocumentPartitionerExtension2#getPartition(int)
    # @since 3.0
    def get_partition(offset, prefer_open_partitions)
      region = get_partition(offset)
      if (prefer_open_partitions)
        if ((region.get_offset).equal?(offset) && !(region.get_type == IDocument::DEFAULT_CONTENT_TYPE))
          if (offset > 0)
            region = get_partition(offset - 1)
            if ((region.get_type == IDocument::DEFAULT_CONTENT_TYPE))
              return region
            end
          end
          return TypedRegion.new(offset, 0, IDocument::DEFAULT_CONTENT_TYPE)
        end
      end
      return region
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
    # @see org.eclipse.jface.text.IDocumentPartitionerExtension2#computePartitioning(int, int, boolean)
    # @since 3.0
    def compute_partitioning(offset, length, include_zero_length_partitions)
      check_initialization
      list = ArrayList.new
      begin
        end_offset = offset + length
        category = @f_document.get_positions(@f_position_category)
        previous = nil
        current = nil
        start = 0
        end_ = 0
        gap_offset = 0
        gap = Position.new(0)
        start_index = get_first_index_ending_after_offset(category, offset)
        end_index = get_first_index_starting_after_offset(category, end_offset)
        i = start_index
        while i < end_index
          current = category[i]
          gap_offset = (!(previous).nil?) ? previous.get_offset + previous.get_length : 0
          gap.set_offset(gap_offset)
          gap.set_length(current.get_offset - gap_offset)
          if ((include_zero_length_partitions && overlaps_or_touches(gap, offset, length)) || (gap.get_length > 0 && gap.overlaps_with(offset, length)))
            start = Math.max(offset, gap_offset)
            end_ = Math.min(end_offset, gap.get_offset + gap.get_length)
            list.add(TypedRegion.new(start, end_ - start, IDocument::DEFAULT_CONTENT_TYPE))
          end
          if (current.overlaps_with(offset, length))
            start = Math.max(offset, current.get_offset)
            end_ = Math.min(end_offset, current.get_offset + current.get_length)
            list.add(TypedRegion.new(start, end_ - start, current.get_type))
          end
          previous = current
          i += 1
        end
        if (!(previous).nil?)
          gap_offset = previous.get_offset + previous.get_length
          gap.set_offset(gap_offset)
          gap.set_length(@f_document.get_length - gap_offset)
          if ((include_zero_length_partitions && overlaps_or_touches(gap, offset, length)) || (gap.get_length > 0 && gap.overlaps_with(offset, length)))
            start = Math.max(offset, gap_offset)
            end_ = Math.min(end_offset, @f_document.get_length)
            list.add(TypedRegion.new(start, end_ - start, IDocument::DEFAULT_CONTENT_TYPE))
          end
        end
        if (list.is_empty)
          list.add(TypedRegion.new(offset, length, IDocument::DEFAULT_CONTENT_TYPE))
        end
      rescue BadPositionCategoryException => x
      end
      result = Array.typed(TypedRegion).new(list.size) { nil }
      list.to_array(result)
      return result
    end
    
    typesig { [Position, ::Java::Int, ::Java::Int] }
    # Returns <code>true</code> if the given ranges overlap with or touch each other.
    # 
    # @param gap the first range
    # @param offset the offset of the second range
    # @param length the length of the second range
    # @return <code>true</code> if the given ranges overlap with or touch each other
    # @since 3.0
    def overlaps_or_touches(gap, offset, length)
      return gap.get_offset <= offset + length && offset <= gap.get_offset + gap.get_length
    end
    
    typesig { [Array.typed(Position), ::Java::Int] }
    # Returns the index of the first position which ends after the given offset.
    # 
    # @param positions the positions in linear order
    # @param offset the offset
    # @return the index of the first position which ends after the offset
    # 
    # @since 3.0
    def get_first_index_ending_after_offset(positions, offset)
      i = -1
      j = positions.attr_length
      while (j - i > 1)
        k = (i + j) >> 1
        p = positions[k]
        if (p.get_offset + p.get_length > offset)
          j = k
        else
          i = k
        end
      end
      return j
    end
    
    typesig { [Array.typed(Position), ::Java::Int] }
    # Returns the index of the first position which starts at or after the given offset.
    # 
    # @param positions the positions in linear order
    # @param offset the offset
    # @return the index of the first position which starts after the offset
    # 
    # @since 3.0
    def get_first_index_starting_after_offset(positions, offset)
      i = -1
      j = positions.attr_length
      while (j - i > 1)
        k = (i + j) >> 1
        p = positions[k]
        if (p.get_offset >= offset)
          j = k
        else
          i = k
        end
      end
      return j
    end
    
    typesig { [DocumentRewriteSession] }
    # @see org.eclipse.jface.text.IDocumentPartitionerExtension3#startRewriteSession(org.eclipse.jface.text.DocumentRewriteSession)
    # @since 3.1
    def start_rewrite_session(session)
      if (!(@f_active_rewrite_session).nil?)
        raise IllegalStateException.new
      end
      @f_active_rewrite_session = session
    end
    
    typesig { [DocumentRewriteSession] }
    # @see org.eclipse.jface.text.IDocumentPartitionerExtension3#stopRewriteSession(org.eclipse.jface.text.DocumentRewriteSession)
    # @since 3.1
    def stop_rewrite_session(session)
      if ((@f_active_rewrite_session).equal?(session))
        flush_rewrite_session
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IDocumentPartitionerExtension3#getActiveRewriteSession()
    # @since 3.1
    def get_active_rewrite_session
      return @f_active_rewrite_session
    end
    
    typesig { [] }
    # Flushes the active rewrite session.
    # 
    # @since 3.1
    def flush_rewrite_session
      @f_active_rewrite_session = nil
      # remove all position belonging to the partitioner position category
      begin
        @f_document.remove_position_category(@f_position_category)
      rescue BadPositionCategoryException => x
      end
      @f_document.add_position_category(@f_position_category)
      @f_is_initialized = false
    end
    
    private
    alias_method :initialize__default_partitioner, :initialize
  end
  
end
