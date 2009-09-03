require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module IContextInformationExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
    }
  end
  
  # Extends {@link org.eclipse.jface.text.contentassist.IContextInformation} with
  # the ability to freely position the context information.
  # 
  # @since 2.0
  module IContextInformationExtension
    include_class_members IContextInformationExtensionImports
    
    typesig { [] }
    # Returns the start offset of the range for which this context
    # information is valid or <code>-1</code> if unknown.
    # 
    # @return the start offset of the range for which this context
    # information is valid
    def get_context_information_position
      raise NotImplementedError
    end
  end
  
end
