require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module RewriteSessionEditProcessorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Text::Edits, :CopyTargetEdit
      include_const ::Org::Eclipse::Text::Edits, :DeleteEdit
      include_const ::Org::Eclipse::Text::Edits, :InsertEdit
      include_const ::Org::Eclipse::Text::Edits, :MalformedTreeException
      include_const ::Org::Eclipse::Text::Edits, :MoveTargetEdit
      include_const ::Org::Eclipse::Text::Edits, :ReplaceEdit
      include_const ::Org::Eclipse::Text::Edits, :TextEdit
      include_const ::Org::Eclipse::Text::Edits, :TextEditProcessor
      include_const ::Org::Eclipse::Text::Edits, :TextEditVisitor
      include_const ::Org::Eclipse::Text::Edits, :UndoEdit
    }
  end
  
  # A text edit processor that brackets the application of edits into a document rewrite session.
  # 
  # @since 3.3
  class RewriteSessionEditProcessor < RewriteSessionEditProcessorImports.const_get :TextEditProcessor
    include_class_members RewriteSessionEditProcessorImports
    
    class_module.module_eval {
      # The threshold for <em>large</em> text edits.
      const_set_lazy(:THRESHOLD) { 1000 }
      const_attr_reader  :THRESHOLD
      
      # Text edit visitor that estimates the compound size of an edit tree in characters.
      const_set_lazy(:SizeVisitor) { Class.new(TextEditVisitor) do
        include_class_members RewriteSessionEditProcessor
        
        attr_accessor :f_size
        alias_method :attr_f_size, :f_size
        undef_method :f_size
        alias_method :attr_f_size=, :f_size=
        undef_method :f_size=
        
        typesig { [class_self::CopyTargetEdit] }
        def visit(edit)
          @f_size += edit.get_length
          return super(edit)
        end
        
        typesig { [class_self::DeleteEdit] }
        def visit(edit)
          @f_size += edit.get_length
          return super(edit)
        end
        
        typesig { [class_self::InsertEdit] }
        def visit(edit)
          @f_size += edit.get_text.length
          return super(edit)
        end
        
        typesig { [class_self::MoveTargetEdit] }
        def visit(edit)
          @f_size += edit.get_length
          return super(edit)
        end
        
        typesig { [class_self::ReplaceEdit] }
        def visit(edit)
          @f_size += Math.max(edit.get_length, edit.get_text.length)
          return super(edit)
        end
        
        typesig { [] }
        def initialize
          @f_size = 0
          super()
          @f_size = 0
        end
        
        private
        alias_method :initialize__size_visitor, :initialize
      end }
    }
    
    typesig { [IDocument, TextEdit, ::Java::Int] }
    # Constructs a new edit processor for the given document.
    # 
    # @param document the document to manipulate
    # @param root the root of the text edit tree describing the modifications. By passing a text
    # edit a a text edit processor the ownership of the edit is transfered to the text edit
    # processors. Clients must not modify the edit (e.g adding new children) any longer.
    # @param style {@link TextEdit#NONE}, {@link TextEdit#CREATE_UNDO} or
    # {@link TextEdit#UPDATE_REGIONS})
    def initialize(document, root, style)
      super(document, root, style)
    end
    
    typesig { [] }
    # @see org.eclipse.text.edits.TextEditProcessor#performEdits()
    def perform_edits
      document = get_document
      if (!(document.is_a?(IDocumentExtension4)))
        return super
      end
      extension = document
      is_large_edit_ = is_large_edit(get_root)
      type = is_large_edit_ ? DocumentRewriteSessionType::UNRESTRICTED : DocumentRewriteSessionType::UNRESTRICTED_SMALL
      session = extension.start_rewrite_session(type)
      begin
        return super
      ensure
        extension.stop_rewrite_session(session)
      end
    end
    
    class_module.module_eval {
      typesig { [TextEdit] }
      # Returns <code>true</code> if the passed edit is considered <em>large</em>,
      # <code>false</code> otherwise.
      # 
      # @param edit the edit to check
      # @return <code>true</code> if <code>edit</code> is considered <em>large</em>,
      # <code>false</code> otherwise
      # @since 3.3
      def is_large_edit(edit)
        size_visitor = SizeVisitor.new
        edit.accept(size_visitor)
        return size_visitor.attr_f_size > THRESHOLD
      end
    }
    
    private
    alias_method :initialize__rewrite_session_edit_processor, :initialize
  end
  
end
