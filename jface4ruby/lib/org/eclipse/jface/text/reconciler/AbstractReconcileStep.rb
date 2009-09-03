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
  module AbstractReconcileStepImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Reconciler
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Collection
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Core::Runtime, :IProgressMonitor
      include_const ::Org::Eclipse::Jface::Text, :IRegion
    }
  end
  
  # Abstract implementation of a reconcile step.
  # 
  # @since 3.0
  class AbstractReconcileStep 
    include_class_members AbstractReconcileStepImports
    include IReconcileStep
    
    attr_accessor :f_next_step
    alias_method :attr_f_next_step, :f_next_step
    undef_method :f_next_step
    alias_method :attr_f_next_step=, :f_next_step=
    undef_method :f_next_step=
    
    attr_accessor :f_previous_step
    alias_method :attr_f_previous_step, :f_previous_step
    undef_method :f_previous_step
    alias_method :attr_f_previous_step=, :f_previous_step=
    undef_method :f_previous_step=
    
    attr_accessor :f_progress_monitor
    alias_method :attr_f_progress_monitor, :f_progress_monitor
    undef_method :f_progress_monitor
    alias_method :attr_f_progress_monitor=, :f_progress_monitor=
    undef_method :f_progress_monitor=
    
    attr_accessor :f_input_model
    alias_method :attr_f_input_model, :f_input_model
    undef_method :f_input_model
    alias_method :attr_f_input_model=, :f_input_model=
    undef_method :f_input_model=
    
    typesig { [IReconcileStep] }
    # Creates an intermediate reconcile step which adds
    # the given step to the pipe.
    # 
    # @param step the reconcile step
    def initialize(step)
      @f_next_step = nil
      @f_previous_step = nil
      @f_progress_monitor = nil
      @f_input_model = nil
      Assert.is_not_null(step)
      @f_next_step = step
      @f_next_step.set_previous_step(self)
    end
    
    typesig { [] }
    # Creates the last reconcile step of the pipe.
    def initialize
      @f_next_step = nil
      @f_previous_step = nil
      @f_progress_monitor = nil
      @f_input_model = nil
    end
    
    typesig { [] }
    def is_last_step
      return (@f_next_step).nil?
    end
    
    typesig { [] }
    def is_first_step
      return (@f_previous_step).nil?
    end
    
    typesig { [IProgressMonitor] }
    # @see org.eclipse.text.reconcilerpipe.IReconcilerResultCollector#setProgressMonitor(org.eclipse.core.runtime.IProgressMonitor)
    def set_progress_monitor(monitor)
      @f_progress_monitor = monitor
      if (!is_last_step)
        @f_next_step.set_progress_monitor(monitor)
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.reconciler.IReconcileStep#getProgressMonitor()
    def get_progress_monitor
      return @f_progress_monitor
    end
    
    typesig { [IRegion] }
    # @see IReconcileStep#reconcile(IRegion)
    def reconcile(partition)
      result = reconcile_model(nil, partition)
      if (!is_last_step)
        @f_next_step.set_input_model(get_model)
        next_result = @f_next_step.reconcile(partition)
        return merge(result, convert_to_input_model(next_result))
      end
      return result
    end
    
    typesig { [DirtyRegion, IRegion] }
    # @see IReconcileStep#reconcile(org.eclipse.jface.text.reconciler.DirtyRegion, org.eclipse.jface.text.IRegion)
    def reconcile(dirty_region, sub_region)
      result = reconcile_model(dirty_region, sub_region)
      if (!is_last_step)
        @f_next_step.set_input_model(get_model)
        next_result = @f_next_step.reconcile(dirty_region, sub_region)
        return merge(result, convert_to_input_model(next_result))
      end
      return result
    end
    
    typesig { [DirtyRegion, IRegion] }
    # Reconciles the model of this reconcile step. The
    # result is based on the input model.
    # 
    # @param dirtyRegion the document region which has been changed
    # @param subRegion the sub region in the dirty region which should be reconciled
    # @return an array with reconcile results
    def reconcile_model(dirty_region, sub_region)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(IReconcileResult)] }
    # Adapts the given an array with reconcile results to
    # this step's input model and returns it.
    # 
    # @param inputResults an array with reconcile results
    # @return an array with the reconcile results adapted to the input model
    def convert_to_input_model(input_results)
      return input_results
    end
    
    typesig { [Array.typed(IReconcileResult), Array.typed(IReconcileResult)] }
    # Merges the two reconcile result arrays.
    # 
    # @param results1 an array with reconcile results
    # @param results2 an array with reconcile results
    # @return an array with the merged reconcile results
    def merge(results1, results2)
      if ((results1).nil?)
        return results2
      end
      if ((results2).nil?)
        return results1
      end
      # XXX: not yet performance optimized
      collection = ArrayList.new(Arrays.as_list(results1))
      collection.add_all(Arrays.as_list(results2))
      return collection.to_array(Array.typed(IReconcileResult).new(collection.size) { nil })
    end
    
    typesig { [] }
    # @see IProgressMonitor#isCanceled()
    def is_canceled
      return !(@f_progress_monitor).nil? && @f_progress_monitor.is_canceled
    end
    
    typesig { [IReconcileStep] }
    # @see IReconcileStep#setPreviousStep(IReconcileStep)
    def set_previous_step(step)
      Assert.is_not_null(step)
      Assert.is_true((@f_previous_step).nil?)
      @f_previous_step = step
    end
    
    typesig { [IReconcilableModel] }
    # @see IReconcileStep#setInputModel(Object)
    def set_input_model(input_model)
      @f_input_model = input_model
      if (!is_last_step)
        @f_next_step.set_input_model(get_model)
      end
    end
    
    typesig { [] }
    # Returns the reconcilable input model.
    # 
    # @return the reconcilable input model.
    def get_input_model
      return @f_input_model
    end
    
    typesig { [] }
    # Returns the reconcilable model.
    # 
    # @return the reconcilable model
    def get_model
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__abstract_reconcile_step, :initialize
  end
  
end
