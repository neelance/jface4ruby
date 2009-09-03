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
  module ISubjectControlContentAssistantImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Contentassist
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistant
    }
  end
  
  # Extends {@link org.eclipse.jface.text.contentassist.IContentAssistant} to
  # allow to install a content assistant on the given
  # {@linkplain org.eclipse.jface.contentassist.IContentAssistSubjectControl content assist subject control}.
  # 
  # @since 3.0
  # @deprecated As of 3.2, replaced by Platform UI's field assist support
  module ISubjectControlContentAssistant
    include_class_members ISubjectControlContentAssistantImports
    include IContentAssistant
    
    typesig { [IContentAssistSubjectControl] }
    # Installs content assist support on the given subject.
    # 
    # @param contentAssistSubjectControl the one who requests content assist
    def install(content_assist_subject_control)
      raise NotImplementedError
    end
  end
  
end
