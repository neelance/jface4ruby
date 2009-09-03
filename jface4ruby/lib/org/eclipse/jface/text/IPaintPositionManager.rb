require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module IPaintPositionManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Manages and updates positions used by {@link IPainter}s.
  # 
  # @see org.eclipse.jface.text.IPainter
  # @since 2.1
  module IPaintPositionManager
    include_class_members IPaintPositionManagerImports
    
    typesig { [Position] }
    # Starts managing the given position until <code>unmanagePosition</code> is called.
    # 
    # @param position the position to manage
    # @see #unmanagePosition(Position)
    def manage_position(position)
      raise NotImplementedError
    end
    
    typesig { [Position] }
    # Stops managing the given position. If the position is not managed
    # by this managed, this call has no effect.
    # 
    # @param position the position that should no longer be managed
    def unmanage_position(position)
      raise NotImplementedError
    end
  end
  
end
