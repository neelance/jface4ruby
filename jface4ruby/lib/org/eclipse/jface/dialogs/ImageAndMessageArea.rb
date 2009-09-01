require "rjava"

# Copyright (c) 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module ImageAndMessageAreaImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Jface::Fieldassist, :DecoratedField
      include_const ::Org::Eclipse::Jface::Fieldassist, :FieldDecorationRegistry
      include_const ::Org::Eclipse::Jface::Fieldassist, :TextControlCreator
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Text
    }
  end
  
  # Instances of this class provide a message area to display a message and an
  # associated image.
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @since 3.2
  # @deprecated As of 3.3, this class is no longer necessary.
  class ImageAndMessageArea < ImageAndMessageAreaImports.const_get :Composite
    include_class_members ImageAndMessageAreaImports
    
    attr_accessor :border_margin
    alias_method :attr_border_margin, :border_margin
    undef_method :border_margin
    alias_method :attr_border_margin=, :border_margin=
    undef_method :border_margin=
    
    attr_accessor :message_field
    alias_method :attr_message_field, :message_field
    undef_method :message_field
    alias_method :attr_message_field=, :message_field=
    undef_method :message_field=
    
    attr_accessor :container
    alias_method :attr_container, :container
    undef_method :container
    alias_method :attr_container=, :container=
    undef_method :container=
    
    typesig { [Composite, ::Java::Int] }
    # Constructs a new ImageAndMessageArea with an empty decorated field. Calls
    # to <code>setText(String text)</code> and
    # <code>setImage(Image image)</code> are required in order to fill the
    # message area. Also, the instance will be invisible when initially
    # created.
    # <p>
    # The style bit <code>SWT.WRAP</code> should be used if a larger message
    # area is desired.
    # </p>
    # 
    # @param parent
    # the parent composite
    # @param style
    # the SWT style bits. Using SWT.WRAP will create a larger
    # message area.
    def initialize(parent, style)
      @border_margin = 0
      @message_field = nil
      @container = nil
      super(parent, style)
      @border_margin = IDialogConstants::HORIZONTAL_SPACING / 2
      @container = Composite.new(self, style)
      glayout = GridLayout.new
      glayout.attr_num_columns = 2
      glayout.attr_margin_width = 0
      glayout.attr_margin_height = 0
      glayout.attr_margin_top = @border_margin
      glayout.attr_margin_bottom = @border_margin
      @container.set_layout(glayout)
      @message_field = DecoratedField.new(@container, SWT::READ_ONLY | style, TextControlCreator.new)
      set_font(JFaceResources.get_dialog_font)
      gd = GridData.new(SWT::FILL, SWT::FILL, true, true)
      line_height = (@message_field.get_control).get_line_height
      if ((style & SWT::WRAP) > 0)
        gd.attr_height_hint = 2 * line_height
      else
        gd.attr_height_hint = line_height
      end
      @message_field.get_layout_control.set_layout_data(gd)
      add_paint_listener(Class.new(PaintListener.class == Class ? PaintListener : Object) do
        extend LocalClass
        include_class_members ImageAndMessageArea
        include PaintListener if PaintListener.class == Module
        
        typesig { [PaintEvent] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.swt.events.PaintListener#paintControl(org.eclipse.swt.events.PaintEvent)
        define_method :paint_control do |e|
          on_paint(e)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      set_layout(# sets the layout and size to account for the BORDER_MARGIN between
      # the border drawn around the container and the decorated field.
      Class.new(Layout.class == Class ? Layout : Object) do
        extend LocalClass
        include_class_members ImageAndMessageArea
        include Layout if Layout.class == Module
        
        typesig { [Composite, ::Java::Boolean] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.swt.widgets.Layout#layout(org.eclipse.swt.widgets.Composite,
        # boolean)
        define_method :layout do |parent, changed|
          carea = get_client_area
          self.attr_container.set_bounds(carea.attr_x + BORDER_MARGIN, carea.attr_y + BORDER_MARGIN, carea.attr_width - (2 * BORDER_MARGIN), carea.attr_height - (2 * BORDER_MARGIN))
        end
        
        typesig { [Composite, ::Java::Int, ::Java::Int, ::Java::Boolean] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.swt.widgets.Layout#computeSize(org.eclipse.swt.widgets.Composite,
        # int, int, boolean)
        define_method :compute_size do |parent, w_hint, h_hint, changed|
          size = nil
          size = self.attr_container.compute_size(w_hint, h_hint, changed)
          # size set to account for the BORDER_MARGIN on
          # all sides of the decorated field
          size.attr_x += 4
          size.attr_y += 4
          return size
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      set_visible(false)
    end
    
    typesig { [Color] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.swt.widgets.Control#setBackground(org.eclipse.swt.graphics.Color)
    def set_background(bg)
      super(bg)
      @message_field.get_layout_control.set_background(bg)
      @message_field.get_control.set_background(bg)
      @container.set_background(bg)
    end
    
    typesig { [String] }
    # Sets the text in the decorated field which will be displayed in the
    # message area.
    # 
    # @param text
    # the text to be displayed in the message area
    # 
    # @see org.eclipse.swt.widgets.Text#setText(String string)
    def set_text(text)
      (@message_field.get_control).set_text(text)
    end
    
    typesig { [Image] }
    # Adds an image to decorated field to be shown in the message area.
    # 
    # @param image
    # desired image to be shown in the ImageAndMessageArea
    def set_image(image)
      registry = FieldDecorationRegistry.get_default
      registry.register_field_decoration("messageImage", nil, image) # $NON-NLS-1$
      # $NON-NLS-1$
      @message_field.add_field_decoration(registry.get_field_decoration("messageImage"), SWT::LEFT | SWT::TOP, false)
    end
    
    typesig { [PaintEvent] }
    # Draws the message area composite with rounded corners.
    def on_paint(e)
      carea = get_client_area
      e.attr_gc.set_foreground(get_foreground)
      # draws the polyline to be rounded in a 2 pixel squared area
      e.attr_gc.draw_polyline(Array.typed(::Java::Int).new([carea.attr_x, carea.attr_y + carea.attr_height - 1, carea.attr_x, carea.attr_y + 2, carea.attr_x + 2, carea.attr_y, carea.attr_x + carea.attr_width - 3, carea.attr_y, carea.attr_x + carea.attr_width - 1, carea.attr_y + 2, carea.attr_x + carea.attr_width - 1, carea.attr_y + carea.attr_height - 1]))
    end
    
    typesig { [Font] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.swt.widgets.Control#setFont(org.eclipse.swt.graphics.Font)
    def set_font(font)
      super(font)
      (@message_field.get_control).set_font(font)
    end
    
    typesig { [String] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.swt.widgets.Control#setToolTipText(java.lang.String)
    def set_tool_tip_text(text)
      super(text)
      (@message_field.get_control).set_tool_tip_text(text)
    end
    
    private
    alias_method :initialize__image_and_message_area, :initialize
  end
  
end
