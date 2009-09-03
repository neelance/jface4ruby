require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module IContextInformationValidatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
    }
  end
  
  # A context information validator is used to determine if
  # a displayed context information is still valid or should
  # be dismissed.
  # <p>
  # The interface can be implemented by clients.
  # </p>
  # 
  # @see IContextInformationPresenter
  module IContextInformationValidator
    include_class_members IContextInformationValidatorImports
    
    typesig { [IContextInformation, ITextViewer, ::Java::Int] }
    # Installs this validator for the given context information.
    # 
    # @param info the context information which this validator should check
    # @param viewer the text viewer on which the information is presented
    # @param offset the document offset for which the information has been computed
    def install(info, viewer, offset)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns whether the information this validator is installed on is still valid
    # at the given document position.
    # 
    # @param offset the current offset within the document
    # @return <code>true</code> if the information also valid at the given document position
    def is_context_information_valid(offset)
      raise NotImplementedError
    end
  end
  
end
