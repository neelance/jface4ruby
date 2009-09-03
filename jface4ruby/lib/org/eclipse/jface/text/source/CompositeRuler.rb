require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module CompositeRulerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :EventListener
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :ControlListener
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :HelpListener
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :MouseTrackListener
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Events, :TraverseListener
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Canvas
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Layout
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension5
    }
  end
  
  # Standard implementation of
  # {@link org.eclipse.jface.text.source.IVerticalRuler}.
  # <p>
  # This ruler does not have a a visual representation of its own. The
  # presentation comes from the configurable list of vertical ruler columns. Such
  # columns must implement the
  # {@link org.eclipse.jface.text.source.IVerticalRulerColumn}. interface.</p>
  # <p>
  # Clients may instantiate and configure this class.</p>
  # 
  # @see org.eclipse.jface.text.source.IVerticalRulerColumn
  # @see org.eclipse.jface.text.ITextViewer
  # @since 2.0
  class CompositeRuler 
    include_class_members CompositeRulerImports
    include IVerticalRuler
    include IVerticalRulerExtension
    include IVerticalRulerInfoExtension
    
    class_module.module_eval {
      # Layout of the composite vertical ruler. Arranges the list of columns.
      const_set_lazy(:RulerLayout) { Class.new(Layout) do
        extend LocalClass
        include_class_members CompositeRuler
        
        typesig { [] }
        # Creates the new ruler layout.
        def initialize
          super()
        end
        
        typesig { [class_self::Composite, ::Java::Int, ::Java::Int, ::Java::Boolean] }
        # @see Layout#computeSize(Composite, int, int, boolean)
        def compute_size(composite, w_hint, h_hint, flush_cache)
          children = composite.get_children
          size = self.class::Point.new(0, 0)
          i = 0
          while i < children.attr_length
            s = children[i].compute_size(SWT::DEFAULT, SWT::DEFAULT, flush_cache)
            size.attr_x += s.attr_x
            size.attr_y = Math.max(size.attr_y, s.attr_y)
            i += 1
          end
          size.attr_x += (Math.max(0, children.attr_length - 1) * self.attr_f_gap)
          return size
        end
        
        typesig { [class_self::Composite, ::Java::Boolean] }
        # @see Layout#layout(Composite, boolean)
        def layout(composite, flush_cache)
          cl_area = composite.get_client_area
          ruler_height = cl_area.attr_height
          x = 0
          e = self.attr_f_decorators.iterator
          while (e.has_next)
            column = e.next_
            column_width = column.get_width
            column.get_control.set_bounds(x, 0, column_width, ruler_height)
            x += (column_width + self.attr_f_gap)
          end
        end
        
        private
        alias_method :initialize__ruler_layout, :initialize
      end }
      
      # A canvas that adds listeners to all its children. Used by the implementation of the
      # vertical ruler to propagate listener additions and removals to the ruler's columns.
      const_set_lazy(:CompositeRulerCanvas) { Class.new(Canvas) do
        include_class_members CompositeRuler
        
        class_module.module_eval {
          # Keeps the information for which event type a listener object has been added.
          const_set_lazy(:ListenerInfo) { Class.new do
            include_class_members CompositeRulerCanvas
            
            attr_accessor :f_class
            alias_method :attr_f_class, :f_class
            undef_method :f_class
            alias_method :attr_f_class=, :f_class=
            undef_method :f_class=
            
            attr_accessor :f_listener
            alias_method :attr_f_listener, :f_listener
            undef_method :f_listener
            alias_method :attr_f_listener=, :f_listener=
            undef_method :f_listener=
            
            typesig { [] }
            def initialize
              @f_class = nil
              @f_listener = nil
            end
            
            private
            alias_method :initialize__listener_info, :initialize
          end }
        }
        
        # The list of listeners added to this canvas.
        attr_accessor :f_cached_listeners
        alias_method :attr_f_cached_listeners, :f_cached_listeners
        undef_method :f_cached_listeners
        alias_method :attr_f_cached_listeners=, :f_cached_listeners=
        undef_method :f_cached_listeners=
        
        # Internal listener for opening the context menu.
        # @since 3.0
        attr_accessor :f_menu_detect_listener
        alias_method :attr_f_menu_detect_listener, :f_menu_detect_listener
        undef_method :f_menu_detect_listener
        alias_method :attr_f_menu_detect_listener=, :f_menu_detect_listener=
        undef_method :f_menu_detect_listener=
        
        typesig { [class_self::Composite, ::Java::Int] }
        # Creates a new composite ruler canvas.
        # 
        # @param parent the parent composite
        # @param style the SWT styles
        def initialize(parent, style)
          @f_cached_listeners = nil
          @f_menu_detect_listener = nil
          super(parent, style)
          @f_cached_listeners = self.class::ArrayList.new
          @f_menu_detect_listener = Class.new(self.class::Listener.class == Class ? self.class::Listener : Object) do
            extend LocalClass
            include_class_members CompositeRulerCanvas
            include class_self::Listener if class_self::Listener.class == Module
            
            typesig { [class_self::Event] }
            define_method :handle_event do |event|
              if ((event.attr_type).equal?(SWT::MenuDetect))
                menu = get_menu
                if (!(menu).nil?)
                  menu.set_location(event.attr_x, event.attr_y)
                  menu.set_visible(true)
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
          Canvas.instance_method(:add_dispose_listener).bind(self).call(Class.new(self.class::DisposeListener.class == Class ? self.class::DisposeListener : Object) do
            extend LocalClass
            include_class_members CompositeRulerCanvas
            include class_self::DisposeListener if class_self::DisposeListener.class == Module
            
            typesig { [class_self::DisposeEvent] }
            define_method :widget_disposed do |e|
              if (!(self.attr_f_cached_listeners).nil?)
                self.attr_f_cached_listeners.clear
                self.attr_f_cached_listeners = nil
              end
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        
        typesig { [class_self::Class, class_self::Control, class_self::EventListener] }
        # Adds the given listener object as listener of the given type (<code>clazz</code>) to
        # the given control.
        # 
        # @param clazz the listener type
        # @param control the control to add the listener to
        # @param listener the listener to be added
        def add_listener(clazz, control, listener)
          if ((ControlListener == clazz))
            control.add_control_listener(listener)
            return
          end
          if ((FocusListener == clazz))
            control.add_focus_listener(listener)
            return
          end
          if ((HelpListener == clazz))
            control.add_help_listener(listener)
            return
          end
          if ((KeyListener == clazz))
            control.add_key_listener(listener)
            return
          end
          if ((MouseListener == clazz))
            control.add_mouse_listener(listener)
            return
          end
          if ((MouseMoveListener == clazz))
            control.add_mouse_move_listener(listener)
            return
          end
          if ((MouseTrackListener == clazz))
            control.add_mouse_track_listener(listener)
            return
          end
          if ((PaintListener == clazz))
            control.add_paint_listener(listener)
            return
          end
          if ((TraverseListener == clazz))
            control.add_traverse_listener(listener)
            return
          end
          if ((DisposeListener == clazz))
            control.add_dispose_listener(listener)
            return
          end
        end
        
        typesig { [class_self::Class, class_self::Control, class_self::EventListener] }
        # Removes the given listener object as listener of the given type (<code>clazz</code>) from
        # the given control.
        # 
        # @param clazz the listener type
        # @param control the control to remove the listener from
        # @param listener the listener to be removed
        def remove_listener(clazz, control, listener)
          if ((ControlListener == clazz))
            control.remove_control_listener(listener)
            return
          end
          if ((FocusListener == clazz))
            control.remove_focus_listener(listener)
            return
          end
          if ((HelpListener == clazz))
            control.remove_help_listener(listener)
            return
          end
          if ((KeyListener == clazz))
            control.remove_key_listener(listener)
            return
          end
          if ((MouseListener == clazz))
            control.remove_mouse_listener(listener)
            return
          end
          if ((MouseMoveListener == clazz))
            control.remove_mouse_move_listener(listener)
            return
          end
          if ((MouseTrackListener == clazz))
            control.remove_mouse_track_listener(listener)
            return
          end
          if ((PaintListener == clazz))
            control.remove_paint_listener(listener)
            return
          end
          if ((TraverseListener == clazz))
            control.remove_traverse_listener(listener)
            return
          end
          if ((DisposeListener == clazz))
            control.remove_dispose_listener(listener)
            return
          end
        end
        
        typesig { [class_self::Class, class_self::EventListener] }
        # Adds the given listener object to the internal book keeping under
        # the given listener type (<code>clazz</code>).
        # 
        # @param clazz the listener type
        # @param listener the listener object
        def add_listener(clazz, listener)
          children = get_children
          i = 0
          while i < children.attr_length
            if (!(children[i]).nil? && !children[i].is_disposed)
              add_listener(clazz, children[i], listener)
            end
            i += 1
          end
          info = self.class::ListenerInfo.new
          info.attr_f_class = clazz
          info.attr_f_listener = listener
          @f_cached_listeners.add(info)
        end
        
        typesig { [class_self::Class, class_self::EventListener] }
        # Removes the given listener object from the internal book keeping under
        # the given listener type (<code>clazz</code>).
        # 
        # @param clazz the listener type
        # @param listener the listener object
        def remove_listener(clazz, listener)
          # Keep as first statement to ensure checkWidget() is called.
          children = get_children
          length = @f_cached_listeners.size
          i = 0
          while i < length
            info = @f_cached_listeners.get(i)
            if ((listener).equal?(info.attr_f_listener) && (clazz == info.attr_f_class))
              @f_cached_listeners.remove(i)
              break
            end
            i += 1
          end
          i_ = 0
          while i_ < children.attr_length
            if (!(children[i_]).nil? && !children[i_].is_disposed)
              remove_listener(clazz, children[i_], listener)
            end
            i_ += 1
          end
        end
        
        typesig { [class_self::Control] }
        # Tells this canvas that a child has been added.
        # 
        # @param child the child
        def child_added(child)
          if (!(child).nil? && !child.is_disposed)
            length = @f_cached_listeners.size
            i = 0
            while i < length
              info = @f_cached_listeners.get(i)
              add_listener(info.attr_f_class, child, info.attr_f_listener)
              i += 1
            end
            child.add_listener(SWT::MenuDetect, @f_menu_detect_listener)
          end
        end
        
        typesig { [class_self::Control] }
        # Tells this canvas that a child has been removed.
        # 
        # @param child the child
        def child_removed(child)
          if (!(child).nil? && !child.is_disposed)
            length = @f_cached_listeners.size
            i = 0
            while i < length
              info = @f_cached_listeners.get(i)
              remove_listener(info.attr_f_class, child, info.attr_f_listener)
              i += 1
            end
            child.remove_listener(SWT::MenuDetect, @f_menu_detect_listener)
          end
        end
        
        typesig { [class_self::ControlListener] }
        # @see Control#removeControlListener(ControlListener)
        def remove_control_listener(listener)
          remove_listener(ControlListener, listener)
          super(listener)
        end
        
        typesig { [class_self::FocusListener] }
        # @see Control#removeFocusListener(FocusListener)
        def remove_focus_listener(listener)
          remove_listener(FocusListener, listener)
          super(listener)
        end
        
        typesig { [class_self::HelpListener] }
        # @see Control#removeHelpListener(HelpListener)
        def remove_help_listener(listener)
          remove_listener(HelpListener, listener)
          super(listener)
        end
        
        typesig { [class_self::KeyListener] }
        # @see Control#removeKeyListener(KeyListener)
        def remove_key_listener(listener)
          remove_listener(KeyListener, listener)
          super(listener)
        end
        
        typesig { [class_self::MouseListener] }
        # @see Control#removeMouseListener(MouseListener)
        def remove_mouse_listener(listener)
          remove_listener(MouseListener, listener)
          super(listener)
        end
        
        typesig { [class_self::MouseMoveListener] }
        # @see Control#removeMouseMoveListener(MouseMoveListener)
        def remove_mouse_move_listener(listener)
          remove_listener(MouseMoveListener, listener)
          super(listener)
        end
        
        typesig { [class_self::MouseTrackListener] }
        # @see Control#removeMouseTrackListener(MouseTrackListener)
        def remove_mouse_track_listener(listener)
          remove_listener(MouseTrackListener, listener)
          super(listener)
        end
        
        typesig { [class_self::PaintListener] }
        # @see Control#removePaintListener(PaintListener)
        def remove_paint_listener(listener)
          remove_listener(PaintListener, listener)
          super(listener)
        end
        
        typesig { [class_self::TraverseListener] }
        # @see Control#removeTraverseListener(TraverseListener)
        def remove_traverse_listener(listener)
          remove_listener(TraverseListener, listener)
          super(listener)
        end
        
        typesig { [class_self::DisposeListener] }
        # @see Widget#removeDisposeListener(DisposeListener)
        def remove_dispose_listener(listener)
          remove_listener(DisposeListener, listener)
          super(listener)
        end
        
        typesig { [class_self::ControlListener] }
        # @seeControl#addControlListener(ControlListener)
        def add_control_listener(listener)
          super(listener)
          add_listener(ControlListener, listener)
        end
        
        typesig { [class_self::FocusListener] }
        # @see Control#addFocusListener(FocusListener)
        def add_focus_listener(listener)
          super(listener)
          add_listener(FocusListener, listener)
        end
        
        typesig { [class_self::HelpListener] }
        # @see Control#addHelpListener(HelpListener)
        def add_help_listener(listener)
          super(listener)
          add_listener(HelpListener, listener)
        end
        
        typesig { [class_self::KeyListener] }
        # @see Control#addKeyListener(KeyListener)
        def add_key_listener(listener)
          super(listener)
          add_listener(KeyListener, listener)
        end
        
        typesig { [class_self::MouseListener] }
        # @see Control#addMouseListener(MouseListener)
        def add_mouse_listener(listener)
          super(listener)
          add_listener(MouseListener, listener)
        end
        
        typesig { [class_self::MouseMoveListener] }
        # @see Control#addMouseMoveListener(MouseMoveListener)
        def add_mouse_move_listener(listener)
          super(listener)
          add_listener(MouseMoveListener, listener)
        end
        
        typesig { [class_self::MouseTrackListener] }
        # @see Control#addMouseTrackListener(MouseTrackListener)
        def add_mouse_track_listener(listener)
          super(listener)
          add_listener(MouseTrackListener, listener)
        end
        
        typesig { [class_self::PaintListener] }
        # @seeControl#addPaintListener(PaintListener)
        def add_paint_listener(listener)
          super(listener)
          add_listener(PaintListener, listener)
        end
        
        typesig { [class_self::TraverseListener] }
        # @see Control#addTraverseListener(TraverseListener)
        def add_traverse_listener(listener)
          super(listener)
          add_listener(TraverseListener, listener)
        end
        
        typesig { [class_self::DisposeListener] }
        # @see Widget#addDisposeListener(DisposeListener)
        def add_dispose_listener(listener)
          super(listener)
          add_listener(DisposeListener, listener)
        end
        
        private
        alias_method :initialize__composite_ruler_canvas, :initialize
      end }
    }
    
    # The ruler's viewer
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    # The ruler's canvas to which to add the ruler columns
    attr_accessor :f_composite
    alias_method :attr_f_composite, :f_composite
    undef_method :f_composite
    alias_method :attr_f_composite=, :f_composite=
    undef_method :f_composite=
    
    # The ruler's annotation model
    attr_accessor :f_model
    alias_method :attr_f_model, :f_model
    undef_method :f_model
    alias_method :attr_f_model=, :f_model=
    undef_method :f_model=
    
    # The list of columns
    attr_accessor :f_decorators
    alias_method :attr_f_decorators, :f_decorators
    undef_method :f_decorators
    alias_method :attr_f_decorators=, :f_decorators=
    undef_method :f_decorators=
    
    # The cached location of the last mouse button activity
    attr_accessor :f_location
    alias_method :attr_f_location, :f_location
    undef_method :f_location
    alias_method :attr_f_location=, :f_location=
    undef_method :f_location=
    
    # The cached line of the list mouse button activity
    attr_accessor :f_last_mouse_button_activity_line
    alias_method :attr_f_last_mouse_button_activity_line, :f_last_mouse_button_activity_line
    undef_method :f_last_mouse_button_activity_line
    alias_method :attr_f_last_mouse_button_activity_line=, :f_last_mouse_button_activity_line=
    undef_method :f_last_mouse_button_activity_line=
    
    # The gap between the individual columns of this composite ruler
    attr_accessor :f_gap
    alias_method :attr_f_gap, :f_gap
    undef_method :f_gap
    alias_method :attr_f_gap=, :f_gap=
    undef_method :f_gap=
    
    # The set of annotation listeners.
    # @since 3.0
    attr_accessor :f_annotation_listeners
    alias_method :attr_f_annotation_listeners, :f_annotation_listeners
    undef_method :f_annotation_listeners
    alias_method :attr_f_annotation_listeners=, :f_annotation_listeners=
    undef_method :f_annotation_listeners=
    
    typesig { [] }
    # Constructs a new composite vertical ruler.
    def initialize
      initialize__composite_ruler(0)
    end
    
    typesig { [::Java::Int] }
    # Constructs a new composite ruler with the given gap between its columns.
    # 
    # @param gap the gap
    def initialize(gap)
      @f_text_viewer = nil
      @f_composite = nil
      @f_model = nil
      @f_decorators = ArrayList.new(2)
      @f_location = Point.new(-1, -1)
      @f_last_mouse_button_activity_line = -1
      @f_gap = 0
      @f_annotation_listeners = HashSet.new
      @f_gap = gap
    end
    
    typesig { [::Java::Int, IVerticalRulerColumn] }
    # Inserts the given column at the specified slot to this composite ruler.
    # Columns are counted from left to right.
    # 
    # @param index the index
    # @param rulerColumn the decorator to be inserted
    def add_decorator(index, ruler_column)
      ruler_column.set_model(get_model)
      if (index > @f_decorators.size)
        @f_decorators.add(ruler_column)
      else
        @f_decorators.add(index, ruler_column)
      end
      if (!(@f_composite).nil? && !@f_composite.is_disposed)
        ruler_column.create_control(self, @f_composite)
        @f_composite.child_added(ruler_column.get_control)
        layout_text_viewer
      end
    end
    
    typesig { [::Java::Int] }
    # Removes the decorator in the specified slot from this composite ruler.
    # 
    # @param index the index
    def remove_decorator(index)
      ruler_column = @f_decorators.get(index)
      remove_decorator(ruler_column)
    end
    
    typesig { [IVerticalRulerColumn] }
    # Removes the given decorator from the composite ruler.
    # 
    # @param rulerColumn the ruler column to be removed
    # @since 3.0
    def remove_decorator(ruler_column)
      @f_decorators.remove(ruler_column)
      if (!(ruler_column).nil?)
        cc = ruler_column.get_control
        if (!(cc).nil? && !cc.is_disposed)
          @f_composite.child_removed(cc)
          cc.dispose
        end
      end
      layout_text_viewer
    end
    
    typesig { [] }
    # Layouts the text viewer. This also causes this ruler to get
    # be layouted.
    def layout_text_viewer
      parent = @f_text_viewer.get_text_widget
      if (@f_text_viewer.is_a?(ITextViewerExtension))
        extension = @f_text_viewer
        parent = extension.get_control
      end
      if (parent.is_a?(Composite) && !parent.is_disposed)
        (parent).layout(true)
      end
    end
    
    typesig { [] }
    # @see IVerticalRuler#getControl()
    def get_control
      return @f_composite
    end
    
    typesig { [Composite, ITextViewer] }
    # @see IVerticalRuler#createControl(Composite, ITextViewer)
    def create_control(parent, text_viewer)
      @f_text_viewer = text_viewer
      @f_composite = CompositeRulerCanvas.new(parent, SWT::NONE)
      @f_composite.set_layout(RulerLayout.new_local(self))
      iter = @f_decorators.iterator
      while (iter.has_next)
        column = iter.next_
        column.create_control(self, @f_composite)
        @f_composite.child_added(column.get_control)
      end
      return @f_composite
    end
    
    typesig { [IAnnotationModel] }
    # @see IVerticalRuler#setModel(IAnnotationModel)
    def set_model(model)
      @f_model = model
      e = @f_decorators.iterator
      while (e.has_next)
        column = e.next_
        column.set_model(model)
      end
    end
    
    typesig { [] }
    # @see IVerticalRuler#getModel()
    def get_model
      return @f_model
    end
    
    typesig { [] }
    # @see IVerticalRuler#update()
    def update
      if (!(@f_composite).nil? && !@f_composite.is_disposed)
        d = @f_composite.get_display
        if (!(d).nil?)
          d.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            extend LocalClass
            include_class_members CompositeRuler
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              immediate_update
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
      end
    end
    
    typesig { [] }
    # Immediately redraws the entire ruler (without asynchronous posting).
    # 
    # @since 3.2
    def immediate_update
      e = @f_decorators.iterator
      while (e.has_next)
        column = e.next_
        column.redraw
      end
    end
    
    typesig { [Font] }
    # @see IVerticalRulerExtension#setFont(Font)
    def set_font(font)
      e = @f_decorators.iterator
      while (e.has_next)
        column = e.next_
        column.set_font(font)
      end
    end
    
    typesig { [] }
    # @see IVerticalRulerInfo#getWidth()
    def get_width
      width = 0
      e = @f_decorators.iterator
      while (e.has_next)
        column = e.next_
        width += (column.get_width + @f_gap)
      end
      return Math.max(0, width - @f_gap)
    end
    
    typesig { [] }
    # @see IVerticalRulerInfo#getLineOfLastMouseButtonActivity()
    def get_line_of_last_mouse_button_activity
      if ((@f_last_mouse_button_activity_line).equal?(-1))
        @f_last_mouse_button_activity_line = to_document_line_number(@f_location.attr_y)
      else
        if ((@f_text_viewer.get_document).nil? || @f_last_mouse_button_activity_line >= @f_text_viewer.get_document.get_number_of_lines)
          @f_last_mouse_button_activity_line = -1
        end
      end
      return @f_last_mouse_button_activity_line
    end
    
    typesig { [::Java::Int] }
    # @see IVerticalRulerInfo#toDocumentLineNumber(int)
    def to_document_line_number(y_coordinate)
      if ((@f_text_viewer).nil? || (y_coordinate).equal?(-1))
        return -1
      end
      text = @f_text_viewer.get_text_widget
      line = text.get_line_index(y_coordinate)
      if ((line).equal?(text.get_line_count - 1))
        # check whether y_coordinate exceeds last line
        if (y_coordinate > text.get_line_pixel(line + 1))
          return -1
        end
      end
      return widget_line2model_line(@f_text_viewer, line)
    end
    
    class_module.module_eval {
      typesig { [ITextViewer, ::Java::Int] }
      # Returns the line in the given viewer's document that correspond to the given
      # line of the viewer's widget.
      # 
      # @param viewer the viewer
      # @param widgetLine the widget line
      # @return the corresponding line the viewer's document
      # @since 2.1
      def widget_line2model_line(viewer, widget_line)
        if (viewer.is_a?(ITextViewerExtension5))
          extension = viewer
          return extension.widget_line2model_line(widget_line)
        end
        begin
          r = viewer.get_visible_region
          d = viewer.get_document
          return widget_line += d.get_line_of_offset(r.get_offset)
        rescue BadLocationException => x
        end
        return widget_line
      end
    }
    
    typesig { [] }
    # Returns this ruler's text viewer.
    # 
    # @return this ruler's text viewer
    def get_text_viewer
      return @f_text_viewer
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see IVerticalRulerExtension#setLocationOfLastMouseButtonActivity(int, int)
    def set_location_of_last_mouse_button_activity(x, y)
      @f_location.attr_x = x
      @f_location.attr_y = y
      @f_last_mouse_button_activity_line = -1
    end
    
    typesig { [] }
    # Returns an iterator over the <code>IVerticalRulerColumns</code> that make up this
    # composite column.
    # 
    # @return an iterator over the contained columns.
    # @since 3.0
    def get_decorator_iterator
      Assert.is_not_null(@f_decorators, "fDecorators must be initialized") # $NON-NLS-1$
      return @f_decorators.iterator
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#getHover()
    # @since 3.0
    def get_hover
      return nil
    end
    
    typesig { [IVerticalRulerListener] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#addVerticalRulerListener(org.eclipse.jface.text.source.IVerticalRulerListener)
    # @since 3.0
    def add_vertical_ruler_listener(listener)
      @f_annotation_listeners.add(listener)
    end
    
    typesig { [IVerticalRulerListener] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#removeVerticalRulerListener(org.eclipse.jface.text.source.IVerticalRulerListener)
    # @since 3.0
    def remove_vertical_ruler_listener(listener)
      @f_annotation_listeners.remove(listener)
    end
    
    typesig { [VerticalRulerEvent] }
    # Fires the annotation selected event to all registered vertical ruler
    # listeners.
    # TODO use robust iterators
    # 
    # @param event the event to fire
    # @since 3.0
    def fire_annotation_selected(event)
      # forward to listeners
      it = @f_annotation_listeners.iterator
      while it.has_next
        listener = it.next_
        listener.annotation_selected(event)
      end
    end
    
    typesig { [VerticalRulerEvent] }
    # Fires the annotation default selected event to all registered vertical
    # ruler listeners.
    # TODO use robust iterators
    # 
    # @param event the event to fire
    # @since 3.0
    def fire_annotation_default_selected(event)
      # forward to listeners
      it = @f_annotation_listeners.iterator
      while it.has_next
        listener = it.next_
        listener.annotation_default_selected(event)
      end
    end
    
    typesig { [VerticalRulerEvent, Menu] }
    # Informs all registered vertical ruler listeners that the content menu on a selected annotation\
    # is about to be shown.
    # TODO use robust iterators
    # 
    # @param event the event to fire
    # @param menu the menu that is about to be shown
    # @since 3.0
    def fire_annotation_context_menu_about_to_show(event, menu)
      # forward to listeners
      it = @f_annotation_listeners.iterator
      while it.has_next
        listener = it.next_
        listener.annotation_context_menu_about_to_show(event, menu)
      end
    end
    
    typesig { [] }
    # Relayouts the receiver.
    # 
    # @since 3.3
    def relayout
      layout_text_viewer
    end
    
    private
    alias_method :initialize__composite_ruler, :initialize
  end
  
end
