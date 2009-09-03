require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Reconciler
  module ReconcilerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Reconciler
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentExtension3
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITypedRegion
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
      include_const ::Org::Eclipse::Jface::Text, :TypedRegion
    }
  end
  
  # Standard implementation of {@link org.eclipse.jface.text.reconciler.IReconciler}.
  # The reconciler is configured with a set of {@linkplain org.eclipse.jface.text.reconciler.IReconcilingStrategy reconciling strategies}
  # each of which is responsible for a particular content type.
  # <p>
  # Usually, clients instantiate this class and configure it before using it.
  # </p>
  # 
  # @see org.eclipse.jface.text.IDocumentListener
  # @see org.eclipse.jface.text.ITextInputListener
  # @see org.eclipse.jface.text.reconciler.DirtyRegion
  class Reconciler < ReconcilerImports.const_get :AbstractReconciler
    include_class_members ReconcilerImports
    overload_protected {
      include IReconcilerExtension
    }
    
    # The map of reconciling strategies.
    attr_accessor :f_strategies
    alias_method :attr_f_strategies, :f_strategies
    undef_method :f_strategies
    alias_method :attr_f_strategies=, :f_strategies=
    undef_method :f_strategies=
    
    # The partitioning this reconciler uses.
    # @since 3.0
    attr_accessor :f_partitioning
    alias_method :attr_f_partitioning, :f_partitioning
    undef_method :f_partitioning
    alias_method :attr_f_partitioning=, :f_partitioning=
    undef_method :f_partitioning=
    
    typesig { [] }
    # Creates a new reconciler with the following configuration: it is
    # an incremental reconciler with a standard delay of 500 milliseconds. There
    # are no predefined reconciling strategies. The partitioning it uses
    # is the default partitioning {@link IDocumentExtension3#DEFAULT_PARTITIONING}.
    def initialize
      @f_strategies = nil
      @f_partitioning = nil
      super()
      @f_partitioning = RJava.cast_to_string(IDocumentExtension3::DEFAULT_PARTITIONING)
    end
    
    typesig { [String] }
    # Sets the document partitioning for this reconciler.
    # 
    # @param partitioning the document partitioning for this reconciler
    # @since 3.0
    def set_document_partitioning(partitioning)
      Assert.is_not_null(partitioning)
      @f_partitioning = partitioning
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.reconciler.IReconcilerExtension#getDocumentPartitioning()
    # @since 3.0
    def get_document_partitioning
      return @f_partitioning
    end
    
    typesig { [IReconcilingStrategy, String] }
    # Registers a given reconciling strategy for a particular content type.
    # If there is already a strategy registered for this type, the new strategy
    # is registered instead of the old one.
    # 
    # @param strategy the reconciling strategy to register, or <code>null</code> to remove an existing one
    # @param contentType the content type under which to register
    def set_reconciling_strategy(strategy, content_type)
      Assert.is_not_null(content_type)
      if ((@f_strategies).nil?)
        @f_strategies = HashMap.new
      end
      if ((strategy).nil?)
        @f_strategies.remove(content_type)
      else
        @f_strategies.put(content_type, strategy)
        if (strategy.is_a?(IReconcilingStrategyExtension) && !(get_progress_monitor).nil?)
          extension = strategy
          extension.set_progress_monitor(get_progress_monitor)
        end
      end
    end
    
    typesig { [String] }
    # @see IReconciler#getReconcilingStrategy(String)
    def get_reconciling_strategy(content_type)
      Assert.is_not_null(content_type)
      if ((@f_strategies).nil?)
        return nil
      end
      return @f_strategies.get(content_type)
    end
    
    typesig { [DirtyRegion] }
    # Processes a dirty region. If the dirty region is <code>null</code> the whole
    # document is consider being dirty. The dirty region is partitioned by the
    # document and each partition is handed over to a reconciling strategy registered
    # for the partition's content type.
    # 
    # @param dirtyRegion the dirty region to be processed
    # @see AbstractReconciler#process(DirtyRegion)
    def process(dirty_region)
      region = dirty_region
      if ((region).nil?)
        region = Region.new(0, get_document.get_length)
      end
      regions = compute_partitioning(region.get_offset, region.get_length)
      i = 0
      while i < regions.attr_length
        r = regions[i]
        s = get_reconciling_strategy(r.get_type)
        if ((s).nil?)
          i += 1
          next
        end
        if (!(dirty_region).nil?)
          s.reconcile(dirty_region, r)
        else
          s.reconcile(r)
        end
        i += 1
      end
    end
    
    typesig { [IDocument] }
    # @see AbstractReconciler#reconcilerDocumentChanged(IDocument)
    # @since 2.0
    def reconciler_document_changed(document)
      if (!(@f_strategies).nil?)
        e = @f_strategies.values.iterator
        while (e.has_next)
          strategy = e.next_
          strategy.set_document(document)
        end
      end
    end
    
    typesig { [IProgressMonitor] }
    # @see AbstractReconciler#setProgressMonitor(IProgressMonitor)
    # @since 2.0
    def set_progress_monitor(monitor)
      super(monitor)
      if (!(@f_strategies).nil?)
        e = @f_strategies.values.iterator
        while (e.has_next)
          strategy = e.next_
          if (strategy.is_a?(IReconcilingStrategyExtension))
            extension = strategy
            extension.set_progress_monitor(monitor)
          end
        end
      end
    end
    
    typesig { [] }
    # @see AbstractReconciler#initialProcess()
    # @since 2.0
    def initial_process
      regions = compute_partitioning(0, get_document.get_length)
      content_types = ArrayList.new(regions.attr_length)
      i = 0
      while i < regions.attr_length
        content_type = regions[i].get_type
        if (content_types.contains(content_type))
          i += 1
          next
        end
        content_types.add(content_type)
        s = get_reconciling_strategy(content_type)
        if (s.is_a?(IReconcilingStrategyExtension))
          e = s
          e.initial_reconcile
        end
        i += 1
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Computes and returns the partitioning for the given region of the input document
    # of the reconciler's connected text viewer.
    # 
    # @param offset the region offset
    # @param length the region length
    # @return the computed partitioning
    # @since 3.0
    def compute_partitioning(offset, length)
      regions = nil
      begin
        regions = TextUtilities.compute_partitioning(get_document, get_document_partitioning, offset, length, false)
      rescue BadLocationException => x
        regions = Array.typed(TypedRegion).new(0) { nil }
      end
      return regions
    end
    
    private
    alias_method :initialize__reconciler, :initialize
  end
  
end
