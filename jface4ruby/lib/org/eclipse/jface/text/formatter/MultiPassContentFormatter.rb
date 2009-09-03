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
  module MultiPassContentFormatterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Formatter
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :DefaultPositionUpdater
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITypedRegion
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
      include_const ::Org::Eclipse::Jface::Text, :TypedPosition
    }
  end
  
  # Content formatter for edit-based formatting strategies.
  # <p>
  # Two kinds of formatting strategies can be registered with this formatter:
  # <ul>
  # <li>one master formatting strategy for the default content type</li>
  # <li>one formatting strategy for each non-default content type</li>
  # </ul>
  # The master formatting strategy always formats the whole region to be
  # formatted in the first pass. In a second pass, all partitions of the region
  # to be formatted that are not of master content type are formatted using the
  # slave formatting strategy registered for the underlying content type. All
  # formatting strategies must implement {@link IFormattingStrategyExtension}.
  # <p>
  # Regions to be formatted with the master formatting strategy always have
  # an offset aligned to the line start. Regions to be formatted with slave formatting
  # strategies are aligned on partition boundaries.
  # 
  # @see IFormattingStrategyExtension
  # @since 3.0
  class MultiPassContentFormatter 
    include_class_members MultiPassContentFormatterImports
    include IContentFormatter
    include IContentFormatterExtension
    
    class_module.module_eval {
      # Position updater that shifts otherwise deleted positions to the next
      # non-whitespace character. The length of the positions are truncated to
      # one if the position was shifted.
      const_set_lazy(:NonDeletingPositionUpdater) { Class.new(DefaultPositionUpdater) do
        extend LocalClass
        include_class_members MultiPassContentFormatter
        
        typesig { [String] }
        # Creates a new non-deleting position updater.
        # 
        # @param category The position category to update its positions
        def initialize(category)
          super(category)
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.DefaultPositionUpdater#notDeleted()
        def not_deleted
          if (self.attr_f_offset < self.attr_f_position.attr_offset && (self.attr_f_position.attr_offset + self.attr_f_position.attr_length < self.attr_f_offset + self.attr_f_length))
            offset = self.attr_f_offset + self.attr_f_length
            if (offset < self.attr_f_document.get_length)
              begin
                moved = false
                character = self.attr_f_document.get_char(offset)
                while (offset < self.attr_f_document.get_length && Character.is_whitespace(character))
                  moved = true
                  character = self.attr_f_document.get_char(((offset += 1) - 1))
                end
                if (moved)
                  offset -= 1
                end
              rescue self.class::BadLocationException => exception
                # Can not happen
              end
              self.attr_f_position.attr_offset = offset
              self.attr_f_position.attr_length = 0
            end
          end
          return true
        end
        
        private
        alias_method :initialize__non_deleting_position_updater, :initialize
      end }
    }
    
    # The master formatting strategy
    attr_accessor :f_master
    alias_method :attr_f_master, :f_master
    undef_method :f_master
    alias_method :attr_f_master=, :f_master=
    undef_method :f_master=
    
    # The partitioning of this content formatter
    attr_accessor :f_partitioning
    alias_method :attr_f_partitioning, :f_partitioning
    undef_method :f_partitioning
    alias_method :attr_f_partitioning=, :f_partitioning=
    undef_method :f_partitioning=
    
    # The slave formatting strategies
    attr_accessor :f_slaves
    alias_method :attr_f_slaves, :f_slaves
    undef_method :f_slaves
    alias_method :attr_f_slaves=, :f_slaves=
    undef_method :f_slaves=
    
    # The default content type
    attr_accessor :f_type
    alias_method :attr_f_type, :f_type
    undef_method :f_type
    alias_method :attr_f_type=, :f_type=
    undef_method :f_type=
    
    typesig { [String, String] }
    # Creates a new content formatter.
    # 
    # @param partitioning the document partitioning for this formatter
    # @param type the default content type
    def initialize(partitioning, type)
      @f_master = nil
      @f_partitioning = nil
      @f_slaves = HashMap.new
      @f_type = nil
      @f_partitioning = partitioning
      @f_type = type
    end
    
    typesig { [IDocument, IFormattingContext] }
    # @see org.eclipse.jface.text.formatter.IContentFormatterExtension#format(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.formatter.IFormattingContext)
    def format(medium, context)
      context.set_property(FormattingContextProperties::CONTEXT_MEDIUM, medium)
      document = context.get_property(FormattingContextProperties::CONTEXT_DOCUMENT)
      if ((document).nil? || !document.boolean_value)
        region = context.get_property(FormattingContextProperties::CONTEXT_REGION)
        if (!(region).nil?)
          begin
            format_master(context, medium, region.get_offset, region.get_length)
          ensure
            format_slaves(context, medium, region.get_offset, region.get_length)
          end
        end
      else
        begin
          format_master(context, medium, 0, medium.get_length)
        ensure
          format_slaves(context, medium, 0, medium.get_length)
        end
      end
    end
    
    typesig { [IDocument, IRegion] }
    # @see org.eclipse.jface.text.formatter.IContentFormatter#format(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IRegion)
    def format(medium, region)
      context = FormattingContext.new
      context.set_property(FormattingContextProperties::CONTEXT_DOCUMENT, Boolean::FALSE)
      context.set_property(FormattingContextProperties::CONTEXT_REGION, region)
      format(medium, context)
    end
    
    typesig { [IFormattingContext, IDocument, ::Java::Int, ::Java::Int] }
    # Formats the document specified in the formatting context with the master
    # formatting strategy.
    # <p>
    # The master formatting strategy covers all regions of the document. The
    # offset of the region to be formatted is aligned on line start boundaries,
    # whereas the end index of the region remains the same. For this formatting
    # type the document partitioning is not taken into account.
    # 
    # @param context The formatting context to use
    # @param document The document to operate on
    # @param offset The offset of the region to format
    # @param length The length of the region to format
    def format_master(context, document, offset, length)
      begin
        delta = offset - document.get_line_information_of_offset(offset).get_offset
        offset -= delta
        length += delta
      rescue BadLocationException => exception
        # Do nothing
      end
      if (!(@f_master).nil?)
        context.set_property(FormattingContextProperties::CONTEXT_PARTITION, TypedPosition.new(offset, length, @f_type))
        @f_master.formatter_starts(context)
        @f_master.format
        @f_master.formatter_stops
      end
    end
    
    typesig { [IFormattingContext, IDocument, ::Java::Int, ::Java::Int, String] }
    # Formats the document specified in the formatting context with the
    # formatting strategy registered for the content type.
    # <p>
    # For this formatting type only slave strategies are used. The region to be
    # formatted is aligned on partition boundaries of the underlying content
    # type. The exact formatting strategy is determined by the underlying
    # content type of the document partitioning.
    # 
    # @param context The formatting context to use
    # @param document The document to operate on
    # @param offset The offset of the region to format
    # @param length The length of the region to format
    # @param type The content type of the region to format
    def format_slave(context, document, offset, length, type)
      strategy = @f_slaves.get(type)
      if (!(strategy).nil?)
        context.set_property(FormattingContextProperties::CONTEXT_PARTITION, TypedPosition.new(offset, length, type))
        strategy.formatter_starts(context)
        strategy.format
        strategy.formatter_stops
      end
    end
    
    typesig { [IFormattingContext, IDocument, ::Java::Int, ::Java::Int] }
    # Formats the document specified in the formatting context with the slave
    # formatting strategies.
    # <p>
    # For each content type of the region to be formatted in the document
    # partitioning, the registered slave formatting strategy is used to format
    # that particular region. The region to be formatted is aligned on
    # partition boundaries of the underlying content type. If the content type
    # is the document's default content type, nothing happens.
    # 
    # @param context The formatting context to use
    # @param document The document to operate on
    # @param offset The offset of the region to format
    # @param length The length of the region to format
    def format_slaves(context, document, offset, length)
      partitioners = HashMap.new(0)
      begin
        partitions = TextUtilities.compute_partitioning(document, @f_partitioning, offset, length, false)
        if (!(@f_type == partitions[0].get_type))
          partitions[0] = TextUtilities.get_partition(document, @f_partitioning, partitions[0].get_offset, false)
        end
        if (partitions.attr_length > 1)
          if (!(@f_type == partitions[partitions.attr_length - 1].get_type))
            partitions[partitions.attr_length - 1] = TextUtilities.get_partition(document, @f_partitioning, partitions[partitions.attr_length - 1].get_offset, false)
          end
        end
        type = nil
        partition = nil
        partitioners = TextUtilities.remove_document_partitioners(document)
        index = partitions.attr_length - 1
        while index >= 0
          partition = partitions[index]
          type = RJava.cast_to_string(partition.get_type)
          if (!(@f_type == type))
            format_slave(context, document, partition.get_offset, partition.get_length, type)
          end
          index -= 1
        end
      rescue BadLocationException => exception
        # Should not happen
      ensure
        TextUtilities.add_document_partitioners(document, partitioners)
      end
    end
    
    typesig { [String] }
    # @see org.eclipse.jface.text.formatter.IContentFormatter#getFormattingStrategy(java.lang.String)
    def get_formatting_strategy(type)
      return nil
    end
    
    typesig { [IFormattingStrategy] }
    # Registers a master formatting strategy.
    # <p>
    # The strategy may already be registered with a certain content type as
    # slave strategy. The master strategy is registered for the default content
    # type of documents. If a master strategy has already been registered, it
    # is overridden by the new one.
    # 
    # @param strategy The master formatting strategy, must implement
    # {@link IFormattingStrategyExtension}
    def set_master_strategy(strategy)
      Assert.is_true(strategy.is_a?(IFormattingStrategyExtension))
      @f_master = strategy
    end
    
    typesig { [IFormattingStrategy, String] }
    # Registers a slave formatting strategy for a certain content type.
    # <p>
    # The strategy may already be registered as master strategy. An
    # already registered slave strategy for the specified content type
    # will be replaced. However, the same strategy may be registered with
    # several content types. Slave strategies cannot be registered for the
    # default content type of documents.
    # 
    # @param strategy The slave formatting strategy
    # @param type The content type to register this strategy with,
    # must implement {@link IFormattingStrategyExtension}
    def set_slave_strategy(strategy, type)
      Assert.is_true(strategy.is_a?(IFormattingStrategyExtension))
      if (!(@f_type == type))
        @f_slaves.put(type, strategy)
      end
    end
    
    private
    alias_method :initialize__multi_pass_content_formatter, :initialize
  end
  
end
