require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module ISourceViewerExtension4Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistant
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.source.ISourceViewer}.
  # <p>
  # It introduces API to access a minimal set of content assistant APIs.</li>
  # </p>
  # 
  # @see IContentAssistant
  # @since 3.4
  module ISourceViewerExtension4
    include_class_members ISourceViewerExtension4Imports
    
    typesig { [] }
    # Returns a facade for this viewer's content assistant.
    # 
    # @return a content assistant facade or <code>null</code> if none is
    # configured
    def get_content_assistant_facade
      raise NotImplementedError
    end
  end
  
end
