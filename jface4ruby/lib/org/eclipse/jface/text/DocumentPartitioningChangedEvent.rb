require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DocumentPartitioningChangedEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Event describing the change of document partitionings.
  # 
  # @see org.eclipse.jface.text.IDocumentExtension3
  # @since 3.0
  class DocumentPartitioningChangedEvent 
    include_class_members DocumentPartitioningChangedEventImports
    
    # The document whose partitionings changed
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The map of partitionings to changed regions.
    attr_accessor :f_map
    alias_method :attr_f_map, :f_map
    undef_method :f_map
    alias_method :attr_f_map=, :f_map=
    undef_method :f_map=
    
    typesig { [IDocument] }
    # Creates a new document partitioning changed event for the given document.
    # Initially this event is empty, i.e. does not describe any change.
    # 
    # @param document the changed document
    def initialize(document)
      @f_document = nil
      @f_map = HashMap.new
      @f_document = document
    end
    
    typesig { [] }
    # Returns the changed document.
    # 
    # @return the changed document
    def get_document
      return @f_document
    end
    
    typesig { [String] }
    # Returns the changed region of the given partitioning or <code>null</code>
    # if the given partitioning did not change.
    # 
    # @param partitioning the partitioning
    # @return the changed region of the given partitioning or <code>null</code>
    def get_changed_region(partitioning)
      return @f_map.get(partitioning)
    end
    
    typesig { [] }
    # Returns the set of changed partitionings.
    # 
    # @return the set of changed partitionings
    def get_changed_partitionings
      partitionings = Array.typed(String).new(@f_map.size) { nil }
      @f_map.key_set.to_array(partitionings)
      return partitionings
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Sets the specified range as changed region for the given partitioning.
    # 
    # @param partitioning the partitioning
    # @param offset the region offset
    # @param length the region length
    def set_partition_change(partitioning, offset, length)
      Assert.is_not_null(partitioning)
      @f_map.put(partitioning, Region.new(offset, length))
    end
    
    typesig { [] }
    # Returns <code>true</code> if the set of changed partitionings is empty,
    # <code>false</code> otherwise.
    # 
    # @return <code>true</code> if the set of changed partitionings is empty
    def is_empty
      return @f_map.is_empty
    end
    
    typesig { [] }
    # Returns the coverage of this event. This is the minimal region that
    # contains all changed regions of all changed partitionings.
    # 
    # @return the coverage of this event
    def get_coverage
      if (@f_map.is_empty)
        return Region.new(0, 0)
      end
      offset = -1
      end_offset = -1
      e = @f_map.values.iterator
      while (e.has_next)
        r = e.next_
        if (offset < 0 || r.get_offset < offset)
          offset = r.get_offset
        end
        end_ = r.get_offset + r.get_length
        if (end_ > end_offset)
          end_offset = end_
        end
      end
      return Region.new(offset, end_offset - offset)
    end
    
    private
    alias_method :initialize__document_partitioning_changed_event, :initialize
  end
  
end
