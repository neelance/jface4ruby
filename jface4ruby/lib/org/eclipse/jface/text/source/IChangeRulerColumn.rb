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
  module IChangeRulerColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt::Graphics, :Color
    }
  end
  
  # An <code>IChangeRulerColumn</code> can display quick diff information.
  # 
  # @since 3.0
  module IChangeRulerColumn
    include_class_members IChangeRulerColumnImports
    include IVerticalRulerColumn
    include IVerticalRulerInfoExtension
    
    class_module.module_eval {
      # The ID under which the quick diff model is registered with a document's annotation model.
      const_set_lazy(:QUICK_DIFF_MODEL_ID) { "diff" }
      const_attr_reader  :QUICK_DIFF_MODEL_ID
    }
    
    typesig { [IAnnotationHover] }
    # $NON-NLS-1$
    # 
    # Sets the hover of this ruler column.
    # 
    # @param hover the hover that will produce hover information text for this ruler column
    def set_hover(hover)
      raise NotImplementedError
    end
    
    typesig { [Color] }
    # Sets the background color for normal lines. The color has to be disposed of by the caller when
    # the receiver is no longer used.
    # 
    # @param backgroundColor the new color to be used as standard line background
    def set_background(background_color)
      raise NotImplementedError
    end
    
    typesig { [Color] }
    # Sets the background color for added lines. The color has to be disposed of by the caller when
    # the receiver is no longer used.
    # 
    # @param addedColor the new color to be used for the added lines background
    def set_added_color(added_color)
      raise NotImplementedError
    end
    
    typesig { [Color] }
    # Sets the background color for changed lines. The color has to be disposed of by the caller when
    # the receiver is no longer used.
    # 
    # @param changedColor the new color to be used for the changed lines background
    def set_changed_color(changed_color)
      raise NotImplementedError
    end
    
    typesig { [Color] }
    # Sets the color for the deleted lines indicator. The color has to be disposed of by the caller when
    # the receiver is no longer used.
    # 
    # @param deletedColor the new color to be used for the deleted lines indicator.
    def set_deleted_color(deleted_color)
      raise NotImplementedError
    end
  end
  
end
