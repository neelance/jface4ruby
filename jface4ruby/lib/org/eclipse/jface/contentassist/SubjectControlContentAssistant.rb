require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Contentassist
  module SubjectControlContentAssistantImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Contentassist
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # The standard implementation of the {@link org.eclipse.jface.contentassist.ISubjectControlContentAssistant} interface.
  # Usually, clients instantiate this class and configure it before using it.
  # 
  # @since 3.0
  # @deprecated As of 3.2, replaced by Platform UI's field assist support *
  class SubjectControlContentAssistant < Org::Eclipse::Jface::Text::Contentassist::ContentAssistant
    include_class_members SubjectControlContentAssistantImports
    overload_protected {
      include ISubjectControlContentAssistant
    }
    
    typesig { [IContentAssistSubjectControl] }
    # @see ISubjectControlContentAssistant#install(IContentAssistSubjectControl)
    def install(content_assist_subject_control)
      Assert.is_not_null(content_assist_subject_control)
      super(content_assist_subject_control)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__subject_control_content_assistant, :initialize
  end
  
end
