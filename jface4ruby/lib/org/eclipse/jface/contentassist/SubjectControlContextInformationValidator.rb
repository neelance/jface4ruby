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
  module SubjectControlContextInformationValidatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Contentassist
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContentAssistProcessor
      include_const ::Org::Eclipse::Jface::Text::Contentassist, :IContextInformation
    }
  end
  
  # A default implementation of the {@link SubjectControlContextInformationValidator} interface.
  # This implementation determines whether the information is valid by asking the content
  # assist processor for all  context information objects for the current position. If the
  # currently displayed information is in the result set, the context information is
  # considered valid.
  # 
  # @since 3.0
  # @deprecated As of 3.2, replaced by Platform UI's field assist support
  class SubjectControlContextInformationValidator 
    include_class_members SubjectControlContextInformationValidatorImports
    include ISubjectControlContextInformationValidator
    
    # The content assist processor.
    attr_accessor :f_processor
    alias_method :attr_f_processor, :f_processor
    undef_method :f_processor
    alias_method :attr_f_processor=, :f_processor=
    undef_method :f_processor=
    
    # The context information to be validated.
    attr_accessor :f_context_information
    alias_method :attr_f_context_information, :f_context_information
    undef_method :f_context_information
    alias_method :attr_f_context_information=, :f_context_information=
    undef_method :f_context_information=
    
    # The content assist subject control.
    attr_accessor :f_content_assist_subject_control
    alias_method :attr_f_content_assist_subject_control, :f_content_assist_subject_control
    undef_method :f_content_assist_subject_control
    alias_method :attr_f_content_assist_subject_control=, :f_content_assist_subject_control=
    undef_method :f_content_assist_subject_control=
    
    typesig { [IContentAssistProcessor] }
    # Creates a new context information validator which is ready to be installed on
    # a particular context information.
    # 
    # @param processor the processor to be used for validation
    def initialize(processor)
      @f_processor = nil
      @f_context_information = nil
      @f_content_assist_subject_control = nil
      @f_processor = processor
    end
    
    typesig { [IContextInformation, ITextViewer, ::Java::Int] }
    # @see IContextInformationValidator#install(IContextInformation, ITextViewer, int)
    def install(context_information, viewer, offset)
      raise UnsupportedOperationException.new
    end
    
    typesig { [IContextInformation, IContentAssistSubjectControl, ::Java::Int] }
    # @see ISubjectControlContextInformationValidator#install(IContextInformation, IContentAssistSubjectControl, int)
    def install(context_information, content_assist_subject_control, offset)
      @f_context_information = context_information
      @f_content_assist_subject_control = content_assist_subject_control
    end
    
    typesig { [::Java::Int] }
    # @see IContentAssistTipCloser#isContextInformationValid(int)
    def is_context_information_valid(offset)
      if (!(@f_content_assist_subject_control).nil? && @f_processor.is_a?(ISubjectControlContentAssistProcessor))
        infos = (@f_processor).compute_context_information(@f_content_assist_subject_control, offset)
        if (!(infos).nil? && infos.attr_length > 0)
          i = 0
          while i < infos.attr_length
            if ((@f_context_information == infos[i]))
              return true
            end
            i += 1
          end
        end
      end
      return false
    end
    
    private
    alias_method :initialize__subject_control_context_information_validator, :initialize
  end
  
end
