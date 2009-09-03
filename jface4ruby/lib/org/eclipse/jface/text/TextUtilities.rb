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
  module TextUtilitiesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ListIterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # A collection of text functions.
  # <p>
  # This class is neither intended to be instantiated nor subclassed.
  # </p>
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class TextUtilities 
    include_class_members TextUtilitiesImports
    
    class_module.module_eval {
      # Default line delimiters used by the text functions of this class.
      const_set_lazy(:DELIMITERS) { Array.typed(String).new(["\n", "\r", "\r\n"]) }
      const_attr_reader  :DELIMITERS
      
      # $NON-NLS-3$ //$NON-NLS-2$ //$NON-NLS-1$
      # 
      # Default line delimiters used by these text functions.
      # 
      # @deprecated use DELIMITERS instead
      const_set_lazy(:FgDelimiters) { DELIMITERS }
      const_attr_reader  :FgDelimiters
      
      typesig { [String, String] }
      # Determines which one of default line delimiters appears first in the list. If none of them the
      # hint is returned.
      # 
      # @param text the text to be checked
      # @param hint the line delimiter hint
      # @return the line delimiter
      def determine_line_delimiter(text, hint)
        begin
          info = index_of(DELIMITERS, text, 0)
          return DELIMITERS[info[1]]
        rescue ArrayIndexOutOfBoundsException => x
        end
        return hint
      end
      
      typesig { [Array.typed(String), String, ::Java::Int] }
      # Returns the starting position and the index of the first matching search string
      # in the given text that is greater than the given offset. If more than one search
      # string matches with the same starting position then the longest one is returned.
      # 
      # @param searchStrings the strings to search for
      # @param text the text to be searched
      # @param offset the offset at which to start the search
      # @return an <code>int[]</code> with two elements where the first is the starting offset, the second the index of the found
      # search string in the given <code>searchStrings</code> array, returns <code>[-1, -1]</code> if no match exists
      def index_of(search_strings, text, offset)
        result = Array.typed(::Java::Int).new([-1, -1])
        zero_index = -1
        i = 0
        while i < search_strings.attr_length
          length = search_strings[i].length
          if ((length).equal?(0))
            zero_index = i
            i += 1
            next
          end
          index = text.index_of(search_strings[i], offset)
          if (index >= 0)
            if ((result[0]).equal?(-1))
              result[0] = index
              result[1] = i
            else
              if (index < result[0])
                result[0] = index
                result[1] = i
              else
                if ((index).equal?(result[0]) && length > search_strings[result[1]].length)
                  result[0] = index
                  result[1] = i
                end
              end
            end
          end
          i += 1
        end
        if (zero_index > -1 && (result[0]).equal?(-1))
          result[0] = 0
          result[1] = zero_index
        end
        return result
      end
      
      typesig { [Array.typed(String), String] }
      # Returns the index of the longest search string with which the given text ends or
      # <code>-1</code> if none matches.
      # 
      # @param searchStrings the strings to search for
      # @param text the text to search
      # @return the index in <code>searchStrings</code> of the longest string with which <code>text</code> ends or <code>-1</code>
      def ends_with(search_strings, text)
        index = -1
        i = 0
        while i < search_strings.attr_length
          if (text.ends_with(search_strings[i]))
            if ((index).equal?(-1) || search_strings[i].length > search_strings[index].length)
              index = i
            end
          end
          i += 1
        end
        return index
      end
      
      typesig { [Array.typed(String), String] }
      # Returns the index of the longest search string with which the given text starts or <code>-1</code>
      # if none matches.
      # 
      # @param searchStrings the strings to search for
      # @param text the text to search
      # @return the index in <code>searchStrings</code> of the longest string with which <code>text</code> starts or <code>-1</code>
      def starts_with(search_strings, text)
        index = -1
        i = 0
        while i < search_strings.attr_length
          if (text.starts_with(search_strings[i]))
            if ((index).equal?(-1) || search_strings[i].length > search_strings[index].length)
              index = i
            end
          end
          i += 1
        end
        return index
      end
      
      typesig { [Array.typed(String), String] }
      # Returns the index of the first compare string that equals the given text or <code>-1</code>
      # if none is equal.
      # 
      # @param compareStrings the strings to compare with
      # @param text the text to check
      # @return the index of the first equal compare string or <code>-1</code>
      def ==(compare_strings, text)
        i = 0
        while i < compare_strings.attr_length
          if ((text == compare_strings[i]))
            return i
          end
          i += 1
        end
        return -1
      end
      
      typesig { [IDocument, JavaList] }
      # Returns a document event which is an accumulation of a list of document events,
      # <code>null</code> if the list of documentEvents is empty.
      # The document of the document events are ignored.
      # 
      # @param unprocessedDocument the document to which the document events would be applied
      # @param documentEvents the list of document events to merge
      # @return returns the merged document event
      # @throws BadLocationException might be thrown if document is not in the correct state with respect to document events
      def merge_unprocessed_document_events(unprocessed_document, document_events)
        if ((document_events.size).equal?(0))
          return nil
        end
        iterator_ = document_events.iterator
        first_event = iterator_.next_
        # current merged event
        document = unprocessed_document
        offset = first_event.get_offset
        length = first_event.get_length
        text = StringBuffer.new((first_event.get_text).nil? ? "" : first_event.get_text) # $NON-NLS-1$
        while (iterator_.has_next)
          delta = text.length - length
          event = iterator_.next_
          event_offset = event.get_offset
          event_length = event.get_length
          event_text = (event.get_text).nil? ? "" : event.get_text # $NON-NLS-1$
          # event is right from merged event
          if (event_offset > offset + length + delta)
            string = document.get(offset + length, (event_offset - delta) - (offset + length))
            text.append(string)
            text.append(event_text)
            length = (event_offset - delta) + event_length - offset
            # event is left from merged event
          else
            if (event_offset + event_length < offset)
              string = document.get(event_offset + event_length, offset - (event_offset + event_length))
              text.insert(0, string)
              text.insert(0, event_text)
              length = offset + length - event_offset
              offset = event_offset
              # events overlap each other
            else
              start = Math.max(0, event_offset - offset)
              end_ = Math.min(text.length, event_length + event_offset - offset)
              text.replace(start, end_, event_text)
              offset = Math.min(offset, event_offset)
              total_delta = delta + event_text.length - event_length
              length = text.length - total_delta
            end
          end
        end
        return DocumentEvent.new(document, offset, length, text.to_s)
      end
      
      typesig { [JavaList] }
      # Returns a document event which is an accumulation of a list of document events,
      # <code>null</code> if the list of document events is empty.
      # The document events being merged must all refer to the same document, to which
      # the document changes have been already applied.
      # 
      # @param documentEvents the list of document events to merge
      # @return returns the merged document event
      # @throws BadLocationException might be thrown if document is not in the correct state with respect to document events
      def merge_processed_document_events(document_events)
        if ((document_events.size).equal?(0))
          return nil
        end
        iterator_ = document_events.list_iterator(document_events.size)
        first_event = iterator_.previous
        # current merged event
        document = first_event.get_document
        offset = first_event.get_offset
        length_ = first_event.get_length
        text_length = (first_event.get_text).nil? ? 0 : first_event.get_text.length
        while (iterator_.has_previous)
          delta = length_ - text_length
          event = iterator_.previous
          event_offset = event.get_offset
          event_length = event.get_length
          event_text_length = (event.get_text).nil? ? 0 : event.get_text.length
          # event is right from merged event
          if (event_offset > offset + text_length + delta)
            length_ = (event_offset - delta) - (offset + text_length) + length_ + event_length
            text_length = (event_offset - delta) + event_text_length - offset
            # event is left from merged event
          else
            if (event_offset + event_text_length < offset)
              length_ = offset - (event_offset + event_text_length) + length_ + event_length
              text_length = offset + text_length - event_offset
              offset = event_offset
              # events overlap each other
            else
              start = Math.max(0, event_offset - offset)
              end_ = Math.min(length_, event_text_length + event_offset - offset)
              length_ += event_length - (end_ - start)
              offset = Math.min(offset, event_offset)
              total_delta = delta + event_length - event_text_length
              text_length = length_ - total_delta
            end
          end
        end
        text = document.get(offset, text_length)
        return DocumentEvent.new(document, offset, length_, text)
      end
      
      typesig { [IDocument] }
      # Removes all connected document partitioners from the given document and stores them
      # under their partitioning name in a map. This map is returned. After this method has been called
      # the given document is no longer connected to any document partitioner.
      # 
      # @param document the document
      # @return the map containing the removed partitioners
      def remove_document_partitioners(document)
        partitioners = HashMap.new
        if (document.is_a?(IDocumentExtension3))
          extension3 = document
          partitionings = extension3.get_partitionings
          i = 0
          while i < partitionings.attr_length
            partitioner = extension3.get_document_partitioner(partitionings[i])
            if (!(partitioner).nil?)
              extension3.set_document_partitioner(partitionings[i], nil)
              partitioner.disconnect
              partitioners.put(partitionings[i], partitioner)
            end
            i += 1
          end
        else
          partitioner = document.get_document_partitioner
          if (!(partitioner).nil?)
            document.set_document_partitioner(nil)
            partitioner.disconnect
            partitioners.put(IDocumentExtension3::DEFAULT_PARTITIONING, partitioner)
          end
        end
        return partitioners
      end
      
      typesig { [IDocument, Map] }
      # Connects the given document with all document partitioners stored in the given map under
      # their partitioning name. This method cleans the given map.
      # 
      # @param document the document
      # @param partitioners the map containing the partitioners to be connected
      # @since 3.0
      def add_document_partitioners(document, partitioners)
        if (document.is_a?(IDocumentExtension3))
          extension3 = document
          e = partitioners.key_set.iterator
          while (e.has_next)
            partitioning = e.next_
            partitioner = partitioners.get(partitioning)
            partitioner.connect(document)
            extension3.set_document_partitioner(partitioning, partitioner)
          end
          partitioners.clear
        else
          partitioner = partitioners.get(IDocumentExtension3::DEFAULT_PARTITIONING)
          partitioner.connect(document)
          document.set_document_partitioner(partitioner)
        end
      end
      
      typesig { [IDocument, String, ::Java::Int, ::Java::Boolean] }
      # Returns the content type at the given offset of the given document.
      # 
      # @param document the document
      # @param partitioning the partitioning to be used
      # @param offset the offset
      # @param preferOpenPartitions <code>true</code> if precedence should be
      # given to a open partition ending at <code>offset</code> over a
      # closed partition starting at <code>offset</code>
      # @return the content type at the given offset of the document
      # @throws BadLocationException if offset is invalid in the document
      # @since 3.0
      def get_content_type(document, partitioning, offset, prefer_open_partitions)
        if (document.is_a?(IDocumentExtension3))
          extension3 = document
          begin
            return extension3.get_content_type(partitioning, offset, prefer_open_partitions)
          rescue BadPartitioningException => x
            return IDocument::DEFAULT_CONTENT_TYPE
          end
        end
        return document.get_content_type(offset)
      end
      
      typesig { [IDocument, String, ::Java::Int, ::Java::Boolean] }
      # Returns the partition of the given offset of the given document.
      # 
      # @param document the document
      # @param partitioning the partitioning to be used
      # @param offset the offset
      # @param preferOpenPartitions <code>true</code> if precedence should be
      # given to a open partition ending at <code>offset</code> over a
      # closed partition starting at <code>offset</code>
      # @return the content type at the given offset of this viewer's input
      # document
      # @throws BadLocationException if offset is invalid in the given document
      # @since 3.0
      def get_partition(document, partitioning, offset, prefer_open_partitions)
        if (document.is_a?(IDocumentExtension3))
          extension3 = document
          begin
            return extension3.get_partition(partitioning, offset, prefer_open_partitions)
          rescue BadPartitioningException => x
            return TypedRegion.new(0, document.get_length, IDocument::DEFAULT_CONTENT_TYPE)
          end
        end
        return document.get_partition(offset)
      end
      
      typesig { [IDocument, String, ::Java::Int, ::Java::Int, ::Java::Boolean] }
      # Computes and returns the partitioning for the given region of the given
      # document for the given partitioning name.
      # 
      # @param document the document
      # @param partitioning the partitioning name
      # @param offset the region offset
      # @param length the region length
      # @param includeZeroLengthPartitions whether to include zero-length partitions
      # @return the partitioning for the given region of the given document for
      # the given partitioning name
      # @throws BadLocationException if the given region is invalid for the given
      # document
      # @since 3.0
      def compute_partitioning(document, partitioning, offset, length_, include_zero_length_partitions)
        if (document.is_a?(IDocumentExtension3))
          extension3 = document
          begin
            return extension3.compute_partitioning(partitioning, offset, length_, include_zero_length_partitions)
          rescue BadPartitioningException => x
            return Array.typed(ITypedRegion).new(0) { nil }
          end
        end
        return document.compute_partitioning(offset, length_)
      end
      
      typesig { [IDocument] }
      # Computes and returns the partition managing position categories for the
      # given document or <code>null</code> if this was impossible.
      # 
      # @param document the document
      # @return the partition managing position categories or <code>null</code>
      # @since 3.0
      def compute_partition_managing_categories(document)
        if (document.is_a?(IDocumentExtension3))
          extension3 = document
          partitionings = extension3.get_partitionings
          if (!(partitionings).nil?)
            categories = HashSet.new
            i = 0
            while i < partitionings.attr_length
              p = extension3.get_document_partitioner(partitionings[i])
              if (p.is_a?(IDocumentPartitionerExtension2))
                extension2 = p
                c = extension2.get_managing_position_categories
                if (!(c).nil?)
                  j = 0
                  while j < c.attr_length
                    categories.add(c[j])
                    j += 1
                  end
                end
              end
              i += 1
            end
            result = Array.typed(String).new(categories.size) { nil }
            categories.to_array(result)
            return result
          end
        end
        return nil
      end
      
      typesig { [IDocument] }
      # Returns the default line delimiter for the given document. This is either the delimiter of the first line, or the platform line delimiter if it is
      # a legal line delimiter or the first one of the legal line delimiters. The default line delimiter should be used when performing document
      # manipulations that span multiple lines.
      # 
      # @param document the document
      # @return the document's default line delimiter
      # @since 3.0
      def get_default_line_delimiter(document)
        if (document.is_a?(IDocumentExtension4))
          return (document).get_default_line_delimiter
        end
        line_delimiter = nil
        begin
          line_delimiter = RJava.cast_to_string(document.get_line_delimiter(0))
        rescue BadLocationException => x
        end
        if (!(line_delimiter).nil?)
          return line_delimiter
        end
        sys_line_delimiter = System.get_property("line.separator") # $NON-NLS-1$
        delimiters = document.get_legal_line_delimiters
        Assert.is_true(delimiters.attr_length > 0)
        i = 0
        while i < delimiters.attr_length
          if ((delimiters[i] == sys_line_delimiter))
            line_delimiter = sys_line_delimiter
            break
          end
          i += 1
        end
        if ((line_delimiter).nil?)
          line_delimiter = RJava.cast_to_string(delimiters[0])
        end
        return line_delimiter
      end
      
      typesig { [IRegion, IRegion] }
      # Returns <code>true</code> if the two regions overlap. Returns <code>false</code> if one of the
      # arguments is <code>null</code>.
      # 
      # @param left the left region
      # @param right the right region
      # @return <code>true</code> if the two regions overlap, <code>false</code> otherwise
      # @since 3.0
      def overlaps(left, right)
        if ((left).nil? || (right).nil?)
          return false
        end
        right_end = right.get_offset + right.get_length
        left_end = left.get_offset + left.get_length
        if (right.get_length > 0)
          if (left.get_length > 0)
            return left.get_offset < right_end && right.get_offset < left_end
          end
          return right.get_offset <= left.get_offset && left.get_offset < right_end
        end
        if (left.get_length > 0)
          return left.get_offset <= right.get_offset && right.get_offset < left_end
        end
        return (left.get_offset).equal?(right.get_offset)
      end
      
      typesig { [Array.typed(String)] }
      # Returns a copy of the given string array.
      # 
      # @param array the string array to be copied
      # @return a copy of the given string array or <code>null</code> when <code>array</code> is <code>null</code>
      # @since 3.1
      def copy(array)
        if (!(array).nil?)
          copy = Array.typed(String).new(array.attr_length) { nil }
          System.arraycopy(array, 0, copy, 0, array.attr_length)
          return copy
        end
        return nil
      end
      
      typesig { [Array.typed(::Java::Int)] }
      # Returns a copy of the given integer array.
      # 
      # @param array the integer array to be copied
      # @return a copy of the given integer array or <code>null</code> when <code>array</code> is <code>null</code>
      # @since 3.1
      def copy(array)
        if (!(array).nil?)
          copy = Array.typed(::Java::Int).new(array.attr_length) { 0 }
          System.arraycopy(array, 0, copy, 0, array.attr_length)
          return copy
        end
        return nil
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__text_utilities, :initialize
  end
  
end
