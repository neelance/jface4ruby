require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Information
  module IInformationProviderExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Information
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
    }
  end
  
  # Extends {@link org.eclipse.jface.text.information.IInformationProvider} with
  # the ability to provide its own information presenter control creator.
  # 
  # @see org.eclipse.jface.text.IInformationControlCreator
  # @see org.eclipse.jface.text.information.IInformationProvider
  # @since 3.0
  module IInformationProviderExtension2
    include_class_members IInformationProviderExtension2Imports
    
    typesig { [] }
    # Returns the information control creator of this information provider.
    # 
    # @return the information control creator or <code>null</code> if none is available
    def get_information_presenter_control_creator
      raise NotImplementedError
    end
  end
  
end
