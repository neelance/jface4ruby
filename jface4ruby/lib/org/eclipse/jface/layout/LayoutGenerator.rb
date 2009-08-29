require "rjava"

# Copyright (c) 2005, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Layout
  module LayoutGeneratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Layout
      include_const ::Org::Eclipse::Jface::Util, :Geometry
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :ModifyListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Scrollable
    }
  end
  
  # package
  class LayoutGenerator 
    include_class_members LayoutGeneratorImports
    
    class_module.module_eval {
      # Default size for controls with varying contents
      const_set_lazy(:DefaultSize) { Point.new(150, 150) }
      const_attr_reader  :DefaultSize
      
      # Default wrapping size for wrapped labels
      const_set_lazy(:WrapSize) { 350 }
      const_attr_reader  :WrapSize
      
      const_set_lazy(:NonWrappingLabelData) { GridDataFactory.fill_defaults.align(SWT::BEGINNING, SWT::CENTER).grab(false, false) }
      const_attr_reader  :NonWrappingLabelData
      
      typesig { [Control, ::Java::Int] }
      def has_style(c, style)
        return !((c.get_style & style)).equal?(0)
      end
      
      typesig { [Composite] }
      # Generates a GridLayout for the given composite by examining its child
      # controls and attaching layout data to any immediate children that do not
      # already have layout data.
      # 
      # @param toGenerate
      # composite to generate a layout for
      def generate_layout(to_generate)
        children = to_generate.get_children
        i = 0
        while i < children.attr_length
          control = children[i]
          # Skip any children that already have layout data
          if (!(control.get_layout_data).nil?)
            i += 1
            next
          end
          apply_layout_data_to(control)
          i += 1
        end
      end
      
      typesig { [Control] }
      def apply_layout_data_to(control)
        defaults_for(control).apply_to(control)
      end
      
      typesig { [Control] }
      # Creates default factory for this control types:
      # <ul>
      # <li>{@link Button} with {@link SWT#CHECK}</li>
      # <li>{@link Button}</li>
      # <li>{@link Composite}</li>
      # </ul>
      # @param control the control the factory is search for
      # @return a default factory for the control
      def defaults_for(control)
        if (control.is_a?(Button))
          button = control
          if (has_style(button, SWT::CHECK))
            return NonWrappingLabelData.copy
          end
          return GridDataFactory.fill_defaults.align(SWT::FILL, SWT::CENTER).hint(Geometry.max(button.compute_size(SWT::DEFAULT, SWT::DEFAULT, true), LayoutConstants.get_min_button_size))
        end
        if (control.is_a?(Scrollable))
          scrollable = control
          if (scrollable.is_a?(Composite))
            composite = control
            the_layout = composite.get_layout
            if (the_layout.is_a?(GridLayout))
              grows_horizontally = false
              grows_vertically = false
              children = composite.get_children
              i = 0
              while i < children.attr_length
                child = children[i]
                data = child.get_layout_data
                if (!(data).nil?)
                  if (data.attr_grab_excess_horizontal_space)
                    grows_horizontally = true
                  end
                  if (data.attr_grab_excess_vertical_space)
                    grows_vertically = true
                  end
                end
                i += 1
              end
              return GridDataFactory.fill_defaults.grab(grows_horizontally, grows_vertically)
            end
          end
        end
        wrapping = has_style(control, SWT::WRAP)
        # Assume any control with the H_SCROLL or V_SCROLL flags are
        # horizontally or vertically
        # scrollable, respectively.
        h_scroll = has_style(control, SWT::H_SCROLL)
        v_scroll = has_style(control, SWT::V_SCROLL)
        contains_text = has_method(control, "setText", Array.typed(Class).new([String])) # $NON-NLS-1$
        # If the control has a setText method, an addModifyListener method, and
        # does not have
        # the SWT.READ_ONLY flag, assume it contains user-editable text.
        user_editable = !has_style(control, SWT::READ_ONLY) && contains_text && has_method(control, "addModifyListener", Array.typed(Class).new([ModifyListener])) # $NON-NLS-1$
        # For controls containing user-editable text...
        if (user_editable)
          if (has_style(control, SWT::MULTI))
            v_scroll = true
          end
          if (!wrapping)
            h_scroll = true
          end
        end
        # Compute the horizontal hint
        h_hint = SWT::DEFAULT
        grab_horizontal = h_scroll
        # For horizontally-scrollable controls, override their horizontal
        # preferred size
        # with a constant
        if (h_scroll)
          h_hint = DefaultSize.attr_x
        else
          # For wrapping controls, there are two cases.
          # 1. For controls that contain text (like wrapping labels,
          # read-only text boxes,
          # etc.) override their preferred size with the preferred wrapping
          # point and
          # make them grab horizontal space.
          # 2. For non-text controls (like wrapping toolbars), assume that
          # their non-wrapped
          # size is best.
          if (wrapping)
            if (contains_text)
              h_hint = WrapSize
              grab_horizontal = true
            end
          end
        end
        v_align = SWT::FILL
        # Heuristic for labels: Controls that contain non-wrapping read-only
        # text should be
        # center-aligned rather than fill-aligned
        if (!v_scroll && !wrapping && !user_editable && contains_text)
          v_align = SWT::CENTER
        end
        return GridDataFactory.fill_defaults.grab(grab_horizontal, v_scroll).align(SWT::FILL, v_align).hint(h_hint, v_scroll ? DefaultSize.attr_y : SWT::DEFAULT)
      end
      
      typesig { [Control, String, Array.typed(Class)] }
      def has_method(control, name, parameter_types)
        c = control.get_class
        begin
          return !(c.get_method(name, parameter_types)).nil?
        rescue SecurityException => e
          return false
        rescue NoSuchMethodException => e
          return false
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__layout_generator, :initialize
  end
  
end
