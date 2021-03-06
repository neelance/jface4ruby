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
  module IAnnotationModelListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
    }
  end
  
  # Interface for objects interested in getting informed about annotation model
  # changes. Changes are the addition or removal of annotations managed by the
  # model. Clients may implement this interface.
  # 
  # In order to provided backward compatibility for clients of
  # <code>IAnnotationModelListener</code>, extension interfaces are used to
  # provide a means of evolution. The following extension interfaces exist:
  # <ul>
  # <li>{@link org.eclipse.jface.text.source.IAnnotationModelListenerExtension}
  # since version 2.0 replacing the change notification mechanisms.</li>
  # </ul>
  # 
  # @see org.eclipse.jface.text.source.IAnnotationModel
  module IAnnotationModelListener
    include_class_members IAnnotationModelListenerImports
    
    typesig { [IAnnotationModel] }
    # Called if a model change occurred on the given model.<p>
    # Replaced by {@link IAnnotationModelListenerExtension#modelChanged(AnnotationModelEvent)}.
    # 
    # @param model the changed annotation model
    def model_changed(model)
      raise NotImplementedError
    end
  end
  
end
