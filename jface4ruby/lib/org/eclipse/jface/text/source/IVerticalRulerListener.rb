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
  module IVerticalRulerListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
    }
  end
  
  # Interface for listening to annotation related events happening on a vertical ruler.
  # <p>
  # This interface may be implemented by clients.
  # </p>
  # 
  # @since 3.0
  module IVerticalRulerListener
    include_class_members IVerticalRulerListenerImports
    
    typesig { [VerticalRulerEvent] }
    # Called when an annotation is selected in the vertical ruler.
    # 
    # @param event the annotation event that occurred
    def annotation_selected(event)
      raise NotImplementedError
    end
    
    typesig { [VerticalRulerEvent] }
    # Called when a default selection occurs on an
    # annotation in the vertical ruler.
    # 
    # @param event the annotation event that occurred
    def annotation_default_selected(event)
      raise NotImplementedError
    end
    
    typesig { [VerticalRulerEvent, Menu] }
    # Called when the context menu is opened on an annotation in the
    # vertical ruler.
    # 
    # @param event the annotation event that occurred
    # @param menu the menu that is about to be shown
    def annotation_context_menu_about_to_show(event, menu)
      raise NotImplementedError
    end
  end
  
end
