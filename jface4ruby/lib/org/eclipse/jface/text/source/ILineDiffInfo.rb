require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module ILineDiffInfoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
    }
  end
  
  # Describes the change state of one line, which consists of the state of the line itself, which
  # can be <code>UNCHANGED</code>, <code>CHANGED</code> or <code>ADDED</code>, and the number of
  # deleted lines before and after this line.
  # <p>
  # This interface may be implemented by clients.
  # </p>
  # 
  # @since 3.0
  module ILineDiffInfo
    include_class_members ILineDiffInfoImports
    
    class_module.module_eval {
      # Denotes an unchanged line.
      const_set_lazy(:UNCHANGED) { 0 }
      const_attr_reader  :UNCHANGED
      
      # Denotes an added line.
      const_set_lazy(:ADDED) { 1 }
      const_attr_reader  :ADDED
      
      # Denotes a changed line.
      const_set_lazy(:CHANGED) { 2 }
      const_attr_reader  :CHANGED
    }
    
    typesig { [] }
    # Returns the number of deleted lines after this line.
    # 
    # @return the number of lines after this line.
    def get_removed_lines_below
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of deleted lines before this line.
    # 
    # @return the number of lines before this line.
    def get_removed_lines_above
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the type of this line, one out of <code>UNCHANGED</code>, <code>CHANGED</code> or
    # <code>ADDED</code>.
    # 
    # @return the type of this line.
    def get_change_type
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this line has any changes (to itself, or any deletions before or after it).
    # 
    # @return <code>true</code>, if the line's state (as returned by <code>getType</code>) is
    # either <code>CHANGED</code> or <code>ADDED</code> or either of <code>getRemovedLinesBelow</code>
    # and <code>getRemovedLinesAbove</code> would return a number &gt; 0
    def has_changes
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the original text of this changed region
    # 
    # @return the original text of this changed region, including any deleted lines. The returned
    # value and its elements may not be <code>null/code>, it may however be of zero length
    def get_original_text
      raise NotImplementedError
    end
  end
  
end
