require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Information
  module IInformationProviderExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Information
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
    }
  end
  
  # Extends {@link org.eclipse.jface.text.information.IInformationProvider} with
  # the ability to provide the element for a given subject.
  # 
  # @see org.eclipse.jface.text.information.IInformationProvider
  # @since 2.1
  module IInformationProviderExtension
    include_class_members IInformationProviderExtensionImports
    
    typesig { [ITextViewer, IRegion] }
    # Returns the element for the given subject or <code>null</code> if
    # no element is available.
    # <p>
    # Implementers should ignore the text returned by {@link IInformationProvider#getInformation(ITextViewer, IRegion)}.
    # </p>
    # 
    # @param textViewer the viewer in whose document the subject is contained
    # @param subject the text region constituting the information subject
    # @return the element for the subject
    # 
    # @see IInformationProvider#getInformation(ITextViewer, IRegion)
    # @see org.eclipse.jface.text.ITextViewer
    def get_information2(text_viewer, subject)
      raise NotImplementedError
    end
  end
  
end
