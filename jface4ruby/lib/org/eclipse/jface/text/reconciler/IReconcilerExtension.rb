require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Reconciler
  module IReconcilerExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Reconciler
    }
  end
  
  # Extends {@link org.eclipse.jface.text.reconciler.IReconciler} with
  # the ability to be aware of documents with multiple partitionings.
  # 
  # @since 3.0
  module IReconcilerExtension
    include_class_members IReconcilerExtensionImports
    
    typesig { [] }
    # Returns the partitioning this reconciler is using.
    # 
    # @return the partitioning this reconciler is using
    def get_document_partitioning
      raise NotImplementedError
    end
  end
  
end
