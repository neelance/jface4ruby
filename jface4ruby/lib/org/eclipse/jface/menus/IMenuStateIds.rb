require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Menus
  module IMenuStateIdsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Menus
      include_const ::Org::Eclipse::Core::Commands, :INamedHandleStateIds
      include_const ::Org::Eclipse::Jface::Commands, :RadioState
      include_const ::Org::Eclipse::Jface::Commands, :ToggleState
    }
  end
  
  # $NON-NLS-1$
  # 
  # <p>
  # State identifiers that should be understood by items and renderers of items.
  # The state is associated with the command, and then interpreted by the menu
  # renderer.
  # </p>
  # <p>
  # Clients may implement or extend this class.
  # </p>
  # 
  # @since 3.2
  module IMenuStateIds
    include_class_members IMenuStateIdsImports
    include INamedHandleStateIds
    
    class_module.module_eval {
      # The state id used for indicating the widget style of a command presented
      # in the menus and tool bars. This state must be an instance of
      # {@link ToggleState} or {@link RadioState}.
      const_set_lazy(:STYLE) { "STYLE" }
      const_attr_reader  :STYLE
    }
  end
  
end
