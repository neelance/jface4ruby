require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ITreePathLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # An extension to {@link ILabelProvider} that is given the
  # path of the element being decorated, when it is available.
  # @since 3.2
  module ITreePathLabelProvider
    include_class_members ITreePathLabelProviderImports
    include IBaseLabelProvider
    
    typesig { [ViewerLabel, TreePath] }
    # Updates the label for the given element.
    # 
    # @param label the label to update
    # @param elementPath the path of the element being decorated
    def update_label(label, element_path)
      raise NotImplementedError
    end
  end
  
end
