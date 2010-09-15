require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ColorCellEditorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :TableTree
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :ImageData
      include_const ::Org::Eclipse::Swt::Graphics, :PaletteData
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :ColorDialog
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :Tree
    }
  end
  
  # A cell editor that manages a color field.
  # The cell editor's value is the color (an SWT <code>RBG</code>).
  # <p>
  # This class may be instantiated; it is not intended to be subclassed.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class ColorCellEditor < ColorCellEditorImports.const_get :DialogCellEditor
    include_class_members ColorCellEditorImports
    
    class_module.module_eval {
      # The default extent in pixels.
      const_set_lazy(:DEFAULT_EXTENT) { 16 }
      const_attr_reader  :DEFAULT_EXTENT
      
      # Gap between between image and text in pixels.
      const_set_lazy(:GAP) { 6 }
      const_attr_reader  :GAP
    }
    
    # The composite widget containing the color and RGB label widgets
    attr_accessor :composite
    alias_method :attr_composite, :composite
    undef_method :composite
    alias_method :attr_composite=, :composite=
    undef_method :composite=
    
    # The label widget showing the current color.
    attr_accessor :color_label
    alias_method :attr_color_label, :color_label
    undef_method :color_label
    alias_method :attr_color_label=, :color_label=
    undef_method :color_label=
    
    # The label widget showing the RGB values.
    attr_accessor :rgb_label
    alias_method :attr_rgb_label, :rgb_label
    undef_method :rgb_label
    alias_method :attr_rgb_label=, :rgb_label=
    undef_method :rgb_label=
    
    # The image.
    attr_accessor :image
    alias_method :attr_image, :image
    undef_method :image
    alias_method :attr_image=, :image=
    undef_method :image=
    
    class_module.module_eval {
      # Internal class for laying out this cell editor.
      const_set_lazy(:ColorCellLayout) { Class.new(Layout) do
        local_class_in ColorCellEditor
        include_class_members ColorCellEditor
        
        typesig { [class_self::Composite, ::Java::Int, ::Java::Int, ::Java::Boolean] }
        def compute_size(editor, w_hint, h_hint, force)
          if (!(w_hint).equal?(SWT::DEFAULT) && !(h_hint).equal?(SWT::DEFAULT))
            return self.class::Point.new(w_hint, h_hint)
          end
          color_size = self.attr_color_label.compute_size(SWT::DEFAULT, SWT::DEFAULT, force)
          rgb_size = self.attr_rgb_label.compute_size(SWT::DEFAULT, SWT::DEFAULT, force)
          return self.class::Point.new(color_size.attr_x + GAP + rgb_size.attr_x, Math.max(color_size.attr_y, rgb_size.attr_y))
        end
        
        typesig { [class_self::Composite, ::Java::Boolean] }
        def layout(editor, force)
          bounds = editor.get_client_area
          color_size = self.attr_color_label.compute_size(SWT::DEFAULT, SWT::DEFAULT, force)
          rgb_size = self.attr_rgb_label.compute_size(SWT::DEFAULT, SWT::DEFAULT, force)
          ty = (bounds.attr_height - rgb_size.attr_y) / 2
          if (ty < 0)
            ty = 0
          end
          self.attr_color_label.set_bounds(-1, 0, color_size.attr_x, color_size.attr_y)
          self.attr_rgb_label.set_bounds(color_size.attr_x + GAP - 1, ty, bounds.attr_width - color_size.attr_x - GAP, bounds.attr_height)
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__color_cell_layout, :initialize
      end }
    }
    
    typesig { [Composite] }
    # Creates a new color cell editor parented under the given control.
    # The cell editor value is black (<code>RGB(0,0,0)</code>) initially, and has no
    # validator.
    # 
    # @param parent the parent control
    def initialize(parent)
      initialize__color_cell_editor(parent, SWT::NONE)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates a new color cell editor parented under the given control.
    # The cell editor value is black (<code>RGB(0,0,0)</code>) initially, and has no
    # validator.
    # 
    # @param parent the parent control
    # @param style the style bits
    # @since 2.1
    def initialize(parent, style)
      @composite = nil
      @color_label = nil
      @rgb_label = nil
      @image = nil
      super(parent, style)
      do_set_value(RGB.new(0, 0, 0))
    end
    
    typesig { [Control, RGB] }
    # Creates and returns the color image data for the given control
    # and RGB value. The image's size is either the control's item extent
    # or the cell editor's default extent, which is 16 pixels square.
    # 
    # @param w the control
    # @param color the color
    def create_color_image(w, color)
      gc = SwtGC.new(w)
      fm = gc.get_font_metrics
      size = fm.get_ascent
      gc.dispose
      indent = 6
      extent = DEFAULT_EXTENT
      if (w.is_a?(Table))
        extent = (w).get_item_height - 1
      else
        if (w.is_a?(Tree))
          extent = (w).get_item_height - 1
        else
          if (w.is_a?(TableTree))
            extent = (w).get_item_height - 1
          end
        end
      end
      if (size > extent)
        size = extent
      end
      width = indent + size
      height = extent
      xoffset = indent
      yoffset = (height - size) / 2
      black = RGB.new(0, 0, 0)
      data_palette = PaletteData.new(Array.typed(RGB).new([black, black, color]))
      data = ImageData.new(width, height, 4, data_palette)
      data.attr_transparent_pixel = 0
      end_ = size - 1
      y = 0
      while y < size
        x = 0
        while x < size
          if ((x).equal?(0) || (y).equal?(0) || (x).equal?(end_) || (y).equal?(end_))
            data.set_pixel(x + xoffset, y + yoffset, 1)
          else
            data.set_pixel(x + xoffset, y + yoffset, 2)
          end
          x += 1
        end
        y += 1
      end
      return data
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # Method declared on DialogCellEditor.
    def create_contents(cell)
      bg = cell.get_background
      @composite = Composite.new(cell, get_style)
      @composite.set_background(bg)
      @composite.set_layout(ColorCellLayout.new_local(self))
      @color_label = Label.new(@composite, SWT::LEFT)
      @color_label.set_background(bg)
      @rgb_label = Label.new(@composite, SWT::LEFT)
      @rgb_label.set_background(bg)
      @rgb_label.set_font(cell.get_font)
      return @composite
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on CellEditor.
    def dispose
      if (!(@image).nil?)
        @image.dispose
        @image = nil
      end
      super
    end
    
    typesig { [Control] }
    # (non-Javadoc)
    # Method declared on DialogCellEditor.
    def open_dialog_box(cell_editor_window)
      dialog = ColorDialog.new(cell_editor_window.get_shell)
      value = get_value
      if (!(value).nil?)
        dialog.set_rgb(value)
      end
      value = dialog.open
      return dialog.get_rgb
    end
    
    typesig { [Object] }
    # (non-Javadoc)
    # Method declared on DialogCellEditor.
    def update_contents(value)
      rgb = value
      # XXX: We don't have a value the first time this method is called".
      if ((rgb).nil?)
        rgb = RGB.new(0, 0, 0)
      end
      # XXX: Workaround for 1FMQ0P3: SWT:ALL - TableItem.setImage doesn't work if using the identical image."
      if (!(@image).nil?)
        @image.dispose
      end
      id = create_color_image(@color_label.get_parent.get_parent, rgb)
      mask = id.get_transparency_mask
      @image = Image.new(@color_label.get_display, id, mask)
      @color_label.set_image(@image)
      @rgb_label.set_text("(" + RJava.cast_to_string(rgb.attr_red) + "," + RJava.cast_to_string(rgb.attr_green) + "," + RJava.cast_to_string(rgb.attr_blue) + ")") # $NON-NLS-4$//$NON-NLS-3$//$NON-NLS-2$//$NON-NLS-1$
    end
    
    private
    alias_method :initialize__color_cell_editor, :initialize
  end
  
end
