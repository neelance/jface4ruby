require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module IInformationControlCreatorExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.IInformationControlCreator}<p>
  # Introduces tests whether information controls can be reused and whether information
  # control creators can replace each other.
  # 
  # @see org.eclipse.jface.text.IInformationControlCreator
  # @see org.eclipse.jface.text.IInformationControl
  # @since 3.0
  module IInformationControlCreatorExtension
    include_class_members IInformationControlCreatorExtensionImports
    
    typesig { [IInformationControl] }
    # Tests if an existing information control can be reused.
    # 
    # @param control the information control to test
    # @return <code>true</code> if the control can be reused
    def can_reuse(control)
      raise NotImplementedError
    end
    
    typesig { [IInformationControlCreator] }
    # Tests whether this information control creator can replace the given
    # information control creator. This is the case if the two creators create
    # the same kind of information controls.
    # 
    # @param creator the creator to be checked
    # @return <code>true</code> if the given creator can be replaced,
    # <code>false</code> otherwise
    def can_replace(creator)
      raise NotImplementedError
    end
  end
  
end
