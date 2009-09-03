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
  module TreeIterationInfoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  class TreeIterationInfo 
    include_class_members TreeIterationInfoImports
    
    class_module.module_eval {
      const_set_lazy(:Visitor) { Module.new do
        include_class_members TreeIterationInfo
        
        typesig { [TextEdit] }
        def visit(edit)
          raise NotImplementedError
        end
      end }
    }
    
    attr_accessor :f_mark
    alias_method :attr_f_mark, :f_mark
    undef_method :f_mark
    alias_method :attr_f_mark=, :f_mark=
    undef_method :f_mark=
    
    attr_accessor :f_edit_stack
    alias_method :attr_f_edit_stack, :f_edit_stack
    undef_method :f_edit_stack
    alias_method :attr_f_edit_stack=, :f_edit_stack=
    undef_method :f_edit_stack=
    
    attr_accessor :f_index_stack
    alias_method :attr_f_index_stack, :f_index_stack
    undef_method :f_index_stack
    alias_method :attr_f_index_stack=, :f_index_stack=
    undef_method :f_index_stack=
    
    typesig { [] }
    def get_size
      return @f_mark + 1
    end
    
    typesig { [Array.typed(TextEdit)] }
    def push(edits)
      if (((@f_mark += 1)).equal?(@f_edit_stack.attr_length))
        t1 = Array.typed(Array.typed(TextEdit)).new(@f_edit_stack.attr_length * 2) { nil }
        System.arraycopy(@f_edit_stack, 0, t1, 0, @f_edit_stack.attr_length)
        @f_edit_stack = t1
        t2 = Array.typed(::Java::Int).new(@f_edit_stack.attr_length) { 0 }
        System.arraycopy(@f_index_stack, 0, t2, 0, @f_index_stack.attr_length)
        @f_index_stack = t2
      end
      @f_edit_stack[@f_mark] = edits
      @f_index_stack[@f_mark] = -1
    end
    
    typesig { [::Java::Int] }
    def set_index(index)
      @f_index_stack[@f_mark] = index
    end
    
    typesig { [] }
    def pop
      @f_edit_stack[@f_mark] = nil
      @f_index_stack[@f_mark] = -1
      @f_mark -= 1
    end
    
    typesig { [Visitor] }
    def accept(visitor)
      i = @f_mark
      while i >= 0
        Assert.is_true(@f_index_stack[i] >= 0)
        start = @f_index_stack[i] + 1
        edits = @f_edit_stack[i]
        s = start
        while s < edits.attr_length
          visitor.visit(edits[s])
          s += 1
        end
        i -= 1
      end
    end
    
    typesig { [] }
    def initialize
      @f_mark = -1
      @f_edit_stack = Array.typed(Array.typed(TextEdit)).new(10) { nil }
      @f_index_stack = Array.typed(::Java::Int).new(10) { 0 }
    end
    
    private
    alias_method :initialize__tree_iteration_info, :initialize
  end
  
end
