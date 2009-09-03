require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module ITextOperationTargetImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Defines the target for text operations. <code>canDoOperation</code> informs
  # the clients about the ability of the target to perform the specified
  # operation at the current point in time. <code>doOperation</code> executes
  # the specified operation.
  # <p>
  # In order to provide backward compatibility for clients of
  # <code>ITextOperationTarget</code>, extension interfaces are used as a
  # means of evolution. The following extension interfaces exist:
  # <ul>
  # <li>{@link org.eclipse.jface.text.ITextOperationTargetExtension} since
  # version 2.0 introducing text operation enabling/disabling.</li>
  # </ul>
  # 
  # @see org.eclipse.jface.text.ITextOperationTargetExtension
  module ITextOperationTarget
    include_class_members ITextOperationTargetImports
    
    class_module.module_eval {
      # Text operation code for undoing the last edit command.
      const_set_lazy(:UNDO) { 1 }
      const_attr_reader  :UNDO
      
      # Text operation code for redoing the last undone edit command.
      const_set_lazy(:REDO) { 2 }
      const_attr_reader  :REDO
      
      # Text operation code for moving the selected text to the clipboard.
      const_set_lazy(:CUT) { 3 }
      const_attr_reader  :CUT
      
      # Text operation code for copying the selected text to the clipboard.
      const_set_lazy(:COPY) { 4 }
      const_attr_reader  :COPY
      
      # Text operation code for inserting the clipboard content at the
      # current position.
      const_set_lazy(:PASTE) { 5 }
      const_attr_reader  :PASTE
      
      # Text operation code for deleting the selected text or if selection
      # is empty the character  at the right of the current position.
      const_set_lazy(:DELETE) { 6 }
      const_attr_reader  :DELETE
      
      # Text operation code for selecting the complete text.
      const_set_lazy(:SELECT_ALL) { 7 }
      const_attr_reader  :SELECT_ALL
      
      # Text operation code for shifting the selected text block to the right.
      const_set_lazy(:SHIFT_RIGHT) { 8 }
      const_attr_reader  :SHIFT_RIGHT
      
      # Text operation code for shifting the selected text block to the left.
      const_set_lazy(:SHIFT_LEFT) { 9 }
      const_attr_reader  :SHIFT_LEFT
      
      # Text operation code for printing the complete text.
      const_set_lazy(:PRINT) { 10 }
      const_attr_reader  :PRINT
      
      # Text operation code for prefixing the selected text block.
      const_set_lazy(:PREFIX) { 11 }
      const_attr_reader  :PREFIX
      
      # Text operation code for removing the prefix from the selected text block.
      const_set_lazy(:STRIP_PREFIX) { 12 }
      const_attr_reader  :STRIP_PREFIX
    }
    
    typesig { [::Java::Int] }
    # Returns whether the operation specified by the given operation code
    # can be performed.
    # 
    # @param operation the operation code
    # @return <code>true</code> if the specified operation can be performed
    def can_do_operation(operation)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Performs the operation specified by the operation code on the target.
    # <code>doOperation</code> must only be called if <code>canDoOperation</code>
    # returns <code>true</code>.
    # 
    # @param operation the operation code
    def do_operation(operation)
      raise NotImplementedError
    end
  end
  
end
