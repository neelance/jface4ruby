require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Reconciler
  module MonoReconcilerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Reconciler
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :Region
    }
  end
  
  # Standard implementation of {@link org.eclipse.jface.text.reconciler.IReconciler}.
  # The reconciler is configured with a single {@linkplain org.eclipse.jface.text.reconciler.IReconcilingStrategy reconciling strategy}
  # that is used independently from where a dirty region is located in the reconciler's
  # document.
  # <p>
  # Usually, clients instantiate this class and configure it before using it.
  # </p>
  # 
  # @see org.eclipse.jface.text.IDocumentListener
  # @see org.eclipse.jface.text.ITextInputListener
  # @see org.eclipse.jface.text.reconciler.DirtyRegion
  # @since 2.0
  class MonoReconciler < MonoReconcilerImports.const_get :AbstractReconciler
    include_class_members MonoReconcilerImports
    
    # The reconciling strategy.
    attr_accessor :f_strategy
    alias_method :attr_f_strategy, :f_strategy
    undef_method :f_strategy
    alias_method :attr_f_strategy=, :f_strategy=
    undef_method :f_strategy=
    
    typesig { [IReconcilingStrategy, ::Java::Boolean] }
    # Creates a new reconciler that uses the same reconciling strategy to
    # reconcile its document independent of the type of the document's contents.
    # 
    # @param strategy the reconciling strategy to be used
    # @param isIncremental the indication whether strategy is incremental or not
    def initialize(strategy, is_incremental)
      @f_strategy = nil
      super()
      Assert.is_not_null(strategy)
      @f_strategy = strategy
      if (@f_strategy.is_a?(IReconcilingStrategyExtension))
        extension = @f_strategy
        extension.set_progress_monitor(get_progress_monitor)
      end
      set_is_incremental_reconciler(is_incremental)
    end
    
    typesig { [String] }
    # @see IReconciler#getReconcilingStrategy(String)
    def get_reconciling_strategy(content_type)
      Assert.is_not_null(content_type)
      return @f_strategy
    end
    
    typesig { [DirtyRegion] }
    # @see AbstractReconciler#process(DirtyRegion)
    def process(dirty_region)
      if (!(dirty_region).nil?)
        @f_strategy.reconcile(dirty_region, dirty_region)
      else
        document = get_document
        if (!(document).nil?)
          @f_strategy.reconcile(Region.new(0, document.get_length))
        end
      end
    end
    
    typesig { [IDocument] }
    # @see AbstractReconciler#reconcilerDocumentChanged(IDocument)
    def reconciler_document_changed(document)
      @f_strategy.set_document(document)
    end
    
    typesig { [IProgressMonitor] }
    # @see AbstractReconciler#setProgressMonitor(IProgressMonitor)
    def set_progress_monitor(monitor)
      super(monitor)
      if (@f_strategy.is_a?(IReconcilingStrategyExtension))
        extension = @f_strategy
        extension.set_progress_monitor(monitor)
      end
    end
    
    typesig { [] }
    # @see AbstractReconciler#initialProcess()
    def initial_process
      if (@f_strategy.is_a?(IReconcilingStrategyExtension))
        extension = @f_strategy
        extension.initial_reconcile
      end
    end
    
    private
    alias_method :initialize__mono_reconciler, :initialize
  end
  
end
