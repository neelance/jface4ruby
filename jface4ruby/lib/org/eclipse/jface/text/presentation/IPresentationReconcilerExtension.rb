require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Presentation
  module IPresentationReconcilerExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Presentation
    }
  end
  
  # Extension interface for {@link IPresentationReconciler}. Adds awareness of
  # documents with multiple partitions.
  # 
  # @since 3.0
  module IPresentationReconcilerExtension
    include_class_members IPresentationReconcilerExtensionImports
    
    typesig { [] }
    # Returns the document partitioning this presentation reconciler is using.
    # 
    # @return the document partitioning this presentation reconciler is using
    def get_document_partitioning
      raise NotImplementedError
    end
  end
  
end
