require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Edits
  module TextEditCopierImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Copies a tree of text edits. A text edit copier keeps a map
  # between original and new text edits. It can be used to map
  # a copy back to its original edit.
  # 
  # @since 3.0
  class TextEditCopier 
    include_class_members TextEditCopierImports
    
    attr_accessor :f_edit
    alias_method :attr_f_edit, :f_edit
    undef_method :f_edit
    alias_method :attr_f_edit=, :f_edit=
    undef_method :f_edit=
    
    attr_accessor :f_copies
    alias_method :attr_f_copies, :f_copies
    undef_method :f_copies
    alias_method :attr_f_copies=, :f_copies=
    undef_method :f_copies=
    
    typesig { [TextEdit] }
    # Constructs a new <code>TextEditCopier</code> for the
    # given edit. The actual copy is done by calling <code>
    # perform</code>.
    # 
    # @param edit the edit to copy
    # 
    # @see #perform()
    def initialize(edit)
      @f_edit = nil
      @f_copies = nil
      Assert.is_not_null(edit)
      @f_edit = edit
      @f_copies = HashMap.new
    end
    
    typesig { [] }
    # Performs the actual copying.
    # 
    # @return the copy
    def perform
      result = do_copy(@f_edit)
      if (!(result).nil?)
        iter = @f_copies.key_set.iterator
        while iter.has_next
          edit = iter.next_
          edit.post_process_copy(self)
        end
      end
      return result
    end
    
    typesig { [TextEdit] }
    # Returns the copy for the original text edit.
    # 
    # @param original the original for which the copy
    # is requested
    # @return the copy of the original edit or <code>null</code>
    # if the original isn't managed by this copier
    def get_copy(original)
      Assert.is_not_null(original)
      return @f_copies.get(original)
    end
    
    typesig { [TextEdit] }
    # ---- helper methods --------------------------------------------
    def do_copy(edit)
      result = edit.do_copy
      children = edit.internal_get_children
      if (!(children).nil?)
        new_children = ArrayList.new(children.size)
        iter = children.iterator
        while iter.has_next
          child_copy = do_copy(iter.next_)
          child_copy.internal_set_parent(result)
          new_children.add(child_copy)
        end
        result.internal_set_children(new_children)
      end
      add_copy(edit, result)
      return result
    end
    
    typesig { [TextEdit, TextEdit] }
    def add_copy(original, copy)
      @f_copies.put(original, copy)
    end
    
    private
    alias_method :initialize__text_edit_copier, :initialize
  end
  
end
