require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Projection
  module ChildDocumentManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Projection
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # Implementation of a child document manager based on
  # {@link org.eclipse.jface.text.projection.ProjectionDocumentManager}. This
  # class exists for compatibility reasons.
  # <p>
  # Internal class. This class is not intended to be used by clients outside
  # the Platform Text framework.</p>
  # 
  # @since 3.0
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class ChildDocumentManager < ChildDocumentManagerImports.const_get :ProjectionDocumentManager
    include_class_members ChildDocumentManagerImports
    
    typesig { [IDocument] }
    # @see org.eclipse.jface.text.projection.ProjectionDocumentManager#createProjectionDocument(org.eclipse.jface.text.IDocument)
    def create_projection_document(master)
      return ChildDocument.new(master)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__child_document_manager, :initialize
  end
  
end
