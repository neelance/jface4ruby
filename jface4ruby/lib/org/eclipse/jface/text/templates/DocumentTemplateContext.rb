require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Templates
  module DocumentTemplateContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Templates
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  # Instances of this class describe the context of a template as a region of
  # a document. That region may be either specified by its offset and length, or
  # by a <code>Position</code> which may or may not be registered with the
  # document.
  # <p>
  # Clients may instantiate and extend this class.
  # </p>
  # 
  # @since 3.0
  class DocumentTemplateContext < DocumentTemplateContextImports.const_get :TemplateContext
    include_class_members DocumentTemplateContextImports
    
    # The text of the document.
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The region of the document described by this context. We store a
    # position since clients may specify the document region as (updateable)
    # Positions.
    attr_accessor :f_position
    alias_method :attr_f_position, :f_position
    undef_method :f_position
    alias_method :attr_f_position=, :f_position=
    undef_method :f_position=
    
    # The original offset of this context. Will only be updated by the setter
    # method.
    attr_accessor :f_original_offset
    alias_method :attr_f_original_offset, :f_original_offset
    undef_method :f_original_offset
    alias_method :attr_f_original_offset=, :f_original_offset=
    undef_method :f_original_offset=
    
    # The original length of this context. Will only be updated by the setter
    # method.
    attr_accessor :f_original_length
    alias_method :attr_f_original_length, :f_original_length
    undef_method :f_original_length
    alias_method :attr_f_original_length=, :f_original_length=
    undef_method :f_original_length=
    
    typesig { [TemplateContextType, IDocument, ::Java::Int, ::Java::Int] }
    # Creates a document template context.
    # 
    # @param type the context type
    # @param document the document this context applies to
    # @param offset the offset of the document region
    # @param length the length of the document region
    def initialize(type, document, offset, length)
      initialize__document_template_context(type, document, Position.new(offset, length))
    end
    
    typesig { [TemplateContextType, IDocument, Position] }
    # Creates a document template context. The supplied <code>Position</code>
    # will be queried to compute the <code>getStart</code> and
    # <code>getEnd</code> methods, which will therefore answer updated
    # position data if it is registered with the document.
    # 
    # @param type the context type
    # @param document the document this context applies to
    # @param position the position describing the area of the document which
    # forms the template context
    # @since 3.1
    def initialize(type, document, position)
      @f_document = nil
      @f_position = nil
      @f_original_offset = 0
      @f_original_length = 0
      super(type)
      Assert.is_not_null(document)
      Assert.is_not_null(position)
      Assert.is_true(position.get_offset <= document.get_length)
      @f_document = document
      @f_position = position
      @f_original_offset = @f_position.get_offset
      @f_original_length = @f_position.get_length
    end
    
    typesig { [] }
    # Returns the document.
    # 
    # @return the document
    def get_document
      return @f_document
    end
    
    typesig { [] }
    # Returns the completion offset within the string of the context.
    # 
    # @return the completion offset within the string of the context
    def get_completion_offset
      return @f_original_offset
    end
    
    typesig { [::Java::Int] }
    # Sets the completion offset.
    # 
    # @param newOffset the new completion offset
    def set_completion_offset(new_offset)
      @f_original_offset = new_offset
      @f_position.set_offset(new_offset)
    end
    
    typesig { [] }
    # Returns the completion length within the string of the context.
    # 
    # @return the completion length within the string of the context
    def get_completion_length
      return @f_original_length
    end
    
    typesig { [::Java::Int] }
    # Sets the completion length.
    # 
    # @param newLength the new completion length
    def set_completion_length(new_length)
      @f_original_length = new_length
      @f_position.set_length(new_length)
    end
    
    typesig { [] }
    # Returns the keyword which triggered template insertion.
    # 
    # @return the keyword which triggered template insertion
    def get_key
      offset = get_start
      length = get_end - offset
      begin
        return @f_document.get(offset, length)
      rescue BadLocationException => e
        return "" # $NON-NLS-1$
      end
    end
    
    typesig { [] }
    # Returns the beginning offset of the keyword.
    # 
    # @return the beginning offset of the keyword
    def get_start
      return @f_position.get_offset
    end
    
    typesig { [] }
    # Returns the end offset of the keyword.
    # 
    # @return the end offset of the keyword
    def get_end
      return @f_position.get_offset + @f_position.get_length
    end
    
    typesig { [Template] }
    # @see org.eclipse.jface.text.templates.TemplateContext#canEvaluate(org.eclipse.jface.text.templates.Template)
    def can_evaluate(template)
      return true
    end
    
    typesig { [Template] }
    # @see org.eclipse.jface.text.templates.TemplateContext#evaluate(org.eclipse.jface.text.templates.Template)
    def evaluate(template)
      if (!can_evaluate(template))
        return nil
      end
      translator = TemplateTranslator.new
      buffer = translator.translate(template)
      get_context_type.resolve(buffer, self)
      return buffer
    end
    
    private
    alias_method :initialize__document_template_context, :initialize
  end
  
end
