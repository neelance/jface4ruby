require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Formatter
  module ContentFormatterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Formatter
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :DefaultPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentExtension3
      include_const ::Org::Eclipse::Jface::Text, :IPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITypedRegion
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
      include_const ::Org::Eclipse::Jface::Text, :TypedPosition
    }
  end
  
  # Standard implementation of <code>IContentFormatter</code>.
  # The formatter supports two operation modes: partition aware and
  # partition unaware. <p>
  # In the partition aware mode, the formatter determines the
  # partitioning of the document region to be formatted. For each
  # partition it determines all document positions  which are affected
  # when text changes are applied to the partition. Those which overlap
  # with the partition are remembered as character positions. These
  # character positions are passed over to the formatting strategy
  # registered for the partition's content type. The formatting strategy
  # returns a string containing the formatted document partition as well
  # as the adapted character positions. The formatted partition replaces
  # the old content of the partition. The remembered document positions
  # are updated with the adapted character positions. In addition, all
  # other document positions are accordingly adapted to the formatting
  # changes.<p>
  # In the partition unaware mode, the document's partitioning is ignored
  # and the document is considered consisting of only one partition of
  # the content type <code>IDocument.DEFAULT_CONTENT_TYPE</code>. The
  # formatting process is similar to the partition aware mode, with the
  # exception of having only one partition.<p>
  # Usually, clients instantiate this class and configure it before using it.
  # 
  # @see IContentFormatter
  # @see IDocument
  # @see ITypedRegion
  # @see Position
  class ContentFormatter 
    include_class_members ContentFormatterImports
    include IContentFormatter
    
    class_module.module_eval {
      # Defines a reference to either the offset or the end offset of
      # a particular position.
      const_set_lazy(:PositionReference) { Class.new do
        include_class_members ContentFormatter
        include JavaComparable
        
        # The referenced position
        attr_accessor :f_position
        alias_method :attr_f_position, :f_position
        undef_method :f_position
        alias_method :attr_f_position=, :f_position=
        undef_method :f_position=
        
        # The reference to either the offset or the end offset
        attr_accessor :f_refers_to_offset
        alias_method :attr_f_refers_to_offset, :f_refers_to_offset
        undef_method :f_refers_to_offset
        alias_method :attr_f_refers_to_offset=, :f_refers_to_offset=
        undef_method :f_refers_to_offset=
        
        # The original category of the referenced position
        attr_accessor :f_category
        alias_method :attr_f_category, :f_category
        undef_method :f_category
        alias_method :attr_f_category=, :f_category=
        undef_method :f_category=
        
        typesig { [class_self::Position, ::Java::Boolean, String] }
        # Creates a new position reference.
        # 
        # @param position the position to be referenced
        # @param refersToOffset <code>true</code> if position offset should be referenced
        # @param category the category the given position belongs to
        def initialize(position, refers_to_offset, category)
          @f_position = nil
          @f_refers_to_offset = false
          @f_category = nil
          @f_position = position
          @f_refers_to_offset = refers_to_offset
          @f_category = category
        end
        
        typesig { [] }
        # Returns the offset of the referenced position.
        # 
        # @return the offset of the referenced position
        def get_offset
          return @f_position.get_offset
        end
        
        typesig { [::Java::Int] }
        # Manipulates the offset of the referenced position.
        # 
        # @param offset the new offset of the referenced position
        def set_offset(offset)
          @f_position.set_offset(offset)
        end
        
        typesig { [] }
        # Returns the length of the referenced position.
        # 
        # @return the length of the referenced position
        def get_length
          return @f_position.get_length
        end
        
        typesig { [::Java::Int] }
        # Manipulates the length of the referenced position.
        # 
        # @param length the new length of the referenced position
        def set_length(length)
          @f_position.set_length(length)
        end
        
        typesig { [] }
        # Returns whether this reference points to the offset or end offset
        # of the references position.
        # 
        # @return <code>true</code> if the offset of the position is referenced, <code>false</code> otherwise
        def refers_to_offset
          return @f_refers_to_offset
        end
        
        typesig { [] }
        # Returns the category of the referenced position.
        # 
        # @return the category of the referenced position
        def get_category
          return @f_category
        end
        
        typesig { [] }
        # Returns the referenced position.
        # 
        # @return the referenced position
        def get_position
          return @f_position
        end
        
        typesig { [] }
        # Returns the referenced character position
        # 
        # @return the referenced character position
        def get_character_position
          if (@f_refers_to_offset)
            return get_offset
          end
          return get_offset + get_length
        end
        
        typesig { [Object] }
        # @see Comparable#compareTo(Object)
        def compare_to(obj)
          if (obj.is_a?(self.class::PositionReference))
            r = obj
            return get_character_position - r.get_character_position
          end
          raise self.class::ClassCastException.new
        end
        
        private
        alias_method :initialize__position_reference, :initialize
      end }
      
      # The position updater used to update the remembered partitions.
      # 
      # @see IPositionUpdater
      # @see DefaultPositionUpdater
      const_set_lazy(:NonDeletingPositionUpdater) { Class.new(DefaultPositionUpdater) do
        local_class_in ContentFormatter
        include_class_members ContentFormatter
        
        typesig { [String] }
        # Creates a new updater for the given category.
        # 
        # @param category the category
        def initialize(category)
          super(category)
        end
        
        typesig { [] }
        # @see DefaultPositionUpdater#notDeleted()
        def not_deleted
          return true
        end
        
        private
        alias_method :initialize__non_deleting_position_updater, :initialize
      end }
      
      # The position updater which runs as first updater on the document's positions.
      # Used to remove all affected positions from their categories to avoid them
      # from being regularly updated.
      # 
      # @see IPositionUpdater
      const_set_lazy(:RemoveAffectedPositions) { Class.new do
        local_class_in ContentFormatter
        include_class_members ContentFormatter
        include IPositionUpdater
        
        typesig { [class_self::DocumentEvent] }
        # @see IPositionUpdater#update(DocumentEvent)
        def update(event)
          remove_affected_positions(event.get_document)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__remove_affected_positions, :initialize
      end }
      
      # The position updater which runs as last updater on the document's positions.
      # Used to update all affected positions and adding them back to their
      # original categories.
      # 
      # @see IPositionUpdater
      const_set_lazy(:UpdateAffectedPositions) { Class.new do
        local_class_in ContentFormatter
        include_class_members ContentFormatter
        include IPositionUpdater
        
        # The affected positions
        attr_accessor :f_positions
        alias_method :attr_f_positions, :f_positions
        undef_method :f_positions
        alias_method :attr_f_positions=, :f_positions=
        undef_method :f_positions=
        
        # The offset
        attr_accessor :f_offset
        alias_method :attr_f_offset, :f_offset
        undef_method :f_offset
        alias_method :attr_f_offset=, :f_offset=
        undef_method :f_offset=
        
        typesig { [Array.typed(::Java::Int), ::Java::Int] }
        # Creates a new updater.
        # 
        # @param positions the affected positions
        # @param offset the offset
        def initialize(positions, offset)
          @f_positions = nil
          @f_offset = 0
          @f_positions = positions
          @f_offset = offset
        end
        
        typesig { [class_self::DocumentEvent] }
        # @see IPositionUpdater#update(DocumentEvent)
        def update(event)
          update_affected_positions(event.get_document, @f_positions, @f_offset)
        end
        
        private
        alias_method :initialize__update_affected_positions, :initialize
      end }
      
      # Internal position category used for the formatter partitioning
      const_set_lazy(:PARTITIONING) { "__formatter_partitioning" }
      const_attr_reader  :PARTITIONING
    }
    
    # $NON-NLS-1$
    # The map of <code>IFormattingStrategy</code> objects
    attr_accessor :f_strategies
    alias_method :attr_f_strategies, :f_strategies
    undef_method :f_strategies
    alias_method :attr_f_strategies=, :f_strategies=
    undef_method :f_strategies=
    
    # The indicator of whether the formatter operates in partition aware mode or not
    attr_accessor :f_is_partition_aware
    alias_method :attr_f_is_partition_aware, :f_is_partition_aware
    undef_method :f_is_partition_aware
    alias_method :attr_f_is_partition_aware=, :f_is_partition_aware=
    undef_method :f_is_partition_aware=
    
    # The partition information managing document position categories
    attr_accessor :f_partition_managing_categories
    alias_method :attr_f_partition_managing_categories, :f_partition_managing_categories
    undef_method :f_partition_managing_categories
    alias_method :attr_f_partition_managing_categories=, :f_partition_managing_categories=
    undef_method :f_partition_managing_categories=
    
    # The list of references to offset and end offset of all overlapping positions
    attr_accessor :f_overlapping_position_references
    alias_method :attr_f_overlapping_position_references, :f_overlapping_position_references
    undef_method :f_overlapping_position_references
    alias_method :attr_f_overlapping_position_references=, :f_overlapping_position_references=
    undef_method :f_overlapping_position_references=
    
    # Position updater used for partitioning positions
    attr_accessor :f_partitioning_updater
    alias_method :attr_f_partitioning_updater, :f_partitioning_updater
    undef_method :f_partitioning_updater
    alias_method :attr_f_partitioning_updater=, :f_partitioning_updater=
    undef_method :f_partitioning_updater=
    
    # The document partitioning used by this formatter.
    # @since 3.0
    attr_accessor :f_partitioning
    alias_method :attr_f_partitioning, :f_partitioning
    undef_method :f_partitioning
    alias_method :attr_f_partitioning=, :f_partitioning=
    undef_method :f_partitioning=
    
    # The document this formatter works on.
    # @since 3.0
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The external partition managing categories.
    # @since 3.0
    attr_accessor :f_external_partiton_managing_categories
    alias_method :attr_f_external_partiton_managing_categories, :f_external_partiton_managing_categories
    undef_method :f_external_partiton_managing_categories
    alias_method :attr_f_external_partiton_managing_categories=, :f_external_partiton_managing_categories=
    undef_method :f_external_partiton_managing_categories=
    
    # Indicates whether <code>fPartitionManagingCategories</code> must be computed.
    # @since 3.0
    attr_accessor :f_needs_computation
    alias_method :attr_f_needs_computation, :f_needs_computation
    undef_method :f_needs_computation
    alias_method :attr_f_needs_computation=, :f_needs_computation=
    undef_method :f_needs_computation=
    
    typesig { [] }
    # Creates a new content formatter. The content formatter operates by default
    # in the partition-aware mode. There are no preconfigured formatting strategies.
    # Will use the default document partitioning if not further configured.
    def initialize
      @f_strategies = nil
      @f_is_partition_aware = true
      @f_partition_managing_categories = nil
      @f_overlapping_position_references = nil
      @f_partitioning_updater = nil
      @f_partitioning = nil
      @f_document = nil
      @f_external_partiton_managing_categories = nil
      @f_needs_computation = true
      @f_partitioning = RJava.cast_to_string(IDocumentExtension3::DEFAULT_PARTITIONING)
    end
    
    typesig { [IFormattingStrategy, String] }
    # Registers a strategy for a particular content type. If there is already a strategy
    # registered for this type, the new strategy is registered instead of the old one.
    # If the given content type is <code>null</code> the given strategy is registered for
    # all content types as is called only once per formatting session.
    # 
    # @param strategy the formatting strategy to register, or <code>null</code> to remove an existing one
    # @param contentType the content type under which to register
    def set_formatting_strategy(strategy, content_type)
      Assert.is_not_null(content_type)
      if ((@f_strategies).nil?)
        @f_strategies = HashMap.new
      end
      if ((strategy).nil?)
        @f_strategies.remove(content_type)
      else
        @f_strategies.put(content_type, strategy)
      end
    end
    
    typesig { [Array.typed(String)] }
    # Informs this content formatter about the names of those position categories
    # which are used to manage the document's partitioning information and thus should
    # be ignored when this formatter updates positions.
    # 
    # @param categories the categories to be ignored
    # @deprecated incompatible with an open set of document partitionings. The provided information is only used
    # if this formatter can not compute the partition managing position categories.
    def set_partition_managing_position_categories(categories)
      @f_external_partiton_managing_categories = TextUtilities.copy(categories)
    end
    
    typesig { [String] }
    # Sets the document partitioning to be used by this formatter.
    # 
    # @param partitioning the document partitioning
    # @since 3.0
    def set_document_partitioning(partitioning)
      @f_partitioning = partitioning
    end
    
    typesig { [::Java::Boolean] }
    # Sets the formatter's operation mode.
    # 
    # @param enable indicates whether the formatting process should be partition ware
    def enable_partition_aware_formatting(enable)
      @f_is_partition_aware = enable
    end
    
    typesig { [String] }
    # @see IContentFormatter#getFormattingStrategy(String)
    def get_formatting_strategy(content_type)
      Assert.is_not_null(content_type)
      if ((@f_strategies).nil?)
        return nil
      end
      return @f_strategies.get(content_type)
    end
    
    typesig { [IDocument, IRegion] }
    # @see IContentFormatter#format(IDocument, IRegion)
    def format(document, region)
      @f_needs_computation = true
      @f_document = document
      begin
        if (@f_is_partition_aware)
          format_partitions(region)
        else
          format_region(region)
        end
      ensure
        @f_needs_computation = true
        @f_document = nil
      end
    end
    
    typesig { [IRegion] }
    # Determines the partitioning of the given region of the document.
    # Informs the formatting strategies of each partition about the start,
    # the process, and the termination of the formatting session.
    # 
    # @param region the document region to be formatted
    # @since 3.0
    def format_partitions(region)
      add_partitioning_updater
      begin
        ranges = get_partitioning(region)
        if (!(ranges).nil?)
          start(ranges, get_indentation(region.get_offset))
          format(ranges)
          stop(ranges)
        end
      rescue BadLocationException => x
      end
      remove_partitioning_updater
    end
    
    typesig { [IRegion] }
    # Formats the given region with the strategy registered for the default
    # content type. The strategy is informed about the start, the process, and
    # the termination of the formatting session.
    # 
    # @param region the region to be formatted
    # @since 3.0
    def format_region(region)
      strategy = get_formatting_strategy(IDocument::DEFAULT_CONTENT_TYPE)
      if (!(strategy).nil?)
        strategy.formatter_starts(get_indentation(region.get_offset))
        format(strategy, TypedPosition.new(region.get_offset, region.get_length, IDocument::DEFAULT_CONTENT_TYPE))
        strategy.formatter_stops
      end
    end
    
    typesig { [IRegion] }
    # Returns the partitioning of the given region of the document to be formatted.
    # As one partition after the other will be formatted and formatting will
    # probably change the length of the formatted partition, it must be kept
    # track of the modifications in order to submit the correct partition to all
    # formatting strategies. For this, all partitions are remembered as positions
    # in a dedicated position category. (As formatting strategies might rely on each
    # other, calling them in reversed order is not an option.)
    # 
    # @param region the region for which the partitioning must be determined
    # @return the partitioning of the specified region
    # @exception BadLocationException of region is invalid in the document
    # @since 3.0
    def get_partitioning(region)
      regions = TextUtilities.compute_partitioning(@f_document, @f_partitioning, region.get_offset, region.get_length, false)
      positions = Array.typed(TypedPosition).new(regions.attr_length) { nil }
      i = 0
      while i < regions.attr_length
        positions[i] = TypedPosition.new(regions[i])
        begin
          @f_document.add_position(PARTITIONING, positions[i])
        rescue BadPositionCategoryException => x
          # should not happen
        end
        i += 1
      end
      return positions
    end
    
    typesig { [Array.typed(TypedPosition), String] }
    # Fires <code>formatterStarts</code> to all formatter strategies
    # which will be involved in the forthcoming formatting process.
    # 
    # @param regions the partitioning of the document to be formatted
    # @param indentation the initial indentation
    def start(regions, indentation)
      i = 0
      while i < regions.attr_length
        s = get_formatting_strategy(regions[i].get_type)
        if (!(s).nil?)
          s.formatter_starts(indentation)
        end
        i += 1
      end
    end
    
    typesig { [Array.typed(TypedPosition)] }
    # Formats one partition after the other using the formatter strategy registered for
    # the partition's content type.
    # 
    # @param ranges the partitioning of the document region to be formatted
    # @since 3.0
    def format(ranges)
      i = 0
      while i < ranges.attr_length
        s = get_formatting_strategy(ranges[i].get_type)
        if (!(s).nil?)
          format(s, ranges[i])
        end
        i += 1
      end
    end
    
    typesig { [IFormattingStrategy, TypedPosition] }
    # Formats the given region of the document using the specified formatting
    # strategy. In order to maintain positions correctly, first all affected
    # positions determined, after all document listeners have been informed about
    # the coming change, the affected positions are removed to avoid that they
    # are regularly updated. After all position updaters have run, the affected
    # positions are updated with the formatter's information and added back to
    # their categories, right before the first document listener is informed about
    # that a change happened.
    # 
    # @param strategy the strategy to be used
    # @param region the region to be formatted
    # @since 3.0
    def format(strategy, region)
      begin
        offset = region.get_offset
        length = region.get_length
        content = @f_document.get(offset, length)
        positions = get_affected_positions(offset, length)
        formatted = strategy.format(content, is_line_start(offset), get_indentation(offset), positions)
        if (!(formatted).nil? && !(formatted == content))
          first = RemoveAffectedPositions.new_local(self)
          @f_document.insert_position_updater(first, 0)
          last = UpdateAffectedPositions.new_local(self, positions, offset)
          @f_document.add_position_updater(last)
          @f_document.replace(offset, length, formatted)
          @f_document.remove_position_updater(first)
          @f_document.remove_position_updater(last)
        end
      rescue BadLocationException => x
        # should not happen
      end
    end
    
    typesig { [Array.typed(TypedPosition)] }
    # Fires <code>formatterStops</code> to all formatter strategies which were
    # involved in the formatting process which is about to terminate.
    # 
    # @param regions the partitioning of the document which has been formatted
    def stop(regions)
      i = 0
      while i < regions.attr_length
        s = get_formatting_strategy(regions[i].get_type)
        if (!(s).nil?)
          s.formatter_stops
        end
        i += 1
      end
    end
    
    typesig { [] }
    # Installs those updaters which the formatter needs to keep track of the partitions.
    # @since 3.0
    def add_partitioning_updater
      @f_partitioning_updater = NonDeletingPositionUpdater.new_local(self, PARTITIONING)
      @f_document.add_position_category(PARTITIONING)
      @f_document.add_position_updater(@f_partitioning_updater)
    end
    
    typesig { [] }
    # Removes the formatter's internal position updater and category.
    # 
    # @since 3.0
    def remove_partitioning_updater
      begin
        @f_document.remove_position_updater(@f_partitioning_updater)
        @f_document.remove_position_category(PARTITIONING)
        @f_partitioning_updater = nil
      rescue BadPositionCategoryException => x
        # should not happen
      end
    end
    
    typesig { [] }
    # Returns the partition managing position categories for the formatted document.
    # 
    # @return the position managing position categories
    # @since 3.0
    def get_partition_managing_categories
      if (@f_needs_computation)
        @f_needs_computation = false
        @f_partition_managing_categories = TextUtilities.compute_partition_managing_categories(@f_document)
        if ((@f_partition_managing_categories).nil?)
          @f_partition_managing_categories = @f_external_partiton_managing_categories
        end
      end
      return @f_partition_managing_categories
    end
    
    typesig { [String] }
    # Determines whether the given document position category should be ignored
    # by this formatter's position updating.
    # 
    # @param category the category to check
    # @return <code>true</code> if the category should be ignored, <code>false</code> otherwise
    def ignore_category(category)
      if ((PARTITIONING == category))
        return true
      end
      categories = get_partition_managing_categories
      if (!(categories).nil?)
        i = 0
        while i < categories.attr_length
          if ((categories[i] == category))
            return true
          end
          i += 1
        end
      end
      return false
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Determines all embracing, overlapping, and follow up positions
    # for the given region of the document.
    # 
    # @param offset the offset of the document region to be formatted
    # @param length the length of the document to be formatted
    # @since 3.0
    def determine_positions_to_update(offset, length)
      categories = @f_document.get_position_categories
      if (!(categories).nil?)
        i = 0
        while i < categories.attr_length
          if (ignore_category(categories[i]))
            i += 1
            next
          end
          begin
            positions = @f_document.get_positions(categories[i])
            j = 0
            while j < positions.attr_length
              p = positions[j]
              if (p.overlaps_with(offset, length))
                if (offset < p.get_offset)
                  @f_overlapping_position_references.add(PositionReference.new(p, true, categories[i]))
                end
                if (p.get_offset + p.get_length < offset + length)
                  @f_overlapping_position_references.add(PositionReference.new(p, false, categories[i]))
                end
              end
              j += 1
            end
          rescue BadPositionCategoryException => x
            # can not happen
          end
          i += 1
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns all offset and the end offset of all positions overlapping with the
    # specified document range.
    # 
    # @param offset the offset of the document region to be formatted
    # @param length the length of the document to be formatted
    # @return all character positions of the interleaving positions
    # @since 3.0
    def get_affected_positions(offset, length)
      @f_overlapping_position_references = ArrayList.new
      determine_positions_to_update(offset, length)
      Collections.sort(@f_overlapping_position_references)
      positions = Array.typed(::Java::Int).new(@f_overlapping_position_references.size) { 0 }
      i = 0
      while i < positions.attr_length
        r = @f_overlapping_position_references.get(i)
        positions[i] = r.get_character_position - offset
        i += 1
      end
      return positions
    end
    
    typesig { [IDocument] }
    # Removes the affected positions from their categories to avoid
    # that they are invalidly updated.
    # 
    # @param document the document
    def remove_affected_positions(document)
      size_ = @f_overlapping_position_references.size
      i = 0
      while i < size_
        r = @f_overlapping_position_references.get(i)
        begin
          document.remove_position(r.get_category, r.get_position)
        rescue BadPositionCategoryException => x
          # can not happen
        end
        i += 1
      end
    end
    
    typesig { [IDocument, Array.typed(::Java::Int), ::Java::Int] }
    # Updates all the overlapping positions. Note, all other positions are
    # automatically updated by their document position updaters.
    # 
    # @param document the document to has been formatted
    # @param positions the adapted character positions to be used to update the document positions
    # @param offset the offset of the document region that has been formatted
    def update_affected_positions(document, positions, offset)
      if (!(document).equal?(@f_document))
        return
      end
      if ((positions.attr_length).equal?(0))
        return
      end
      i = 0
      while i < positions.attr_length
        r = @f_overlapping_position_references.get(i)
        if (r.refers_to_offset)
          r.set_offset(offset + positions[i])
        else
          r.set_length((offset + positions[i]) - r.get_offset)
        end
        p = r.get_position
        category = r.get_category
        if (!document.contains_position(category, p.attr_offset, p.attr_length))
          begin
            if (position_about_to_be_added(document, category, p))
              document.add_position(r.get_category, p)
            end
          rescue BadPositionCategoryException => x
            # can not happen
          rescue BadLocationException => x
            # should not happen
          end
        end
        i += 1
      end
      @f_overlapping_position_references = nil
    end
    
    typesig { [IDocument, String, Position] }
    # The given position is about to be added to the given position category of the given document. <p>
    # This default implementation return <code>true</code>.
    # 
    # @param document the document
    # @param category the position category
    # @param position the position that will be added
    # @return <code>true</code> if the position can be added, <code>false</code> if it should be ignored
    def position_about_to_be_added(document, category, position)
      return true
    end
    
    typesig { [::Java::Int] }
    # Returns the indentation of the line of the given offset.
    # 
    # @param offset the offset
    # @return the indentation of the line of the offset
    # @since 3.0
    def get_indentation(offset)
      begin
        start_ = @f_document.get_line_of_offset(offset)
        start_ = @f_document.get_line_offset(start_)
        end_ = start_
        c = @f_document.get_char(end_)
        while ((Character.new(?\t.ord)).equal?(c) || (Character.new(?\s.ord)).equal?(c))
          c = @f_document.get_char((end_ += 1))
        end
        return @f_document.get(start_, end_ - start_)
      rescue BadLocationException => x
      end
      return "" # $NON-NLS-1$
    end
    
    typesig { [::Java::Int] }
    # Determines whether the offset is the beginning of a line in the given document.
    # 
    # @param offset the offset
    # @return <code>true</code> if offset is the beginning of a line
    # @exception BadLocationException if offset is invalid in document
    # @since 3.0
    def is_line_start(offset)
      start_ = @f_document.get_line_of_offset(offset)
      start_ = @f_document.get_line_offset(start_)
      return ((start_).equal?(offset))
    end
    
    private
    alias_method :initialize__content_formatter, :initialize
  end
  
end
