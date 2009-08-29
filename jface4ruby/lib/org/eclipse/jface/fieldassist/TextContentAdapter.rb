require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Fieldassist
  module TextContentAdapterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Text
    }
  end
  
  # An {@link IControlContentAdapter} for SWT Text controls. This is a
  # convenience class for easily creating a {@link ContentProposalAdapter} for
  # text fields.
  # 
  # @since 3.2
  class TextContentAdapter 
    include_class_members TextContentAdapterImports
    include IControlContentAdapter
    include IControlContentAdapter2
    
    typesig { [Control] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.taskassistance.IControlContentAdapter#getControlContents(org.eclipse.swt.widgets.Control)
    def get_control_contents(control)
      return (control).get_text
    end
    
    typesig { [Control, String, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.fieldassist.IControlContentAdapter#setControlContents(org.eclipse.swt.widgets.Control,
    # java.lang.String, int)
    def set_control_contents(control, text, cursor_position)
      (control).set_text(text)
      (control).set_selection(cursor_position, cursor_position)
    end
    
    typesig { [Control, String, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.fieldassist.IControlContentAdapter#insertControlContents(org.eclipse.swt.widgets.Control,
    # java.lang.String, int)
    def insert_control_contents(control, text, cursor_position)
      selection = (control).get_selection
      (control).insert(text)
      # Insert will leave the cursor at the end of the inserted text. If this
      # is not what we wanted, reset the selection.
      if (cursor_position < text.length)
        (control).set_selection(selection.attr_x + cursor_position, selection.attr_x + cursor_position)
      end
    end
    
    typesig { [Control] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.fieldassist.IControlContentAdapter#getCursorPosition(org.eclipse.swt.widgets.Control)
    def get_cursor_position(control)
      return (control).get_caret_position
    end
    
    typesig { [Control] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.fieldassist.IControlContentAdapter#getInsertionBounds(org.eclipse.swt.widgets.Control)
    def get_insertion_bounds(control)
      text = control
      caret_origin = text.get_caret_location
      # We fudge the y pixels due to problems with getCaretLocation
      # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=52520
      return Rectangle.new(caret_origin.attr_x + text.get_client_area.attr_x, caret_origin.attr_y + text.get_client_area.attr_y + 3, 1, text.get_line_height)
    end
    
    typesig { [Control, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.fieldassist.IControlContentAdapter#setCursorPosition(org.eclipse.swt.widgets.Control,
    # int)
    def set_cursor_position(control, position)
      (control).set_selection(Point.new(position, position))
    end
    
    typesig { [Control] }
    # @see org.eclipse.jface.fieldassist.IControlContentAdapter2#getSelection(org.eclipse.swt.widgets.Control)
    # 
    # @since 3.4
    def get_selection(control)
      return (control).get_selection
    end
    
    typesig { [Control, Point] }
    # @see org.eclipse.jface.fieldassist.IControlContentAdapter2#setSelection(org.eclipse.swt.widgets.Control,
    # org.eclipse.swt.graphics.Point)
    # 
    # @since 3.4
    def set_selection(control, range)
      (control).set_selection(range)
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__text_content_adapter, :initialize
  end
  
end
