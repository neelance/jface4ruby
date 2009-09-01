require "rjava"

# Copyright (c) 2006, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Fieldassist
  module ControlDecorationImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :MenuDetectEvent
      include_const ::Org::Eclipse::Swt::Events, :MenuDetectListener
      include_const ::Org::Eclipse::Swt::Events, :MouseAdapter
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :MouseTrackListener
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Graphics, :Region
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # ControlDecoration renders an image decoration near a control. It allows
  # clients to specify an image and a position for the image relative to the
  # control. A ControlDecoration may be assigned description text, which can
  # optionally be shown when the user hovers over the image. Clients can decorate
  # any kind of control.
  # <p>
  # Decoration images always appear on the left or right side of the field, never
  # above or below it. Decorations can be positioned at the top, center, or
  # bottom of either side of the control. Future implementations may provide
  # additional positioning options for decorations.
  # <p>
  # ControlDecoration renders the image adjacent to the specified (already
  # created) control, with no guarantee that it won't be clipped or otherwise
  # obscured or overlapped by adjacent controls, including another
  # ControlDecoration placed in the same location. Clients should ensure that
  # there is adequate space adjacent to the control to show the decoration
  # properly.
  # <p>
  # Clients using ControlDecoration should typically ensure that enough margin
  # space is reserved for a decoration by altering the layout data margins,
  # although this is not assumed or required by the ControlDecoration
  # implementation.
  # <p>
  # This class is intended to be instantiated and used by clients. It is not
  # intended to be subclassed by clients.
  # 
  # @since 3.3
  # 
  # @see FieldDecoration
  # @see FieldDecorationRegistry
  class ControlDecoration 
    include_class_members ControlDecorationImports
    
    class_module.module_eval {
      # Debug flag for tracing
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= false
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      # Cached platform flag for dealing with platform-specific issue:
      # https://bugs.eclipse.org/bugs/show_bug.cgi?id=219326 : Shell with custom region and SWT.NO_TRIM still has border
      
      def mac
        defined?(@@mac) ? @@mac : @@mac= Util.is_mac
      end
      alias_method :attr_mac, :mac
      
      def mac=(value)
        @@mac = value
      end
      alias_method :attr_mac=, :mac=
    }
    
    # The associated control
    attr_accessor :control
    alias_method :attr_control, :control
    undef_method :control
    alias_method :attr_control=, :control=
    undef_method :control=
    
    # The composite on which to render the decoration and hook mouse events, or
    # null if we are hooking all parent composites.
    attr_accessor :composite
    alias_method :attr_composite, :composite
    undef_method :composite
    alias_method :attr_composite=, :composite=
    undef_method :composite=
    
    # The associated image.
    attr_accessor :image
    alias_method :attr_image, :image
    undef_method :image
    alias_method :attr_image=, :image=
    undef_method :image=
    
    # The associated description text.
    attr_accessor :description_text
    alias_method :attr_description_text, :description_text
    undef_method :description_text
    alias_method :attr_description_text=, :description_text=
    undef_method :description_text=
    
    # The position of the decoration.
    attr_accessor :position
    alias_method :attr_position, :position
    undef_method :position
    alias_method :attr_position=, :position=
    undef_method :position=
    
    # The decoration's visibility flag
    attr_accessor :visible
    alias_method :attr_visible, :visible
    undef_method :visible
    alias_method :attr_visible=, :visible=
    undef_method :visible=
    
    # Boolean indicating whether the decoration should only be shown when the
    # control has focus
    attr_accessor :show_only_on_focus
    alias_method :attr_show_only_on_focus, :show_only_on_focus
    undef_method :show_only_on_focus
    alias_method :attr_show_only_on_focus=, :show_only_on_focus=
    undef_method :show_only_on_focus=
    
    # Boolean indicating whether the decoration should show its description
    # text in a hover when the user hovers over the decoration.
    attr_accessor :show_hover
    alias_method :attr_show_hover, :show_hover
    undef_method :show_hover
    alias_method :attr_show_hover=, :show_hover=
    undef_method :show_hover=
    
    # Margin width used between the decorator and the control.
    attr_accessor :margin_width
    alias_method :attr_margin_width, :margin_width
    undef_method :margin_width
    alias_method :attr_margin_width=, :margin_width=
    undef_method :margin_width=
    
    # Registered selection listeners.
    attr_accessor :selection_listeners
    alias_method :attr_selection_listeners, :selection_listeners
    undef_method :selection_listeners
    alias_method :attr_selection_listeners=, :selection_listeners=
    undef_method :selection_listeners=
    
    # Registered menu detect listeners.
    attr_accessor :menu_detect_listeners
    alias_method :attr_menu_detect_listeners, :menu_detect_listeners
    undef_method :menu_detect_listeners
    alias_method :attr_menu_detect_listeners=, :menu_detect_listeners=
    undef_method :menu_detect_listeners=
    
    # The focus listener
    attr_accessor :focus_listener
    alias_method :attr_focus_listener, :focus_listener
    undef_method :focus_listener
    alias_method :attr_focus_listener=, :focus_listener=
    undef_method :focus_listener=
    
    # The dispose listener
    attr_accessor :dispose_listener
    alias_method :attr_dispose_listener, :dispose_listener
    undef_method :dispose_listener
    alias_method :attr_dispose_listener=, :dispose_listener=
    undef_method :dispose_listener=
    
    # The paint listener installed for drawing the decoration
    attr_accessor :paint_listener
    alias_method :attr_paint_listener, :paint_listener
    undef_method :paint_listener
    alias_method :attr_paint_listener=, :paint_listener=
    undef_method :paint_listener=
    
    # The mouse listener installed for tracking the hover
    attr_accessor :mouse_track_listener
    alias_method :attr_mouse_track_listener, :mouse_track_listener
    undef_method :mouse_track_listener
    alias_method :attr_mouse_track_listener=, :mouse_track_listener=
    undef_method :mouse_track_listener=
    
    # The mouse move listener installed for tracking the hover
    attr_accessor :mouse_move_listener
    alias_method :attr_mouse_move_listener, :mouse_move_listener
    undef_method :mouse_move_listener
    alias_method :attr_mouse_move_listener=, :mouse_move_listener=
    undef_method :mouse_move_listener=
    
    # The untyped listener installed for notifying external listeners
    attr_accessor :composite_listener
    alias_method :attr_composite_listener, :composite_listener
    undef_method :composite_listener
    alias_method :attr_composite_listener=, :composite_listener=
    undef_method :composite_listener=
    
    # Control that we last installed a move listener on. We only want one at a
    # time.
    attr_accessor :move_listening_target
    alias_method :attr_move_listening_target, :move_listening_target
    undef_method :move_listening_target
    alias_method :attr_move_listening_target=, :move_listening_target=
    undef_method :move_listening_target=
    
    # Debug counter used to match add and remove listeners
    attr_accessor :listener_installs
    alias_method :attr_listener_installs, :listener_installs
    undef_method :listener_installs
    alias_method :attr_listener_installs=, :listener_installs=
    undef_method :listener_installs=
    
    # The current rectangle used for tracking mouse moves
    attr_accessor :decoration_rectangle
    alias_method :attr_decoration_rectangle, :decoration_rectangle
    undef_method :decoration_rectangle
    alias_method :attr_decoration_rectangle=, :decoration_rectangle=
    undef_method :decoration_rectangle=
    
    # The rectangle of the previously used image.  Used
    # for redrawing in the case where a smaller image replaces
    # a larger one.
    # 
    # @since 3.5
    attr_accessor :previous_decoration_rectangle
    alias_method :attr_previous_decoration_rectangle, :previous_decoration_rectangle
    undef_method :previous_decoration_rectangle
    alias_method :attr_previous_decoration_rectangle=, :previous_decoration_rectangle=
    undef_method :previous_decoration_rectangle=
    
    # An internal flag tracking whether we have focus. We use this rather than
    # isFocusControl() so that we can set the flag as soon as we get the focus
    # callback, rather than having to do an asyncExec in the middle of a focus
    # callback to ensure that isFocusControl() represents the outcome of the
    # event.
    attr_accessor :has_focus
    alias_method :attr_has_focus, :has_focus
    undef_method :has_focus
    alias_method :attr_has_focus=, :has_focus=
    undef_method :has_focus=
    
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
        include_class_members ControlDecoration
        
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
              pe.attr_gc.draw_text(self.attr_text, self.attr_hm, self.attr_hm)
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
        
        typesig { [String, class_self::Rectangle, class_self::Control] }
        # Set the text of the hover to the specified text. Recompute the size
        # and location of the hover to hover near the decoration rectangle,
        # pointing the arrow toward the target control.
        def set_text(t, decoration_rectangle, target_control)
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
              @arrow_on_left = decoration_rectangle.attr_x <= target_control.get_location.attr_x
              set_new_shape
            end
          end
          extent = get_extent
          y = -extent.attr_y - @hah + 1
          x = @arrow_on_left ? -@hao + @haw / 2 : -extent.attr_x + @hao + @haw / 2
          @hover_shell.set_location(self.attr_control.get_parent.to_display(decoration_rectangle.attr_x + x, decoration_rectangle.attr_y + y))
        end
        
        typesig { [] }
        # Return whether or not the hover (shell) is visible.
        def is_visible
          return @hover_shell.is_visible
        end
        
        typesig { [] }
        # Compute the extent of the hover for the current text.
        def get_extent
          gc = self.class::GC.new(@hover_shell)
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
    
    typesig { [Control, ::Java::Int] }
    # Construct a ControlDecoration for decorating the specified control at the
    # specified position relative to the control. Render the decoration on top
    # of any Control that happens to appear at the specified location.
    # <p>
    # SWT constants are used to specify the position of the decoration relative
    # to the control. The position should include style bits describing both
    # the vertical and horizontal orientation. <code>SWT.LEFT</code> and
    # <code>SWT.RIGHT</code> describe the horizontal placement of the
    # decoration relative to the control, and the constants
    # <code>SWT.TOP</code>, <code>SWT.CENTER</code>, and
    # <code>SWT.BOTTOM</code> describe the vertical alignment of the
    # decoration relative to the control. Decorations always appear on either
    # the left or right side of the control, never above or below it. For
    # example, a decoration appearing on the left side of the field, at the
    # top, is specified as SWT.LEFT | SWT.TOP. If no position style bits are
    # specified, the control decoration will be positioned to the left and
    # center of the control (<code>SWT.LEFT | SWT.CENTER</code>).
    # </p>
    # 
    # @param control
    # the control to be decorated
    # @param position
    # bit-wise or of position constants (<code>SWT.TOP</code>,
    # <code>SWT.BOTTOM</code>, <code>SWT.LEFT</code>,
    # <code>SWT.RIGHT</code>, and <code>SWT.CENTER</code>).
    def initialize(control, position)
      initialize__control_decoration(control, position, nil)
    end
    
    typesig { [Control, ::Java::Int, Composite] }
    # Construct a ControlDecoration for decorating the specified control at the
    # specified position relative to the control. Render the decoration only on
    # the specified Composite or its children. The decoration will be clipped
    # if it does not appear within the visible bounds of the composite or its
    # child composites.
    # <p>
    # SWT constants are used to specify the position of the decoration relative
    # to the control. The position should include style bits describing both
    # the vertical and horizontal orientation. <code>SWT.LEFT</code> and
    # <code>SWT.RIGHT</code> describe the horizontal placement of the
    # decoration relative to the control, and the constants
    # <code>SWT.TOP</code>, <code>SWT.CENTER</code>, and
    # <code>SWT.BOTTOM</code> describe the vertical alignment of the
    # decoration relative to the control. Decorations always appear on either
    # the left or right side of the control, never above or below it. For
    # example, a decoration appearing on the left side of the field, at the
    # top, is specified as SWT.LEFT | SWT.TOP. If no position style bits are
    # specified, the control decoration will be positioned to the left and
    # center of the control (<code>SWT.LEFT | SWT.CENTER</code>).
    # </p>
    # 
    # @param control
    # the control to be decorated
    # @param position
    # bit-wise or of position constants (<code>SWT.TOP</code>,
    # <code>SWT.BOTTOM</code>, <code>SWT.LEFT</code>,
    # <code>SWT.RIGHT</code>, and <code>SWT.CENTER</code>).
    # @param composite
    # The SWT composite within which the decoration should be
    # rendered. The decoration will be clipped to this composite,
    # but it may be rendered on a child of the composite. The
    # decoration will not be visible if the specified composite or
    # its child composites are not visible in the space relative to
    # the control, where the decoration is to be rendered. If this
    # value is <code>null</code>, then the decoration will be
    # rendered on whichever composite (or composites) are located in
    # the specified position.
    def initialize(control, position, composite)
      @control = nil
      @composite = nil
      @image = nil
      @description_text = nil
      @position = 0
      @visible = true
      @show_only_on_focus = false
      @show_hover = true
      @margin_width = 0
      @selection_listeners = ListenerList.new
      @menu_detect_listeners = ListenerList.new
      @focus_listener = nil
      @dispose_listener = nil
      @paint_listener = nil
      @mouse_track_listener = nil
      @mouse_move_listener = nil
      @composite_listener = nil
      @move_listening_target = nil
      @listener_installs = 0
      @decoration_rectangle = nil
      @previous_decoration_rectangle = nil
      @has_focus = false
      @hover = nil
      @position = position
      @control = control
      @composite = composite
      add_control_listeners
    end
    
    typesig { [MenuDetectListener] }
    # Adds the listener to the collection of listeners who will be notified
    # when the platform-specific context menu trigger has occurred, by sending
    # it one of the messages defined in the <code>MenuDetectListener</code>
    # interface.
    # <p>
    # The <code>widget</code> field in the SelectionEvent will contain the
    # Composite on which the decoration is rendered that received the click.
    # The <code>x</code> and <code>y</code> fields will be in coordinates
    # relative to the display. The <code>data</code> field will contain the
    # decoration that received the event.
    # </p>
    # 
    # @param listener
    # the listener which should be notified
    # 
    # @see org.eclipse.swt.events.MenuDetectListener
    # @see org.eclipse.swt.events.MenuDetectEvent
    # @see #removeMenuDetectListener
    def add_menu_detect_listener(listener)
      @menu_detect_listeners.add(listener)
    end
    
    typesig { [MenuDetectListener] }
    # Removes the listener from the collection of listeners who will be
    # notified when the platform-specific context menu trigger has occurred.
    # 
    # @param listener
    # the listener which should no longer be notified. This message
    # has no effect if the listener was not previously added to the
    # receiver.
    # 
    # @see org.eclipse.swt.events.MenuDetectListener
    # @see #addMenuDetectListener
    def remove_menu_detect_listener(listener)
      @menu_detect_listeners.remove(listener)
    end
    
    typesig { [SelectionListener] }
    # Adds the listener to the collection of listeners who will be notified
    # when the decoration is selected, by sending it one of the messages
    # defined in the <code>SelectionListener</code> interface.
    # <p>
    # <code>widgetSelected</code> is called when the decoration is selected
    # (by mouse click). <code>widgetDefaultSelected</code> is called when the
    # decoration is double-clicked.
    # </p>
    # <p>
    # The <code>widget</code> field in the SelectionEvent will contain the
    # Composite on which the decoration is rendered that received the click.
    # The <code>x</code> and <code>y</code> fields will be in coordinates
    # relative to that widget. The <code>data</code> field will contain the
    # decoration that received the event.
    # </p>
    # 
    # @param listener
    # the listener which should be notified
    # 
    # @see org.eclipse.swt.events.SelectionListener
    # @see org.eclipse.swt.events.SelectionEvent
    # @see #removeSelectionListener
    def add_selection_listener(listener)
      @selection_listeners.add(listener)
    end
    
    typesig { [SelectionListener] }
    # Removes the listener from the collection of listeners who will be
    # notified when the decoration is selected.
    # 
    # @param listener
    # the listener which should no longer be notified. This message
    # has no effect if the listener was not previously added to the
    # receiver.
    # 
    # @see org.eclipse.swt.events.SelectionListener
    # @see #addSelectionListener
    def remove_selection_listener(listener)
      @selection_listeners.remove(listener)
    end
    
    typesig { [] }
    # Dispose this ControlDecoration. Unhook any listeners that have been
    # installed on the target control. This method has no effect if the
    # receiver is already disposed.
    def dispose
      if ((@control).nil?)
        return
      end
      if (!(@hover).nil?)
        @hover.dispose
        @hover = nil
      end
      remove_control_listeners
      @control = nil
    end
    
    typesig { [] }
    # Get the control that is decorated by the receiver.
    # 
    # @return the Control decorated by the receiver. May be <code>null</code>
    # if the control has been uninstalled.
    def get_control
      return @control
    end
    
    typesig { [] }
    # Add any listeners needed on the target control and on the composite where
    # the decoration is to be rendered.
    def add_control_listeners
      @dispose_listener = Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members ControlDecoration
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |event|
          dispose
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      print_add_listener(@control, "DISPOSE") # $NON-NLS-1$
      @control.add_dispose_listener(@dispose_listener)
      @focus_listener = Class.new(FocusListener.class == Class ? FocusListener : Object) do
        extend LocalClass
        include_class_members ControlDecoration
        include FocusListener if FocusListener.class == Module
        
        typesig { [FocusEvent] }
        define_method :focus_gained do |event|
          self.attr_has_focus = true
          if (self.attr_show_only_on_focus)
            update
          end
        end
        
        typesig { [FocusEvent] }
        define_method :focus_lost do |event|
          self.attr_has_focus = false
          if (self.attr_show_only_on_focus)
            update
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      print_add_listener(@control, "FOCUS") # $NON-NLS-1$
      @control.add_focus_listener(@focus_listener)
      @paint_listener = # Listener for painting the decoration
      Class.new(PaintListener.class == Class ? PaintListener : Object) do
        extend LocalClass
        include_class_members ControlDecoration
        include PaintListener if PaintListener.class == Module
        
        typesig { [PaintEvent] }
        define_method :paint_control do |event|
          control = event.attr_widget
          rect = get_decoration_rectangle(control)
          if (should_show_decoration)
            event.attr_gc.draw_image(get_image, rect.attr_x, rect.attr_y)
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @mouse_move_listener = # Listener for tracking the end of a hover. Only installed
      # after a hover begins.
      Class.new(MouseMoveListener.class == Class ? MouseMoveListener : Object) do
        extend LocalClass
        include_class_members ControlDecoration
        include MouseMoveListener if MouseMoveListener.class == Module
        
        typesig { [MouseEvent] }
        define_method :mouse_move do |event|
          if (self.attr_show_hover)
            if (!self.attr_decoration_rectangle.contains(event.attr_x, event.attr_y))
              hide_hover
              # No need to listen any longer
              print_remove_listener(event.attr_widget, "MOUSEMOVE") # $NON-NLS-1$
              (event.attr_widget).remove_mouse_move_listener(self.attr_mouse_move_listener)
              self.attr_move_listening_target = nil
            end
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @mouse_track_listener = # Listener for tracking the beginning of a hover. Always installed.
      Class.new(MouseTrackListener.class == Class ? MouseTrackListener : Object) do
        extend LocalClass
        include_class_members ControlDecoration
        include MouseTrackListener if MouseTrackListener.class == Module
        
        typesig { [MouseEvent] }
        define_method :mouse_exit do |event|
          # Just in case we didn't catch it before.
          target = event.attr_widget
          if ((target).equal?(self.attr_move_listening_target))
            print_remove_listener(target, "MOUSEMOVE") # $NON-NLS-1$
            target.remove_mouse_move_listener(self.attr_mouse_move_listener)
            self.attr_move_listening_target = nil
          end
          hide_hover
        end
        
        typesig { [MouseEvent] }
        define_method :mouse_hover do |event|
          if (self.attr_show_hover)
            self.attr_decoration_rectangle = get_decoration_rectangle(event.attr_widget)
            if (self.attr_decoration_rectangle.contains(event.attr_x, event.attr_y))
              show_hover_text(get_description_text)
              target = event.attr_widget
              if ((self.attr_move_listening_target).nil?)
                print_add_listener(target, "MOUSEMOVE") # $NON-NLS-1$
                target.add_mouse_move_listener(self.attr_mouse_move_listener)
                self.attr_move_listening_target = target
              else
                if (!(target).equal?(self.attr_move_listening_target))
                  print_remove_listener(self.attr_move_listening_target, "MOUSEMOVE") # $NON-NLS-1$
                  self.attr_move_listening_target.remove_mouse_move_listener(self.attr_mouse_move_listener)
                  print_add_listener(target, "MOUSEMOVE") # $NON-NLS-1$
                  target.add_mouse_move_listener(self.attr_mouse_move_listener)
                  self.attr_move_listening_target = target
                else
                  # It is already installed on this control.
                end
              end
            end
          end
        end
        
        typesig { [MouseEvent] }
        define_method :mouse_enter do |event|
          # Nothing to do until a hover occurs.
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @composite_listener = Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members ControlDecoration
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |event|
          # Don't forward events if decoration is not showing
          if (!self.attr_visible)
            return
          end
          # Notify listeners if any are registered.
          case (event.attr_type)
          when SWT::MouseDown
            if (!self.attr_selection_listeners.is_empty)
              notify_selection_listeners(event)
            end
          when SWT::MouseDoubleClick
            if (!self.attr_selection_listeners.is_empty)
              notify_selection_listeners(event)
            end
          when SWT::MenuDetect
            if (!self.attr_menu_detect_listeners.is_empty)
              notify_menu_detect_listeners(event)
            end
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      # We do not know which parent in the control hierarchy
      # is providing the decoration space, so hook all the way up, until
      # the shell or the specified parent composite is reached.
      c = @control.get_parent
      while (!(c).nil?)
        install_composite_listeners(c)
        if (!(@composite).nil? && (@composite).equal?(c))
          # We just installed on the specified composite, so stop.
          c = nil
        else
          if (c.is_a?(Shell))
            # We just installed on a shell, so don't go further
            c = nil
          else
            c = c.get_parent
          end
        end
      end
      # force a redraw of the decoration area so our paint listener
      # is notified.
      update
    end
    
    typesig { [Composite] }
    # Install the listeners used to paint and track mouse events on the
    # composite.
    def install_composite_listeners(c)
      if (!c.is_disposed)
        print_add_listener(c, "PAINT") # $NON-NLS-1$
        c.add_paint_listener(@paint_listener)
        print_add_listener(c, "MOUSETRACK") # $NON-NLS-1$
        c.add_mouse_track_listener(@mouse_track_listener)
        print_add_listener(c, "SWT.MenuDetect") # $NON-NLS-1$
        c.add_listener(SWT::MenuDetect, @composite_listener)
        print_add_listener(c, "SWT.MouseDown") # $NON-NLS-1$
        c.add_listener(SWT::MouseDown, @composite_listener)
        print_add_listener(c, "SWT.MouseDoubleClick") # $NON-NLS-1$
        c.add_listener(SWT::MouseDoubleClick, @composite_listener)
      end
    end
    
    typesig { [Composite] }
    # Remove the listeners used to paint and track mouse events on the
    # composite.
    def remove_composite_listeners(c)
      if (!c.is_disposed)
        print_remove_listener(c, "PAINT") # $NON-NLS-1$
        c.remove_paint_listener(@paint_listener)
        print_remove_listener(c, "MOUSETRACK") # $NON-NLS-1$
        c.remove_mouse_track_listener(@mouse_track_listener)
        print_remove_listener(c, "SWT.MenuDetect") # $NON-NLS-1$
        c.remove_listener(SWT::MenuDetect, @composite_listener)
        print_remove_listener(c, "SWT.MouseDown") # $NON-NLS-1$
        c.remove_listener(SWT::MouseDown, @composite_listener)
        print_remove_listener(c, "SWT.MouseDoubleClick") # $NON-NLS-1$
        c.remove_listener(SWT::MouseDoubleClick, @composite_listener)
      end
    end
    
    typesig { [Event] }
    def notify_selection_listeners(event)
      if (!(event.attr_widget.is_a?(Control)))
        return
      end
      if (get_decoration_rectangle(event.attr_widget).contains(event.attr_x, event.attr_y))
        client_event = SelectionEvent.new(event)
        client_event.attr_data = self
        if (!(get_image).nil?)
          client_event.attr_height = get_image.get_bounds.attr_height
          client_event.attr_width = get_image.get_bounds.attr_width
        end
        listeners = nil
        case (event.attr_type)
        when SWT::MouseDoubleClick
          if ((event.attr_button).equal?(1))
            listeners = @selection_listeners.get_listeners
            i = 0
            while i < listeners.attr_length
              (listeners[i]).widget_default_selected(client_event)
              i += 1
            end
          end
        when SWT::MouseDown
          if ((event.attr_button).equal?(1))
            listeners = @selection_listeners.get_listeners
            i = 0
            while i < listeners.attr_length
              (listeners[i]).widget_selected(client_event)
              i += 1
            end
          end
        end
      end
    end
    
    typesig { [Event] }
    def notify_menu_detect_listeners(event)
      if (get_decoration_rectangle(nil).contains(event.attr_x, event.attr_y))
        client_event = MenuDetectEvent.new(event)
        client_event.attr_data = self
        listeners = @menu_detect_listeners.get_listeners
        i = 0
        while i < listeners.attr_length
          (listeners[i]).menu_detected(client_event)
          i += 1
        end
      end
    end
    
    typesig { [String] }
    # Show the specified text using the same hover dialog as is used to show
    # decorator descriptions. When {@link #setShowHover(boolean)} has been set
    # to <code>true</code>, a decoration's description text will be shown in
    # an info hover over the field's control whenever the mouse hovers over the
    # decoration. This method can be used to show a decoration's description
    # text at other times (such as when the control receives focus), or to show
    # other text associated with the field. The hover will not be shown if the
    # decoration is hidden.
    # 
    # @param text
    # the text to be shown in the info hover, or <code>null</code>
    # if no text should be shown.
    def show_hover_text(text)
      if ((@control).nil?)
        return
      end
      show_hover_text(text, @control)
    end
    
    typesig { [] }
    # Hide any hover popups that are currently showing on the control. When
    # {@link #setShowHover(boolean)} has been set to <code>true</code>, a
    # decoration's description text will be shown in an info hover over the
    # field's control as long as the mouse hovers over the decoration, and will
    # be hidden when the mouse exits the decoration. This method can be used to
    # hide a hover, whether it was shown explicitly using
    # {@link #showHoverText(String)}, or was showing because the user was
    # hovering in the decoration.
    # <p>
    # This message has no effect if there is no current hover.
    def hide_hover
      if (!(@hover).nil?)
        @hover.set_visible(false)
      end
    end
    
    typesig { [] }
    # Show the control decoration. This message has no effect if the decoration
    # is already showing. If {@link #setShowOnlyOnFocus(boolean)} is set to
    # <code>true</code>, the decoration will only be shown if the control
    # has focus.
    def show
      if (!@visible)
        @visible = true
        update
      end
    end
    
    typesig { [] }
    # Hide the control decoration and any associated hovers. This message has
    # no effect if the decoration is already hidden.
    def hide
      if (@visible)
        @visible = false
        hide_hover
        update
      end
    end
    
    typesig { [] }
    # Get the description text that may be shown in a hover for this
    # decoration.
    # 
    # @return the text to be shown as a description for the decoration, or
    # <code>null</code> if none has been set.
    def get_description_text
      return @description_text
    end
    
    typesig { [String] }
    # Set the image shown in this control decoration. Update the rendered
    # decoration.
    # 
    # @param text
    # the text to be shown as a description for the decoration, or
    # <code>null</code> if none has been set.
    def set_description_text(text)
      @description_text = text
      update
    end
    
    typesig { [] }
    # Get the image shown in this control decoration.
    # 
    # @return the image to be shown adjacent to the control, or
    # <code>null</code> if one has not been set.
    def get_image
      return @image
    end
    
    typesig { [Image] }
    # Set the image shown in this control decoration. Update the rendered
    # decoration.
    # 
    # @param image
    # the image to be shown adjacent to the control. Should never be
    # <code>null</code>.
    def set_image(image)
      @previous_decoration_rectangle = get_decoration_rectangle(@control.get_shell)
      @image = image
      update
    end
    
    typesig { [] }
    # Get the boolean that controls whether the decoration is shown only when
    # the control has focus. The default value of this setting is
    # <code>false</code>.
    # 
    # @return <code>true</code> if the decoration should only be shown when
    # the control has focus, and <code>false</code> if it should
    # always be shown. Note that if the control is not capable of
    # receiving focus (<code>SWT.NO_FOCUS</code>), then the
    # decoration will never show when this value is <code>true</code>.
    def get_show_only_on_focus
      return @show_only_on_focus
    end
    
    typesig { [::Java::Boolean] }
    # Set the boolean that controls whether the decoration is shown only when
    # the control has focus. The default value of this setting is
    # <code>false</code>.
    # 
    # @param showOnlyOnFocus
    # <code>true</code> if the decoration should only be shown
    # when the control has focus, and <code>false</code> if it
    # should always be shown. Note that if the control is not
    # capable of receiving focus (<code>SWT.NO_FOCUS</code>),
    # then the decoration will never show when this value is
    # <code>true</code>.
    def set_show_only_on_focus(show_only_on_focus)
      @show_only_on_focus = show_only_on_focus
      update
    end
    
    typesig { [] }
    # Get the boolean that controls whether the decoration's description text
    # should be shown in a hover when the user hovers over the decoration. The
    # default value of this setting is <code>true</code>.
    # 
    # @return <code>true</code> if a hover popup containing the decoration's
    # description text should be shown when the user hovers over the
    # decoration, and <code>false</code> if a hover should not be
    # shown.
    def get_show_hover
      return @show_hover
    end
    
    typesig { [::Java::Boolean] }
    # Set the boolean that controls whether the decoration's description text
    # should be shown in a hover when the user hovers over the decoration. The
    # default value of this setting is <code>true</code>.
    # 
    # @param showHover
    # <code>true</code> if a hover popup containing the
    # decoration's description text should be shown when the user
    # hovers over the decoration, and <code>false</code> if a
    # hover should not be shown.
    def set_show_hover(show_hover)
      @show_hover = show_hover
      update
    end
    
    typesig { [] }
    # Get the margin width in pixels that should be used between the decorator
    # and the horizontal edge of the control. The default value of this setting
    # is <code>0</code>.
    # 
    # @return the number of pixels that should be reserved between the
    # horizontal edge of the control and the adjacent edge of the
    # decoration.
    def get_margin_width
      return @margin_width
    end
    
    typesig { [::Java::Int] }
    # Set the margin width in pixels that should be used between the decorator
    # and the horizontal edge of the control. The default value of this setting
    # is <code>0</code>.
    # 
    # @param marginWidth
    # the number of pixels that should be reserved between the
    # horizontal edge of the control and the adjacent edge of the
    # decoration.
    def set_margin_width(margin_width)
      @previous_decoration_rectangle = get_decoration_rectangle(@control.get_shell)
      @margin_width = margin_width
      update
    end
    
    typesig { [] }
    # Something has changed, requiring redraw. Redraw the decoration and update
    # the hover text if appropriate.
    def update
      if ((@control).nil? || @control.is_disposed)
        return
      end
      rect = get_decoration_rectangle(@control.get_shell)
      # If this update is happening due to an image reset, we need to make
      # sure we clear the area from the old image.
      # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=212501
      if (!(@previous_decoration_rectangle).nil?)
        rect = rect.union(@previous_decoration_rectangle)
      end
      # Redraw this rectangle in all children
      @control.get_shell.redraw(rect.attr_x, rect.attr_y, rect.attr_width, rect.attr_height, true)
      @control.get_shell.update
      if (!(@hover).nil? && !(get_description_text).nil?)
        @hover.set_text(get_description_text, get_decoration_rectangle(@control.get_parent), @control)
      end
      @previous_decoration_rectangle = nil
    end
    
    typesig { [String, Control] }
    # Show the specified text in the hover, positioning the hover near the
    # specified control.
    def show_hover_text(text, hover_near)
      # If we aren't to show a hover, don't do anything.
      if (!@show_hover)
        return
      end
      # If we are not visible, don't show the hover.
      if (!@visible)
        return
      end
      # If there is no text, don't do anything.
      if ((text).nil?)
        hide_hover
        return
      end
      # If there is no control, nothing to do
      if ((@control).nil?)
        return
      end
      # Create the hover if it's not showing
      if ((@hover).nil?)
        @hover = Hover.new_local(self, hover_near.get_shell)
      end
      @hover.set_text(text, get_decoration_rectangle(@control.get_parent), @control)
      @hover.set_visible(true)
    end
    
    typesig { [] }
    # Remove any listeners installed on the controls.
    def remove_control_listeners
      if ((@control).nil?)
        return
      end
      print_remove_listener(@control, "FOCUS") # $NON-NLS-1$
      @control.remove_focus_listener(@focus_listener)
      @focus_listener = nil
      print_remove_listener(@control, "DISPOSE") # $NON-NLS-1$
      @control.remove_dispose_listener(@dispose_listener)
      @dispose_listener = nil
      c = @control.get_parent
      while (!(c).nil?)
        remove_composite_listeners(c)
        if (!(@composite).nil? && (@composite).equal?(c))
          # We previously installed listeners only to the specified
          # composite, so stop.
          c = nil
        else
          if (c.is_a?(Shell))
            # We previously installed listeners only up to the first Shell
            # encountered, so stop.
            c = nil
          else
            c = c.get_parent
          end
        end
      end
      @paint_listener = nil
      @mouse_track_listener = nil
      @composite_listener = nil
      # We may have a remaining mouse move listener installed
      if (!(@move_listening_target).nil?)
        print_remove_listener(@move_listening_target, "MOUSEMOVE") # $NON-NLS-1$
        @move_listening_target.remove_mouse_move_listener(@mouse_move_listener)
        @move_listening_target = nil
        @mouse_move_listener = nil
      end
      if (self.attr_debug)
        if (@listener_installs > 0)
          System.out.println("LISTENER LEAK>>>CHECK TRACE ABOVE") # $NON-NLS-1$
        else
          if (@listener_installs < 0)
            System.out.println("REMOVED UNREGISTERED LISTENERS>>>CHECK TRACE ABOVE") # $NON-NLS-1$
          else
            System.out.println("ALL INSTALLED LISTENERS WERE REMOVED.") # $NON-NLS-1$
          end
        end
      end
    end
    
    typesig { [Control] }
    # Return the rectangle in which the decoration should be rendered, in
    # coordinates relative to the specified control. If the specified control
    # is null, return the rectangle in display coordinates.
    # 
    # @param targetControl
    # the control whose coordinates should be used
    # @return the rectangle in which the decoration should be rendered
    def get_decoration_rectangle(target_control)
      if ((get_image).nil? || (@control).nil?)
        return Rectangle.new(0, 0, 0, 0)
      end
      # Compute the bounds first relative to the control's parent.
      image_bounds = get_image.get_bounds
      control_bounds = @control.get_bounds
      x = 0
      y = 0
      # Compute x
      if (((@position & SWT::RIGHT)).equal?(SWT::RIGHT))
        x = control_bounds.attr_x + control_bounds.attr_width + @margin_width
      else
        # default is left
        x = control_bounds.attr_x - image_bounds.attr_width - @margin_width
      end
      # Compute y
      if (((@position & SWT::TOP)).equal?(SWT::TOP))
        y = control_bounds.attr_y
      else
        if (((@position & SWT::BOTTOM)).equal?(SWT::BOTTOM))
          y = control_bounds.attr_y + @control.get_bounds.attr_height - image_bounds.attr_height
        else
          # default is center
          y = control_bounds.attr_y + (@control.get_bounds.attr_height - image_bounds.attr_height) / 2
        end
      end
      # Now convert to coordinates relative to the target control.
      global_point = @control.get_parent.to_display(x, y)
      target_point = nil
      if ((target_control).nil?)
        target_point = global_point
      else
        target_point = target_control.to_control(global_point)
      end
      return Rectangle.new(target_point.attr_x, target_point.attr_y, image_bounds.attr_width, image_bounds.attr_height)
    end
    
    typesig { [] }
    # Return true if the decoration should be shown, false if it should not.
    def should_show_decoration
      if (!@visible)
        return false
      end
      if ((@control).nil? || @control.is_disposed || (get_image).nil?)
        return false
      end
      if (!@control.is_visible)
        return false
      end
      if (@show_only_on_focus)
        return @has_focus
      end
      return true
    end
    
    typesig { [Widget, String] }
    # If in debug mode, print info about adding the specified listener.
    def print_add_listener(widget, listener_type)
      @listener_installs += 1
      if (self.attr_debug)
        System.out.println("Added listener>>>" + listener_type + " to>>>" + RJava.cast_to_string(widget)) # $NON-NLS-1$//$NON-NLS-2$
      end
    end
    
    typesig { [Widget, String] }
    # If in debug mode, print info about adding the specified listener.
    def print_remove_listener(widget, listener_type)
      @listener_installs -= 1
      if (self.attr_debug)
        System.out.println("Removed listener>>>" + listener_type + " from>>>" + RJava.cast_to_string(widget)) # $NON-NLS-1$//$NON-NLS-2$
      end
    end
    
    private
    alias_method :initialize__control_decoration, :initialize
  end
  
end
