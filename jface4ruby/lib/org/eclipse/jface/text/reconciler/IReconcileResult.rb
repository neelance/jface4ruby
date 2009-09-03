require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Reconciler
  module IReconcileResultImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Reconciler
    }
  end
  
  # Tagging interface for the {@linkplain org.eclipse.jface.text.reconciler.IReconcileStep reconcile step}
  # result's array element type.
  # <p>
  # This interface must be implemented by clients that want to
  # let one of their model elements be part of a reconcile step result.
  # </p>
  # 
  # @see org.eclipse.jface.text.reconciler.IReconcileStep
  # @since 3.0
  module IReconcileResult
    include_class_members IReconcileResultImports
  end
  
end
