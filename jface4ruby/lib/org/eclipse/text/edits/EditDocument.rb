require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Edits
  module EditDocumentImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :BadPositionCategoryException
      include_const ::Org::Eclipse::Jface::Text, :FindReplaceDocumentAdapter
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :IDocumentPartitioner
      include_const ::Org::Eclipse::Jface::Text, :IDocumentPartitioningListener
      include_const ::Org::Eclipse::Jface::Text, :IPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITypedRegion
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  class EditDocument 
    include_class_members EditDocumentImports
    include IDocument
    
    attr_accessor :f_buffer
    alias_method :attr_f_buffer, :f_buffer
    undef_method :f_buffer
    alias_method :attr_f_buffer=, :f_buffer=
    undef_method :f_buffer=
    
    typesig { [String] }
    def initialize(content)
      @f_buffer = nil
      @f_buffer = StringBuffer.new(content)
    end
    
    typesig { [IDocumentListener] }
    def add_document_listener(listener)
      raise UnsupportedOperationException.new
    end
    
    typesig { [IDocumentPartitioningListener] }
    def add_document_partitioning_listener(listener)
      raise UnsupportedOperationException.new
    end
    
    typesig { [Position] }
    def add_position(position)
      raise UnsupportedOperationException.new
    end
    
    typesig { [String, Position] }
    def add_position(category, position)
      raise UnsupportedOperationException.new
    end
    
    typesig { [String] }
    def add_position_category(category)
      raise UnsupportedOperationException.new
    end
    
    typesig { [IPositionUpdater] }
    def add_position_updater(updater)
      raise UnsupportedOperationException.new
    end
    
    typesig { [IDocumentListener] }
    def add_prenotified_document_listener(document_adapter)
      raise UnsupportedOperationException.new
    end
    
    typesig { [String, ::Java::Int] }
    def compute_index_in_category(category, offset)
      raise UnsupportedOperationException.new
    end
    
    typesig { [String] }
    def compute_number_of_lines(text)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def compute_partitioning(offset, length)
      raise UnsupportedOperationException.new
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    def contains_position(category, offset, length)
      raise UnsupportedOperationException.new
    end
    
    typesig { [String] }
    def contains_position_category(category)
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    def get
      return @f_buffer.to_s
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def get(offset, length)
      return @f_buffer.substring(offset, offset + length)
    end
    
    typesig { [::Java::Int] }
    def get_char(offset)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    def get_content_type(offset)
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    def get_document_partitioner
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    def get_legal_content_types
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    def get_legal_line_delimiters
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    def get_length
      return @f_buffer.length
    end
    
    typesig { [::Java::Int] }
    def get_line_delimiter(line)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    def get_line_information(line)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    def get_line_information_of_offset(offset)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    def get_line_length(line)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    def get_line_offset(line)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    def get_line_of_offset(offset)
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    def get_number_of_lines
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def get_number_of_lines(offset, length_)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int] }
    def get_partition(offset)
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    def get_position_categories
      raise UnsupportedOperationException.new
    end
    
    typesig { [String] }
    def get_positions(category)
      raise UnsupportedOperationException.new
    end
    
    typesig { [] }
    def get_position_updaters
      raise UnsupportedOperationException.new
    end
    
    typesig { [IPositionUpdater, ::Java::Int] }
    def insert_position_updater(updater, index)
      raise UnsupportedOperationException.new
    end
    
    typesig { [IDocumentListener] }
    def remove_document_listener(listener)
      raise UnsupportedOperationException.new
    end
    
    typesig { [IDocumentPartitioningListener] }
    def remove_document_partitioning_listener(listener)
      raise UnsupportedOperationException.new
    end
    
    typesig { [Position] }
    def remove_position(position)
      raise UnsupportedOperationException.new
    end
    
    typesig { [String, Position] }
    def remove_position(category, position)
      raise UnsupportedOperationException.new
    end
    
    typesig { [String] }
    def remove_position_category(category)
      raise UnsupportedOperationException.new
    end
    
    typesig { [IPositionUpdater] }
    def remove_position_updater(updater)
      raise UnsupportedOperationException.new
    end
    
    typesig { [IDocumentListener] }
    def remove_prenotified_document_listener(document_adapter)
      raise UnsupportedOperationException.new
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    def replace(offset, length_, text)
      @f_buffer.replace(offset, offset + length_, text)
    end
    
    typesig { [::Java::Int, String, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # {@inheritDoc}
    # 
    # @deprecated As of 3.0 search is provided by {@link FindReplaceDocumentAdapter}
    def search(start_offset, find_string, forward_search, case_sensitive, whole_word)
      raise UnsupportedOperationException.new
    end
    
    typesig { [String] }
    def set(text)
      raise UnsupportedOperationException.new
    end
    
    typesig { [IDocumentPartitioner] }
    def set_document_partitioner(partitioner)
      raise UnsupportedOperationException.new
    end
    
    private
    alias_method :initialize__edit_document, :initialize
  end
  
end
