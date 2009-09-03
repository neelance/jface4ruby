require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source::Projection
  module IProjectionListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source::Projection
    }
  end
  
  # Implementers registered with a
  # {@link org.eclipse.jface.text.source.projection.ProjectionViewer} get
  # informed when the projection mode of the viewer gets enabled and when it gets
  # disabled.
  # 
  # @since 3.0
  module IProjectionListener
    include_class_members IProjectionListenerImports
    
    typesig { [] }
    # Tells this listener that projection has been enabled.
    def projection_enabled
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells this listener that projection has been disabled.
    def projection_disabled
      raise NotImplementedError
    end
  end
  
end
