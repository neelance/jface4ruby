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
  module ISourceViewerExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.source.ISourceViewer}.<p>
  # Allows the source viewer to roll back a previous configuration process and allows
  # clients access to the viewer's visual annotation model.
  # 
  # @since 3.0
  module ISourceViewerExtension2
    include_class_members ISourceViewerExtension2Imports
    
    typesig { [] }
    # Rolls back the configuration process of this source viewer. The source
    # viewer can be configured again after a call to this method. Unlike
    # {@link ISourceViewer#configure(SourceViewerConfiguration)} this method
    # can be called more than once without interleaving calls to
    # {@link ISourceViewer#configure(SourceViewerConfiguration)}.
    def unconfigure
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the visual annotation model of this viewer.
    # 
    # @return the visual annotation model of this viewer
    def get_visual_annotation_model
      raise NotImplementedError
    end
  end
  
end
