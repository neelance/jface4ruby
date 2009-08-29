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
  module ComboContentAdapterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Combo
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # An {@link IControlContentAdapter} for SWT Combo controls. This is a
  # convenience class for easily creating a {@link ContentProposalAdapter} for
  # combo fields.
  # 
  # @since 3.2
  class ComboContentAdapter 
    include_class_members ComboContentAdapterImports
    include IControlContentAdapter
    include IControlContentAdapter2
    
    class_module.module_eval {
      # Set to <code>true</code> if we should compute the text
      # vertical bounds rather than just use the field size.
      # Workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=164748
      # The corresponding SWT bug is
      # https://bugs.eclipse.org/bugs/show_bug.cgi?id=44072
      const_set_lazy(:COMPUTE_TEXT_USING_CLIENTAREA) { !Util.is_carbon }
      const_attr_reader  :COMPUTE_TEXT_USING_CLIENTAREA
    }
    
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
      (control).set_selection(Point.new(cursor_position, cursor_position))
    end
    
    typesig { [Control, String, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.fieldassist.IControlContentAdapter#insertControlContents(org.eclipse.swt.widgets.Control,
    # java.lang.String, int)
    def insert_control_contents(control, text, cursor_position)
      combo = control
      contents = combo.get_text
      selection = combo.get_selection
      sb = StringBuffer.new
      sb.append(contents.substring(0, selection.attr_x))
      sb.append(text)
      if (selection.attr_y < contents.length)
        sb.append(contents.substring(selection.attr_y, contents.length))
      end
      combo.set_text(sb.to_s)
      selection.attr_x = selection.attr_x + cursor_position
      selection.attr_y = selection.attr_x
      combo.set_selection(selection)
    end
    
    typesig { [Control] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.fieldassist.IControlContentAdapter#getCursorPosition(org.eclipse.swt.widgets.Control)
    def get_cursor_position(control)
      return (control).get_selection.attr_x
    end
    
    typesig { [Control] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.fieldassist.IControlContentAdapter#getInsertionBounds(org.eclipse.swt.widgets.Control)
    def get_insertion_bounds(control)
      # This doesn't take horizontal scrolling into affect.
      # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=204599
      combo = control
      position = combo.get_selection.attr_y
      contents = combo.get_text
      gc = GC.new(combo)
      gc.set_font(combo.get_font)
      extent = gc.text_extent(contents.substring(0, Math.min(position, contents.length)))
      gc.dispose
      if (COMPUTE_TEXT_USING_CLIENTAREA)
        return Rectangle.new(combo.get_client_area.attr_x + extent.attr_x, combo.get_client_area.attr_y, 1, combo.get_client_area.attr_height)
      end
      return Rectangle.new(extent.attr_x, 0, 1, combo.get_size.attr_y)
    end
    
    typesig { [Control, ::Java::Int] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.fieldassist.IControlContentAdapter#setCursorPosition(org.eclipse.swt.widgets.Control,
    # int)
    def set_cursor_position(control, index)
      (control).set_selection(Point.new(index, index))
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
    alias_method :initialize__combo_content_adapter, :initialize
  end
  
end
