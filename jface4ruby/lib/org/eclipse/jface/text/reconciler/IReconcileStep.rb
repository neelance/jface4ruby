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
  module IReconcileStepImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Reconciler
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Jface::Text, :IRegion
    }
  end
  
  # A reconcile step is one of several steps of a
  # {@linkplain org.eclipse.jface.text.reconciler.IReconcilingStrategy reconcile strategy}
  # that consists of several steps. This relationship is not coded into an interface but
  # should be used by clients who's reconcile strategy consists of several steps.
  # <p>
  # If a reconcile step has an {@linkplain org.eclipse.jface.text.reconciler.IReconcilableModel input model}
  # it will compute the correct model for the next step in the chain and set the next steps
  # input model before <code>reconcile</code> gets called on that next step. After the last
  # step has reconciled the {@linkplain org.eclipse.jface.text.reconciler.IReconcileResult reconcile result}
  # array gets returned to the previous step. Each step in the chain adapts the result to its
  # input model and returns it to its previous step.
  # </p>
  # <p>
  # Example: Assume a strategy consists of steps A, B and C. And the main model is M.
  # The strategy will set M to be A's input model. What will happen is:
  # <ol>
  # <li>A.setInputModel(M)</li>
  # <li>A.reconcile: A reconciles M</li>
  # <li>A computes the model for B =&gt; MB</li>
  # <li>B.setInputModel(MB)</li>
  # <li>B.reconcile: B reconciles MB</li>
  # <li>B computes the model for C =&gt; MC</li>
  # <li>C.setInputModel(MC)</li>
  # <li>C.reconcile: C reconciles MC</li>
  # <li>C returns result RC to step B</li>
  # <li>B adapts the RC to MB and merges with its own results</li>
  # <li>B returns result RB to step A</li>
  # <li>A adapts the result to M and merges with its own results</li>
  # <li>A returns the result to the reconcile strategy</li>
  # </ol>
  # </p>
  # <p>
  # This interface must be implemented by clients.
  # </p>
  # @since 3.0
  module IReconcileStep
    include_class_members IReconcileStepImports
    
    typesig { [] }
    # Returns whether this is the last reconcile step or not.
    # 
    # @return <code>true</code> iff this is the last reconcile step
    def is_last_step
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this is the first reconcile step or not.
    # 
    # @return <code>true</code> iff this is the first reconcile step
    def is_first_step
      raise NotImplementedError
    end
    
    typesig { [IReconcileStep] }
    # Sets the step which is in front of this step in the pipe.
    # <p>
    # Note: This method must be called at most once per reconcile step.
    # </p>
    # 
    # @param step the previous step
    # @throws RuntimeException if called more than once
    def set_previous_step(step)
      raise NotImplementedError
    end
    
    typesig { [DirtyRegion, IRegion] }
    # Activates incremental reconciling of the specified dirty region.
    # As a dirty region might span multiple content types, the segment of the
    # dirty region which should be investigated is also provided to this
    # reconciling strategy. The given regions refer to the document passed into
    # the most recent call of {@link IReconcilingStrategy#setDocument(org.eclipse.jface.text.IDocument)}.
    # 
    # @param dirtyRegion the document region which has been changed
    # @param subRegion the sub region in the dirty region which should be reconciled
    # @return an array with reconcile results
    def reconcile(dirty_region, sub_region)
      raise NotImplementedError
    end
    
    typesig { [IRegion] }
    # Activates non-incremental reconciling. The reconciling strategy is just told
    # that there are changes and that it should reconcile the given partition of the
    # document most recently passed into {@link IReconcilingStrategy#setDocument(org.eclipse.jface.text.IDocument)}.
    # 
    # @param partition the document partition to be reconciled
    # @return an array with reconcile results
    def reconcile(partition)
      raise NotImplementedError
    end
    
    typesig { [IProgressMonitor] }
    # Sets the progress monitor for this reconcile step.
    # 
    # @param monitor the progress monitor to be used
    def set_progress_monitor(monitor)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the progress monitor used to report progress.
    # 
    # @return a progress monitor or <code>null</code> if no progress monitor is available
    def get_progress_monitor
      raise NotImplementedError
    end
    
    typesig { [IReconcilableModel] }
    # Tells this reconcile step on which model it will
    # work. This method will be called before any other method
    # and can be called multiple times. The regions passed to the
    # other methods always refer to the most recent model
    # passed into this method.
    # 
    # @param inputModel the model on which this step will work
    def set_input_model(input_model)
      raise NotImplementedError
    end
  end
  
end
