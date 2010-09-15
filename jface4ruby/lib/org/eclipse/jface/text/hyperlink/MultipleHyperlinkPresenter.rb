require "rjava"

# Copyright (c) 2008, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Hyperlink
  module MultipleHyperlinkPresenterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Hyperlink
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :KeyAdapter
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseAdapter
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :ShellAdapter
      include_const ::Org::Eclipse::Swt::Events, :ShellEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Layout, :GridLayout
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :Table
      include_const ::Org::Eclipse::Swt::Widgets, :TableItem
      include_const ::Org::Eclipse::Jface::Preference, :IPreferenceStore
      include_const ::Org::Eclipse::Jface::Util, :Geometry
      include_const ::Org::Eclipse::Jface::Viewers, :ColumnLabelProvider
      include_const ::Org::Eclipse::Jface::Viewers, :IStructuredContentProvider
      include_const ::Org::Eclipse::Jface::Viewers, :TableViewer
      include_const ::Org::Eclipse::Jface::Viewers, :Viewer
      include_const ::Org::Eclipse::Jface::Text, :AbstractInformationControl
      include_const ::Org::Eclipse::Jface::Text, :AbstractInformationControlManager
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension2
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension3
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextHover
      include_const ::Org::Eclipse::Jface::Text, :ITextHoverExtension
      include_const ::Org::Eclipse::Jface::Text, :ITextHoverExtension2
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenKeeper
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenKeeperExtension
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenOwner
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenOwnerExtension
      include_const ::Org::Eclipse::Jface::Text, :JFaceTextUtil
      include_const ::Org::Eclipse::Jface::Text, :Region
    }
  end
  
  # A hyperlink presenter capable of showing multiple hyperlinks in a hover.
  # 
  # @since 3.4
  class MultipleHyperlinkPresenter < MultipleHyperlinkPresenterImports.const_get :DefaultHyperlinkPresenter
    include_class_members MultipleHyperlinkPresenterImports
    
    class_module.module_eval {
      const_set_lazy(:IS_WIN32) { ("win32" == SWT.get_platform) }
      const_attr_reader  :IS_WIN32
      
      # $NON-NLS-1$
      # 
      # An information control capable of showing a list of hyperlinks. The hyperlinks can be opened.
      const_set_lazy(:LinkListInformationControl) { Class.new(AbstractInformationControl) do
        include_class_members MultipleHyperlinkPresenter
        overload_protected {
          include IInformationControlExtension2
        }
        
        class_module.module_eval {
          const_set_lazy(:LinkContentProvider) { Class.new do
            include_class_members LinkListInformationControl
            include class_self::IStructuredContentProvider
            
            typesig { [Object] }
            # @see org.eclipse.jface.viewers.IStructuredContentProvider#getElements(java.lang.Object)
            def get_elements(input_element)
              return input_element
            end
            
            typesig { [] }
            # @see org.eclipse.jface.viewers.IContentProvider#dispose()
            def dispose
            end
            
            typesig { [class_self::Viewer, Object, Object] }
            # @see org.eclipse.jface.viewers.IContentProvider#inputChanged(org.eclipse.jface.viewers.Viewer, java.lang.Object, java.lang.Object)
            def input_changed(viewer, old_input, new_input)
            end
            
            typesig { [] }
            def initialize
            end
            
            private
            alias_method :initialize__link_content_provider, :initialize
          end }
          
          const_set_lazy(:LinkLabelProvider) { Class.new(class_self::ColumnLabelProvider) do
            include_class_members LinkListInformationControl
            
            typesig { [Object] }
            # @see org.eclipse.jface.viewers.ColumnLabelProvider#getText(java.lang.Object)
            def get_text(element)
              link = element
              text = link.get_hyperlink_text
              if (!(text).nil?)
                return text
              end
              return HyperlinkMessages.get_string("LinkListInformationControl.unknownLink") # $NON-NLS-1$
            end
            
            typesig { [] }
            def initialize
              super()
            end
            
            private
            alias_method :initialize__link_label_provider, :initialize
          end }
        }
        
        attr_accessor :f_manager
        alias_method :attr_f_manager, :f_manager
        undef_method :f_manager
        alias_method :attr_f_manager=, :f_manager=
        undef_method :f_manager=
        
        attr_accessor :f_input
        alias_method :attr_f_input, :f_input
        undef_method :f_input
        alias_method :attr_f_input=, :f_input=
        undef_method :f_input=
        
        attr_accessor :f_parent
        alias_method :attr_f_parent, :f_parent
        undef_method :f_parent
        alias_method :attr_f_parent=, :f_parent=
        undef_method :f_parent=
        
        attr_accessor :f_table
        alias_method :attr_f_table, :f_table
        undef_method :f_table
        alias_method :attr_f_table=, :f_table=
        undef_method :f_table=
        
        attr_accessor :f_foreground_color
        alias_method :attr_f_foreground_color, :f_foreground_color
        undef_method :f_foreground_color
        alias_method :attr_f_foreground_color=, :f_foreground_color=
        undef_method :f_foreground_color=
        
        attr_accessor :f_background_color
        alias_method :attr_f_background_color, :f_background_color
        undef_method :f_background_color
        alias_method :attr_f_background_color=, :f_background_color=
        undef_method :f_background_color=
        
        typesig { [class_self::Shell, class_self::MultipleHyperlinkHoverManager, class_self::Color, class_self::Color] }
        # Creates a link list information control with the given shell as parent.
        # 
        # @param parentShell the parent shell
        # @param manager the hover manager
        # @param foregroundColor the foreground color, must not be disposed
        # @param backgroundColor the background color, must not be disposed
        def initialize(parent_shell, manager, foreground_color, background_color)
          @f_manager = nil
          @f_input = nil
          @f_parent = nil
          @f_table = nil
          @f_foreground_color = nil
          @f_background_color = nil
          super(parent_shell, false)
          @f_manager = manager
          @f_foreground_color = foreground_color
          @f_background_color = background_color
          create
        end
        
        typesig { [String] }
        # @see org.eclipse.jface.text.IInformationControl#setInformation(java.lang.String)
        def set_information(information)
          # replaced by IInformationControlExtension2#setInput(java.lang.Object)
        end
        
        typesig { [Object] }
        # @see org.eclipse.jface.text.IInformationControlExtension2#setInput(java.lang.Object)
        def set_input(input)
          @f_input = input
          deferred_create_content(@f_parent)
        end
        
        typesig { [class_self::Composite] }
        # @see org.eclipse.jface.text.AbstractInformationControl#createContent(org.eclipse.swt.widgets.Composite)
        def create_content(parent)
          @f_parent = parent
          if (IS_WIN32)
            layout = self.class::GridLayout.new
            layout.attr_margin_width = 0
            layout.attr_margin_right = 4
            @f_parent.set_layout(layout)
          end
          @f_parent.set_foreground(@f_foreground_color)
          @f_parent.set_background(@f_background_color)
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.AbstractInformationControl#computeSizeHint()
        def compute_size_hint
          prefered_size = get_shell.compute_size(SWT::DEFAULT, SWT::DEFAULT, true)
          constraints = get_size_constraints
          if ((constraints).nil?)
            return prefered_size
          end
          if ((@f_table.get_vertical_bar).nil? || (@f_table.get_horizontal_bar).nil?)
            return Geometry.min(constraints, prefered_size)
          end
          scroll_bar_width = @f_table.get_vertical_bar.get_size.attr_x
          scroll_bar_height = @f_table.get_horizontal_bar.get_size.attr_y
          width = 0
          if (prefered_size.attr_y - scroll_bar_height <= constraints.attr_y)
            width = prefered_size.attr_x - scroll_bar_width
            @f_table.get_vertical_bar.set_visible(false)
          else
            width = Math.min(prefered_size.attr_x, constraints.attr_x)
          end
          height = 0
          if (prefered_size.attr_x - scroll_bar_width <= constraints.attr_x)
            height = prefered_size.attr_y - scroll_bar_height
            @f_table.get_horizontal_bar.set_visible(false)
          else
            height = Math.min(prefered_size.attr_y, constraints.attr_y)
          end
          return self.class::Point.new(width, height)
        end
        
        typesig { [class_self::Composite] }
        def deferred_create_content(parent)
          @f_table = self.class::Table.new(parent, SWT::SINGLE | SWT::FULL_SELECTION)
          @f_table.set_lines_visible(false)
          @f_table.set_header_visible(false)
          @f_table.set_foreground(@f_foreground_color)
          @f_table.set_background(@f_background_color)
          if (IS_WIN32)
            data = self.class::GridData.new(SWT::BEGINNING, SWT::BEGINNING, true, true)
            @f_table.set_layout_data(data)
          end
          viewer = self.class::TableViewer.new(@f_table)
          viewer.set_content_provider(self.class::LinkContentProvider.new)
          viewer.set_label_provider(self.class::LinkLabelProvider.new)
          viewer.set_input(@f_input)
          @f_table.set_selection(0)
          register_table_listeners
          get_shell.add_shell_listener(Class.new(self.class::ShellAdapter.class == Class ? self.class::ShellAdapter : Object) do
            local_class_in LinkListInformationControl
            include_class_members LinkListInformationControl
            include class_self::ShellAdapter if class_self::ShellAdapter.class == Module
            
            typesig { [class_self::ShellEvent] }
            # @see org.eclipse.swt.events.ShellAdapter#shellActivated(org.eclipse.swt.events.ShellEvent)
            define_method :shell_activated do |e|
              if ((viewer.get_table.get_selection_count).equal?(0))
                viewer.get_table.set_selection(0)
              end
              viewer.get_table.set_focus
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        
        typesig { [] }
        def register_table_listeners
          @f_table.add_mouse_move_listener(Class.new(self.class::MouseMoveListener.class == Class ? self.class::MouseMoveListener : Object) do
            local_class_in LinkListInformationControl
            include_class_members LinkListInformationControl
            include class_self::MouseMoveListener if class_self::MouseMoveListener.class == Module
            
            attr_accessor :f_last_item
            alias_method :attr_f_last_item, :f_last_item
            undef_method :f_last_item
            alias_method :attr_f_last_item=, :f_last_item=
            undef_method :f_last_item=
            
            typesig { [class_self::MouseEvent] }
            define_method :mouse_move do |e|
              if ((self.attr_f_table == e.get_source))
                o = self.attr_f_table.get_item(self.class::Point.new(e.attr_x, e.attr_y))
                if (o.is_a?(self.class::TableItem))
                  item = o
                  if (!(o == @f_last_item))
                    @f_last_item = o
                    self.attr_f_table.set_selection(Array.typed(self.class::TableItem).new([@f_last_item]))
                  else
                    if (e.attr_y < self.attr_f_table.get_item_height / 4)
                      # Scroll up
                      index = self.attr_f_table.index_of(item)
                      if (index > 0)
                        @f_last_item = self.attr_f_table.get_item(index - 1)
                        self.attr_f_table.set_selection(Array.typed(self.class::TableItem).new([@f_last_item]))
                      end
                    else
                      if (e.attr_y > self.attr_f_table.get_bounds.attr_height - self.attr_f_table.get_item_height / 4)
                        # Scroll down
                        index = self.attr_f_table.index_of(item)
                        if (index < self.attr_f_table.get_item_count - 1)
                          @f_last_item = self.attr_f_table.get_item(index + 1)
                          self.attr_f_table.set_selection(Array.typed(self.class::TableItem).new([@f_last_item]))
                        end
                      end
                    end
                  end
                end
              end
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              @f_last_item = nil
              super(*args)
              @f_last_item = nil
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          @f_table.add_selection_listener(Class.new(self.class::SelectionAdapter.class == Class ? self.class::SelectionAdapter : Object) do
            local_class_in LinkListInformationControl
            include_class_members LinkListInformationControl
            include class_self::SelectionAdapter if class_self::SelectionAdapter.class == Module
            
            typesig { [class_self::SelectionEvent] }
            define_method :widget_selected do |e|
              open_selected_link
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          @f_table.add_mouse_listener(Class.new(self.class::MouseAdapter.class == Class ? self.class::MouseAdapter : Object) do
            local_class_in LinkListInformationControl
            include_class_members LinkListInformationControl
            include class_self::MouseAdapter if class_self::MouseAdapter.class == Module
            
            typesig { [class_self::MouseEvent] }
            define_method :mouse_up do |e|
              if (self.attr_f_table.get_selection_count < 1)
                return
              end
              if (!(e.attr_button).equal?(1))
                return
              end
              if ((self.attr_f_table == e.get_source))
                o = self.attr_f_table.get_item(self.class::Point.new(e.attr_x, e.attr_y))
                selection = self.attr_f_table.get_selection[0]
                if ((selection == o))
                  open_selected_link
                end
              end
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          @f_table.add_key_listener(Class.new(self.class::KeyAdapter.class == Class ? self.class::KeyAdapter : Object) do
            local_class_in LinkListInformationControl
            include_class_members LinkListInformationControl
            include class_self::KeyAdapter if class_self::KeyAdapter.class == Module
            
            typesig { [class_self::KeyEvent] }
            define_method :key_pressed do |e|
              if ((e.attr_key_code).equal?(0xd))
                # return
                open_selected_link
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
        
        typesig { [] }
        # @see org.eclipse.jface.text.IInformationControlExtension#hasContents()
        def has_contents
          return true
        end
        
        typesig { [] }
        # Opens the currently selected link.
        def open_selected_link
          selection = @f_table.get_selection[0]
          link = selection.get_data
          @f_manager.hide_information_control
          @f_manager.set_caret
          link.open
        end
        
        private
        alias_method :initialize__link_list_information_control, :initialize
      end }
      
      const_set_lazy(:MultipleHyperlinkHover) { Class.new do
        local_class_in MultipleHyperlinkPresenter
        include_class_members MultipleHyperlinkPresenter
        include ITextHover
        include ITextHoverExtension
        include ITextHoverExtension2
        
        typesig { [class_self::ITextViewer, class_self::IRegion] }
        # @see org.eclipse.jface.text.ITextHover#getHoverInfo(org.eclipse.jface.text.ITextViewer, org.eclipse.jface.text.IRegion)
        # @deprecated As of 3.4, replaced by
        # {@link ITextHoverExtension2#getHoverInfo2(ITextViewer, IRegion)}
        def get_hover_info(text_viewer, hover_region)
          return nil
        end
        
        typesig { [class_self::ITextViewer, ::Java::Int] }
        # @see org.eclipse.jface.text.ITextHover#getHoverRegion(org.eclipse.jface.text.ITextViewer, int)
        def get_hover_region(text_viewer, offset)
          return self.attr_f_subject_region
        end
        
        typesig { [class_self::ITextViewer, class_self::IRegion] }
        # @see org.eclipse.jface.text.ITextHoverExtension2#getHoverInfo2(org.eclipse.jface.text.ITextViewer, org.eclipse.jface.text.IRegion)
        def get_hover_info2(text_viewer, hover_region)
          return self.attr_f_hyperlinks
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.ITextHoverExtension#getHoverControlCreator()
        def get_hover_control_creator
          return Class.new(self.class::IInformationControlCreator.class == Class ? self.class::IInformationControlCreator : Object) do
            local_class_in MultipleHyperlinkHover
            include_class_members MultipleHyperlinkHover
            include class_self::IInformationControlCreator if class_self::IInformationControlCreator.class == Module
            
            typesig { [class_self::Shell] }
            define_method :create_information_control do |parent|
              foreground_color = self.attr_f_text_viewer.get_text_widget.get_foreground
              background_color = self.attr_f_text_viewer.get_text_widget.get_background
              return self.class::LinkListInformationControl.new(parent, self.attr_f_manager, foreground_color, background_color)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__multiple_hyperlink_hover, :initialize
      end }
      
      const_set_lazy(:MultipleHyperlinkHoverManager) { Class.new(AbstractInformationControlManager) do
        include_class_members MultipleHyperlinkPresenter
        overload_protected {
          include IWidgetTokenKeeper
          include IWidgetTokenKeeperExtension
        }
        
        class_module.module_eval {
          const_set_lazy(:Closer) { Class.new do
            local_class_in MultipleHyperlinkHoverManager
            include_class_members MultipleHyperlinkHoverManager
            include class_self::IInformationControlCloser
            include class_self::Listener
            include class_self::KeyListener
            include class_self::MouseListener
            
            attr_accessor :f_subject_control
            alias_method :attr_f_subject_control, :f_subject_control
            undef_method :f_subject_control
            alias_method :attr_f_subject_control=, :f_subject_control=
            undef_method :f_subject_control=
            
            attr_accessor :f_display
            alias_method :attr_f_display, :f_display
            undef_method :f_display
            alias_method :attr_f_display=, :f_display=
            undef_method :f_display=
            
            attr_accessor :f_control
            alias_method :attr_f_control, :f_control
            undef_method :f_control
            alias_method :attr_f_control=, :f_control=
            undef_method :f_control=
            
            attr_accessor :f_subject_area
            alias_method :attr_f_subject_area, :f_subject_area
            undef_method :f_subject_area
            alias_method :attr_f_subject_area=, :f_subject_area=
            undef_method :f_subject_area=
            
            typesig { [class_self::IInformationControl] }
            # @see org.eclipse.jface.text.AbstractInformationControlManager.IInformationControlCloser#setInformationControl(org.eclipse.jface.text.IInformationControl)
            def set_information_control(control)
              @f_control = control
            end
            
            typesig { [class_self::Control] }
            # @see org.eclipse.jface.text.AbstractInformationControlManager.IInformationControlCloser#setSubjectControl(org.eclipse.swt.widgets.Control)
            def set_subject_control(subject)
              @f_subject_control = subject
            end
            
            typesig { [class_self::Rectangle] }
            # @see org.eclipse.jface.text.AbstractInformationControlManager.IInformationControlCloser#start(org.eclipse.swt.graphics.Rectangle)
            def start(subject_area)
              @f_subject_area = subject_area
              @f_display = @f_subject_control.get_display
              if (!@f_display.is_disposed)
                @f_display.add_filter(SWT::FocusOut, self)
                @f_display.add_filter(SWT::MouseMove, self)
                self.attr_f_text_viewer.get_text_widget.add_key_listener(self)
                self.attr_f_text_viewer.get_text_widget.add_mouse_listener(self)
              end
            end
            
            typesig { [] }
            # @see org.eclipse.jface.text.AbstractInformationControlManager.IInformationControlCloser#stop()
            def stop
              if (!(@f_display).nil? && !@f_display.is_disposed)
                @f_display.remove_filter(SWT::FocusOut, self)
                @f_display.remove_filter(SWT::MouseMove, self)
                self.attr_f_text_viewer.get_text_widget.remove_key_listener(self)
                self.attr_f_text_viewer.get_text_widget.remove_mouse_listener(self)
              end
              @f_subject_area = nil
            end
            
            typesig { [class_self::Event] }
            # @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
            def handle_event(event)
              case (event.attr_type)
              when SWT::FocusOut
                if (!@f_control.is_focus_control)
                  dispose_information_control
                end
              when SWT::MouseMove
                handle_mouse_move(event)
              end
            end
            
            typesig { [class_self::Event] }
            # Handle mouse movement events.
            # 
            # @param event the event
            def handle_mouse_move(event)
              if (!(event.attr_widget.is_a?(self.class::Control)))
                return
              end
              if (@f_control.is_focus_control)
                return
              end
              event_control = event.attr_widget
              # transform coordinates to subject control:
              mouse_loc = event.attr_display.map(event_control, @f_subject_control, event.attr_x, event.attr_y)
              if (@f_subject_area.contains(mouse_loc))
                return
              end
              if (in_keep_up_zone(mouse_loc.attr_x, mouse_loc.attr_y, (@f_control).get_bounds))
                return
              end
              hide_information_control
            end
            
            typesig { [::Java::Int, ::Java::Int, class_self::Rectangle] }
            # Tests whether a given mouse location is within the keep-up zone.
            # The hover should not be hidden as long as the mouse stays inside this zone.
            # 
            # @param x the x coordinate, relative to the <em>subject control</em>
            # @param y the y coordinate, relative to the <em>subject control</em>
            # @param controlBounds the bounds of the current control
            # 
            # @return <code>true</code> iff the mouse event occurred in the keep-up zone
            def in_keep_up_zone(x, y, control_bounds)
              # +-----------+
              # |subjectArea|
              # +-----------+
              # |also keepUp|
              # ++-----------+-------+
              # | totalBounds        |
              # +--------------------+
              if (@f_subject_area.contains(x, y))
                return true
              end
              i_control_bounds = @f_subject_control.get_display.map(nil, @f_subject_control, control_bounds)
              total_bounds = Geometry.copy(i_control_bounds)
              if (total_bounds.contains(x, y))
                return true
              end
              keep_up_y = @f_subject_area.attr_y + @f_subject_area.attr_height
              also_keep_up = self.class::Rectangle.new(@f_subject_area.attr_x, keep_up_y, @f_subject_area.attr_width, total_bounds.attr_y - keep_up_y)
              return also_keep_up.contains(x, y)
            end
            
            typesig { [class_self::KeyEvent] }
            # @see org.eclipse.swt.events.KeyListener#keyPressed(org.eclipse.swt.events.KeyEvent)
            def key_pressed(e)
            end
            
            typesig { [class_self::KeyEvent] }
            # @see org.eclipse.swt.events.KeyListener#keyReleased(org.eclipse.swt.events.KeyEvent)
            def key_released(e)
              hide_information_control
            end
            
            typesig { [class_self::MouseEvent] }
            # @see org.eclipse.swt.events.MouseListener#mouseDoubleClick(org.eclipse.swt.events.MouseEvent)
            # @since 3.5
            def mouse_double_click(e)
            end
            
            typesig { [class_self::MouseEvent] }
            # @see org.eclipse.swt.events.MouseListener#mouseDown(org.eclipse.swt.events.MouseEvent)
            # @since 3.5
            def mouse_down(e)
            end
            
            typesig { [class_self::MouseEvent] }
            # @see org.eclipse.swt.events.MouseListener#mouseUp(org.eclipse.swt.events.MouseEvent)
            # @since 3.5
            def mouse_up(e)
              hide_information_control
            end
            
            typesig { [] }
            def initialize
              @f_subject_control = nil
              @f_display = nil
              @f_control = nil
              @f_subject_area = nil
            end
            
            private
            alias_method :initialize__closer, :initialize
          end }
          
          # Priority of the hover managed by this manager.
          # Default value: One higher then for the hovers
          # managed by TextViewerHoverManager.
          const_set_lazy(:WIDGET_TOKEN_PRIORITY) { 1 }
          const_attr_reader  :WIDGET_TOKEN_PRIORITY
        }
        
        attr_accessor :f_hover
        alias_method :attr_f_hover, :f_hover
        undef_method :f_hover
        alias_method :attr_f_hover=, :f_hover=
        undef_method :f_hover=
        
        attr_accessor :f_text_viewer
        alias_method :attr_f_text_viewer, :f_text_viewer
        undef_method :f_text_viewer
        alias_method :attr_f_text_viewer=, :f_text_viewer=
        undef_method :f_text_viewer=
        
        attr_accessor :f_hyperlink_presenter
        alias_method :attr_f_hyperlink_presenter, :f_hyperlink_presenter
        undef_method :f_hyperlink_presenter
        alias_method :attr_f_hyperlink_presenter=, :f_hyperlink_presenter=
        undef_method :f_hyperlink_presenter=
        
        attr_accessor :f_closer
        alias_method :attr_f_closer, :f_closer
        undef_method :f_closer
        alias_method :attr_f_closer=, :f_closer=
        undef_method :f_closer=
        
        attr_accessor :f_is_control_visible
        alias_method :attr_f_is_control_visible, :f_is_control_visible
        undef_method :f_is_control_visible
        alias_method :attr_f_is_control_visible=, :f_is_control_visible=
        undef_method :f_is_control_visible=
        
        typesig { [class_self::MultipleHyperlinkHover, class_self::ITextViewer, class_self::MultipleHyperlinkPresenter] }
        # Create a new MultipleHyperlinkHoverManager. The MHHM can show and hide
        # the given MultipleHyperlinkHover inside the given ITextViewer.
        # 
        # @param hover the hover to manage
        # @param viewer the viewer to show the hover in
        # @param hyperlinkPresenter the hyperlink presenter using this manager to present hyperlinks
        def initialize(hover, viewer, hyperlink_presenter)
          @f_hover = nil
          @f_text_viewer = nil
          @f_hyperlink_presenter = nil
          @f_closer = nil
          @f_is_control_visible = false
          super(hover.get_hover_control_creator)
          @f_hover = hover
          @f_text_viewer = viewer
          @f_hyperlink_presenter = hyperlink_presenter
          @f_closer = self.class::Closer.new_local(self)
          set_closer(@f_closer)
          @f_is_control_visible = false
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.AbstractInformationControlManager#computeInformation()
        def compute_information
          region = @f_hover.get_hover_region(@f_text_viewer, -1)
          if ((region).nil?)
            set_information(nil, nil)
            return
          end
          area = JFaceTextUtil.compute_area(region, @f_text_viewer)
          if ((area).nil? || area.is_empty)
            set_information(nil, nil)
            return
          end
          information = @f_hover.get_hover_info2(@f_text_viewer, region)
          set_custom_information_control_creator(@f_hover.get_hover_control_creator)
          set_information(information, area)
        end
        
        typesig { [class_self::Rectangle, class_self::Point] }
        # @see org.eclipse.jface.text.AbstractInformationControlManager#computeInformationControlLocation(org.eclipse.swt.graphics.Rectangle, org.eclipse.swt.graphics.Point)
        def compute_information_control_location(subject_area, control_size)
          result = super(subject_area, control_size)
          cursor_location = @f_text_viewer.get_text_widget.get_display.get_cursor_location
          if (cursor_location.attr_x <= result.attr_x + control_size.attr_x)
            return result
          end
          result.attr_x = cursor_location.attr_x + 20 - control_size.attr_x
          return result
        end
        
        typesig { [class_self::Rectangle] }
        # @see org.eclipse.jface.text.AbstractInformationControlManager#showInformationControl(org.eclipse.swt.graphics.Rectangle)
        def show_information_control(subject_area)
          if (@f_text_viewer.is_a?(self.class::IWidgetTokenOwnerExtension))
            if ((@f_text_viewer).request_widget_token(self, self.class::WIDGET_TOKEN_PRIORITY))
              super(subject_area)
            end
          else
            if (@f_text_viewer.is_a?(self.class::IWidgetTokenOwner))
              if ((@f_text_viewer).request_widget_token(self))
                super(subject_area)
              end
            else
              super(subject_area)
            end
          end
          @f_is_control_visible = true
        end
        
        typesig { [] }
        # Sets the caret where hyperlinking got initiated.
        # 
        # @since 3.5
        def set_caret
          @f_hyperlink_presenter.set_caret
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.AbstractInformationControlManager#hideInformationControl()
        def hide_information_control
          super
          if (@f_text_viewer.is_a?(self.class::IWidgetTokenOwner))
            (@f_text_viewer).release_widget_token(self)
          end
          @f_is_control_visible = false
          @f_hyperlink_presenter.hide_hyperlinks
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.AbstractInformationControlManager#disposeInformationControl()
        def dispose_information_control
          super
          if (@f_text_viewer.is_a?(self.class::IWidgetTokenOwner))
            (@f_text_viewer).release_widget_token(self)
          end
          @f_is_control_visible = false
          @f_hyperlink_presenter.hide_hyperlinks
        end
        
        typesig { [class_self::IWidgetTokenOwner] }
        # @see org.eclipse.jface.text.IWidgetTokenKeeper#requestWidgetToken(org.eclipse.jface.text.IWidgetTokenOwner)
        def request_widget_token(owner)
          hide_information_control
          return true
        end
        
        typesig { [class_self::IWidgetTokenOwner, ::Java::Int] }
        # @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#requestWidgetToken(org.eclipse.jface.text.IWidgetTokenOwner, int)
        def request_widget_token(owner, priority)
          if (priority < self.class::WIDGET_TOKEN_PRIORITY)
            return false
          end
          hide_information_control
          return true
        end
        
        typesig { [class_self::IWidgetTokenOwner] }
        # @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#setFocus(org.eclipse.jface.text.IWidgetTokenOwner)
        def set_focus(owner)
          return false
        end
        
        typesig { [] }
        # Returns <code>true</code> if the information control managed by
        # this manager is visible, <code>false</code> otherwise.
        # 
        # @return <code>true</code> if information control is visible
        def is_information_control_visible
          return @f_is_control_visible
        end
        
        private
        alias_method :initialize__multiple_hyperlink_hover_manager, :initialize
      end }
    }
    
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    attr_accessor :f_hyperlinks
    alias_method :attr_f_hyperlinks, :f_hyperlinks
    undef_method :f_hyperlinks
    alias_method :attr_f_hyperlinks=, :f_hyperlinks=
    undef_method :f_hyperlinks=
    
    attr_accessor :f_subject_region
    alias_method :attr_f_subject_region, :f_subject_region
    undef_method :f_subject_region
    alias_method :attr_f_subject_region=, :f_subject_region=
    undef_method :f_subject_region=
    
    attr_accessor :f_manager
    alias_method :attr_f_manager, :f_manager
    undef_method :f_manager
    alias_method :attr_f_manager=, :f_manager=
    undef_method :f_manager=
    
    # The offset in the text viewer where hyperlinking got initiated.
    # @since 3.5
    attr_accessor :f_cursor_offset
    alias_method :attr_f_cursor_offset, :f_cursor_offset
    undef_method :f_cursor_offset
    alias_method :attr_f_cursor_offset=, :f_cursor_offset=
    undef_method :f_cursor_offset=
    
    typesig { [IPreferenceStore] }
    # Creates a new multiple hyperlink presenter which uses
    # {@link #HYPERLINK_COLOR} to read the color from the given preference store.
    # 
    # @param store the preference store
    def initialize(store)
      @f_text_viewer = nil
      @f_hyperlinks = nil
      @f_subject_region = nil
      @f_manager = nil
      @f_cursor_offset = 0
      super(store)
    end
    
    typesig { [RGB] }
    # Creates a new multiple hyperlink presenter.
    # 
    # @param color the hyperlink color, to be disposed by the caller
    def initialize(color)
      @f_text_viewer = nil
      @f_hyperlinks = nil
      @f_subject_region = nil
      @f_manager = nil
      @f_cursor_offset = 0
      super(color)
    end
    
    typesig { [ITextViewer] }
    # @see org.eclipse.jface.text.hyperlink.DefaultHyperlinkPresenter#install(org.eclipse.jface.text.ITextViewer)
    def install(viewer)
      super(viewer)
      @f_text_viewer = viewer
      @f_manager = MultipleHyperlinkHoverManager.new(MultipleHyperlinkHover.new_local(self), @f_text_viewer, self)
      @f_manager.install(viewer.get_text_widget)
      @f_manager.set_size_constraints(100, 12, false, true)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.hyperlink.DefaultHyperlinkPresenter#uninstall()
    def uninstall
      super
      if (!(@f_text_viewer).nil?)
        @f_manager.dispose
        @f_text_viewer = nil
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.hyperlink.DefaultHyperlinkPresenter#canShowMultipleHyperlinks()
    def can_show_multiple_hyperlinks
      return true
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.hyperlink.DefaultHyperlinkPresenter#canHideHyperlinks()
    def can_hide_hyperlinks
      return !@f_manager.is_information_control_visible
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.hyperlink.DefaultHyperlinkPresenter#hideHyperlinks()
    def hide_hyperlinks
      super
      @f_hyperlinks = nil
    end
    
    typesig { [Array.typed(IHyperlink)] }
    # @see org.eclipse.jface.text.hyperlink.DefaultHyperlinkPresenter#showHyperlinks(org.eclipse.jface.text.hyperlink.IHyperlink[])
    def show_hyperlinks(hyperlinks)
      super(Array.typed(IHyperlink).new([hyperlinks[0]]))
      @f_subject_region = nil
      @f_hyperlinks = hyperlinks
      if ((hyperlinks.attr_length).equal?(1))
        return
      end
      start = hyperlinks[0].get_hyperlink_region.get_offset
      end_ = start + hyperlinks[0].get_hyperlink_region.get_length
      i = 1
      while i < hyperlinks.attr_length
        hstart = hyperlinks[i].get_hyperlink_region.get_offset
        hend = hstart + hyperlinks[i].get_hyperlink_region.get_length
        start = Math.min(start, hstart)
        end_ = Math.max(end_, hend)
        i += 1
      end
      @f_subject_region = Region.new(start, end_ - start)
      @f_cursor_offset = JFaceTextUtil.get_offset_for_cursor_location(@f_text_viewer)
      @f_manager.show_information
    end
    
    typesig { [] }
    # Sets the caret where hyperlinking got initiated.
    # 
    # @since 3.5
    def set_caret
      selected_range = @f_text_viewer.get_selected_range
      if (!(@f_cursor_offset).equal?(-1) && !(@f_subject_region.get_offset <= selected_range.attr_x && selected_range.attr_x + selected_range.attr_y <= @f_subject_region.get_offset + @f_subject_region.get_length))
        @f_text_viewer.set_selected_range(@f_cursor_offset, 0)
      end
    end
    
    private
    alias_method :initialize__multiple_hyperlink_presenter, :initialize
  end
  
end
