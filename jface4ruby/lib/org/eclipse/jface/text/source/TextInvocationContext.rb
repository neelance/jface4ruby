require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module TextInvocationContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Jface::Text::Quickassist, :IQuickAssistInvocationContext
    }
  end
  
  # Text quick assist invocation context.
  # <p>
  # Clients may extend this class to add additional context information.
  # </p>
  # 
  # @since 3.3
  class TextInvocationContext 
    include_class_members TextInvocationContextImports
    include IQuickAssistInvocationContext
    
    attr_accessor :f_source_viewer
    alias_method :attr_f_source_viewer, :f_source_viewer
    undef_method :f_source_viewer
    alias_method :attr_f_source_viewer=, :f_source_viewer=
    undef_method :f_source_viewer=
    
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    attr_accessor :f_length
    alias_method :attr_f_length, :f_length
    undef_method :f_length
    alias_method :attr_f_length=, :f_length=
    undef_method :f_length=
    
    typesig { [ISourceViewer, ::Java::Int, ::Java::Int] }
    def initialize(source_viewer, offset, length)
      @f_source_viewer = nil
      @f_offset = 0
      @f_length = 0
      @f_source_viewer = source_viewer
      @f_offset = offset
      @f_length = length
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistInvocationContext#getOffset()
    def get_offset
      return @f_offset
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistInvocationContext#getLength()
    def get_length
      return @f_length
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.quickassist.IQuickAssistInvocationContext#getSourceViewer()
    def get_source_viewer
      return @f_source_viewer
    end
    
    private
    alias_method :initialize__text_invocation_context, :initialize
  end
  
end
