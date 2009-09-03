require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Christian Plesner Hansen (plesner@quenta.org) - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module DefaultCharacterPairMatcherImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentExtension3
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITypedRegion
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
    }
  end
  
  # A character pair matcher that matches a specified set of character
  # pairs against each other.  Only characters that occur in the same
  # partitioning are matched.
  # 
  # @since 3.3
  class DefaultCharacterPairMatcher 
    include_class_members DefaultCharacterPairMatcherImports
    include ICharacterPairMatcher
    
    attr_accessor :f_anchor
    alias_method :attr_f_anchor, :f_anchor
    undef_method :f_anchor
    alias_method :attr_f_anchor=, :f_anchor=
    undef_method :f_anchor=
    
    attr_accessor :f_pairs
    alias_method :attr_f_pairs, :f_pairs
    undef_method :f_pairs
    alias_method :attr_f_pairs=, :f_pairs=
    undef_method :f_pairs=
    
    attr_accessor :f_partitioning
    alias_method :attr_f_partitioning, :f_partitioning
    undef_method :f_partitioning
    alias_method :attr_f_partitioning=, :f_partitioning=
    undef_method :f_partitioning=
    
    typesig { [Array.typed(::Java::Char), String] }
    # Creates a new character pair matcher that matches the specified
    # characters within the specified partitioning.  The specified
    # list of characters must have the form
    # <blockquote>{ <i>start</i>, <i>end</i>, <i>start</i>, <i>end</i>, ..., <i>start</i>, <i>end</i> }</blockquote>
    # For instance:
    # <pre>
    # char[] chars = new char[] {'(', ')', '{', '}', '[', ']'};
    # new SimpleCharacterPairMatcher(chars, ...);
    # </pre>
    # 
    # @param chars a list of characters
    # @param partitioning the partitioning to match within
    def initialize(chars, partitioning)
      @f_anchor = -1
      @f_pairs = nil
      @f_partitioning = nil
      Assert.is_legal((chars.attr_length % 2).equal?(0))
      Assert.is_not_null(partitioning)
      @f_pairs = CharPairs.new(chars)
      @f_partitioning = partitioning
    end
    
    typesig { [Array.typed(::Java::Char)] }
    # Creates a new character pair matcher that matches characters
    # within the default partitioning.  The specified list of
    # characters must have the form
    # <blockquote>{ <i>start</i>, <i>end</i>, <i>start</i>, <i>end</i>, ..., <i>start</i>, <i>end</i> }</blockquote>
    # For instance:
    # <pre>
    # char[] chars = new char[] {'(', ')', '{', '}', '[', ']'};
    # new SimpleCharacterPairMatcher(chars);
    # </pre>
    # 
    # @param chars a list of characters
    def initialize(chars)
      initialize__default_character_pair_matcher(chars, IDocumentExtension3::DEFAULT_PARTITIONING)
    end
    
    typesig { [IDocument, ::Java::Int] }
    # @see ICharacterPairMatcher#match(IDocument, int)
    def match(doc, offset)
      if ((doc).nil? || offset < 0 || offset > doc.get_length)
        return nil
      end
      begin
        return perform_match(doc, offset)
      rescue BadLocationException => ble
        return nil
      end
    end
    
    typesig { [IDocument, ::Java::Int] }
    # Performs the actual work of matching for #match(IDocument, int).
    def perform_match(doc, caret_offset)
      char_offset = caret_offset - 1
      prev_char = doc.get_char(Math.max(char_offset, 0))
      if (!@f_pairs.contains(prev_char))
        return nil
      end
      is_forward = @f_pairs.is_start_character(prev_char)
      @f_anchor = is_forward ? ICharacterPairMatcher::LEFT : ICharacterPairMatcher::RIGHT
      search_start_position = is_forward ? caret_offset : caret_offset - 2
      adjusted_offset = is_forward ? char_offset : caret_offset
      partition = TextUtilities.get_content_type(doc, @f_partitioning, char_offset, false)
      part_doc = DocumentPartitionAccessor.new(doc, @f_partitioning, partition)
      end_offset = find_matching_peer(part_doc, prev_char, @f_pairs.get_matching(prev_char), is_forward, is_forward ? doc.get_length : -1, search_start_position)
      if ((end_offset).equal?(-1))
        return nil
      end
      adjusted_end_offset = is_forward ? end_offset + 1 : end_offset
      if ((adjusted_end_offset).equal?(adjusted_offset))
        return nil
      end
      return Region.new(Math.min(adjusted_offset, adjusted_end_offset), Math.abs(adjusted_end_offset - adjusted_offset))
    end
    
    typesig { [DocumentPartitionAccessor, ::Java::Char, ::Java::Char, ::Java::Boolean, ::Java::Int, ::Java::Int] }
    # Searches <code>doc</code> for the specified end character, <code>end</code>.
    # 
    # @param doc the document to search
    # @param start the opening matching character
    # @param end the end character to search for
    # @param searchForward search forwards or backwards?
    # @param boundary a boundary at which the search should stop
    # @param startPos the start offset
    # @return the index of the end character if it was found, otherwise -1
    # @throws BadLocationException if the document is accessed with invalid offset or line
    def find_matching_peer(doc, start, end_, search_forward, boundary, start_pos)
      pos = start_pos
      while (!(pos).equal?(boundary))
        c = doc.get_char(pos)
        if (doc.is_match(pos, end_))
          return pos
        else
          if ((c).equal?(start) && doc.in_partition(pos))
            pos = find_matching_peer(doc, start, end_, search_forward, boundary, doc.get_next_position(pos, search_forward))
            if ((pos).equal?(-1))
              return -1
            end
          end
        end
        pos = doc.get_next_position(pos, search_forward)
      end
      return -1
    end
    
    typesig { [] }
    # @see ICharacterPairMatcher#getAnchor()
    def get_anchor
      return @f_anchor
    end
    
    typesig { [] }
    # @see ICharacterPairMatcher#dispose()
    def dispose
    end
    
    typesig { [] }
    # @see ICharacterPairMatcher#clear()
    def clear
      @f_anchor = -1
    end
    
    class_module.module_eval {
      # Utility class that wraps a document and gives access to
      # partitioning information.  A document is tied to a particular
      # partition and, when considering whether or not a position is a
      # valid match, only considers position within its partition.
      const_set_lazy(:DocumentPartitionAccessor) { Class.new do
        include_class_members DefaultCharacterPairMatcher
        
        attr_accessor :f_document
        alias_method :attr_f_document, :f_document
        undef_method :f_document
        alias_method :attr_f_document=, :f_document=
        undef_method :f_document=
        
        attr_accessor :f_partitioning
        alias_method :attr_f_partitioning, :f_partitioning
        undef_method :f_partitioning
        alias_method :attr_f_partitioning=, :f_partitioning=
        undef_method :f_partitioning=
        
        attr_accessor :f_partition
        alias_method :attr_f_partition, :f_partition
        undef_method :f_partition
        alias_method :attr_f_partition=, :f_partition=
        undef_method :f_partition=
        
        attr_accessor :f_cached_partition
        alias_method :attr_f_cached_partition, :f_cached_partition
        undef_method :f_cached_partition
        alias_method :attr_f_cached_partition=, :f_cached_partition=
        undef_method :f_cached_partition=
        
        typesig { [class_self::IDocument, String, String] }
        # Creates a new partitioned document for the specified document.
        # 
        # @param doc the document to wrap
        # @param partitioning the partitioning used
        # @param partition the partition managed by this document
        def initialize(doc, partitioning, partition)
          @f_document = nil
          @f_partitioning = nil
          @f_partition = nil
          @f_cached_partition = nil
          @f_document = doc
          @f_partitioning = partitioning
          @f_partition = partition
        end
        
        typesig { [::Java::Int] }
        # Returns the character at the specified position in this document.
        # 
        # @param pos an offset within this document
        # @return the character at the offset
        # @throws BadLocationException if the offset is invalid in this document
        def get_char(pos)
          return @f_document.get_char(pos)
        end
        
        typesig { [::Java::Int, ::Java::Char] }
        # Returns true if the character at the specified position is a valid match for the
        # specified end character. To be a valid match, it must be in the appropriate partition and
        # equal to the end character.
        # 
        # @param pos an offset within this document
        # @param end the end character to match against
        # @return true exactly if the position represents a valid match
        # @throws BadLocationException if the offset is invalid in this document
        def is_match(pos, end_)
          return (get_char(pos)).equal?(end_) && in_partition(pos)
        end
        
        typesig { [::Java::Int] }
        # Returns true if the specified offset is within the partition
        # managed by this document.
        # 
        # @param pos an offset within this document
        # @return true if the offset is within this document's partition
        def in_partition(pos)
          partition = get_partition(pos)
          return !(partition).nil? && (partition.get_type == @f_partition)
        end
        
        typesig { [::Java::Int, ::Java::Boolean] }
        # Returns the next position to query in the search.  The position
        # is not guaranteed to be in this document's partition.
        # 
        # @param pos an offset within the document
        # @param searchForward the direction of the search
        # @return the next position to query
        def get_next_position(pos, search_forward)
          partition = get_partition(pos)
          if ((partition).nil?)
            return simple_increment(pos, search_forward)
          end
          if ((@f_partition == partition.get_type))
            return simple_increment(pos, search_forward)
          end
          if (search_forward)
            end_ = partition.get_offset + partition.get_length
            if (pos < end_)
              return end_
            end
          else
            offset = partition.get_offset
            if (pos > offset)
              return offset - 1
            end
          end
          return simple_increment(pos, search_forward)
        end
        
        typesig { [::Java::Int, ::Java::Boolean] }
        def simple_increment(pos, search_forward)
          return pos + (search_forward ? 1 : -1)
        end
        
        typesig { [::Java::Int] }
        # Returns partition information about the region containing the
        # specified position.
        # 
        # @param pos a position within this document.
        # @return positioning information about the region containing the
        # position
        def get_partition(pos)
          if ((@f_cached_partition).nil? || !contains(@f_cached_partition, pos))
            Assert.is_true(pos >= 0 && pos <= @f_document.get_length)
            begin
              @f_cached_partition = TextUtilities.get_partition(@f_document, @f_partitioning, pos, false)
            rescue self.class::BadLocationException => e
              @f_cached_partition = nil
            end
          end
          return @f_cached_partition
        end
        
        class_module.module_eval {
          typesig { [class_self::IRegion, ::Java::Int] }
          def contains(region, pos)
            offset = region.get_offset
            return offset <= pos && pos < offset + region.get_length
          end
        }
        
        private
        alias_method :initialize__document_partition_accessor, :initialize
      end }
      
      # Utility class that encapsulates access to matching character pairs.
      const_set_lazy(:CharPairs) { Class.new do
        include_class_members DefaultCharacterPairMatcher
        
        attr_accessor :f_pairs
        alias_method :attr_f_pairs, :f_pairs
        undef_method :f_pairs
        alias_method :attr_f_pairs=, :f_pairs=
        undef_method :f_pairs=
        
        typesig { [Array.typed(::Java::Char)] }
        def initialize(pairs)
          @f_pairs = nil
          @f_chars_cache = nil
          @f_pairs = pairs
        end
        
        typesig { [::Java::Char] }
        # Returns true if the specified character pair occurs in one
        # of the character pairs.
        # 
        # @param c a character
        # @return true exactly if the character occurs in one of the pairs
        def contains(c)
          return get_all_characters.contains(self.class::Character.new(c))
        end
        
        # <Character>
        attr_accessor :f_chars_cache
        alias_method :attr_f_chars_cache, :f_chars_cache
        undef_method :f_chars_cache
        alias_method :attr_f_chars_cache=, :f_chars_cache=
        undef_method :f_chars_cache=
        
        typesig { [] }
        # @return A set containing all characters occurring in character pairs.
        # 
        # <Character>
        def get_all_characters
          if ((@f_chars_cache).nil?)
            # <Character>
            # <Character>
            set = self.class::HashSet.new
            i = 0
            while i < @f_pairs.attr_length
              set.add(self.class::Character.new(@f_pairs[i]))
              i += 1
            end
            @f_chars_cache = set
          end
          return @f_chars_cache
        end
        
        typesig { [::Java::Char, ::Java::Boolean] }
        # Returns true if the specified character opens a character pair
        # when scanning in the specified direction.
        # 
        # @param c a character
        # @param searchForward the direction of the search
        # @return whether or not the character opens a character pair
        def is_opening_character(c, search_forward)
          i = 0
          while i < @f_pairs.attr_length
            if (search_forward && (get_start_char(i)).equal?(c))
              return true
            else
              if (!search_forward && (get_end_char(i)).equal?(c))
                return true
              end
            end
            i += 2
          end
          return false
        end
        
        typesig { [::Java::Char] }
        # Returns true of the specified character is a start character.
        # 
        # @param c a character
        # @return true exactly if the character is a start character
        def is_start_character(c)
          return self.is_opening_character(c, true)
        end
        
        typesig { [::Java::Char] }
        # Returns the matching character for the specified character.
        # 
        # @param c a character occurring in a character pair
        # @return the matching character
        def get_matching(c)
          i = 0
          while i < @f_pairs.attr_length
            if ((get_start_char(i)).equal?(c))
              return get_end_char(i)
            else
              if ((get_end_char(i)).equal?(c))
                return get_start_char(i)
              end
            end
            i += 2
          end
          Assert.is_true(false)
          return Character.new(?\0.ord)
        end
        
        typesig { [::Java::Int] }
        def get_start_char(i)
          return @f_pairs[i]
        end
        
        typesig { [::Java::Int] }
        def get_end_char(i)
          return @f_pairs[i + 1]
        end
        
        private
        alias_method :initialize__char_pairs, :initialize
      end }
    }
    
    private
    alias_method :initialize__default_character_pair_matcher, :initialize
  end
  
end
