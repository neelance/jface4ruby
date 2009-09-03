require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Information
  module IInformationPresenterExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Information
    }
  end
  
  # Extends {@link org.eclipse.jface.text.information.IInformationPresenter} with
  # the ability to handle documents with multiple partitions.
  # 
  # @see org.eclipse.jface.text.information.IInformationPresenter
  # 
  # @since 3.0
  module IInformationPresenterExtension
    include_class_members IInformationPresenterExtensionImports
    
    typesig { [] }
    # Returns the document partitioning this information presenter is using.
    # 
    # @return the document partitioning this information presenter is using
    def get_document_partitioning
      raise NotImplementedError
    end
  end
  
end
