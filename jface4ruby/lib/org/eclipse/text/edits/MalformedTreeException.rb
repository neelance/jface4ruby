require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Edits
  module MalformedTreeExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
    }
  end
  
  # Thrown to indicate that an edit got added to a parent edit
  # but the child edit somehow conflicts with the parent or
  # one of it siblings.
  # <p>
  # This class is not intended to be serialized.
  # </p>
  # 
  # @see TextEdit#addChild(TextEdit)
  # @see TextEdit#addChildren(TextEdit[])
  # 
  # @since 3.0
  class MalformedTreeException < MalformedTreeExceptionImports.const_get :RuntimeException
    include_class_members MalformedTreeExceptionImports
    
    class_module.module_eval {
      # Not intended to be serialized
      const_set_lazy(:SerialVersionUID) { 1 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :f_parent
    alias_method :attr_f_parent, :f_parent
    undef_method :f_parent
    alias_method :attr_f_parent=, :f_parent=
    undef_method :f_parent=
    
    attr_accessor :f_child
    alias_method :attr_f_child, :f_child
    undef_method :f_child
    alias_method :attr_f_child=, :f_child=
    undef_method :f_child=
    
    typesig { [TextEdit, TextEdit, String] }
    # Constructs a new malformed tree exception.
    # 
    # @param parent the parent edit
    # @param child the child edit
    # @param message the detail message
    def initialize(parent, child, message)
      @f_parent = nil
      @f_child = nil
      super(message)
      @f_parent = parent
      @f_child = child
    end
    
    typesig { [] }
    # Returns the parent edit that caused the exception.
    # 
    # @return the parent edit
    def get_parent
      return @f_parent
    end
    
    typesig { [] }
    # Returns the child edit that caused the exception.
    # 
    # @return the child edit
    def get_child
      return @f_child
    end
    
    typesig { [TextEdit] }
    def set_parent(parent)
      @f_parent = parent
    end
    
    private
    alias_method :initialize__malformed_tree_exception, :initialize
  end
  
end
