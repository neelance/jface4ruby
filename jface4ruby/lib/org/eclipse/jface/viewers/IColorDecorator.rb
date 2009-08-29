require "rjava"

# Copyright (c) 2004, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module IColorDecoratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Graphics, :Color
    }
  end
  
  # The IColorDecorator is an interface for objects that return a color to
  # decorate either the foreground and background colors for displaying an
  # an object.
  # 
  # If an IColorDecorator decorates a foreground or background in an object
  # that also has an IColorProvider the IColorDecorator will take precedence.
  # @see IColorProvider
  # 
  # @since 3.1
  module IColorDecorator
    include_class_members IColorDecoratorImports
    
    typesig { [Object] }
    # Return the foreground Color for element or <code>null</code> if there
    # is not one.
    # @param element
    # @return Color or <code>null</code>
    def decorate_foreground(element)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Return the background Color for element or <code>null</code> if there
    # is not one.
    # @param element
    # @return Color or <code>null</code>
    def decorate_background(element)
      raise NotImplementedError
    end
  end
  
end
