require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module IFindReplaceTargetExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Point
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.IFindReplaceTarget}.
  # <p>
  # Introduces the concepts of find/replace sessions, searching in a limiting
  # scope and a replace-all mode.
  # <p>
  # If a scope is set, <code>findAndSelect</code> is limited to the scope.
  # Occurrences outside of the scope are not considered.
  # 
  # @since 2.0
  module IFindReplaceTargetExtension
    include_class_members IFindReplaceTargetExtensionImports
    
    typesig { [] }
    # Indicates that a session with the target begins.
    # All calls except <code>beginSession()</code> and <code>endSession()</code> to
    # <code>IFindReplaceTarget</code> and
    # <code>IFindReplaceTargetExtension</code> must be embedded within calls to
    # <code>beginSession()</code> and <code>endSession()</code>.
    # 
    # @see #endSession()
    def begin_session
      raise NotImplementedError
    end
    
    typesig { [] }
    # Indicates that a session with the target ends.
    # 
    # @see #beginSession()
    def end_session
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the find scope of the target, <code>null</code> for global scope.
    # 
    # @return returns the find scope of the target, may be <code>null</code>
    def get_scope
      raise NotImplementedError
    end
    
    typesig { [IRegion] }
    # Sets the find scope of the target to operate on. <code>null</code>
    # indicates that the global scope should be used.
    # 
    # @param scope the find scope of the target, may be <code>null</code>
    def set_scope(scope)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the currently selected range of lines as a offset and length.
    # 
    # @return the currently selected line range
    def get_line_selection
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets a selection.
    # 
    # @param offset the offset of the selection
    # @param length the length of the selection
    def set_selection(offset, length)
      raise NotImplementedError
    end
    
    typesig { [Color] }
    # Sets the scope highlight color
    # 
    # @param color the color of the scope highlight
    def set_scope_highlight_color(color)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Sets the target's replace-all mode.
    # 
    # @param replaceAll <code>true</code> if this target should switch into replace-all mode,
    # <code>false</code> if it should leave the replace-all state
    def set_replace_all_mode(replace_all)
      raise NotImplementedError
    end
  end
  
end
