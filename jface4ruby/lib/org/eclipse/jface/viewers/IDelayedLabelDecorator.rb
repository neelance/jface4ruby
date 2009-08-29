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
  module IDelayedLabelDecoratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # A delayed label decorator is a label decorator that may not have a
  # decoration available immediately. This interface defines the methods for
  # requesting the preparation of a decorator for an object and for querying
  # if the decorator is ready. Interested parties should register an
  # ILabelProviderListener with a delayed label decorator in order to be informed
  # when the decoration is ready.
  # @since 3.0
  module IDelayedLabelDecorator
    include_class_members IDelayedLabelDecoratorImports
    include ILabelDecorator
    
    typesig { [Object, String] }
    # Prepare the element for decoration. If it is already decorated and ready for update
    # return true. If decoration is pending return false.
    # @param element The element to be decorated
    # @param originalText The starting text.
    # @return boolean <code>true</code> if the decoration is ready for this element
    def prepare_decoration(element, original_text)
      raise NotImplementedError
    end
  end
  
end
