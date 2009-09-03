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
  module IMarkRegionTargetImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # A mark region target to support marked regions as found in emacs.
  # 
  # @since 2.0
  module IMarkRegionTarget
    include_class_members IMarkRegionTargetImports
    
    typesig { [::Java::Boolean] }
    # Sets or clears a mark at the current cursor position.
    # 
    # @param set sets the mark if <code>true</code>, clears otherwise.
    def set_mark_at_cursor(set)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Swaps the mark and cursor position if the mark is in the visible region.
    def swap_mark_and_cursor
      raise NotImplementedError
    end
  end
  
end
