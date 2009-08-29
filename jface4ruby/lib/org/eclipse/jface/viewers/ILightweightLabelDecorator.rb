require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ILightweightLabelDecoratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # The <code>ILightweightLabelDecorator</code> is a decorator that decorates
  # using a prefix, suffix and overlay image rather than doing all
  # of the image and text management itself like an <code>ILabelDecorator</code>.
  module ILightweightLabelDecorator
    include_class_members ILightweightLabelDecoratorImports
    include IBaseLabelProvider
    
    typesig { [Object, IDecoration] }
    # Calculates decorations based on element.
    # 
    # @param element the element to decorate
    # @param decoration the decoration to set
    def decorate(element, decoration)
      raise NotImplementedError
    end
  end
  
end
