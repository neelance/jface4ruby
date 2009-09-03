require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Text::Edits
  module TextEditGroupImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Text::Edits
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :IRegion
    }
  end
  
  # A text edit group combines a list of {@link TextEdit}s
  # and a name into a single object. The name must be a human
  # readable string use to present the text edit group in the
  # user interface.
  # <p>
  # Clients may extend this class to add extra information to
  # a text edit group.
  # </p>
  # 
  # @since 3.0
  class TextEditGroup 
    include_class_members TextEditGroupImports
    
    attr_accessor :f_description
    alias_method :attr_f_description, :f_description
    undef_method :f_description
    alias_method :attr_f_description=, :f_description=
    undef_method :f_description=
    
    attr_accessor :f_edits
    alias_method :attr_f_edits, :f_edits
    undef_method :f_edits
    alias_method :attr_f_edits=, :f_edits=
    undef_method :f_edits=
    
    typesig { [String] }
    # Creates a new text edit group with the given name.
    # 
    # @param name the name of the text edit group. Must be
    # a human readable string
    def initialize(name)
      @f_description = nil
      @f_edits = nil
      Assert.is_not_null(name)
      @f_description = name
      @f_edits = ArrayList.new(3)
    end
    
    typesig { [String, TextEdit] }
    # Creates a new text edit group with a name and a single
    # {@link TextEdit}.
    # 
    # @param name the name of the text edit group. Must be
    # a human readable string
    # @param edit the edit to manage
    def initialize(name, edit)
      @f_description = nil
      @f_edits = nil
      Assert.is_not_null(name)
      Assert.is_not_null(edit)
      @f_description = name
      @f_edits = ArrayList.new(1)
      @f_edits.add(edit)
    end
    
    typesig { [String, Array.typed(TextEdit)] }
    # Creates a new text edit group with the given name and
    # array of edits.
    # 
    # @param name the name of the text edit group. Must be
    # a human readable string
    # @param edits the array of edits
    def initialize(name, edits)
      @f_description = nil
      @f_edits = nil
      Assert.is_not_null(name)
      Assert.is_not_null(edits)
      @f_description = name
      @f_edits = ArrayList.new(Arrays.as_list(edits))
    end
    
    typesig { [] }
    # Returns the edit group's name.
    # 
    # @return the edit group's name
    def get_name
      return @f_description
    end
    
    typesig { [TextEdit] }
    # Adds the given {@link TextEdit} to this group.
    # 
    # @param edit the edit to add
    def add_text_edit(edit)
      @f_edits.add(edit)
    end
    
    typesig { [TextEdit] }
    # Removes the given {@link TextEdit} from this group.
    # 
    # @param edit the edit to remove
    # @return <code>true</code> if this group contained the specified edit.
    # @since 3.3
    def remove_text_edit(edit)
      return @f_edits.remove(edit)
    end
    
    typesig { [] }
    # Removes all text edits from this group.
    # 
    # @since 3.3
    def clear_text_edits
      @f_edits.clear
    end
    
    typesig { [] }
    # Returns <code>true</code> if the list of managed
    # {@link TextEdit}s is empty; otherwise <code>false
    # </code> is returned.
    # 
    # @return whether the list of managed text edits is
    # empty or not
    def is_empty
      return @f_edits.is_empty
    end
    
    typesig { [] }
    # Returns an array of {@link TextEdit}s containing
    # the edits managed by this group.
    # 
    # @return the managed text edits
    def get_text_edits
      return @f_edits.to_array(Array.typed(TextEdit).new(@f_edits.size) { nil })
    end
    
    typesig { [] }
    # Returns the text region covered by the edits managed via this
    # edit group. If the group doesn't manage any edits <code>null
    # </code> is returned.
    # 
    # @return the text region covered by this edit group or <code>
    # null</code> if no edits are managed
    def get_region
      size_ = @f_edits.size
      if ((size_).equal?(0))
        return nil
      else
        if ((size_).equal?(1))
          return (@f_edits.get(0)).get_region
        else
          return TextEdit.get_coverage(@f_edits.to_array(Array.typed(TextEdit).new(@f_edits.size) { nil }))
        end
      end
    end
    
    private
    alias_method :initialize__text_edit_group, :initialize
  end
  
end
