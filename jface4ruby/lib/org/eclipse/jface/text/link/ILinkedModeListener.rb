require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Link
  module ILinkedModeListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Link
    }
  end
  
  # Protocol used by {@link LinkedModeModel}s to communicate state changes, such
  # as leaving linked mode, suspending it due to a child mode coming up, and
  # resuming after a child mode has left.
  # <p>
  # This interface may implemented by clients.
  # </p>
  # 
  # @since 3.0
  module ILinkedModeListener
    include_class_members ILinkedModeListenerImports
    
    class_module.module_eval {
      # Flag to <code>leave</code> specifying no special action.
      const_set_lazy(:NONE) { 0 }
      const_attr_reader  :NONE
      
      # Flag to <code>leave</code> specifying that all nested modes should
      # exit.
      const_set_lazy(:EXIT_ALL) { 1 << 0 }
      const_attr_reader  :EXIT_ALL
      
      # Flag to <code>leave</code> specifying that the caret should be moved to
      # the exit position.
      const_set_lazy(:UPDATE_CARET) { 1 << 1 }
      const_attr_reader  :UPDATE_CARET
      
      # Flag to <code>leave</code> specifying that a UI of a parent mode should
      # select the current position.
      const_set_lazy(:SELECT) { 1 << 2 }
      const_attr_reader  :SELECT
      
      # Flag to <code>leave</code> specifying that document content outside of
      # a linked position was modified.
      const_set_lazy(:EXTERNAL_MODIFICATION) { 1 << 3 }
      const_attr_reader  :EXTERNAL_MODIFICATION
    }
    
    typesig { [LinkedModeModel, ::Java::Int] }
    # The leave event occurs when linked is left.
    # 
    # @param model the model being left
    # @param flags the reason and commands for leaving linked mode
    def left(model, flags)
      raise NotImplementedError
    end
    
    typesig { [LinkedModeModel] }
    # The suspend event occurs when a nested linked mode is installed within
    # <code>model</code>.
    # 
    # @param model the model being suspended due to a nested model being
    # installed
    def suspend(model)
      raise NotImplementedError
    end
    
    typesig { [LinkedModeModel, ::Java::Int] }
    # The resume event occurs when a nested linked mode exits.
    # 
    # @param model the linked mode model being resumed due to a nested mode
    # exiting
    # @param flags the commands to execute when resuming after suspend
    def resume(model, flags)
      raise NotImplementedError
    end
  end
  
end
