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
  module ContextInformationValidatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
    }
  end
  
  # A default implementation of the <code>IContextInfomationValidator</code> interface.
  # This implementation determines whether the information is valid by asking the content
  # assist processor for all  context information objects for the current position. If the
  # currently displayed information is in the result set, the context information is
  # considered valid.
  class ContextInformationValidator 
    include_class_members ContextInformationValidatorImports
    include IContextInformationValidator
    
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
    
    # The associated text viewer.
    attr_accessor :f_viewer
    alias_method :attr_f_viewer, :f_viewer
    undef_method :f_viewer
    alias_method :attr_f_viewer=, :f_viewer=
    undef_method :f_viewer=
    
    typesig { [IContentAssistProcessor] }
    # Creates a new context information validator which is ready to be installed on
    # a particular context information.
    # 
    # @param processor the processor to be used for validation
    def initialize(processor)
      @f_processor = nil
      @f_context_information = nil
      @f_viewer = nil
      @f_processor = processor
    end
    
    typesig { [IContextInformation, ITextViewer, ::Java::Int] }
    # @see IContextInformationValidator#install(IContextInformation, ITextViewer, int)
    def install(context_information, viewer, offset)
      @f_context_information = context_information
      @f_viewer = viewer
    end
    
    typesig { [::Java::Int] }
    # @see IContentAssistTipCloser#isContextInformationValid(int)
    def is_context_information_valid(offset)
      infos = @f_processor.compute_context_information(@f_viewer, offset)
      if (!(infos).nil? && infos.attr_length > 0)
        i = 0
        while i < infos.attr_length
          if ((@f_context_information == infos[i]))
            return true
          end
          i += 1
        end
      end
      return false
    end
    
    private
    alias_method :initialize__context_information_validator, :initialize
  end
  
end
