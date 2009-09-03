require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Contentassist
  module ISubjectControlContextInformationPresenterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Contentassist
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformation
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformationPresenter
    }
  end
  
  # Extends {@link org.eclipse.jface.text.contentassist.IContextInformationPresenter} to
  # allow to install a content assistant on the given
  # {@linkplain org.eclipse.jface.contentassist.IContentAssistSubjectControl content assist subject control}.
  # 
  # @since 3.0
  # @deprecated As of 3.2, replaced by Platform UI's field assist support
  module ISubjectControlContextInformationPresenter
    include_class_members ISubjectControlContextInformationPresenterImports
    include IContextInformationPresenter
    
    typesig { [IContextInformation, IContentAssistSubjectControl, ::Java::Int] }
    # Installs this presenter for the given context information.
    # 
    # @param info the context information which this presenter should style
    # @param contentAssistSubjectControl the content assist subject control
    # @param offset the document offset for which the information has been computed
    def install(info, content_assist_subject_control, offset)
      raise NotImplementedError
    end
  end
  
end
