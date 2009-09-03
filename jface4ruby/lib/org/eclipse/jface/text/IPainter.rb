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
  module IPainterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # A painter is responsible for creating, managing, updating, and removing
  # visual decorations on an <code>ITextViewer</code>'s text widget. Examples
  # are the highlighting of the caret line, the print margin, or the highlighting
  # of matching peer characters such as pairs of brackets.</p>
  # <p>
  # Clients may implement this interface.</p>
  # <p>
  # Painters should be registered with a
  # {@link org.eclipse.jface.text.PaintManager}. The paint manager tracks
  # several classes of events issued by an <code>ITextViewer</code> and reacts
  # by appropriately invoking the registered painters.
  # <p>
  # Painters are either active or inactive. Usually, painters are initially
  # inactive and are activated by the first call to their <code>paint</code>
  # method. Painters can be deactivated by calling <code>deactivate</code>.
  # Inactive painter can be reactivated by calling <code>paint</code>.
  # <p>
  # Painters usually have to manage state information. E.g., a painter painting a
  # caret line highlight must redraw the previous and the actual caret line in
  # the advent of a change of the caret position. This state information must be
  # adapted to changes of the viewer's content. In order to support this common
  # scenario, the <code>PaintManager</code> gives a painter access to a
  # {@link org.eclipse.jface.text.IPaintPositionManager}. The painter can use
  # this updater to manage its state information.
  # <p>
  # 
  # @see org.eclipse.jface.text.PaintManager
  # @see org.eclipse.jface.text.IPaintPositionManager
  # @since 2.1
  module IPainter
    include_class_members IPainterImports
    
    class_module.module_eval {
      # Constant describing the reason of a repaint request: selection changed.
      const_set_lazy(:SELECTION) { 0 }
      const_attr_reader  :SELECTION
      
      # Constant describing the reason of a repaint request: text changed.
      const_set_lazy(:TEXT_CHANGE) { 1 }
      const_attr_reader  :TEXT_CHANGE
      
      # Constant describing the reason of a repaint request: key pressed.
      const_set_lazy(:KEY_STROKE) { 2 }
      const_attr_reader  :KEY_STROKE
      
      # Constant describing the reason of a repaint request: mouse button pressed.
      const_set_lazy(:MOUSE_BUTTON) { 4 }
      const_attr_reader  :MOUSE_BUTTON
      
      # Constant describing the reason of a repaint request: paint manager internal change.
      const_set_lazy(:INTERNAL) { 8 }
      const_attr_reader  :INTERNAL
      
      # Constant describing the reason of a repaint request: paint manager or painter configuration changed.
      const_set_lazy(:CONFIGURATION) { 16 }
      const_attr_reader  :CONFIGURATION
    }
    
    typesig { [] }
    # Disposes this painter. Prior to disposing, a painter should be deactivated. A disposed
    # painter can not be reactivated.
    # 
    # @see #deactivate(boolean)
    def dispose
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Requests this painter to repaint because of the given reason. Based on
    # the given reason the painter can decide whether it will repaint or not.
    # If it repaints and is inactive, it will activate itself.
    # 
    # @param reason the repaint reason, value is one of the constants defined
    # in this interface
    def paint(reason)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Deactivates this painter. If the painter is inactive, this call does not
    # have any effect. <code>redraw</code> indicates whether the painter
    # should remove any decoration it previously applied. A deactivated painter
    # can be reactivated by calling <code>paint</code>.
    # 
    # @param redraw <code>true</code> if any previously applied decoration
    # should be removed
    # @see #paint(int)
    def deactivate(redraw)
      raise NotImplementedError
    end
    
    typesig { [IPaintPositionManager] }
    # Sets the paint position manager that can be used by this painter or removes any previously
    # set paint position manager.
    # 
    # @param manager the paint position manager or <code>null</code>
    def set_position_manager(manager)
      raise NotImplementedError
    end
  end
  
end
