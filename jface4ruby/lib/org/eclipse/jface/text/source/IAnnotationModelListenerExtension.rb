require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module IAnnotationModelListenerExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
    }
  end
  
  # Extension interface for {@link IAnnotationModelListener}. Introduces a
  # notification mechanism that notifies the user by means of <code>AnnotationModelEvent</code>s.
  # Thus, more detailed information can be sent to the listener. This mechanism replaces the original notification
  # mechanism of <code>IAnnotationModelListener</code>.
  # 
  # @since 2.0
  module IAnnotationModelListenerExtension
    include_class_members IAnnotationModelListenerExtensionImports
    
    typesig { [AnnotationModelEvent] }
    # Called if a model change occurred on the given model.
    # 
    # @param event the event to be sent out
    def model_changed(event)
      raise NotImplementedError
    end
  end
  
end
