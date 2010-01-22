require "rjava"

# Copyright (c) 2005, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Fieldassist
  module DecoratedFieldImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :MouseAdapter
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseTrackListener
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Region
      include_const ::Org::Eclipse::Swt::Layout, :FormAttachment
      include_const ::Org::Eclipse::Swt::Layout, :FormData
      include_const ::Org::Eclipse::Swt::Layout, :FormLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # DecoratedField manages image decorations around a control. It allows clients
  # to specify an image decoration and a position for the decoration relative to
  # the field. Decorations may be assigned descriptions, which are shown when the
  # user hovers over the decoration. Clients can decorate any kind of control by
  # supplying a {@link IControlCreator} to create the control that is decorated.
  # <p>
  # Decorations always appear on either horizontal side of the field, never above
  # or below it. Decorations can be positioned at the top or bottom of either
  # side. Future implementations may provide additional positioning options for
  # decorations.
  # <p>
  # By default, DecoratedField will consult the {@link FieldDecorationRegistry}
  # to determine how much space should be reserved for each decoration. This
  # allows fields with decorations from different sources to align properly on
  # the same dialog, since the registry tracks the size of all decorations
  # registered. Therefore, it is recommended, but not required, that clients of
  # DecoratedField register the decorations used. In cases where alignment
  # between different fields is not a concern, clients can use
  # <code>setUseMaximumDecorationWidth(false)</code> and need not register
  # their decorations.
  # <p>
  # This class is not intended to be subclassed.
  # 
  # @since 3.2
  # @deprecated As of 3.3, clients should use {@link ControlDecoration} instead.
  class DecoratedField 
    include_class_members DecoratedFieldImports
    
    class_module.module_eval {
      # Cached platform flags for dealing with platform-specific issues.
      
      def mac
        defined?(@@mac) ? @@mac : @@mac= Util.is_mac
      end
      alias_method :attr_mac, :mac
      
      def mac=(value)
        @@mac = value
      end
      alias_method :attr_mac=, :mac=
      
      # Constants describing the array indices used to hold the decorations in
      # array slots.
      const_set_lazy(:LEFT_TOP) { 0 }
      const_attr_reader  :LEFT_TOP
      
      const_set_lazy(:LEFT_BOTTOM) { 1 }
      const_attr_reader  :LEFT_BOTTOM
      
      const_set_lazy(:RIGHT_TOP) { 2 }
      const_attr_reader  :RIGHT_TOP
      
      const_set_lazy(:RIGHT_BOTTOM) { 3 }
      const_attr_reader  :RIGHT_BOTTOM
      
      const_set_lazy(:DECORATION_SLOTS) { 4 }
      const_attr_reader  :DECORATION_SLOTS
      
      # Simple data structure class for specifying the internals for a field
      # decoration. This class contains data specific to the implementation of
      # field decorations as labels attached to the field. Clients should use
      # <code>FieldDecoration</code> for specifying a decoration.
      const_set_lazy(:FieldDecorationData) { Class.new do
        extend LocalClass
        include_class_members DecoratedField
        
        # Package
        attr_accessor :decoration
        alias_method :attr_decoration, :decoration
        undef_method :decoration
        alias_method :attr_decoration=, :decoration=
        undef_method :decoration=
        
        # Package
        attr_accessor :label
        alias_method :attr_label, :label
        undef_method :label
        alias_method :attr_label=, :label=
        undef_method :label=
        
        # Package
        attr_accessor :data
        alias_method :attr_data, :data
        undef_method :data
        alias_method :attr_data=, :data=
        undef_method :data=
        
        # Package
        attr_accessor :show_on_focus
        alias_method :attr_show_on_focus, :show_on_focus
        undef_method :show_on_focus
        alias_method :attr_show_on_focus=, :show_on_focus=
        undef_method :show_on_focus=
        
        # Package
        attr_accessor :visible
        alias_method :attr_visible, :visible
        undef_method :visible
        alias_method :attr_visible=, :visible=
        undef_method :visible=
        
        typesig { [class_self::FieldDecoration, class_self::Label, class_self::FormData, ::Java::Boolean] }
        # Create a decoration data representing the specified decoration, using
        # the specified label and form data for its representation.
        # 
        # @param decoration
        # the decoration whose data is kept.
        # @param label
        # the label used to represent the decoration.
        # @param formData
        # the form data used to attach the decoration to its field.
        # @param showOnFocus
        # a boolean specifying whether the decoration should only be
        # shown when the field has focus.
        def initialize(decoration, label, form_data, show_on_focus)
          @decoration = nil
          @label = nil
          @data = nil
          @show_on_focus = false
          @visible = true
          @decoration = decoration
          @label = label
          @data = form_data
          @show_on_focus = show_on_focus
        end
        
        private
        alias_method :initialize__field_decoration_data, :initialize
      end }
    }
    
    # Decorations keyed by position.
    attr_accessor :dec_datas
    alias_method :attr_dec_datas, :dec_datas
    undef_method :dec_datas
    alias_method :attr_dec_datas=, :dec_datas=
    undef_method :dec_datas=
    
    # The associated control
    attr_accessor :control
    alias_method :attr_control, :control
    undef_method :control
    alias_method :attr_control=, :control=
    undef_method :control=
    
    # The composite with form layout used to manage decorations.
    attr_accessor :form
    alias_method :attr_form, :form
    undef_method :form
    alias_method :attr_form=, :form=
    undef_method :form=
    
    # The boolean that indicates whether the maximum decoration width is used
    # when allocating space for decorations.
    attr_accessor :use_max_decoration_width
    alias_method :attr_use_max_decoration_width, :use_max_decoration_width
    undef_method :use_max_decoration_width
    alias_method :attr_use_max_decoration_width=, :use_max_decoration_width=
    undef_method :use_max_decoration_width=
    
    # The hover used for showing description text
    attr_accessor :hover
    alias_method :attr_hover, :hover
    undef_method :hover
    alias_method :attr_hover=, :hover=
    undef_method :hover=
    
    class_module.module_eval {
      # The hover used to show a decoration image's description.
      const_set_lazy(:Hover) { Class.new do
        extend LocalClass
        include_class_members DecoratedField
        
        class_module.module_eval {
          const_set_lazy(:EMPTY) { "" }
          const_attr_reader  :EMPTY
        }
        
        # $NON-NLS-1$
        # 
        # Offset of info hover arrow from the left or right side.
        attr_accessor :hao
        alias_method :attr_hao, :hao
        undef_method :hao
        alias_method :attr_hao=, :hao=
        undef_method :hao=
        
        # Width of info hover arrow.
        attr_accessor :haw
        alias_method :attr_haw, :haw
        undef_method :haw
        alias_method :attr_haw=, :haw=
        undef_method :haw=
        
        # Height of info hover arrow.
        attr_accessor :hah
        alias_method :attr_hah, :hah
        undef_method :hah
        alias_method :attr_hah=, :hah=
        undef_method :hah=
        
        # Margin around info hover text.
        attr_accessor :hm
        alias_method :attr_hm, :hm
        undef_method :hm
        alias_method :attr_hm=, :hm=
        undef_method :hm=
        
        # This info hover's shell.
        attr_accessor :hover_shell
        alias_method :attr_hover_shell, :hover_shell
        undef_method :hover_shell
        alias_method :attr_hover_shell=, :hover_shell=
        undef_method :hover_shell=
        
        # The info hover text.
        attr_accessor :text
        alias_method :attr_text, :text
        undef_method :text
        alias_method :attr_text=, :text=
        undef_method :text=
        
        # The region used to manage the shell shape
        attr_accessor :region
        alias_method :attr_region, :region
        undef_method :region
        alias_method :attr_region=, :region=
        undef_method :region=
        
        # Boolean indicating whether the last computed polygon location had an
        # arrow on left. (true if left, false if right).
        attr_accessor :arrow_on_left
        alias_method :attr_arrow_on_left, :arrow_on_left
        undef_method :arrow_on_left
        alias_method :attr_arrow_on_left=, :arrow_on_left=
        undef_method :arrow_on_left=
        
        typesig { [class_self::Shell] }
        # Create a hover parented by the specified shell.
        def initialize(parent)
          @hao = 10
          @haw = 8
          @hah = 10
          @hm = 2
          @hover_shell = nil
          @text = self.class::EMPTY
          @region = nil
          @arrow_on_left = true
          display = parent.get_display
          @hover_shell = self.class::Shell.new(parent, SWT::NO_TRIM | SWT::ON_TOP | SWT::NO_FOCUS | SWT::TOOL)
          @hover_shell.set_background(display.get_system_color(SWT::COLOR_INFO_BACKGROUND))
          @hover_shell.set_foreground(display.get_system_color(SWT::COLOR_INFO_FOREGROUND))
          @hover_shell.add_paint_listener(Class.new(self.class::PaintListener.class == Class ? self.class::PaintListener : Object) do
            extend LocalClass
            include_class_members Hover
            include class_self::PaintListener if class_self::PaintListener.class == Module
            
            typesig { [class_self::PaintEvent] }
            define_method :paint_control do |pe|
              pe.attr_gc.draw_string(self.attr_text, self.attr_hm, self.attr_hm)
              if (!self.attr_mac)
                pe.attr_gc.draw_polygon(get_polygon(true))
              end
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          @hover_shell.add_mouse_listener(Class.new(self.class::MouseAdapter.class == Class ? self.class::MouseAdapter : Object) do
            extend LocalClass
            include_class_members Hover
            include class_self::MouseAdapter if class_self::MouseAdapter.class == Module
            
            typesig { [class_self::MouseEvent] }
            define_method :mouse_down do |e|
              hide_hover
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        
        typesig { [::Java::Boolean] }
        # Compute a polygon that represents a hover with an arrow pointer. If
        # border is true, compute the polygon inset by 1-pixel border. Consult
        # the arrowOnLeft flag to determine which side the arrow is on.
        def get_polygon(border)
          e = get_extent
          b = border ? 1 : 0
          if (@arrow_on_left)
            return Array.typed(::Java::Int).new([0, 0, e.attr_x - b, 0, e.attr_x - b, e.attr_y - b, @hao + @haw, e.attr_y - b, @hao + @haw / 2, e.attr_y + @hah - b, @hao, e.attr_y - b, 0, e.attr_y - b, 0, 0])
          end
          return Array.typed(::Java::Int).new([0, 0, e.attr_x - b, 0, e.attr_x - b, e.attr_y - b, e.attr_x - @hao - b, e.attr_y - b, e.attr_x - @hao - @haw / 2, e.attr_y + @hah - b, e.attr_x - @hao - @haw, e.attr_y - b, 0, e.attr_y - b, 0, 0])
        end
        
        typesig { [] }
        # Dispose the hover, it is no longer needed. Dispose any resources
        # allocated by the hover.
        def dispose
          if (!@hover_shell.is_disposed)
            @hover_shell.dispose
          end
          if (!(@region).nil?)
            @region.dispose
          end
        end
        
        typesig { [::Java::Boolean] }
        # Set the visibility of the hover.
        def set_visible(visible)
          if (visible)
            if (!@hover_shell.is_visible)
              @hover_shell.set_visible(true)
            end
          else
            if (@hover_shell.is_visible)
              @hover_shell.set_visible(false)
            end
          end
        end
        
        typesig { [String, class_self::Control, class_self::Control] }
        # Set the text of the hover to the specified text. Recompute the size
        # and location of the hover to hover near the specified control,
        # pointing the arrow toward the target control.
        def set_text(t, hover_near, target_control)
          if ((t).nil?)
            t = self.class::EMPTY
          end
          if (!(t == @text))
            old_size = get_extent
            @text = t
            @hover_shell.redraw
            new_size = get_extent
            if (!(old_size == new_size))
              # set a flag that indicates the direction of arrow
              @arrow_on_left = hover_near.get_location.attr_x <= target_control.get_location.attr_x
              set_new_shape
            end
          end
          if (!(hover_near).nil?)
            extent = get_extent
            y = -extent.attr_y - @hah + 1
            x = @arrow_on_left ? -@hao + @haw / 2 : -extent.attr_x + @hao + @haw / 2
            @hover_shell.set_location(hover_near.to_display(x, y))
          end
        end
        
        typesig { [] }
        # Return whether or not the hover (shell) is visible.
        def is_visible
          return @hover_shell.is_visible
        end
        
        typesig { [] }
        # Compute the extent of the hover for the current text.
        def get_extent
          gc = SwtGC.new(@hover_shell)
          e = gc.text_extent(@text)
          gc.dispose
          e.attr_x += @hm * 2
          e.attr_y += @hm * 2
          return e
        end
        
        typesig { [] }
        # Compute a new shape for the hover shell.
        def set_new_shape
          old_region = @region
          @region = self.class::Region.new
          @region.add(get_polygon(false))
          @hover_shell.set_region(@region)
          if (!(old_region).nil?)
            old_region.dispose
          end
        end
        
        private
        alias_method :initialize__hover, :initialize
      end }
    }
    
    typesig { [Composite, ::Java::Int, IControlCreator] }
    # Construct a decorated field which is parented by the specified composite
    # and has the given style bits. Use the controlCreator to create the
    # specific kind of control that is decorated inside the field.
    # 
    # @param parent
    # the parent of the decorated field.
    # @param style
    # the desired style bits for the field.
    # @param controlCreator
    # the IControlCreator used to specify the specific kind of
    # control that is to be decorated.
    # 
    # @see IControlCreator
    def initialize(parent, style, control_creator)
      @dec_datas = Array.typed(FieldDecorationData).new(DECORATION_SLOTS) { nil }
      @control = nil
      @form = nil
      @use_max_decoration_width = true
      @hover = nil
      @form = create_form(parent)
      @control = control_creator.create_control(@form, style)
      add_control_listeners
      @form.set_tab_list(Array.typed(Control).new([@control]))
      # Set up the initial layout data.
      data = FormData.new
      data.attr_left = FormAttachment.new(0, 0)
      data.attr_top = FormAttachment.new(0, 0)
      data.attr_right = FormAttachment.new(100, 0)
      data.attr_bottom = FormAttachment.new(100, 0)
      @control.set_layout_data(data)
    end
    
    typesig { [FieldDecoration, ::Java::Int, ::Java::Boolean] }
    # Adds an image decoration to the field.
    # 
    # @param decoration
    # A FieldDecoration describing the image and description for the
    # decoration
    # 
    # @param position
    # The SWT constant indicating the position of the decoration
    # relative to the field's control. The position should include
    # style bits describing both the vertical and horizontal
    # orientation. <code>SWT.LEFT</code> and
    # <code>SWT.RIGHT</code> describe the horizontal placement of
    # the decoration relative to the field, and the constants
    # <code>SWT.TOP</code> and <code>SWT.BOTTOM</code> describe
    # the vertical alignment of the decoration relative to the
    # field. Decorations always appear on either horizontal side of
    # the field, never above or below it. For example, a decoration
    # appearing on the left side of the field, at the top, is
    # specified as SWT.LEFT | SWT.TOP. If an image decoration
    # already exists in the specified position, it will be replaced
    # by the one specified.
    # @param showOnFocus
    # <code>true</code> if the decoration should only be shown
    # when the associated control has focus, <code>false</code> if
    # it should always be shown.
    def add_field_decoration(decoration, position, show_on_focus)
      label = nil
      form_data = nil
      i = index_for_position(position)
      if ((@dec_datas[i]).nil?)
        form_data = create_form_data_for_index(i, decoration.get_image)
        label = Label.new(@form, SWT::HORIZONTAL | SWT::VERTICAL | SWT::CENTER)
        label.add_mouse_track_listener(Class.new(MouseTrackListener.class == Class ? MouseTrackListener : Object) do
          extend LocalClass
          include_class_members DecoratedField
          include MouseTrackListener if MouseTrackListener.class == Module
          
          typesig { [MouseEvent] }
          define_method :mouse_hover do |event|
            dec_data = event.attr_widget.get_data
            desc = dec_data.attr_decoration.get_description
            if (!(desc).nil?)
              show_hover_text(desc, label)
            end
          end
          
          typesig { [MouseEvent] }
          define_method :mouse_enter do |event|
          end
          
          typesig { [MouseEvent] }
          define_method :mouse_exit do |event|
            hide_hover
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        @dec_datas[i] = FieldDecorationData.new_local(self, decoration, label, form_data, show_on_focus)
      else
        label = @dec_datas[i].attr_label
        form_data = @dec_datas[i].attr_data
        @dec_datas[i].attr_decoration = decoration
        @dec_datas[i].attr_show_on_focus = show_on_focus
      end
      label.set_image(@dec_datas[i].attr_decoration.get_image)
      label.set_data(@dec_datas[i])
      label.set_layout_data(form_data)
      label.set_visible(!show_on_focus)
      # Since sizes may have changed or there could be a new position
      # defined, we need to update layout data on the control.
      update_control_attachments(i, @dec_datas[i])
    end
    
    typesig { [::Java::Int, FieldDecorationData] }
    # A decoration at the specified index has been added. Update the control's
    # attachments if it has not previously been attached on that side or if it
    # was attached to a decoration with a lesser width.
    def update_control_attachments(index, dec_data)
      form_data = @control.get_layout_data
      new_width = width_of(dec_data.attr_decoration.get_image)
      # opposing represents the location of the decoration above or below
      # the one in question.
      opposing = 0
      case (index)
      # The only real difference in right side cases is that we are attaching
      # the right side of the control to the wider decoration rather than the
      # left side of the control. Other concerns (horizontally aligning the
      # smaller decoration relative to the larger one) are the same.
      when LEFT_TOP, LEFT_BOTTOM
        if ((index).equal?(LEFT_TOP))
          opposing = LEFT_BOTTOM
        else
          opposing = LEFT_TOP
        end
        if ((@dec_datas[opposing]).nil?)
          # No decorator on the opposing side.
          # Attach the control to this decorator
          form_data.attr_left = FormAttachment.new(dec_data.attr_label)
        else
          if (@dec_datas[opposing].attr_data.attr_width < new_width)
            # Decorator on opposing side is the smaller one. Attach
            # control to the new one.
            form_data.attr_left = FormAttachment.new(dec_data.attr_label)
            # Center align the smaller one relative to the larger one.
            @dec_datas[opposing].attr_data.attr_left.attr_alignment = SWT::CENTER
            @dec_datas[opposing].attr_data.attr_left.attr_control = dec_data.attr_label
          else
            # The new decorator is the smaller one. Keep the
            # control attached to the opposing one.
            form_data = nil
            # Horizontally center the smaller one relative to the larger
            # one.
            dec_data.attr_data.attr_left.attr_alignment = SWT::CENTER
            dec_data.attr_data.attr_left.attr_control = @dec_datas[opposing].attr_label
          end
        end
      when RIGHT_TOP, RIGHT_BOTTOM
        if ((index).equal?(RIGHT_TOP))
          opposing = RIGHT_BOTTOM
        else
          opposing = RIGHT_TOP
        end
        if ((@dec_datas[opposing]).nil?)
          # No decorator on the opposing side.
          # Attach the control to this decorator.
          form_data.attr_right = FormAttachment.new(dec_data.attr_label)
        else
          if (@dec_datas[opposing].attr_data.attr_width < new_width)
            # Decorator on opposing side is the smaller one. Attach
            # control to the new one.
            form_data.attr_right = FormAttachment.new(dec_data.attr_label)
            # Center align the smaller one to the larger one.
            # Note that this could be done using the left or right
            # attachment, we use the right since it is already
            # created for all right-side decorations.
            @dec_datas[opposing].attr_data.attr_right.attr_alignment = SWT::CENTER
            @dec_datas[opposing].attr_data.attr_right.attr_control = dec_data.attr_label
          else
            # The new decorator is the smaller one. Keep the
            # control attached to the opposing one.
            form_data = nil
            # Horizontally center align the smaller one to the
            # larger one.
            dec_data.attr_data.attr_right.attr_alignment = SWT::CENTER
            dec_data.attr_data.attr_right.attr_control = @dec_datas[opposing].attr_label
          end
        end
      else
        return
      end
      if (!(form_data).nil?)
        # Form data was updated.
        @control.set_layout_data(form_data)
        @form.layout
      end
    end
    
    typesig { [] }
    # Get the control that is decorated by the receiver.
    # 
    # @return the Control decorated by the receiver, or <code>null</code> if
    # none has been created yet.
    def get_control
      return @control
    end
    
    typesig { [] }
    # Get the control that represents the decorated field. This composite
    # should be used to lay out the field within its parent.
    # 
    # @return the Control that should be layed out in the field's parent's
    # layout. This is typically not the control itself, since
    # additional controls are used to represent the decorations.
    def get_layout_control
      return @form
    end
    
    typesig { [Composite] }
    # Create the parent composite and a form layout that will be used to manage
    # decorations.
    def create_form(parent)
      composite = Composite.new(parent, SWT::NO_FOCUS)
      # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=126553
      composite.set_background_mode(SWT::INHERIT_DEFAULT)
      composite.set_layout(FormLayout.new)
      return composite
    end
    
    typesig { [] }
    # Add any listeners needed on the target control.
    def add_control_listeners
      @control.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members DecoratedField
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |event|
          if (!(self.attr_hover).nil?)
            self.attr_hover.dispose
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @control.add_focus_listener(Class.new(FocusListener.class == Class ? FocusListener : Object) do
        extend LocalClass
        include_class_members DecoratedField
        include FocusListener if FocusListener.class == Module
        
        typesig { [FocusEvent] }
        define_method :focus_gained do |event|
          control_focus_gained
        end
        
        typesig { [FocusEvent] }
        define_method :focus_lost do |event|
          control_focus_lost
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [::Java::Int] }
    # Return the index in the array of decoration datas that represents the
    # specified SWT position.
    # 
    # @param position The SWT constant indicating the position of the
    # decoration relative to the field's control. The position should include
    # style bits describing both the vertical and horizontal orientation.
    # <code>SWT.LEFT</code> and <code>SWT.RIGHT</code> describe the
    # horizontal placement of the decoration relative to the field, and the
    # constants <code>SWT.TOP</code> and <code>SWT.BOTTOM</code> describe
    # the vertical alignment of the decoration relative to the field.
    # Decorations always appear on either horizontal side of the field, never
    # above or below it. For example, a decoration appearing on the left side
    # of the field, at the top, is specified as SWT.LEFT | SWT.TOP.
    # 
    # @return index the index in the array of decorations that represents the
    # specified SWT position. If the position is not an expected position, the
    # index representing the top left position will be returned.
    def index_for_position(position)
      case (position)
      when SWT::LEFT | SWT::BOTTOM
        return LEFT_BOTTOM
      when SWT::RIGHT | SWT::TOP
        return RIGHT_TOP
      when SWT::RIGHT | SWT::BOTTOM
        return RIGHT_BOTTOM
      else
        return LEFT_TOP
      end
    end
    
    typesig { [::Java::Int, Image] }
    # Create a form data that will place the decoration at the specified
    # position.
    # 
    # @param index the index in the decDatas describing the position of the
    # decoration.
    # 
    # @param image the image shown in the decoration.
    def create_form_data_for_index(index, image)
      Assert.is_true(index >= 0 && index < DECORATION_SLOTS, "Index out of range") # $NON-NLS-1$
      data = FormData.new
      case (index)
      when LEFT_TOP
        data.attr_left = FormAttachment.new(0, 0)
        data.attr_top = FormAttachment.new(0, 0)
      when LEFT_BOTTOM
        data.attr_left = FormAttachment.new(0, 0)
        data.attr_bottom = FormAttachment.new(100, 0)
      when RIGHT_TOP
        data.attr_right = FormAttachment.new(100, 0)
        data.attr_top = FormAttachment.new(0, 0)
      when RIGHT_BOTTOM
        data.attr_right = FormAttachment.new(100, 0)
        data.attr_bottom = FormAttachment.new(100, 0)
      end
      data.attr_width = width_of(image)
      data.attr_height = SWT::DEFAULT
      return data
    end
    
    typesig { [String] }
    # Show the specified text using the same hover dialog as is used to show
    # decorator descriptions. Normally, a decoration's description text will be
    # shown in an info hover over the field's control whenever the mouse hovers
    # over the decoration. This method can be used to show a decoration's
    # description text at other times (such as when the control receives
    # focus), or to show other text associated with the field.
    # 
    # <p>
    # If there is currently a hover visible, the hover's text will be replaced
    # with the specified text.
    # 
    # @param text
    # the text to be shown in the info hover, or <code>null</code>
    # if no text should be shown.
    def show_hover_text(text)
      show_hover_text(text, @control)
    end
    
    typesig { [] }
    # Hide any hover popups that are currently showing on the control.
    # Normally, a decoration's description text will be shown in an info hover
    # over the field's control as long as the mouse hovers over the decoration,
    # and will be hidden when the mouse exits the control. This method can be
    # used to hide a hover that was shown using <code>showHoverText</code>,
    # or to programatically hide the current decoration hover.
    # 
    # <p>
    # This message has no effect if there is no current hover.
    def hide_hover
      if (!(@hover).nil?)
        @hover.set_visible(false)
      end
    end
    
    typesig { [] }
    # The target control gained focus. Any decorations that should show only
    # when they have the focus should be shown here.
    def control_focus_gained
      i = 0
      while i < DECORATION_SLOTS
        if (!(@dec_datas[i]).nil? && @dec_datas[i].attr_show_on_focus)
          set_visible(@dec_datas[i], true)
        end
        i += 1
      end
    end
    
    typesig { [] }
    # The target control lost focus. Any decorations that should show only when
    # they have the focus should be hidden here.
    def control_focus_lost
      i = 0
      while i < DECORATION_SLOTS
        if (!(@dec_datas[i]).nil? && @dec_datas[i].attr_show_on_focus)
          set_visible(@dec_datas[i], false)
        end
        i += 1
      end
    end
    
    typesig { [FieldDecoration] }
    # Show the specified decoration. This message has no effect if the
    # decoration is already showing, or was not already added to the field
    # using <code>addFieldDecoration</code>.
    # 
    # @param decoration
    # the decoration to be shown.
    def show_decoration(decoration)
      data = get_decoration_data(decoration)
      if ((data).nil?)
        return
      end
      # record the fact that client would like it to be visible
      data.attr_visible = true
      # even if it is supposed to be shown, if the field does not have focus,
      # do not show it (yet)
      if (!data.attr_show_on_focus || @control.is_focus_control)
        set_visible(data, true)
      end
    end
    
    typesig { [FieldDecoration] }
    # Hide the specified decoration. This message has no effect if the
    # decoration is already hidden, or was not already added to the field using
    # <code>addFieldDecoration</code>.
    # 
    # @param decoration
    # the decoration to be hidden.
    def hide_decoration(decoration)
      data = get_decoration_data(decoration)
      if ((data).nil?)
        return
      end
      # Store the desired visibility in the decData. We remember the
      # client's instructions so that changes in visibility caused by
      # field focus changes won't violate the client's visibility setting.
      data.attr_visible = false
      set_visible(data, false)
    end
    
    typesig { [FieldDecoration] }
    # Update the specified decoration. This message should be used if the image
    # or description in the decoration have changed. This message has no
    # immediate effect if the decoration is not visible, and no effect at all
    # if the decoration was not previously added to the field.
    # 
    # @param decoration
    # the decoration to be hidden.
    def update_decoration(decoration)
      data = get_decoration_data(decoration)
      if ((data).nil?)
        return
      end
      if (!(data.attr_label).nil?)
        data.attr_label.set_image(decoration.get_image)
        # If the decoration is being shown, and a hover is active,
        # update the hover text to display the new description.
        if ((data.attr_label.get_visible).equal?(true) && !(@hover).nil?)
          show_hover_text(decoration.get_description, data.attr_label)
        end
      end
    end
    
    typesig { [FieldDecorationData, ::Java::Boolean] }
    # Set the visibility of the specified decoration data. This method does not
    # change the visibility value stored in the decData, but instead consults
    # it to determine how the visibility should be changed. This method is
    # called any time visibility of a decoration might change, whether by
    # client API or focus changes.
    def set_visible(dec_data, visible)
      # Check the decData visibility flag, since it contains the client's
      # instructions for visibility.
      if (visible && dec_data.attr_visible)
        dec_data.attr_label.set_visible(true)
      else
        dec_data.attr_label.set_visible(false)
      end
    end
    
    typesig { [FieldDecoration] }
    # Get the FieldDecorationData that corresponds to the given decoration.
    def get_decoration_data(dec)
      i = 0
      while i < DECORATION_SLOTS
        if (!(@dec_datas[i]).nil? && (dec).equal?(@dec_datas[i].attr_decoration) && !(@dec_datas[i].attr_label).nil? && !@dec_datas[i].attr_label.is_disposed)
          return @dec_datas[i]
        end
        i += 1
      end
      return nil
    end
    
    typesig { [String, Control] }
    # Show the specified text in the hover, positioning the hover near the
    # specified control.
    def show_hover_text(text, hover_near)
      if ((text).nil?)
        hide_hover
        return
      end
      if ((@hover).nil?)
        @hover = Hover.new_local(self, hover_near.get_shell)
      end
      @hover.set_text(text, hover_near, @control)
      @hover.set_visible(true)
    end
    
    typesig { [::Java::Boolean] }
    # Set a boolean that indicates whether the receiver should use the
    # decoration registry's maximum decoration width when allocating space for
    # decorations. The default value is <code>true</code>. Using the maximum
    # decoration width is useful so that decorated fields on the same dialog
    # that have different decoration widths will all align. This also allows
    # client dialogs to align non-decorated fields with decorated fields by
    # consulting the maximum decoration width.
    # </p>
    # <p>
    # Clients may wish to set this value to <code>false</code> in cases where
    # space usage is more important than alignment of fields. This value must
    # be set before the decorations are added in order to ensure proper
    # alignment.
    # </p>
    # 
    # @param useMaximumWidth
    # <code>true</code> if the maximum decoration width should be
    # used as the size for all decorations, <code>false</code> if
    # only the decoration size should be used.
    # 
    # @see FieldDecorationRegistry#getMaximumDecorationWidth()
    def set_use_maximum_decoration_width(use_maximum_width)
      @use_max_decoration_width = use_maximum_width
    end
    
    typesig { [Image] }
    # Return the width appropriate for the specified decoration image.
    def width_of(image)
      if ((image).nil?)
        return 0
      end
      return @use_max_decoration_width ? FieldDecorationRegistry.get_default.get_maximum_decoration_width : image.get_bounds.attr_width
    end
    
    private
    alias_method :initialize__decorated_field, :initialize
  end
  
end
