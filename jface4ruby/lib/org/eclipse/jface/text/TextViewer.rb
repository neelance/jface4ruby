require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Eicher (Avaloq Evolution AG) - block selection mode
module Org::Eclipse::Jface::Text
  module TextViewerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util::Regex, :PatternSyntaxException
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :LineBackgroundEvent
      include_const ::Org::Eclipse::Swt::Custom, :LineBackgroundListener
      include_const ::Org::Eclipse::Swt::Custom, :MovementEvent
      include_const ::Org::Eclipse::Swt::Custom, :MovementListener
      include_const ::Org::Eclipse::Swt::Custom, :ST
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Custom, :StyledTextPrintOptions
      include_const ::Org::Eclipse::Swt::Custom, :VerifyKeyListener
      include_const ::Org::Eclipse::Swt::Dnd, :Clipboard
      include_const ::Org::Eclipse::Swt::Dnd, :DND
      include_const ::Org::Eclipse::Swt::Dnd, :TextTransfer
      include_const ::Org::Eclipse::Swt::Events, :ControlEvent
      include_const ::Org::Eclipse::Swt::Events, :ControlListener
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseAdapter
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Events, :TraverseEvent
      include_const ::Org::Eclipse::Swt::Events, :TraverseListener
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
      include_const ::Org::Eclipse::Swt::Events, :VerifyListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Printing, :PrintDialog
      include_const ::Org::Eclipse::Swt::Printing, :Printer
      include_const ::Org::Eclipse::Swt::Printing, :PrinterData
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :ScrollBar
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Text::Edits, :TextEdit
      include_const ::Org::Eclipse::Jface::Dialogs, :MessageDialog
      include_const ::Org::Eclipse::Jface::Internal::Text, :NonDeletingPositionUpdater
      include_const ::Org::Eclipse::Jface::Internal::Text, :SelectionProcessor
      include_const ::Org::Eclipse::Jface::Internal::Text, :StickyHoverManager
      include_const ::Org::Eclipse::Jface::Util, :Geometry
      include_const ::Org::Eclipse::Jface::Viewers, :IPostSelectionProvider
      include_const ::Org::Eclipse::Jface::Viewers, :ISelection
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionChangedListener
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionProvider
      include_const ::Org::Eclipse::Jface::Viewers, :SelectionChangedEvent
      include_const ::Org::Eclipse::Jface::Viewers, :Viewer
      include_const ::Org::Eclipse::Jface::Text::Hyperlink, :HyperlinkManager
      include_const ::Org::Eclipse::Jface::Text::Hyperlink, :IHyperlinkDetector
      include_const ::Org::Eclipse::Jface::Text::Hyperlink, :IHyperlinkDetectorExtension
      include_const ::Org::Eclipse::Jface::Text::Hyperlink, :IHyperlinkPresenter
      include_const ::Org::Eclipse::Jface::Text::Hyperlink::HyperlinkManager, :DETECTION_STRATEGY
      include_const ::Org::Eclipse::Jface::Text::Projection, :ChildDocument
      include_const ::Org::Eclipse::Jface::Text::Projection, :ChildDocumentManager
    }
  end
  
  # SWT based implementation of {@link ITextViewer} and its extension interfaces.
  # Once the viewer and its SWT control have been created the viewer can only
  # indirectly be disposed by disposing its SWT control.
  # <p>
  # Clients are supposed to instantiate a text viewer and subsequently to
  # communicate with it exclusively using the
  # {@link org.eclipse.jface.text.ITextViewer} interface or any of the
  # implemented extension interfaces.
  # <p>
  # A text viewer serves as text operation target. It only partially supports the
  # external control of the enable state of its text operations. A text viewer is
  # also a widget token owner. Anything that wants to display an overlay window
  # on top of a text viewer should implement the
  # {@link org.eclipse.jface.text.IWidgetTokenKeeper} interface and participate
  # in the widget token negotiation between the text viewer and all its potential
  # widget token keepers.
  # <p>
  # This class is not intended to be subclassed outside the JFace Text component.</p>
  # @noextend This class is not intended to be subclassed by clients.
  class TextViewer < TextViewerImports.const_get :Viewer
    include_class_members TextViewerImports
    overload_protected {
      include ITextViewer
      include ITextViewerExtension
      include ITextViewerExtension2
      include ITextViewerExtension4
      include ITextViewerExtension6
      include ITextViewerExtension7
      include ITextViewerExtension8
      include IEditingSupportRegistry
      include ITextOperationTarget
      include ITextOperationTargetExtension
      include IWidgetTokenOwner
      include IWidgetTokenOwnerExtension
      include IPostSelectionProvider
    }
    
    class_module.module_eval {
      # Internal flag to indicate the debug state.
      const_set_lazy(:TRACE_ERRORS) { false }
      const_attr_reader  :TRACE_ERRORS
      
      # Internal flag to indicate the debug state.
      const_set_lazy(:TRACE_DOUBLE_CLICK) { false }
      const_attr_reader  :TRACE_DOUBLE_CLICK
      
      # FIXME always use setRedraw to avoid flickering due to scrolling
      # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=158746
      const_set_lazy(:REDRAW_BUG_158746) { true }
      const_attr_reader  :REDRAW_BUG_158746
      
      # Width constraint for text hovers (in characters).
      # @since 3.4
      const_set_lazy(:TEXT_HOVER_WIDTH_CHARS) { 100 }
      const_attr_reader  :TEXT_HOVER_WIDTH_CHARS
      
      # used to be 60 (text font)
      # 
      # Height constraint for text hovers (in characters).
      # @since 3.4
      const_set_lazy(:TEXT_HOVER_HEIGHT_CHARS) { 12 }
      const_attr_reader  :TEXT_HOVER_HEIGHT_CHARS
      
      # used to be 10 (text font)
      # 
      # Represents a replace command that brings the text viewer's text widget
      # back in synchronization with text viewer's document after the document
      # has been changed.
      const_set_lazy(:WidgetCommand) { Class.new do
        local_class_in TextViewer
        include_class_members TextViewer
        
        # The document event encapsulated by this command.
        attr_accessor :event
        alias_method :attr_event, :event
        undef_method :event
        alias_method :attr_event=, :event=
        undef_method :event=
        
        # The start of the event.
        attr_accessor :start
        alias_method :attr_start, :start
        undef_method :start
        alias_method :attr_start=, :start=
        undef_method :start=
        
        # The length of the event.
        attr_accessor :length
        alias_method :attr_length, :length
        undef_method :length
        alias_method :attr_length=, :length=
        undef_method :length=
        
        # The inserted and replaced text segments of <code>event</code>.
        attr_accessor :text
        alias_method :attr_text, :text
        undef_method :text
        alias_method :attr_text=, :text=
        undef_method :text=
        
        # The replaced text segments of <code>event</code>.
        attr_accessor :preserved_text
        alias_method :attr_preserved_text, :preserved_text
        undef_method :preserved_text
        alias_method :attr_preserved_text=, :preserved_text=
        undef_method :preserved_text=
        
        typesig { [class_self::DocumentEvent] }
        # Translates a document event into the presentation coordinates of this text viewer.
        # 
        # @param e the event to be translated
        def set_event(e)
          @event = e
          @start = e.get_offset
          @length = e.get_length
          @text = RJava.cast_to_string(e.get_text)
          if (!(@length).equal?(0))
            begin
              if (e.is_a?(self.class::SlaveDocumentEvent))
                slave = e
                master = slave.get_master_event
                if (!(master).nil?)
                  @preserved_text = RJava.cast_to_string(master.get_document.get(master.get_offset, master.get_length))
                end
              else
                @preserved_text = RJava.cast_to_string(e.get_document.get(e.get_offset, e.get_length))
              end
            rescue self.class::BadLocationException => x
              @preserved_text = RJava.cast_to_string(nil)
              if (TRACE_ERRORS)
                System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.WidgetCommand.setEvent"))
              end # $NON-NLS-1$
            end
          else
            @preserved_text = RJava.cast_to_string(nil)
          end
        end
        
        typesig { [] }
        def initialize
          @event = nil
          @start = 0
          @length = 0
          @text = nil
          @preserved_text = nil
        end
        
        private
        alias_method :initialize__widget_command, :initialize
      end }
      
      # Connects a text double click strategy to this viewer's text widget.
      # Calls the double click strategies when the mouse has
      # been clicked inside the text editor.
      const_set_lazy(:TextDoubleClickStrategyConnector) { Class.new(MouseAdapter) do
        local_class_in TextViewer
        include_class_members TextViewer
        overload_protected {
          include MovementListener
        }
        
        # Internal flag to remember the last double-click selection.
        attr_accessor :f_double_click_selection
        alias_method :attr_f_double_click_selection, :f_double_click_selection
        undef_method :f_double_click_selection
        alias_method :attr_f_double_click_selection=, :f_double_click_selection=
        undef_method :f_double_click_selection=
        
        typesig { [class_self::MouseEvent] }
        # @see org.eclipse.swt.events.MouseAdapter#mouseUp(org.eclipse.swt.events.MouseEvent)
        # @since 3.2
        def mouse_up(e)
          @f_double_click_selection = nil
        end
        
        typesig { [class_self::MovementEvent] }
        # @see org.eclipse.swt.custom.MovementListener#getNextOffset(org.eclipse.swt.custom.MovementEvent)
        # @since 3.3
        def get_next_offset(event)
          if (!(event.attr_movement).equal?(SWT::MOVEMENT_WORD_END))
            return
          end
          if (TRACE_DOUBLE_CLICK)
            System.out.println("\n+++") # $NON-NLS-1$
            print(event)
          end
          if (!(@f_double_click_selection).nil?)
            if (@f_double_click_selection.attr_x <= event.attr_offset && event.attr_offset <= @f_double_click_selection.attr_y)
              event.attr_new_offset = @f_double_click_selection.attr_y
            end
          end
        end
        
        typesig { [class_self::MovementEvent] }
        # @see org.eclipse.swt.custom.MovementListener#getPreviousOffset(org.eclipse.swt.custom.MovementEvent)
        # @since 3.3
        def get_previous_offset(event)
          if (!(event.attr_movement).equal?(SWT::MOVEMENT_WORD_START))
            return
          end
          if (TRACE_DOUBLE_CLICK)
            System.out.println("\n---") # $NON-NLS-1$
            print(event)
          end
          if ((@f_double_click_selection).nil?)
            s = select_content_type_plugin(get_selected_range.attr_x, self.attr_f_double_click_strategies)
            if (!(s).nil?)
              text_widget = get_text_widget
              s.double_clicked(@local_class_parent)
              @f_double_click_selection = text_widget.get_selection
              event.attr_new_offset = @f_double_click_selection.attr_x
              if (TRACE_DOUBLE_CLICK)
                System.out.println("- setting selection: x= " + RJava.cast_to_string(@f_double_click_selection.attr_x) + ", y= " + RJava.cast_to_string(@f_double_click_selection.attr_y))
              end # $NON-NLS-1$ //$NON-NLS-2$
            end
          else
            if (@f_double_click_selection.attr_x <= event.attr_offset && event.attr_offset <= @f_double_click_selection.attr_y)
              event.attr_new_offset = @f_double_click_selection.attr_x
            end
          end
        end
        
        typesig { [] }
        def initialize
          @f_double_click_selection = nil
          super()
        end
        
        private
        alias_method :initialize__text_double_click_strategy_connector, :initialize
      end }
    }
    
    typesig { [MovementEvent] }
    # Print trace info about <code>MovementEvent</code>.
    # 
    # @param e the event to print
    # @since 3.3
    def print(e)
      System.out.println("line offset: " + RJava.cast_to_string(e.attr_line_offset)) # $NON-NLS-1$
      System.out.println("line: " + RJava.cast_to_string(e.attr_line_text)) # $NON-NLS-1$
      System.out.println("type: " + RJava.cast_to_string(e.attr_movement)) # $NON-NLS-1$
      System.out.println("offset: " + RJava.cast_to_string(e.attr_offset)) # $NON-NLS-1$
      System.out.println("newOffset: " + RJava.cast_to_string(e.attr_new_offset)) # $NON-NLS-1$
    end
    
    class_module.module_eval {
      # Monitors the area of the viewer's document that is visible in the viewer.
      # If the area might have changed, it informs the text viewer about this
      # potential change and its origin. The origin is internally used for optimization
      # purposes.
      const_set_lazy(:ViewportGuard) { Class.new(MouseAdapter) do
        local_class_in TextViewer
        include_class_members TextViewer
        overload_protected {
          include ControlListener
          include KeyListener
          include SelectionListener
        }
        
        typesig { [class_self::ControlEvent] }
        # @see ControlListener#controlResized(ControlEvent)
        def control_resized(e)
          update_viewport_listeners(RESIZE)
        end
        
        typesig { [class_self::ControlEvent] }
        # @see ControlListener#controlMoved(ControlEvent)
        def control_moved(e)
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyReleased
        def key_released(e)
          update_viewport_listeners(KEY)
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyPressed
        def key_pressed(e)
          update_viewport_listeners(KEY)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseUp
        def mouse_up(e)
          if (!(self.attr_f_text_widget).nil?)
            self.attr_f_text_widget.remove_selection_listener(self)
          end
          update_viewport_listeners(MOUSE_END)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDown
        def mouse_down(e)
          if (!(self.attr_f_text_widget).nil?)
            self.attr_f_text_widget.add_selection_listener(self)
          end
        end
        
        typesig { [class_self::SelectionEvent] }
        # @see SelectionListener#widgetSelected
        def widget_selected(e)
          if ((e.attr_widget).equal?(self.attr_f_scroller))
            update_viewport_listeners(SCROLLER)
          else
            update_viewport_listeners(MOUSE)
          end
        end
        
        typesig { [class_self::SelectionEvent] }
        # @see SelectionListener#widgetDefaultSelected
        def widget_default_selected(e)
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__viewport_guard, :initialize
      end }
      
      # This position updater is used to keep the selection during text shift operations.
      const_set_lazy(:ShiftPositionUpdater) { Class.new(DefaultPositionUpdater) do
        include_class_members TextViewer
        
        typesig { [String] }
        # Creates the position updater for the given category.
        # 
        # @param category the category this updater takes care of
        def initialize(category)
          super(category)
        end
        
        typesig { [] }
        # If an insertion happens at the selection's start offset,
        # the position is extended rather than shifted.
        def adapt_to_insert
          my_start = self.attr_f_position.attr_offset
          my_end = self.attr_f_position.attr_offset + self.attr_f_position.attr_length - 1
          my_end = Math.max(my_start, my_end)
          yours_start = self.attr_f_offset
          yours_end = self.attr_f_offset + self.attr_f_replace_length - 1
          yours_end = Math.max(yours_start, yours_end)
          if (my_end < yours_start)
            return
          end
          if (my_start <= yours_start)
            self.attr_f_position.attr_length += self.attr_f_replace_length
            return
          end
          if (my_start > yours_start)
            self.attr_f_position.attr_offset += self.attr_f_replace_length
          end
        end
        
        private
        alias_method :initialize__shift_position_updater, :initialize
      end }
      
      # Internal document listener on the visible document.
      const_set_lazy(:VisibleDocumentListener) { Class.new do
        local_class_in TextViewer
        include_class_members TextViewer
        include IDocumentListener
        
        typesig { [class_self::DocumentEvent] }
        # @see IDocumentListener#documentAboutToBeChanged
        def document_about_to_be_changed(e)
          if ((e.get_document).equal?(get_visible_document))
            self.attr_f_widget_command.set_event(e)
          end
          handle_visible_document_about_to_be_changed(e)
        end
        
        typesig { [class_self::DocumentEvent] }
        # @see IDocumentListener#documentChanged
        def document_changed(e)
          if ((self.attr_f_widget_command.attr_event).equal?(e))
            update_text_listeners(self.attr_f_widget_command)
          end
          self.attr_f_last_sent_selection_change = nil
          handle_visible_document_changed(e)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__visible_document_listener, :initialize
      end }
      
      # Internal verify listener.
      const_set_lazy(:TextVerifyListener) { Class.new do
        local_class_in TextViewer
        include_class_members TextViewer
        include VerifyListener
        
        # Indicates whether verify events are forwarded or ignored.
        # @since 2.0
        attr_accessor :f_forward
        alias_method :attr_f_forward, :f_forward
        undef_method :f_forward
        alias_method :attr_f_forward=, :f_forward=
        undef_method :f_forward=
        
        typesig { [::Java::Boolean] }
        # Tells the listener to forward received events.
        # 
        # @param forward <code>true</code> if forwarding should be enabled.
        # @since 2.0
        def forward(forward)
          @f_forward = forward
        end
        
        typesig { [class_self::VerifyEvent] }
        # @see VerifyListener#verifyText(VerifyEvent)
        def verify_text(e)
          if (@f_forward)
            handle_verify_event(e)
          end
        end
        
        typesig { [] }
        def initialize
          @f_forward = true
        end
        
        private
        alias_method :initialize__text_verify_listener, :initialize
      end }
      
      # The viewer's manager responsible for registered verify key listeners.
      # Uses batches rather than robust iterators because of performance issues.
      # <p>
      # The implementation is reentrant, i.e. installed listeners may trigger
      # further <code>VerifyKeyEvent</code>s that may cause other listeners to be
      # installed, but not thread safe.
      # </p>
      # @since 2.0
      const_set_lazy(:VerifyKeyListenersManager) { Class.new do
        local_class_in TextViewer
        include_class_members TextViewer
        include VerifyKeyListener
        
        class_module.module_eval {
          # Represents a batched addListener/removeListener command.
          const_set_lazy(:Batch) { Class.new do
            local_class_in VerifyKeyListenersManager
            include_class_members VerifyKeyListenersManager
            
            # The index at which to insert the listener.
            attr_accessor :index
            alias_method :attr_index, :index
            undef_method :index
            alias_method :attr_index=, :index=
            undef_method :index=
            
            # The listener to be inserted.
            attr_accessor :listener
            alias_method :attr_listener, :listener
            undef_method :listener
            alias_method :attr_listener=, :listener=
            undef_method :listener=
            
            typesig { [class_self::VerifyKeyListener, ::Java::Int] }
            # Creates a new batch containing the given listener for the given index.
            # 
            # @param l the listener to be added
            # @param i the index at which to insert the listener
            def initialize(l, i)
              @index = 0
              @listener = nil
              @listener = l
              @index = i
            end
            
            private
            alias_method :initialize__batch, :initialize
          end }
        }
        
        # List of registered verify key listeners.
        attr_accessor :f_listeners
        alias_method :attr_f_listeners, :f_listeners
        undef_method :f_listeners
        alias_method :attr_f_listeners=, :f_listeners=
        undef_method :f_listeners=
        
        # List of pending batches.
        attr_accessor :f_batched
        alias_method :attr_f_batched, :f_batched
        undef_method :f_batched
        alias_method :attr_f_batched=, :f_batched=
        undef_method :f_batched=
        
        # The reentrance count.
        attr_accessor :f_reentrance_count
        alias_method :attr_f_reentrance_count, :f_reentrance_count
        undef_method :f_reentrance_count
        alias_method :attr_f_reentrance_count=, :f_reentrance_count=
        undef_method :f_reentrance_count=
        
        typesig { [class_self::VerifyEvent] }
        # @see VerifyKeyListener#verifyKey(VerifyEvent)
        def verify_key(event)
          if (@f_listeners.is_empty)
            return
          end
          begin
            @f_reentrance_count += 1
            iterator_ = @f_listeners.iterator
            while (iterator_.has_next && event.attr_doit)
              listener = iterator_.next_
              listener.verify_key(event) # we might trigger reentrant calls on GTK
            end
          ensure
            @f_reentrance_count -= 1
          end
          if ((@f_reentrance_count).equal?(0))
            process_batched_requests
          end
        end
        
        typesig { [] }
        # Processes the pending batched requests.
        def process_batched_requests
          if (!@f_batched.is_empty)
            e = @f_batched.iterator
            while (e.has_next)
              batch = e.next_
              insert_listener(batch.attr_listener, batch.attr_index)
            end
            @f_batched.clear
          end
        end
        
        typesig { [] }
        # Returns the number of registered verify key listeners.
        # 
        # @return the number of registered verify key listeners
        def number_of_listeners
          return @f_listeners.size
        end
        
        typesig { [class_self::VerifyKeyListener, ::Java::Int] }
        # Inserts the given listener at the given index or moves it
        # to that index.
        # 
        # @param listener the listener to be inserted
        # @param index the index of the listener or -1 for remove
        def insert_listener(listener, index)
          if ((index).equal?(-1))
            remove_listener(listener)
          else
            if (!(listener).nil?)
              if (@f_reentrance_count > 0)
                @f_batched.add(self.class::Batch.new_local(self, listener, index))
              else
                idx = -1
                # find index based on identity
                size_ = @f_listeners.size
                i = 0
                while i < size_
                  if ((listener).equal?(@f_listeners.get(i)))
                    idx = i
                    break
                  end
                  i += 1
                end
                # move or add it
                if (!(idx).equal?(index))
                  if (!(idx).equal?(-1))
                    @f_listeners.remove(idx)
                  end
                  if (index > @f_listeners.size)
                    @f_listeners.add(listener)
                  else
                    @f_listeners.add(index, listener)
                  end
                end
                if ((size_).equal?(0))
                  # checking old size, i.e. current size == size + 1
                  install
                end
              end
            end
          end
        end
        
        typesig { [class_self::VerifyKeyListener] }
        # Removes the given listener.
        # 
        # @param listener the listener to be removed
        def remove_listener(listener)
          if ((listener).nil?)
            return
          end
          if (@f_reentrance_count > 0)
            @f_batched.add(self.class::Batch.new_local(self, listener, -1))
          else
            size_ = @f_listeners.size
            i = 0
            while i < size_
              if ((listener).equal?(@f_listeners.get(i)))
                @f_listeners.remove(i)
                if ((size_).equal?(1))
                  # checking old size, i.e. current size == size - 1
                  uninstall
                end
                return
              end
              i += 1
            end
          end
        end
        
        typesig { [] }
        # Installs this manager.
        def install
          text_widget = get_text_widget
          if (!(text_widget).nil? && !text_widget.is_disposed)
            text_widget.add_verify_key_listener(self)
          end
        end
        
        typesig { [] }
        # Uninstalls this manager.
        def uninstall
          text_widget = get_text_widget
          if (!(text_widget).nil? && !text_widget.is_disposed)
            text_widget.remove_verify_key_listener(self)
          end
        end
        
        typesig { [] }
        def initialize
          @f_listeners = self.class::ArrayList.new
          @f_batched = self.class::ArrayList.new
          @f_reentrance_count = 0
        end
        
        private
        alias_method :initialize__verify_key_listeners_manager, :initialize
      end }
      
      # Reification of a range in which a find replace operation is performed. This range is visually
      # highlighted in the viewer as long as the replace operation is in progress.
      # 
      # @since 2.0
      const_set_lazy(:FindReplaceRange) { Class.new do
        local_class_in TextViewer
        include_class_members TextViewer
        include LineBackgroundListener
        include ITextListener
        include IPositionUpdater
        
        class_module.module_eval {
          # Internal name for the position category used to update the range.
          const_set_lazy(:RANGE_CATEGORY) { "org.eclipse.jface.text.TextViewer.find.range" }
          const_attr_reader  :RANGE_CATEGORY
        }
        
        # $NON-NLS-1$
        # The highlight color of this range.
        attr_accessor :f_highlight_color
        alias_method :attr_f_highlight_color, :f_highlight_color
        undef_method :f_highlight_color
        alias_method :attr_f_highlight_color=, :f_highlight_color=
        undef_method :f_highlight_color=
        
        # The position used to lively update this range's extent.
        attr_accessor :f_position
        alias_method :attr_f_position, :f_position
        undef_method :f_position
        alias_method :attr_f_position=, :f_position=
        undef_method :f_position=
        
        typesig { [class_self::IRegion] }
        # Creates a new find/replace range with the given extent.
        # 
        # @param range the extent of this range
        def initialize(range)
          @f_highlight_color = nil
          @f_position = nil
          set_range(range)
        end
        
        typesig { [class_self::IRegion] }
        # Sets the extent of this range.
        # 
        # @param range the extent of this range
        def set_range(range)
          @f_position = self.class::Position.new(range.get_offset, range.get_length)
        end
        
        typesig { [] }
        # Returns the extent of this range.
        # 
        # @return the extent of this range
        def get_range
          return self.class::Region.new(@f_position.get_offset, @f_position.get_length)
        end
        
        typesig { [class_self::Color] }
        # Sets the highlight color of this range. Causes the range to be redrawn.
        # 
        # @param color the highlight color
        def set_highlight_color(color)
          @f_highlight_color = color
          paint
        end
        
        typesig { [class_self::LineBackgroundEvent] }
        # @see LineBackgroundListener#lineGetBackground(LineBackgroundEvent)
        # @since 2.0
        def line_get_background(event)
          # Don't use cached line information because of patched redrawing events.
          if (!(self.attr_f_text_widget).nil?)
            offset = widget_offset2model_offset(event.attr_line_offset)
            if (@f_position.includes(offset))
              event.attr_line_background = @f_highlight_color
            end
          end
        end
        
        typesig { [] }
        # Installs this range. The range registers itself as background
        # line painter and text listener. Also, it creates a category with the
        # viewer's document to maintain its own extent.
        def install
          @local_class_parent.add_text_listener(self)
          self.attr_f_text_widget.add_line_background_listener(self)
          document = @local_class_parent.get_document
          begin
            document.add_position_category(self.class::RANGE_CATEGORY)
            document.add_position(self.class::RANGE_CATEGORY, @f_position)
            document.add_position_updater(self)
          rescue self.class::BadPositionCategoryException => e
            # should not happen
          rescue self.class::BadLocationException => e
            # should not happen
          end
          paint
        end
        
        typesig { [] }
        # Uninstalls this range.
        # @see #install()
        def uninstall
          # http://bugs.eclipse.org/bugs/show_bug.cgi?id=19612
          document = @local_class_parent.get_document
          if (!(document).nil?)
            document.remove_position_updater(self)
            document.remove_position(@f_position)
          end
          if (!(self.attr_f_text_widget).nil? && !self.attr_f_text_widget.is_disposed)
            self.attr_f_text_widget.remove_line_background_listener(self)
          end
          @local_class_parent.remove_text_listener(self)
          clear
        end
        
        typesig { [] }
        # Clears the highlighting of this range.
        def clear
          if (!(self.attr_f_text_widget).nil? && !self.attr_f_text_widget.is_disposed)
            self.attr_f_text_widget.redraw
          end
        end
        
        typesig { [] }
        # Paints the highlighting of this range.
        def paint
          widget_region = model_range2widget_range(@f_position)
          offset = widget_region.get_offset
          length = widget_region.get_length
          count = self.attr_f_text_widget.get_char_count
          if (offset + length >= count)
            length = count - offset # clip
            upper_left = self.attr_f_text_widget.get_location_at_offset(offset)
            lower_right = self.attr_f_text_widget.get_location_at_offset(offset + length)
            width = self.attr_f_text_widget.get_client_area.attr_width
            height = self.attr_f_text_widget.get_line_height(offset + length) + lower_right.attr_y - upper_left.attr_y
            self.attr_f_text_widget.redraw(upper_left.attr_x, upper_left.attr_y, width, height, false)
          end
          self.attr_f_text_widget.redraw_range(offset, length, true)
        end
        
        typesig { [class_self::TextEvent] }
        # @see ITextListener#textChanged(TextEvent)
        # @since 2.0
        def text_changed(event)
          if (event.get_viewer_redraw_state)
            paint
          end
        end
        
        typesig { [class_self::DocumentEvent] }
        # @see IPositionUpdater#update(DocumentEvent)
        # @since 2.0
        def update(event)
          offset = event.get_offset
          length = event.get_length
          delta = event.get_text.length - length
          if (offset < @f_position.get_offset)
            @f_position.set_offset(@f_position.get_offset + delta)
          else
            if (offset < @f_position.get_offset + @f_position.get_length)
              @f_position.set_length(@f_position.get_length + delta)
            end
          end
        end
        
        private
        alias_method :initialize__find_replace_range, :initialize
      end }
      
      # This viewer's find/replace target.
      const_set_lazy(:FindReplaceTarget) { Class.new do
        local_class_in TextViewer
        include_class_members TextViewer
        include IFindReplaceTarget
        include IFindReplaceTargetExtension
        include IFindReplaceTargetExtension3
        
        # The range for this target.
        attr_accessor :f_range
        alias_method :attr_f_range, :f_range
        undef_method :f_range
        alias_method :attr_f_range=, :f_range=
        undef_method :f_range=
        
        # The highlight color of the range of this target.
        attr_accessor :f_scope_highlight_color
        alias_method :attr_f_scope_highlight_color, :f_scope_highlight_color
        undef_method :f_scope_highlight_color
        alias_method :attr_f_scope_highlight_color=, :f_scope_highlight_color=
        undef_method :f_scope_highlight_color=
        
        # The document partitioner remembered in case of a "Replace All".
        attr_accessor :f_remembered_partitioners
        alias_method :attr_f_remembered_partitioners, :f_remembered_partitioners
        undef_method :f_remembered_partitioners
        alias_method :attr_f_remembered_partitioners=, :f_remembered_partitioners=
        undef_method :f_remembered_partitioners=
        
        # The active rewrite session.
        # @since 3.1
        attr_accessor :f_rewrite_session
        alias_method :attr_f_rewrite_session, :f_rewrite_session
        undef_method :f_rewrite_session
        alias_method :attr_f_rewrite_session=, :f_rewrite_session=
        undef_method :f_rewrite_session=
        
        typesig { [] }
        # @see IFindReplaceTarget#getSelectionText()
        def get_selection_text
          s = @local_class_parent.get_selected_range
          if (s.attr_x > -1 && s.attr_y > -1)
            begin
              document = @local_class_parent.get_document
              return document.get(s.attr_x, s.attr_y)
            rescue self.class::BadLocationException => x
            end
          end
          return "" # $NON-NLS-1$
        end
        
        typesig { [String] }
        # @see IFindReplaceTarget#replaceSelection(String)
        def replace_selection(text)
          replace_selection(text, false)
        end
        
        typesig { [String, ::Java::Boolean] }
        # @see IFindReplaceTarget#replaceSelection(String)
        def replace_selection(text, reg_ex_replace)
          s = @local_class_parent.get_selected_range
          if (s.attr_x > -1 && s.attr_y > -1)
            begin
              match_region = @local_class_parent.get_find_replace_document_adapter.replace(text, reg_ex_replace)
              length = -1
              if (!(match_region).nil?)
                length = match_region.get_length
              end
              if (!(text).nil? && length > 0)
                @local_class_parent.set_selected_range(s.attr_x, length)
              end
            rescue self.class::BadLocationException => x
            end
          end
        end
        
        typesig { [] }
        # @see IFindReplaceTarget#isEditable()
        def is_editable
          return @local_class_parent.is_editable
        end
        
        typesig { [] }
        # @see IFindReplaceTarget#getSelection()
        def get_selection
          model_selection = @local_class_parent.get_selected_range
          widget_selection = model_selection2widget_selection(model_selection)
          return !(widget_selection).nil? ? widget_selection : self.class::Point.new(-1, -1)
        end
        
        typesig { [::Java::Int, String, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
        # @see IFindReplaceTarget#findAndSelect(int, String, boolean, boolean, boolean)
        def find_and_select(widget_offset, find_string, search_forward, case_sensitive, whole_word)
          begin
            return find_and_select(widget_offset, find_string, search_forward, case_sensitive, whole_word, false)
          rescue self.class::PatternSyntaxException => x
            return -1
          end
        end
        
        typesig { [::Java::Int, String, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
        # @see IFindReplaceTarget#findAndSelect(int, String, boolean, boolean, boolean)
        def find_and_select(widget_offset, find_string, search_forward, case_sensitive, whole_word, reg_ex_search)
          model_offset = (widget_offset).equal?(-1) ? -1 : widget_offset2model_offset(widget_offset)
          if (!(@f_range).nil?)
            range = @f_range.get_range
            model_offset = @local_class_parent.find_and_select_in_range(model_offset, find_string, search_forward, case_sensitive, whole_word, range.get_offset, range.get_length, reg_ex_search)
          else
            model_offset = @local_class_parent.find_and_select(model_offset, find_string, search_forward, case_sensitive, whole_word, reg_ex_search)
          end
          widget_offset = (model_offset).equal?(-1) ? -1 : model_offset2widget_offset(model_offset)
          return widget_offset
        end
        
        typesig { [] }
        # @see IFindReplaceTarget#canPerformFind()
        def can_perform_find
          return @local_class_parent.can_perform_find
        end
        
        typesig { [] }
        # @see IFindReplaceTargetExtension#beginSession()
        # @since 2.0
        def begin_session
          @f_range = nil
        end
        
        typesig { [] }
        # @see IFindReplaceTargetExtension#endSession()
        # @since 2.0
        def end_session
          if (!(@f_range).nil?)
            @f_range.uninstall
            @f_range = nil
          end
        end
        
        typesig { [] }
        # @see IFindReplaceTargetExtension#getScope()
        # @since 2.0
        def get_scope
          return (@f_range).nil? ? nil : @f_range.get_range
        end
        
        typesig { [] }
        # @see IFindReplaceTargetExtension#getLineSelection()
        # @since 2.0
        def get_line_selection
          point = @local_class_parent.get_selected_range
          begin
            document = @local_class_parent.get_document
            # beginning of line
            line = document.get_line_of_offset(point.attr_x)
            offset = document.get_line_offset(line)
            # end of line
            last_line_info = document.get_line_information_of_offset(point.attr_x + point.attr_y)
            last_line = document.get_line_of_offset(point.attr_x + point.attr_y)
            length = 0
            if ((last_line_info.get_offset).equal?(point.attr_x + point.attr_y) && last_line > 0)
              length = document.get_line_offset(last_line - 1) + document.get_line_length(last_line - 1) - offset
            else
              length = last_line_info.get_offset + last_line_info.get_length - offset
            end
            return self.class::Point.new(offset, length)
          rescue self.class::BadLocationException => e
            # should not happen
            return self.class::Point.new(point.attr_x, 0)
          end
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # @see IFindReplaceTargetExtension#setSelection(int, int)
        # @since 2.0
        def set_selection(model_offset, model_length)
          @local_class_parent.set_selected_range(model_offset, model_length)
        end
        
        typesig { [class_self::IRegion] }
        # @see IFindReplaceTargetExtension#setScope(IRegion)
        # @since 2.0
        def set_scope(scope)
          if (!(@f_range).nil?)
            @f_range.uninstall
          end
          if ((scope).nil?)
            @f_range = nil
            return
          end
          @f_range = self.class::FindReplaceRange.new(scope)
          @f_range.set_highlight_color(@f_scope_highlight_color)
          @f_range.install
        end
        
        typesig { [class_self::Color] }
        # @see IFindReplaceTargetExtension#setScopeHighlightColor(Color)
        # @since 2.0
        def set_scope_highlight_color(color)
          if (!(@f_range).nil?)
            @f_range.set_highlight_color(color)
          end
          @f_scope_highlight_color = color
        end
        
        typesig { [::Java::Boolean] }
        # @see IFindReplaceTargetExtension#setReplaceAllMode(boolean)
        # @since 2.0
        def set_replace_all_mode(replace_all)
          # http://bugs.eclipse.org/bugs/show_bug.cgi?id=18232
          document = @local_class_parent.get_document
          if (replace_all)
            if (document.is_a?(self.class::IDocumentExtension4))
              extension = document
              @f_rewrite_session = extension.start_rewrite_session(DocumentRewriteSessionType::SEQUENTIAL)
            else
              @local_class_parent.set_redraw(false)
              @local_class_parent.start_sequential_rewrite_mode(false)
              if (!(self.attr_f_undo_manager).nil?)
                self.attr_f_undo_manager.begin_compound_change
              end
              @f_remembered_partitioners = TextUtilities.remove_document_partitioners(document)
            end
          else
            if (document.is_a?(self.class::IDocumentExtension4))
              extension = document
              extension.stop_rewrite_session(@f_rewrite_session)
            else
              @local_class_parent.set_redraw(true)
              @local_class_parent.stop_sequential_rewrite_mode
              if (!(self.attr_f_undo_manager).nil?)
                self.attr_f_undo_manager.end_compound_change
              end
              if (!(@f_remembered_partitioners).nil?)
                TextUtilities.add_document_partitioners(document, @f_remembered_partitioners)
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
          @f_range = nil
          @f_scope_highlight_color = nil
          @f_remembered_partitioners = nil
          @f_rewrite_session = nil
        end
        
        private
        alias_method :initialize__find_replace_target, :initialize
      end }
      
      # The viewer's rewrite target.
      # @since 2.0
      const_set_lazy(:RewriteTarget) { Class.new do
        local_class_in TextViewer
        include_class_members TextViewer
        include IRewriteTarget
        
        typesig { [] }
        # @see org.eclipse.jface.text.IRewriteTarget#beginCompoundChange()
        def begin_compound_change
          if (!(self.attr_f_undo_manager).nil?)
            self.attr_f_undo_manager.begin_compound_change
          end
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.IRewriteTarget#endCompoundChange()
        def end_compound_change
          if (!(self.attr_f_undo_manager).nil?)
            self.attr_f_undo_manager.end_compound_change
          end
        end
        
        typesig { [] }
        # @see org.eclipse.jface.text.IRewriteTarget#getDocument()
        def get_document
          return @local_class_parent.get_document
        end
        
        typesig { [::Java::Boolean] }
        # @see org.eclipse.jface.text.IRewriteTarget#setRedraw(boolean)
        def set_redraw(redraw)
          @local_class_parent.set_redraw(redraw)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__rewrite_target, :initialize
      end }
      
      # Value object used as key in the text hover configuration table. It is
      # modifiable only inside this compilation unit to allow the reuse of created
      # objects for efficiency reasons
      # 
      # @since 2.1
      const_set_lazy(:TextHoverKey) { Class.new do
        local_class_in TextViewer
        include_class_members TextViewer
        
        # The content type this key belongs to
        attr_accessor :f_content_type
        alias_method :attr_f_content_type, :f_content_type
        undef_method :f_content_type
        alias_method :attr_f_content_type=, :f_content_type=
        undef_method :f_content_type=
        
        # The state mask
        attr_accessor :f_state_mask
        alias_method :attr_f_state_mask, :f_state_mask
        undef_method :f_state_mask
        alias_method :attr_f_state_mask=, :f_state_mask=
        undef_method :f_state_mask=
        
        typesig { [String, ::Java::Int] }
        # Creates a new text hover key for the given content type and state mask.
        # 
        # @param contentType the content type
        # @param stateMask the state mask
        def initialize(content_type, state_mask)
          @f_content_type = nil
          @f_state_mask = 0
          Assert.is_not_null(content_type)
          @f_content_type = content_type
          @f_state_mask = state_mask
        end
        
        typesig { [Object] }
        # @see java.lang.Object#equals(java.lang.Object)
        def ==(obj)
          if ((obj).nil? || !(obj.get_class).equal?(get_class))
            return false
          end
          text_hover_key = obj
          return (text_hover_key.attr_f_content_type == @f_content_type) && (text_hover_key.attr_f_state_mask).equal?(@f_state_mask)
        end
        
        typesig { [] }
        # @see java.lang.Object#hashCode()
        def hash_code
          return @f_state_mask << 16 | @f_content_type.hash_code
        end
        
        typesig { [::Java::Int] }
        # Sets the state mask of this text hover key.
        # 
        # @param stateMask the state mask
        def set_state_mask(state_mask)
          @f_state_mask = state_mask
        end
        
        private
        alias_method :initialize__text_hover_key, :initialize
      end }
      
      # Position storing block selection information in order to maintain a column selection.
      # 
      # @since 3.5
      const_set_lazy(:ColumnPosition) { Class.new(Position) do
        include_class_members TextViewer
        
        attr_accessor :f_start_column
        alias_method :attr_f_start_column, :f_start_column
        undef_method :f_start_column
        alias_method :attr_f_start_column=, :f_start_column=
        undef_method :f_start_column=
        
        attr_accessor :f_end_column
        alias_method :attr_f_end_column, :f_end_column
        undef_method :f_end_column
        alias_method :attr_f_end_column=, :f_end_column=
        undef_method :f_end_column=
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
        def initialize(offset, length, start_column, end_column)
          @f_start_column = 0
          @f_end_column = 0
          super(offset, length)
          @f_start_column = start_column
          @f_end_column = end_column
        end
        
        private
        alias_method :initialize__column_position, :initialize
      end }
      
      # Captures and remembers the viewer state (selection and visual position). {@link TextViewer.ViewerState}
      # instances are normally used once and then discarded, similar to the following snippet:
      # <pre>
      # ViewerState state= new ViewerState(); // remember the state
      # doStuff(); // operation that may call setRedraw() and perform complex document modifications
      # state.restore(true); // restore the remembered state
      # </pre>
      # 
      # @since 3.3
      const_set_lazy(:ViewerState) { Class.new do
        local_class_in TextViewer
        include_class_members TextViewer
        
        # The position tracking the selection.
        attr_accessor :f_selection
        alias_method :attr_f_selection, :f_selection
        undef_method :f_selection
        alias_method :attr_f_selection=, :f_selection=
        undef_method :f_selection=
        
        # <code>true</code> if {@link #fSelection} was originally backwards.
        attr_accessor :f_reverse_selection
        alias_method :attr_f_reverse_selection, :f_reverse_selection
        undef_method :f_reverse_selection
        alias_method :attr_f_reverse_selection=, :f_reverse_selection=
        undef_method :f_reverse_selection=
        
        # <code>true</code> if the selection has been updated while in redraw(off) mode.
        attr_accessor :f_selection_set
        alias_method :attr_f_selection_set, :f_selection_set
        undef_method :f_selection_set
        alias_method :attr_f_selection_set=, :f_selection_set=
        undef_method :f_selection_set=
        
        # The position tracking the visually stable line.
        attr_accessor :f_stable_line
        alias_method :attr_f_stable_line, :f_stable_line
        undef_method :f_stable_line
        alias_method :attr_f_stable_line=, :f_stable_line=
        undef_method :f_stable_line=
        
        # The pixel offset of the stable line measured from the client area.
        attr_accessor :f_stable_pixel
        alias_method :attr_f_stable_pixel, :f_stable_pixel
        undef_method :f_stable_pixel
        alias_method :attr_f_stable_pixel=, :f_stable_pixel=
        undef_method :f_stable_pixel=
        
        # The position updater for {@link #fSelection} and {@link #fStableLine}.
        attr_accessor :f_updater
        alias_method :attr_f_updater, :f_updater
        undef_method :f_updater
        alias_method :attr_f_updater=, :f_updater=
        undef_method :f_updater=
        
        # The document that the position updater and the positions are registered with.
        attr_accessor :f_updater_document
        alias_method :attr_f_updater_document, :f_updater_document
        undef_method :f_updater_document
        alias_method :attr_f_updater_document=, :f_updater_document=
        undef_method :f_updater_document=
        
        # The position category used by {@link #fUpdater}.
        attr_accessor :f_updater_category
        alias_method :attr_f_updater_category, :f_updater_category
        undef_method :f_updater_category
        alias_method :attr_f_updater_category=, :f_updater_category=
        undef_method :f_updater_category=
        
        typesig { [] }
        # Creates a new viewer state instance and connects it to the current document.
        def initialize
          @f_selection = nil
          @f_reverse_selection = false
          @f_selection_set = false
          @f_stable_line = nil
          @f_stable_pixel = 0
          @f_updater = nil
          @f_updater_document = nil
          @f_updater_category = nil
          document = get_document
          if (!(document).nil?)
            connect(document)
          end
        end
        
        typesig { [] }
        # Returns the normalized selection, i.e. the the selection length is always non-negative.
        # 
        # @return the normalized selection
        def get_selection
          if ((@f_selection).nil?)
            return self.class::Point.new(-1, -1)
          end
          return self.class::Point.new(@f_selection.get_offset, @f_selection.get_length)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # Updates the selection.
        # 
        # @param offset the new selection offset
        # @param length the new selection length
        def update_selection(offset, length)
          @f_selection_set = true
          if ((@f_selection).nil?)
            @f_selection = self.class::Position.new(offset, length)
          else
            update_position(@f_selection, offset, length)
          end
        end
        
        typesig { [::Java::Boolean] }
        # Restores the state and disconnects it from the document. The selection is no longer
        # tracked after this call.
        # 
        # @param restoreViewport <code>true</code> to restore both selection and viewport,
        # <code>false</code> to only restore the selection
        def restore(restore_viewport)
          if (is_connected)
            disconnect
          end
          if (!(@f_selection).nil?)
            if (@f_selection.is_a?(self.class::ColumnPosition))
              cp = @f_selection
              document = self.attr_f_document
              begin
                start_line = document.get_line_of_offset(@f_selection.get_offset)
                start_line_offset = document.get_line_offset(start_line)
                selection_end = @f_selection.get_offset + @f_selection.get_length
                end_line = document.get_line_of_offset(selection_end)
                end_line_offset = document.get_line_offset(end_line)
                tabs = get_text_widget.get_tabs
                start_column = @f_selection.get_offset - start_line_offset + cp.attr_f_start_column
                end_column = selection_end - end_line_offset + cp.attr_f_end_column
                set_selection(self.class::BlockTextSelection.new(document, start_line, start_column, end_line, end_column, tabs))
              rescue self.class::BadLocationException => e
                # fall back to linear mode
                set_selected_range(cp.get_offset, cp.get_length)
              end
            else
              offset = @f_selection.get_offset
              length = @f_selection.get_length
              if (@f_reverse_selection)
                offset -= length
                length = -length
              end
              set_selected_range(offset, length)
            end
            if (restore_viewport)
              update_viewport
            end
          end
        end
        
        typesig { [] }
        # Updates the viewport, trying to keep the
        # {@linkplain StyledText#getLinePixel(int) line pixel} of the caret line stable. If the
        # selection has been updated while in redraw(false) mode, the new selection is revealed.
        def update_viewport
          if (@f_selection_set)
            reveal_range(@f_selection.get_offset, @f_selection.get_length)
          else
            if (!(@f_stable_line).nil?)
              stable_line = 0
              begin
                stable_line = @f_updater_document.get_line_of_offset(@f_stable_line.get_offset)
              rescue self.class::BadLocationException => x
                # ignore and return silently
                return
              end
              stable_widget_line = get_closest_widget_line_for_model_line(stable_line)
              if ((stable_widget_line).equal?(-1))
                return
              end
              line_pixel = get_text_widget.get_line_pixel(stable_widget_line)
              delta = @f_stable_pixel - line_pixel
              top_pixel = get_text_widget.get_top_pixel
              get_text_widget.set_top_pixel(top_pixel - delta)
            end
          end
        end
        
        typesig { [class_self::IDocument] }
        # Remembers the viewer state.
        # 
        # @param document the document to remember the state of
        def connect(document)
          Assert.is_legal(!(document).nil?)
          Assert.is_legal(!is_connected)
          @f_updater_document = document
          begin
            @f_updater_category = SELECTION_POSITION_CATEGORY + RJava.cast_to_string(hash_code)
            @f_updater = self.class::NonDeletingPositionUpdater.new(@f_updater_category)
            @f_updater_document.add_position_category(@f_updater_category)
            @f_updater_document.add_position_updater(@f_updater)
            selection = @local_class_parent.get_selection
            if (selection.is_a?(self.class::IBlockTextSelection))
              bts = selection
              start_virtual = Math.max(0, bts.get_start_column - document.get_line_information_of_offset(bts.get_offset).get_length)
              end_virtual = Math.max(0, bts.get_end_column - document.get_line_information_of_offset(bts.get_offset + bts.get_length).get_length)
              @f_selection = self.class::ColumnPosition.new(bts.get_offset, bts.get_length, start_virtual, end_virtual)
            else
              selection_range = get_selected_range
              @f_reverse_selection = selection_range.attr_y < 0
              offset = 0
              length = 0
              if (@f_reverse_selection)
                offset = selection_range.attr_x + selection_range.attr_y
                length = -selection_range.attr_y
              else
                offset = selection_range.attr_x
                length = selection_range.attr_y
              end
              @f_selection = self.class::Position.new(offset, length)
            end
            @f_selection_set = false
            @f_updater_document.add_position(@f_updater_category, @f_selection)
            stable_line = get_stable_line
            stable_widget_line = model_line2widget_line(stable_line)
            @f_stable_pixel = get_text_widget.get_line_pixel(stable_widget_line)
            stable_line_info = @f_updater_document.get_line_information(stable_line)
            @f_stable_line = self.class::Position.new(stable_line_info.get_offset, stable_line_info.get_length)
            @f_updater_document.add_position(@f_updater_category, @f_stable_line)
          rescue self.class::BadPositionCategoryException => e
            # cannot happen
            Assert.is_true(false)
          rescue self.class::BadLocationException => e
            # should not happen except on concurrent modification
            # ignore and disconnect
            disconnect
          end
        end
        
        typesig { [class_self::Position, ::Java::Int, ::Java::Int] }
        # Updates a position with the given information and clears its deletion state.
        # 
        # @param position the position to update
        # @param offset the new selection offset
        # @param length the new selection length
        def update_position(position, offset, length)
          position.set_offset(offset)
          position.set_length(length)
          # http://bugs.eclipse.org/bugs/show_bug.cgi?id=32795
          position.attr_is_deleted = false
        end
        
        typesig { [] }
        # Returns the document line to keep visually stable. If the caret line is (partially)
        # visible, it is returned, otherwise the topmost (partially) visible line is returned.
        # 
        # @return the visually stable line of this viewer state
        def get_stable_line
          stable_line = 0 # the model line that we try to keep stable
          caret_line = get_text_widget.get_line_at_offset(get_text_widget.get_caret_offset)
          if (caret_line < JFaceTextUtil.get_partial_top_index(get_text_widget) || caret_line > JFaceTextUtil.get_partial_bottom_index(get_text_widget))
            stable_line = JFaceTextUtil.get_partial_top_index(@local_class_parent)
          else
            stable_line = widget_line2model_line(caret_line)
          end
          return stable_line
        end
        
        typesig { [] }
        # Returns <code>true</code> if the viewer state is being tracked, <code>false</code>
        # otherwise.
        # 
        # @return the tracking state
        def is_connected
          return !(@f_updater).nil?
        end
        
        typesig { [] }
        # Disconnects from the document.
        def disconnect
          Assert.is_true(is_connected)
          begin
            @f_updater_document.remove_position(@f_updater_category, @f_selection)
            @f_updater_document.remove_position(@f_updater_category, @f_stable_line)
            @f_updater_document.remove_position_updater(@f_updater)
            @f_updater = nil
            @f_updater_document.remove_position_category(@f_updater_category)
            @f_updater_category = RJava.cast_to_string(nil)
          rescue self.class::BadPositionCategoryException => x
            # cannot happen
            Assert.is_true(false)
          end
        end
        
        private
        alias_method :initialize__viewer_state, :initialize
      end }
      
      # Internal cursor listener i.e. aggregation of mouse and key listener.
      # 
      # @since 3.0
      const_set_lazy(:CursorListener) { Class.new do
        local_class_in TextViewer
        include_class_members TextViewer
        include KeyListener
        include MouseListener
        
        typesig { [] }
        # Installs this cursor listener.
        def install
          if (!(self.attr_f_text_widget).nil? && !self.attr_f_text_widget.is_disposed)
            self.attr_f_text_widget.add_key_listener(self)
            self.attr_f_text_widget.add_mouse_listener(self)
          end
        end
        
        typesig { [] }
        # Uninstalls this cursor listener.
        def uninstall
          if (!(self.attr_f_text_widget).nil? && !self.attr_f_text_widget.is_disposed)
            self.attr_f_text_widget.remove_key_listener(self)
            self.attr_f_text_widget.remove_mouse_listener(self)
          end
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyPressed(org.eclipse.swt.events.KeyEvent)
        def key_pressed(event)
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyPressed(org.eclipse.swt.events.KeyEvent)
        def key_released(e)
          if ((self.attr_f_text_widget.get_selection_count).equal?(0))
            self.attr_f_last_sent_selection_change = nil
            queue_post_selection_changed((e.attr_character).equal?(SWT::DEL))
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDoubleClick(org.eclipse.swt.events.MouseEvent)
        def mouse_double_click(e)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDown(org.eclipse.swt.events.MouseEvent)
        def mouse_down(e)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseUp(org.eclipse.swt.events.MouseEvent)
        def mouse_up(event)
          if ((self.attr_f_text_widget.get_selection_count).equal?(0))
            queue_post_selection_changed(false)
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__cursor_listener, :initialize
      end }
      
      # Internal listener to document rewrite session state changes.
      # @since 3.1
      const_set_lazy(:DocumentRewriteSessionListener) { Class.new do
        local_class_in TextViewer
        include_class_members TextViewer
        include IDocumentRewriteSessionListener
        
        typesig { [class_self::DocumentRewriteSessionEvent] }
        # @see org.eclipse.jface.text.IDocumentRewriteSessionListener#documentRewriteSessionChanged(org.eclipse.jface.text.DocumentRewriteSessionEvent)
        def document_rewrite_session_changed(event)
          target = @local_class_parent.get_rewrite_target
          toggle_redraw = false
          if (REDRAW_BUG_158746)
            toggle_redraw = true
          else
            toggle_redraw = !(event.get_session.get_session_type).equal?(DocumentRewriteSessionType::UNRESTRICTED_SMALL)
          end
          viewport_stabilize = !toggle_redraw
          if ((DocumentRewriteSessionEvent::SESSION_START).equal?(event.get_change_type))
            if (toggle_redraw)
              target.set_redraw(false)
            end
            target.begin_compound_change
            if (viewport_stabilize && (self.attr_f_viewer_state).nil?)
              self.attr_f_viewer_state = self.class::ViewerState.new
            end
          else
            if ((DocumentRewriteSessionEvent::SESSION_STOP).equal?(event.get_change_type))
              if (viewport_stabilize && !(self.attr_f_viewer_state).nil?)
                self.attr_f_viewer_state.restore(true)
                self.attr_f_viewer_state = nil
              end
              target.end_compound_change
              if (toggle_redraw)
                target.set_redraw(true)
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__document_rewrite_session_listener, :initialize
      end }
      
      # Identifies the scrollbars as originators of a view port change.
      const_set_lazy(:SCROLLER) { 1 }
      const_attr_reader  :SCROLLER
      
      # Identifies  mouse moves as originators of a view port change.
      const_set_lazy(:MOUSE) { 2 }
      const_attr_reader  :MOUSE
      
      # Identifies mouse button up as originator of a view port change.
      const_set_lazy(:MOUSE_END) { 3 }
      const_attr_reader  :MOUSE_END
      
      # Identifies key strokes as originators of a view port change.
      const_set_lazy(:KEY) { 4 }
      const_attr_reader  :KEY
      
      # Identifies window resizing as originator of a view port change.
      const_set_lazy(:RESIZE) { 5 }
      const_attr_reader  :RESIZE
      
      # Identifies internal reasons as originators of a view port change.
      const_set_lazy(:INTERNAL) { 6 }
      const_attr_reader  :INTERNAL
      
      # Internal name of the position category used selection preservation during shift.
      const_set_lazy(:SHIFTING) { "__TextViewer_shifting" }
      const_attr_reader  :SHIFTING
      
      # $NON-NLS-1$
      # 
      # Base position category name used by the selection updater
      # @since 3.1
      const_set_lazy(:SELECTION_POSITION_CATEGORY) { "_textviewer_selection_category" }
      const_attr_reader  :SELECTION_POSITION_CATEGORY
    }
    
    # $NON-NLS-1$
    # The viewer's text widget
    attr_accessor :f_text_widget
    alias_method :attr_f_text_widget, :f_text_widget
    undef_method :f_text_widget
    alias_method :attr_f_text_widget=, :f_text_widget=
    undef_method :f_text_widget=
    
    # The viewer's input document
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The viewer's visible document
    attr_accessor :f_visible_document
    alias_method :attr_f_visible_document, :f_visible_document
    undef_method :f_visible_document
    alias_method :attr_f_visible_document=, :f_visible_document=
    undef_method :f_visible_document=
    
    # The viewer's document adapter
    attr_accessor :f_document_adapter
    alias_method :attr_f_document_adapter, :f_document_adapter
    undef_method :f_document_adapter
    alias_method :attr_f_document_adapter=, :f_document_adapter=
    undef_method :f_document_adapter=
    
    # The slave document manager
    attr_accessor :f_slave_document_manager
    alias_method :attr_f_slave_document_manager, :f_slave_document_manager
    undef_method :f_slave_document_manager
    alias_method :attr_f_slave_document_manager=, :f_slave_document_manager=
    undef_method :f_slave_document_manager=
    
    # The text viewer's double click strategies connector
    attr_accessor :f_double_click_strategy_connector
    alias_method :attr_f_double_click_strategy_connector, :f_double_click_strategy_connector
    undef_method :f_double_click_strategy_connector
    alias_method :attr_f_double_click_strategy_connector=, :f_double_click_strategy_connector=
    undef_method :f_double_click_strategy_connector=
    
    # The text viewer's view port guard
    attr_accessor :f_viewport_guard
    alias_method :attr_f_viewport_guard, :f_viewport_guard
    undef_method :f_viewport_guard
    alias_method :attr_f_viewport_guard=, :f_viewport_guard=
    undef_method :f_viewport_guard=
    
    # Caches the graphical coordinate of the first visible line
    attr_accessor :f_top_inset
    alias_method :attr_f_top_inset, :f_top_inset
    undef_method :f_top_inset
    alias_method :attr_f_top_inset=, :f_top_inset=
    undef_method :f_top_inset=
    
    # The most recent document modification as widget command
    attr_accessor :f_widget_command
    alias_method :attr_f_widget_command, :f_widget_command
    undef_method :f_widget_command
    alias_method :attr_f_widget_command=, :f_widget_command=
    undef_method :f_widget_command=
    
    # The SWT control's scrollbars
    attr_accessor :f_scroller
    alias_method :attr_f_scroller, :f_scroller
    undef_method :f_scroller
    alias_method :attr_f_scroller=, :f_scroller=
    undef_method :f_scroller=
    
    # Listener on the visible document
    attr_accessor :f_visible_document_listener
    alias_method :attr_f_visible_document_listener, :f_visible_document_listener
    undef_method :f_visible_document_listener
    alias_method :attr_f_visible_document_listener=, :f_visible_document_listener=
    undef_method :f_visible_document_listener=
    
    # Verify listener
    attr_accessor :f_verify_listener
    alias_method :attr_f_verify_listener, :f_verify_listener
    undef_method :f_verify_listener
    alias_method :attr_f_verify_listener=, :f_verify_listener=
    undef_method :f_verify_listener=
    
    # The most recent widget modification as document command
    attr_accessor :f_document_command
    alias_method :attr_f_document_command, :f_document_command
    undef_method :f_document_command
    alias_method :attr_f_document_command=, :f_document_command=
    undef_method :f_document_command=
    
    # The viewer's find/replace target
    attr_accessor :f_find_replace_target
    alias_method :attr_f_find_replace_target, :f_find_replace_target
    undef_method :f_find_replace_target
    alias_method :attr_f_find_replace_target=, :f_find_replace_target=
    undef_method :f_find_replace_target=
    
    # The text viewer's hovering controller
    # @since 2.0
    attr_accessor :f_text_hover_manager
    alias_method :attr_f_text_hover_manager, :f_text_hover_manager
    undef_method :f_text_hover_manager
    alias_method :attr_f_text_hover_manager=, :f_text_hover_manager=
    undef_method :f_text_hover_manager=
    
    # The viewer widget token keeper
    # @since 2.0
    attr_accessor :f_widget_token_keeper
    alias_method :attr_f_widget_token_keeper, :f_widget_token_keeper
    undef_method :f_widget_token_keeper
    alias_method :attr_f_widget_token_keeper=, :f_widget_token_keeper=
    undef_method :f_widget_token_keeper=
    
    # The viewer's manager of verify key listeners
    # @since 2.0
    attr_accessor :f_verify_key_listeners_manager
    alias_method :attr_f_verify_key_listeners_manager, :f_verify_key_listeners_manager
    undef_method :f_verify_key_listeners_manager
    alias_method :attr_f_verify_key_listeners_manager=, :f_verify_key_listeners_manager=
    undef_method :f_verify_key_listeners_manager=
    
    # The mark position.
    # @since 2.0
    attr_accessor :f_mark_position
    alias_method :attr_f_mark_position, :f_mark_position
    undef_method :f_mark_position
    alias_method :attr_f_mark_position=, :f_mark_position=
    undef_method :f_mark_position=
    
    # The mark position category.
    # @since 2.0
    attr_accessor :mark_position_category
    alias_method :attr_mark_position_category, :mark_position_category
    undef_method :mark_position_category
    alias_method :attr_mark_position_category=, :mark_position_category=
    undef_method :mark_position_category=
    
    # $NON-NLS-1$
    # 
    # The mark position updater
    # @since 2.0
    attr_accessor :f_mark_position_updater
    alias_method :attr_f_mark_position_updater, :f_mark_position_updater
    undef_method :f_mark_position_updater
    alias_method :attr_f_mark_position_updater=, :f_mark_position_updater=
    undef_method :f_mark_position_updater=
    
    # The flag indicating the redraw behavior
    # @since 2.0
    attr_accessor :f_redraw_counter
    alias_method :attr_f_redraw_counter, :f_redraw_counter
    undef_method :f_redraw_counter
    alias_method :attr_f_redraw_counter=, :f_redraw_counter=
    undef_method :f_redraw_counter=
    
    # The viewer's rewrite target
    # @since 2.0
    attr_accessor :f_rewrite_target
    alias_method :attr_f_rewrite_target, :f_rewrite_target
    undef_method :f_rewrite_target
    alias_method :attr_f_rewrite_target=, :f_rewrite_target=
    undef_method :f_rewrite_target=
    
    # The viewer's cursor listener.
    # @since 3.0
    attr_accessor :f_cursor_listener
    alias_method :attr_f_cursor_listener, :f_cursor_listener
    undef_method :f_cursor_listener
    alias_method :attr_f_cursor_listener=, :f_cursor_listener=
    undef_method :f_cursor_listener=
    
    # Last selection range sent to selection change listeners.
    # @since 3.0
    attr_accessor :f_last_sent_selection_change
    alias_method :attr_f_last_sent_selection_change, :f_last_sent_selection_change
    undef_method :f_last_sent_selection_change
    alias_method :attr_f_last_sent_selection_change=, :f_last_sent_selection_change=
    undef_method :f_last_sent_selection_change=
    
    # The registered post selection changed listeners.
    # @since 3.0
    attr_accessor :f_post_selection_changed_listeners
    alias_method :attr_f_post_selection_changed_listeners, :f_post_selection_changed_listeners
    undef_method :f_post_selection_changed_listeners
    alias_method :attr_f_post_selection_changed_listeners=, :f_post_selection_changed_listeners=
    undef_method :f_post_selection_changed_listeners=
    
    # Queued post selection changed events count.
    # @since 3.0
    attr_accessor :f_number_of_post_selection_changed_events
    alias_method :attr_f_number_of_post_selection_changed_events, :f_number_of_post_selection_changed_events
    undef_method :f_number_of_post_selection_changed_events
    alias_method :attr_f_number_of_post_selection_changed_events=, :f_number_of_post_selection_changed_events=
    undef_method :f_number_of_post_selection_changed_events=
    
    # Last selection range sent to post selection change listeners.
    # @since 3.0
    attr_accessor :f_last_sent_post_selection_change
    alias_method :attr_f_last_sent_post_selection_change, :f_last_sent_post_selection_change
    undef_method :f_last_sent_post_selection_change
    alias_method :attr_f_last_sent_post_selection_change=, :f_last_sent_post_selection_change=
    undef_method :f_last_sent_post_selection_change=
    
    # The set of registered editor helpers.
    # @since 3.1
    attr_accessor :f_editor_helpers
    alias_method :attr_f_editor_helpers, :f_editor_helpers
    undef_method :f_editor_helpers
    alias_method :attr_f_editor_helpers=, :f_editor_helpers=
    undef_method :f_editor_helpers=
    
    # The internal rewrite session listener.
    # @since 3.1
    attr_accessor :f_document_rewrite_session_listener
    alias_method :attr_f_document_rewrite_session_listener, :f_document_rewrite_session_listener
    undef_method :f_document_rewrite_session_listener
    alias_method :attr_f_document_rewrite_session_listener=, :f_document_rewrite_session_listener=
    undef_method :f_document_rewrite_session_listener=
    
    # Should the auto indent strategies ignore the next edit operation
    attr_accessor :f_ignore_auto_indent
    alias_method :attr_f_ignore_auto_indent, :f_ignore_auto_indent
    undef_method :f_ignore_auto_indent
    alias_method :attr_f_ignore_auto_indent=, :f_ignore_auto_indent=
    undef_method :f_ignore_auto_indent=
    
    # The strings a line is prefixed with on SHIFT_RIGHT and removed from each line on SHIFT_LEFT
    attr_accessor :f_indent_chars
    alias_method :attr_f_indent_chars, :f_indent_chars
    undef_method :f_indent_chars
    alias_method :attr_f_indent_chars=, :f_indent_chars=
    undef_method :f_indent_chars=
    
    # The string a line is prefixed with on PREFIX and removed from each line on STRIP_PREFIX
    attr_accessor :f_default_prefix_chars
    alias_method :attr_f_default_prefix_chars, :f_default_prefix_chars
    undef_method :f_default_prefix_chars
    alias_method :attr_f_default_prefix_chars=, :f_default_prefix_chars=
    undef_method :f_default_prefix_chars=
    
    # The text viewer's text double click strategies
    attr_accessor :f_double_click_strategies
    alias_method :attr_f_double_click_strategies, :f_double_click_strategies
    undef_method :f_double_click_strategies
    alias_method :attr_f_double_click_strategies=, :f_double_click_strategies=
    undef_method :f_double_click_strategies=
    
    # The text viewer's undo manager
    attr_accessor :f_undo_manager
    alias_method :attr_f_undo_manager, :f_undo_manager
    undef_method :f_undo_manager
    alias_method :attr_f_undo_manager=, :f_undo_manager=
    undef_method :f_undo_manager=
    
    # The text viewer's auto indent strategies
    attr_accessor :f_auto_indent_strategies
    alias_method :attr_f_auto_indent_strategies, :f_auto_indent_strategies
    undef_method :f_auto_indent_strategies
    alias_method :attr_f_auto_indent_strategies=, :f_auto_indent_strategies=
    undef_method :f_auto_indent_strategies=
    
    # The text viewer's text hovers
    attr_accessor :f_text_hovers
    alias_method :attr_f_text_hovers, :f_text_hovers
    undef_method :f_text_hovers
    alias_method :attr_f_text_hovers=, :f_text_hovers=
    undef_method :f_text_hovers=
    
    # All registered view port listeners>
    attr_accessor :f_viewport_listeners
    alias_method :attr_f_viewport_listeners, :f_viewport_listeners
    undef_method :f_viewport_listeners
    alias_method :attr_f_viewport_listeners=, :f_viewport_listeners=
    undef_method :f_viewport_listeners=
    
    # The last visible vertical position of the top line
    attr_accessor :f_last_top_pixel
    alias_method :attr_f_last_top_pixel, :f_last_top_pixel
    undef_method :f_last_top_pixel
    alias_method :attr_f_last_top_pixel=, :f_last_top_pixel=
    undef_method :f_last_top_pixel=
    
    # All registered text listeners
    attr_accessor :f_text_listeners
    alias_method :attr_f_text_listeners, :f_text_listeners
    undef_method :f_text_listeners
    alias_method :attr_f_text_listeners=, :f_text_listeners=
    undef_method :f_text_listeners=
    
    # All registered text input listeners
    attr_accessor :f_text_input_listeners
    alias_method :attr_f_text_input_listeners, :f_text_input_listeners
    undef_method :f_text_input_listeners
    alias_method :attr_f_text_input_listeners=, :f_text_input_listeners=
    undef_method :f_text_input_listeners=
    
    # The text viewer's event consumer
    attr_accessor :f_event_consumer
    alias_method :attr_f_event_consumer, :f_event_consumer
    undef_method :f_event_consumer
    alias_method :attr_f_event_consumer=, :f_event_consumer=
    undef_method :f_event_consumer=
    
    # Indicates whether the viewer's text presentation should be replaced are modified.
    attr_accessor :f_replace_text_presentation
    alias_method :attr_f_replace_text_presentation, :f_replace_text_presentation
    undef_method :f_replace_text_presentation
    alias_method :attr_f_replace_text_presentation=, :f_replace_text_presentation=
    undef_method :f_replace_text_presentation=
    
    # The creator of the text hover control
    # @since 2.0
    attr_accessor :f_hover_control_creator
    alias_method :attr_f_hover_control_creator, :f_hover_control_creator
    undef_method :f_hover_control_creator
    alias_method :attr_f_hover_control_creator=, :f_hover_control_creator=
    undef_method :f_hover_control_creator=
    
    # The mapping between model and visible document.
    # @since 2.1
    attr_accessor :f_information_mapping
    alias_method :attr_f_information_mapping, :f_information_mapping
    undef_method :f_information_mapping
    alias_method :attr_f_information_mapping=, :f_information_mapping=
    undef_method :f_information_mapping=
    
    # The viewer's paint manager.
    # @since 2.1
    attr_accessor :f_paint_manager
    alias_method :attr_f_paint_manager, :f_paint_manager
    undef_method :f_paint_manager
    alias_method :attr_f_paint_manager=, :f_paint_manager=
    undef_method :f_paint_manager=
    
    # The viewers partitioning. I.e. the partitioning name the viewer uses to access partitioning information of its input document.
    # @since 3.0
    attr_accessor :f_partitioning
    alias_method :attr_f_partitioning, :f_partitioning
    undef_method :f_partitioning
    alias_method :attr_f_partitioning=, :f_partitioning=
    undef_method :f_partitioning=
    
    # All registered text presentation listeners.
    # since 3.0
    attr_accessor :f_text_presentation_listeners
    alias_method :attr_f_text_presentation_listeners, :f_text_presentation_listeners
    undef_method :f_text_presentation_listeners
    alias_method :attr_f_text_presentation_listeners=, :f_text_presentation_listeners=
    undef_method :f_text_presentation_listeners=
    
    # The find/replace document adapter.
    # @since 3.0
    attr_accessor :f_find_replace_document_adapter
    alias_method :attr_f_find_replace_document_adapter, :f_find_replace_document_adapter
    undef_method :f_find_replace_document_adapter
    alias_method :attr_f_find_replace_document_adapter=, :f_find_replace_document_adapter=
    undef_method :f_find_replace_document_adapter=
    
    # The text viewer's hyperlink detectors.
    # @since 3.1
    attr_accessor :f_hyperlink_detectors
    alias_method :attr_f_hyperlink_detectors, :f_hyperlink_detectors
    undef_method :f_hyperlink_detectors
    alias_method :attr_f_hyperlink_detectors=, :f_hyperlink_detectors=
    undef_method :f_hyperlink_detectors=
    
    # The text viewer's hyperlink presenter.
    # @since 3.1
    attr_accessor :f_hyperlink_presenter
    alias_method :attr_f_hyperlink_presenter, :f_hyperlink_presenter
    undef_method :f_hyperlink_presenter
    alias_method :attr_f_hyperlink_presenter=, :f_hyperlink_presenter=
    undef_method :f_hyperlink_presenter=
    
    # The text viewer's hyperlink manager.
    # @since 3.1
    attr_accessor :f_hyperlink_manager
    alias_method :attr_f_hyperlink_manager, :f_hyperlink_manager
    undef_method :f_hyperlink_manager
    alias_method :attr_f_hyperlink_manager=, :f_hyperlink_manager=
    undef_method :f_hyperlink_manager=
    
    # The SWT key modifier mask which in combination
    # with the left mouse button triggers the hyperlink mode.
    # @since 3.1
    attr_accessor :f_hyperlink_state_mask
    alias_method :attr_f_hyperlink_state_mask, :f_hyperlink_state_mask
    undef_method :f_hyperlink_state_mask
    alias_method :attr_f_hyperlink_state_mask=, :f_hyperlink_state_mask=
    undef_method :f_hyperlink_state_mask=
    
    # The viewer state when in non-redraw state, <code>null</code> otherwise.
    # @since 3.3
    attr_accessor :f_viewer_state
    alias_method :attr_f_viewer_state, :f_viewer_state
    undef_method :f_viewer_state
    alias_method :attr_f_viewer_state=, :f_viewer_state=
    undef_method :f_viewer_state=
    
    # The editor's tab converter.
    # @since 3.3
    attr_accessor :f_tabs_to_spaces_converter
    alias_method :attr_f_tabs_to_spaces_converter, :f_tabs_to_spaces_converter
    undef_method :f_tabs_to_spaces_converter
    alias_method :attr_f_tabs_to_spaces_converter=, :f_tabs_to_spaces_converter=
    undef_method :f_tabs_to_spaces_converter=
    
    # The last verify event time, used to fold block editing events.
    # @since 3.5
    attr_accessor :f_last_event_time
    alias_method :attr_f_last_event_time, :f_last_event_time
    undef_method :f_last_event_time
    alias_method :attr_f_last_event_time=, :f_last_event_time=
    undef_method :f_last_event_time=
    
    typesig { [] }
    # ---- Construction and disposal ------------------
    # 
    # Internal use only
    def initialize
      @f_text_widget = nil
      @f_document = nil
      @f_visible_document = nil
      @f_document_adapter = nil
      @f_slave_document_manager = nil
      @f_double_click_strategy_connector = nil
      @f_viewport_guard = nil
      @f_top_inset = 0
      @f_widget_command = nil
      @f_scroller = nil
      @f_visible_document_listener = nil
      @f_verify_listener = nil
      @f_document_command = nil
      @f_find_replace_target = nil
      @f_text_hover_manager = nil
      @f_widget_token_keeper = nil
      @f_verify_key_listeners_manager = nil
      @f_mark_position = nil
      @mark_position_category = nil
      @f_mark_position_updater = nil
      @f_redraw_counter = 0
      @f_rewrite_target = nil
      @f_cursor_listener = nil
      @f_last_sent_selection_change = nil
      @f_post_selection_changed_listeners = nil
      @f_number_of_post_selection_changed_events = nil
      @f_last_sent_post_selection_change = nil
      @f_editor_helpers = nil
      @f_document_rewrite_session_listener = nil
      @f_ignore_auto_indent = false
      @f_indent_chars = nil
      @f_default_prefix_chars = nil
      @f_double_click_strategies = nil
      @f_undo_manager = nil
      @f_auto_indent_strategies = nil
      @f_text_hovers = nil
      @f_viewport_listeners = nil
      @f_last_top_pixel = 0
      @f_text_listeners = nil
      @f_text_input_listeners = nil
      @f_event_consumer = nil
      @f_replace_text_presentation = false
      @f_hover_control_creator = nil
      @f_information_mapping = nil
      @f_paint_manager = nil
      @f_partitioning = nil
      @f_text_presentation_listeners = nil
      @f_find_replace_document_adapter = nil
      @f_hyperlink_detectors = nil
      @f_hyperlink_presenter = nil
      @f_hyperlink_manager = nil
      @f_hyperlink_state_mask = 0
      @f_viewer_state = nil
      @f_tabs_to_spaces_converter = nil
      @f_last_event_time = 0
      super()
      @f_top_inset = 0
      @f_widget_command = WidgetCommand.new_local(self)
      @f_visible_document_listener = VisibleDocumentListener.new_local(self)
      @f_verify_listener = TextVerifyListener.new_local(self)
      @f_document_command = DocumentCommand.new
      @f_verify_key_listeners_manager = VerifyKeyListenersManager.new_local(self)
      @mark_position_category = "__mark_category_" + RJava.cast_to_string(hash_code)
      @f_mark_position_updater = DefaultPositionUpdater.new(@mark_position_category)
      @f_redraw_counter = 0
      @f_number_of_post_selection_changed_events = Array.typed(::Java::Int).new(1) { 0 }
      @f_editor_helpers = HashSet.new
      @f_document_rewrite_session_listener = DocumentRewriteSessionListener.new_local(self)
      @f_ignore_auto_indent = false
      @f_replace_text_presentation = false
    end
    
    typesig { [Composite, ::Java::Int] }
    # Create a new text viewer with the given SWT style bits.
    # The viewer is ready to use but does not have any plug-in installed.
    # 
    # @param parent the parent of the viewer's control
    # @param styles the SWT style bits for the viewer's control,
    # <em>if <code>SWT.WRAP</code> is set then a custom document adapter needs to be provided, see {@link #createDocumentAdapter()}
    def initialize(parent, styles)
      @f_text_widget = nil
      @f_document = nil
      @f_visible_document = nil
      @f_document_adapter = nil
      @f_slave_document_manager = nil
      @f_double_click_strategy_connector = nil
      @f_viewport_guard = nil
      @f_top_inset = 0
      @f_widget_command = nil
      @f_scroller = nil
      @f_visible_document_listener = nil
      @f_verify_listener = nil
      @f_document_command = nil
      @f_find_replace_target = nil
      @f_text_hover_manager = nil
      @f_widget_token_keeper = nil
      @f_verify_key_listeners_manager = nil
      @f_mark_position = nil
      @mark_position_category = nil
      @f_mark_position_updater = nil
      @f_redraw_counter = 0
      @f_rewrite_target = nil
      @f_cursor_listener = nil
      @f_last_sent_selection_change = nil
      @f_post_selection_changed_listeners = nil
      @f_number_of_post_selection_changed_events = nil
      @f_last_sent_post_selection_change = nil
      @f_editor_helpers = nil
      @f_document_rewrite_session_listener = nil
      @f_ignore_auto_indent = false
      @f_indent_chars = nil
      @f_default_prefix_chars = nil
      @f_double_click_strategies = nil
      @f_undo_manager = nil
      @f_auto_indent_strategies = nil
      @f_text_hovers = nil
      @f_viewport_listeners = nil
      @f_last_top_pixel = 0
      @f_text_listeners = nil
      @f_text_input_listeners = nil
      @f_event_consumer = nil
      @f_replace_text_presentation = false
      @f_hover_control_creator = nil
      @f_information_mapping = nil
      @f_paint_manager = nil
      @f_partitioning = nil
      @f_text_presentation_listeners = nil
      @f_find_replace_document_adapter = nil
      @f_hyperlink_detectors = nil
      @f_hyperlink_presenter = nil
      @f_hyperlink_manager = nil
      @f_hyperlink_state_mask = 0
      @f_viewer_state = nil
      @f_tabs_to_spaces_converter = nil
      @f_last_event_time = 0
      super()
      @f_top_inset = 0
      @f_widget_command = WidgetCommand.new_local(self)
      @f_visible_document_listener = VisibleDocumentListener.new_local(self)
      @f_verify_listener = TextVerifyListener.new_local(self)
      @f_document_command = DocumentCommand.new
      @f_verify_key_listeners_manager = VerifyKeyListenersManager.new_local(self)
      @mark_position_category = "__mark_category_" + RJava.cast_to_string(hash_code)
      @f_mark_position_updater = DefaultPositionUpdater.new(@mark_position_category)
      @f_redraw_counter = 0
      @f_number_of_post_selection_changed_events = Array.typed(::Java::Int).new(1) { 0 }
      @f_editor_helpers = HashSet.new
      @f_document_rewrite_session_listener = DocumentRewriteSessionListener.new_local(self)
      @f_ignore_auto_indent = false
      @f_replace_text_presentation = false
      create_control(parent, styles)
    end
    
    typesig { [Composite, ::Java::Int] }
    # Factory method to create the text widget to be used as the viewer's text widget.
    # 
    # @param parent the parent of the styled text
    # @param styles the styles for the styled text
    # @return the text widget to be used
    def create_text_widget(parent, styles)
      return StyledText.new(parent, styles)
    end
    
    typesig { [] }
    # Factory method to create the document adapter to be used by this viewer.
    # 
    # @return the document adapter to be used
    def create_document_adapter
      return DefaultDocumentAdapter.new
    end
    
    typesig { [Composite, ::Java::Int] }
    # Creates the viewer's SWT control. The viewer's text widget either is
    # the control or is a child of the control.
    # 
    # @param parent the parent of the viewer's control
    # @param styles the SWT style bits for the viewer's control
    def create_control(parent, styles)
      @f_text_widget = create_text_widget(parent, styles)
      @f_text_widget.add_listener(SWT::MouseWheel, # Support scroll page upon MOD1+MouseWheel
      Class.new(Listener.class == Class ? Listener : Object) do
        local_class_in TextViewer
        include_class_members TextViewer
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |event|
          if ((((event.attr_state_mask & SWT::MOD1)).equal?(0)))
            return
          end
          top_index = self.attr_f_text_widget.get_top_index
          bottom_index = JFaceTextUtil.get_bottom_index(self.attr_f_text_widget)
          if (event.attr_count > 0)
            self.attr_f_text_widget.set_top_index(2 * top_index - bottom_index)
          else
            self.attr_f_text_widget.set_top_index(bottom_index)
          end
          update_viewport_listeners(INTERNAL)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_text_widget.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        local_class_in TextViewer
        include_class_members TextViewer
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |e|
          handle_dispose
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_text_widget.set_font(parent.get_font)
      @f_text_widget.set_double_click_enabled(true)
      @f_text_widget.add_traverse_listener(# Disable SWT Shift+TAB traversal in this viewer
      # 1GIYQ9K: ITPUI:WINNT - StyledText swallows Shift+TAB
      Class.new(TraverseListener.class == Class ? TraverseListener : Object) do
        local_class_in TextViewer
        include_class_members TextViewer
        include TraverseListener if TraverseListener.class == Module
        
        typesig { [TraverseEvent] }
        define_method :key_traversed do |e|
          if (((SWT::SHIFT).equal?(e.attr_state_mask)) && ((Character.new(?\t.ord)).equal?(e.attr_character)))
            e.attr_doit = false
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      # where does the first line start
      @f_top_inset = -@f_text_widget.compute_trim(0, 0, 0, 0).attr_y
      @f_verify_listener.forward(true)
      @f_text_widget.add_verify_listener(@f_verify_listener)
      @f_text_widget.add_selection_listener(Class.new(SelectionListener.class == Class ? SelectionListener : Object) do
        local_class_in TextViewer
        include_class_members TextViewer
        include SelectionListener if SelectionListener.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_default_selected do |event|
          selection_changed(event.attr_x, event.attr_y - event.attr_x)
        end
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |event|
          selection_changed(event.attr_x, event.attr_y - event.attr_x)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @f_cursor_listener = CursorListener.new_local(self)
      @f_cursor_listener.install
      initialize_viewport_update
    end
    
    typesig { [] }
    # @see Viewer#getControl()
    def get_control
      return @f_text_widget
    end
    
    typesig { [] }
    # @see ITextViewer#activatePlugins()
    def activate_plugins
      if (!(@f_double_click_strategies).nil? && !@f_double_click_strategies.is_empty && (@f_double_click_strategy_connector).nil?)
        @f_double_click_strategy_connector = TextDoubleClickStrategyConnector.new_local(self)
        @f_text_widget.add_word_movement_listener(@f_double_click_strategy_connector)
        @f_text_widget.add_mouse_listener(@f_double_click_strategy_connector)
      end
      ensure_hover_control_manager_installed
      ensure_hyperlink_manager_installed
      if (!(@f_undo_manager).nil?)
        @f_undo_manager.connect(self)
        @f_undo_manager.reset
      end
    end
    
    typesig { [] }
    # After this method has been executed the caller knows that any installed text hover has been installed.
    def ensure_hover_control_manager_installed
      if (!(@f_text_hovers).nil? && !@f_text_hovers.is_empty && !(@f_hover_control_creator).nil? && (@f_text_hover_manager).nil?)
        @f_text_hover_manager = TextViewerHoverManager.new(self, @f_hover_control_creator)
        @f_text_hover_manager.install(self.get_text_widget)
        @f_text_hover_manager.set_size_constraints(TEXT_HOVER_WIDTH_CHARS, TEXT_HOVER_HEIGHT_CHARS, false, true)
        @f_text_hover_manager.set_information_control_replacer(StickyHoverManager.new(self))
      end
    end
    
    typesig { [] }
    # @see ITextViewer#resetPlugins()
    def reset_plugins
      if (!(@f_undo_manager).nil?)
        @f_undo_manager.reset
      end
    end
    
    typesig { [] }
    # Frees all resources allocated by this viewer. Internally called when the viewer's
    # control has been disposed.
    def handle_dispose
      set_document(nil)
      if (!(@f_paint_manager).nil?)
        @f_paint_manager.dispose
        @f_paint_manager = nil
      end
      remove_view_port_update
      @f_viewport_guard = nil
      if (!(@f_viewport_listeners).nil?)
        @f_viewport_listeners.clear
        @f_viewport_listeners = nil
      end
      if (!(@f_text_listeners).nil?)
        @f_text_listeners.clear
        @f_text_listeners = nil
      end
      if (!(@f_text_input_listeners).nil?)
        @f_text_input_listeners.clear
        @f_text_input_listeners = nil
      end
      if (!(@f_post_selection_changed_listeners).nil?)
        @f_post_selection_changed_listeners.clear
        @f_post_selection_changed_listeners = nil
      end
      if (!(@f_auto_indent_strategies).nil?)
        @f_auto_indent_strategies.clear
        @f_auto_indent_strategies = nil
      end
      if (!(@f_undo_manager).nil?)
        @f_undo_manager.disconnect
        @f_undo_manager = nil
      end
      if (!(@f_double_click_strategies).nil?)
        @f_double_click_strategies.clear
        @f_double_click_strategies = nil
      end
      if (!(@f_text_hovers).nil?)
        @f_text_hovers.clear
        @f_text_hovers = nil
      end
      @f_double_click_strategy_connector = nil
      if (!(@f_text_hover_manager).nil?)
        @f_text_hover_manager.dispose
        @f_text_hover_manager = nil
      end
      if (!(@f_visible_document_listener).nil?)
        if (!(@f_visible_document).nil?)
          @f_visible_document.remove_document_listener(@f_visible_document_listener)
        end
        @f_visible_document_listener = nil
      end
      if (!(@f_document_adapter).nil?)
        @f_document_adapter.set_document(nil)
        @f_document_adapter = nil
      end
      if (!(@f_slave_document_manager).nil?)
        if (!(@f_visible_document).nil?)
          @f_slave_document_manager.free_slave_document(@f_visible_document)
        end
        @f_slave_document_manager = nil
      end
      if (!(@f_cursor_listener).nil?)
        @f_cursor_listener.uninstall
        @f_cursor_listener = nil
      end
      if (!(@f_hyperlink_manager).nil?)
        @f_hyperlink_manager.uninstall
        @f_hyperlink_manager = nil
      end
      @f_hyperlink_detectors = nil
      @f_visible_document = nil
      @f_document = nil
      @f_scroller = nil
      @f_text_widget = nil
    end
    
    typesig { [] }
    # ---- simple getters and setters
    # 
    # @see org.eclipse.jface.text.ITextViewer#getTextWidget()
    def get_text_widget
      return @f_text_widget
    end
    
    typesig { [] }
    # The delay in milliseconds before an empty selection
    # changed event is sent by the cursor listener.
    # <p>
    # Note: The return value is used to initialize the cursor
    # listener. To return a non-constant value has no effect.</p>
    # <p>
    # The same value (<code>500</code>) is used in <code>OpenStrategy.TIME</code>.</p>
    # 
    # @return delay in milliseconds
    # @see org.eclipse.jface.util.OpenStrategy
    # @since 3.0
    def get_empty_selection_changed_event_delay
      return 500
    end
    
    typesig { [IAutoIndentStrategy, String] }
    # {@inheritDoc}
    # @deprecated since 3.1, use
    # {@link ITextViewerExtension2#prependAutoEditStrategy(IAutoEditStrategy, String)} and
    # {@link ITextViewerExtension2#removeAutoEditStrategy(IAutoEditStrategy, String)} instead
    def set_auto_indent_strategy(strategy, content_type)
      set_auto_edit_strategies(Array.typed(IAutoEditStrategy).new([strategy]), content_type)
    end
    
    typesig { [Array.typed(IAutoEditStrategy), String] }
    # Sets the given edit strategy as the only strategy for the given content type.
    # 
    # @param strategies the auto edit strategies
    # @param contentType the content type
    # @since 3.1
    def set_auto_edit_strategies(strategies, content_type)
      if ((@f_auto_indent_strategies).nil?)
        @f_auto_indent_strategies = HashMap.new
      end
      auto_edit_strategies = @f_auto_indent_strategies.get(content_type)
      if ((strategies).nil?)
        if ((auto_edit_strategies).nil?)
          return
        end
        @f_auto_indent_strategies.put(content_type, nil)
      else
        if ((auto_edit_strategies).nil?)
          auto_edit_strategies = ArrayList.new
          @f_auto_indent_strategies.put(content_type, auto_edit_strategies)
        end
        auto_edit_strategies.clear
        auto_edit_strategies.add_all(Arrays.as_list(strategies))
      end
    end
    
    typesig { [IAutoEditStrategy, String] }
    # @see org.eclipse.jface.text.ITextViewerExtension2#prependAutoEditStrategy(org.eclipse.jface.text.IAutoEditStrategy, java.lang.String)
    # @since 2.1
    def prepend_auto_edit_strategy(strategy, content_type)
      if ((strategy).nil? || (content_type).nil?)
        raise IllegalArgumentException.new
      end
      if ((@f_auto_indent_strategies).nil?)
        @f_auto_indent_strategies = HashMap.new
      end
      auto_edit_strategies = @f_auto_indent_strategies.get(content_type)
      if ((auto_edit_strategies).nil?)
        auto_edit_strategies = ArrayList.new
        @f_auto_indent_strategies.put(content_type, auto_edit_strategies)
      end
      auto_edit_strategies.add(0, strategy)
    end
    
    typesig { [IAutoEditStrategy, String] }
    # @see org.eclipse.jface.text.ITextViewerExtension2#removeAutoEditStrategy(org.eclipse.jface.text.IAutoEditStrategy, java.lang.String)
    # @since 2.1
    def remove_auto_edit_strategy(strategy, content_type)
      if ((@f_auto_indent_strategies).nil?)
        return
      end
      auto_edit_strategies = @f_auto_indent_strategies.get(content_type)
      if ((auto_edit_strategies).nil?)
        return
      end
      iterator_ = auto_edit_strategies.iterator
      while iterator_.has_next
        if ((iterator_.next_ == strategy))
          iterator_.remove
          break
        end
      end
      if (auto_edit_strategies.is_empty)
        @f_auto_indent_strategies.put(content_type, nil)
      end
    end
    
    typesig { [IEventConsumer] }
    # @see ITextViewer#setEventConsumer(IEventConsumer)
    def set_event_consumer(consumer)
      @f_event_consumer = consumer
    end
    
    typesig { [Array.typed(String), String] }
    # @see ITextViewer#setIndentPrefixes(String[], String)
    def set_indent_prefixes(indent_prefixes, content_type)
      i = -1
      ok = (!(indent_prefixes).nil?)
      while (ok && (i += 1) < indent_prefixes.attr_length)
        ok = (!(indent_prefixes[i]).nil?)
      end
      if (ok)
        if ((@f_indent_chars).nil?)
          @f_indent_chars = HashMap.new
        end
        @f_indent_chars.put(content_type, indent_prefixes)
      else
        if (!(@f_indent_chars).nil?)
          @f_indent_chars.remove(content_type)
        end
      end
    end
    
    typesig { [] }
    # @see ITextViewer#getTopInset()
    def get_top_inset
      return @f_top_inset
    end
    
    typesig { [] }
    # @see ITextViewer#isEditable()
    def is_editable
      if ((@f_text_widget).nil?)
        return false
      end
      return @f_text_widget.get_editable
    end
    
    typesig { [::Java::Boolean] }
    # @see ITextViewer#setEditable(boolean)
    def set_editable(editable)
      if (!(@f_text_widget).nil?)
        @f_text_widget.set_editable(editable)
      end
    end
    
    typesig { [Array.typed(String), String] }
    # @see ITextViewer#setDefaultPrefixes
    # @since 2.0
    def set_default_prefixes(default_prefixes, content_type)
      if (!(default_prefixes).nil? && default_prefixes.attr_length > 0)
        if ((@f_default_prefix_chars).nil?)
          @f_default_prefix_chars = HashMap.new
        end
        @f_default_prefix_chars.put(content_type, default_prefixes)
      else
        if (!(@f_default_prefix_chars).nil?)
          @f_default_prefix_chars.remove(content_type)
        end
      end
    end
    
    typesig { [IUndoManager] }
    # @see ITextViewer#setUndoManager(IUndoManager)
    def set_undo_manager(undo_manager)
      @f_undo_manager = undo_manager
    end
    
    typesig { [] }
    # @see ITextViewerExtension6#getUndoManager()
    # @since 3.1
    def get_undo_manager
      return @f_undo_manager
    end
    
    typesig { [ITextHover, String] }
    # @see ITextViewer#setTextHover(ITextHover, String)
    def set_text_hover(hover, content_type)
      set_text_hover(hover, content_type, ITextViewerExtension2::DEFAULT_HOVER_STATE_MASK)
    end
    
    typesig { [ITextHover, String, ::Java::Int] }
    # @see ITextViewerExtension2#setTextHover(ITextHover, String, int)
    # @since 2.1
    def set_text_hover(hover, content_type, state_mask)
      key = TextHoverKey.new_local(self, content_type, state_mask)
      if (!(hover).nil?)
        if ((@f_text_hovers).nil?)
          @f_text_hovers = HashMap.new
        end
        @f_text_hovers.put(key, hover)
      else
        if (!(@f_text_hovers).nil?)
          @f_text_hovers.remove(key)
        end
      end
      ensure_hover_control_manager_installed
    end
    
    typesig { [String] }
    # @see ITextViewerExtension2#removeTextHovers(String)
    # @since 2.1
    def remove_text_hovers(content_type)
      if ((@f_text_hovers).nil?)
        return
      end
      iter = HashSet.new(@f_text_hovers.key_set).iterator
      while (iter.has_next)
        key = iter.next_
        if ((key.attr_f_content_type == content_type))
          @f_text_hovers.remove(key)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the text hover for a given offset.
    # 
    # @param offset the offset for which to return the text hover
    # @return the text hover for the given offset
    def get_text_hover(offset)
      return get_text_hover(offset, ITextViewerExtension2::DEFAULT_HOVER_STATE_MASK)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the text hover for a given offset and a given state mask.
    # 
    # @param offset the offset for which to return the text hover
    # @param stateMask the SWT event state mask
    # @return the text hover for the given offset and state mask
    # @since 2.1
    def get_text_hover(offset, state_mask)
      if ((@f_text_hovers).nil?)
        return nil
      end
      document = get_document
      if ((document).nil?)
        return nil
      end
      begin
        key = TextHoverKey.new_local(self, TextUtilities.get_content_type(document, get_document_partitioning, offset, true), state_mask)
        text_hover = @f_text_hovers.get(key)
        if ((text_hover).nil?)
          # Use default text hover
          key.set_state_mask(ITextViewerExtension2::DEFAULT_HOVER_STATE_MASK)
          text_hover = @f_text_hovers.get(key)
        end
        return text_hover
      rescue BadLocationException => x
        if (TRACE_ERRORS)
          System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.selectContentTypePlugin"))
        end # $NON-NLS-1$
      end
      return nil
    end
    
    typesig { [] }
    # Returns the text hovering controller of this viewer.
    # 
    # @return the text hovering controller of this viewer
    # @since 2.0
    def get_text_hovering_controller
      return @f_text_hover_manager
    end
    
    typesig { [IInformationControlCreator] }
    # Sets the creator for the hover controls.
    # 
    # @param creator the hover control creator
    # @since 2.0
    def set_hover_control_creator(creator)
      @f_hover_control_creator = creator
    end
    
    typesig { [ITextViewerExtension8::EnrichMode] }
    # {@inheritDoc}
    # 
    # @since 3.4
    def set_hover_enrich_mode(mode)
      if ((@f_text_hover_manager).nil?)
        return
      end
      @f_text_hover_manager.set_hover_enrich_mode(mode)
    end
    
    typesig { [IWidgetTokenKeeper] }
    # @see IWidgetTokenOwner#requestWidgetToken(IWidgetTokenKeeper)
    # @since 2.0
    def request_widget_token(requester)
      if (!(@f_text_widget).nil?)
        if (!(@f_widget_token_keeper).nil?)
          if ((@f_widget_token_keeper).equal?(requester))
            return true
          end
          if (@f_widget_token_keeper.request_widget_token(self))
            @f_widget_token_keeper = requester
            return true
          end
        else
          @f_widget_token_keeper = requester
          return true
        end
      end
      return false
    end
    
    typesig { [IWidgetTokenKeeper, ::Java::Int] }
    # @see org.eclipse.jface.text.IWidgetTokenOwnerExtension#requestWidgetToken(org.eclipse.jface.text.IWidgetTokenKeeper, int)
    # @since 3.0
    def request_widget_token(requester, priority)
      if (!(@f_text_widget).nil?)
        if (!(@f_widget_token_keeper).nil?)
          if ((@f_widget_token_keeper).equal?(requester))
            return true
          end
          accepted = false
          if (@f_widget_token_keeper.is_a?(IWidgetTokenKeeperExtension))
            extension = @f_widget_token_keeper
            accepted = extension.request_widget_token(self, priority)
          else
            accepted = @f_widget_token_keeper.request_widget_token(self)
          end
          if (accepted)
            @f_widget_token_keeper = requester
            return true
          end
        else
          @f_widget_token_keeper = requester
          return true
        end
      end
      return false
    end
    
    typesig { [IWidgetTokenKeeper] }
    # @see IWidgetTokenOwner#releaseWidgetToken(IWidgetTokenKeeper)
    # @since 2.0
    def release_widget_token(token_keeper)
      if ((@f_widget_token_keeper).equal?(token_keeper))
        @f_widget_token_keeper = nil
      end
    end
    
    typesig { [] }
    # ---- Selection
    # 
    # @see ITextViewer#getSelectedRange()
    def get_selected_range
      if (!redraws && !(@f_viewer_state).nil?)
        return @f_viewer_state.get_selection
      end
      if (!(@f_text_widget).nil?)
        p = @f_text_widget.get_selection_range
        p = widget_selection2model_selection(p)
        if (!(p).nil?)
          return p
        end
      end
      return Point.new(-1, -1)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see ITextViewer#setSelectedRange(int, int)
    def set_selected_range(selection_offset, selection_length)
      if (!redraws)
        if (!(@f_viewer_state).nil?)
          @f_viewer_state.update_selection(selection_offset, selection_length)
        end
        return
      end
      if ((@f_text_widget).nil?)
        return
      end
      widget_selection = model_range2closest_widget_range(Region.new(selection_offset, selection_length))
      if (!(widget_selection).nil?)
        selection_range = Array.typed(::Java::Int).new([widget_selection.get_offset, widget_selection.get_length])
        validate_selection_range(selection_range)
        if (selection_range[0] >= 0)
          @f_text_widget.set_selection_range(selection_range[0], selection_range[1])
          selection_changed(selection_range[0], selection_range[1])
        end
      end
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Validates and adapts the given selection range if it is not a valid
    # widget selection. The widget selection is invalid if it starts or ends
    # inside a multi-character line delimiter. If so, the selection is adapted to
    # start <b>after</b> the divided line delimiter and to end <b>before</b>
    # the divided line delimiter.  The parameter passed in is changed in-place
    # when being adapted. An adaptation to <code>[-1, -1]</code> indicates
    # that the selection range could not be validated.
    # Subclasses may reimplement this method.
    # 
    # @param selectionRange selectionRange[0] is the offset, selectionRange[1]
    # the length of the selection to validate.
    # @since 2.0
    def validate_selection_range(selection_range)
      document = get_visible_document
      if ((document).nil?)
        selection_range[0] = -1
        selection_range[1] = -1
        return
      end
      document_length = document.get_length
      offset = selection_range[0]
      length = selection_range[1]
      if (length < 0)
        length = -length
        offset -= length
      end
      if (offset < 0)
        offset = 0
      end
      if (offset > document_length)
        offset = document_length
      end
      delta = (offset + length) - document_length
      if (delta > 0)
        length -= delta
      end
      begin
        line_number = document.get_line_of_offset(offset)
        line_information = document.get_line_information(line_number)
        line_end = line_information.get_offset + line_information.get_length
        delta = offset - line_end
        if (delta > 0)
          # in the middle of a multi-character line delimiter
          offset = line_end
          delimiter = document.get_line_delimiter(line_number)
          if (!(delimiter).nil?)
            offset += delimiter.length
          end
        end
        end_ = offset + length
        line_information = document.get_line_information_of_offset(end_)
        line_end = line_information.get_offset + line_information.get_length
        delta = end_ - line_end
        if (delta > 0)
          # in the middle of a multi-character line delimiter
          length -= delta
        end
      rescue BadLocationException => x
        selection_range[0] = -1
        selection_range[1] = -1
        return
      end
      if (selection_range[1] < 0)
        selection_range[0] = offset + length
        selection_range[1] = -length
      else
        selection_range[0] = offset
        selection_range[1] = length
      end
    end
    
    typesig { [ISelection, ::Java::Boolean] }
    # @see Viewer#setSelection(ISelection)
    def set_selection(selection, reveal)
      if (selection.is_a?(IBlockTextSelection) && get_text_widget.get_block_selection)
        s = selection
        begin
          start_line = s.get_start_line
          end_line = s.get_end_line
          start_line_info = @f_document.get_line_information(start_line)
          start_line_length = start_line_info.get_length
          start_virtuals = Math.max(0, s.get_start_column - start_line_length)
          end_line_info = @f_document.get_line_information(end_line)
          end_line_length = end_line_info.get_length
          end_virtuals = Math.max(0, s.get_end_column - end_line_length)
          start_region = Region.new(start_line_info.get_offset + s.get_start_column - start_virtuals, 0)
          start_offset = model_range2closest_widget_range(start_region).get_offset
          end_region = Region.new(end_line_info.get_offset + s.get_end_column - end_virtuals, 0)
          end_offset = model_range2closest_widget_range(end_region).get_offset
          client_area_origin = Point.new(@f_text_widget.get_horizontal_pixel, @f_text_widget.get_top_pixel)
          start_location = Geometry.add(client_area_origin, @f_text_widget.get_location_at_offset(start_offset))
          average_char_width = get_average_char_width
          start_location.attr_x += start_virtuals * average_char_width
          end_location = Geometry.add(client_area_origin, @f_text_widget.get_location_at_offset(end_offset))
          end_location.attr_x += end_virtuals * average_char_width
          end_location.attr_y += @f_text_widget.get_line_height(end_offset)
          widget_length = end_offset - start_offset
          widget_selection = Array.typed(::Java::Int).new([start_offset, widget_length])
          validate_selection_range(widget_selection)
          if (widget_selection[0] >= 0)
            @f_text_widget.set_block_selection_bounds(Geometry.create_rectangle(start_location, Geometry.subtract(end_location, start_location)))
            selection_changed(start_offset, widget_length)
          end
        rescue BadLocationException => e
          # fall back to linear selection mode
          set_selected_range(s.get_offset, s.get_length)
        end
        if (reveal)
          reveal_range(s.get_offset, s.get_length)
        end
      else
        if (selection.is_a?(ITextSelection))
          s = selection
          set_selected_range(s.get_offset, s.get_length)
          if (reveal)
            reveal_range(s.get_offset, s.get_length)
          end
        end
      end
    end
    
    typesig { [] }
    # @see Viewer#getSelection()
    def get_selection
      if (!(@f_text_widget).nil? && @f_text_widget.get_block_selection)
        ranges = @f_text_widget.get_selection_ranges
        start_offset = ranges[0]
        end_offset = ranges[ranges.attr_length - 2] + ranges[ranges.attr_length - 1]
        # getBlockSelectionBounds returns pixel coordinates relative to document
        bounds = @f_text_widget.get_block_selection_bounds
        client_area_x = @f_text_widget.get_horizontal_pixel
        start_x = bounds.attr_x - client_area_x
        end_x = bounds.attr_x + bounds.attr_width - client_area_x
        avg_char_width = get_average_char_width
        start_virtuals = compute_virtual_chars(start_offset, start_x, avg_char_width)
        end_virtuals = compute_virtual_chars(end_offset, end_x, avg_char_width)
        document = get_document
        model_selection = widget_selection2model_selection(Point.new(start_offset, end_offset - start_offset))
        if ((model_selection).nil?)
          return TextSelection.empty_selection
        end
        start_offset = model_selection.attr_x
        end_offset = model_selection.attr_x + model_selection.attr_y
        begin
          start_line = document.get_line_of_offset(start_offset)
          end_line = document.get_line_of_offset(end_offset)
          start_column = start_offset - document.get_line_offset(start_line) + start_virtuals
          end_column = end_offset - document.get_line_offset(end_line) + end_virtuals
          if ((start_line).equal?(-1) || (end_line).equal?(-1))
            return TextSelection.empty_selection
          end
          return BlockTextSelection.new(document, start_line, start_column, end_line, end_column, @f_text_widget.get_tabs)
        rescue BadLocationException => e
          return TextSelection.empty_selection
        end
      end
      p = get_selected_range
      if ((p.attr_x).equal?(-1) || (p.attr_y).equal?(-1))
        return TextSelection.empty_selection
      end
      return TextSelection.new(get_document, p.attr_x, p.attr_y)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
    # Returns the number of virtual characters that exist beyond the end-of-line at offset
    # <code>offset</code> for an x-coordinate <code>x</code>.
    # 
    # @param offset the non-virtual offset to consider
    # @param x the x-coordinate (relative to the client area) of the possibly virtual offset
    # @param avgCharWidth the average character width to assume for virtual spaces
    # @return the number of virtual spaces needed to reach <code>x</code> from the location of
    # <code>offset</code>, <code>0</code> if <code>x</code> points inside the text
    # @since 3.5
    def compute_virtual_chars(offset, x, avg_char_width)
      diff = x - @f_text_widget.get_location_at_offset(offset).attr_x
      return diff > 0 ? diff / avg_char_width : 0
    end
    
    typesig { [] }
    # @see ITextViewer#getSelectionProvider()
    def get_selection_provider
      return self
    end
    
    typesig { [ISelectionChangedListener] }
    # @see org.eclipse.jface.text.IPostSelectionProvider#addPostSelectionChangedListener(org.eclipse.jface.viewers.ISelectionChangedListener)
    # @since 3.0
    def add_post_selection_changed_listener(listener)
      Assert.is_not_null(listener)
      if ((@f_post_selection_changed_listeners).nil?)
        @f_post_selection_changed_listeners = ArrayList.new
      end
      if (!@f_post_selection_changed_listeners.contains(listener))
        @f_post_selection_changed_listeners.add(listener)
      end
    end
    
    typesig { [ISelectionChangedListener] }
    # @see org.eclipse.jface.text.IPostSelectionProvider#removePostSelectionChangedListener(org.eclipse.jface.viewers.ISelectionChangedListener)
    # @since 3.0
    def remove_post_selection_changed_listener(listener)
      Assert.is_not_null(listener)
      if (!(@f_post_selection_changed_listeners).nil?)
        @f_post_selection_changed_listeners.remove(listener)
        if ((@f_post_selection_changed_listeners.size).equal?(0))
          @f_post_selection_changed_listeners = nil
        end
      end
    end
    
    typesig { [] }
    # Get the text widget's display.
    # 
    # @return the display or <code>null</code> if the display cannot be retrieved or if the display is disposed
    # @since 3.0
    def get_display
      if ((@f_text_widget).nil? || @f_text_widget.is_disposed)
        return nil
      end
      display = @f_text_widget.get_display
      if (!(display).nil? && display.is_disposed)
        return nil
      end
      return display
    end
    
    typesig { [::Java::Boolean] }
    # Starts a timer to send out a post selection changed event.
    # 
    # @param fireEqualSelection <code>true</code> iff the event must be fired if the selection does not change
    # @since 3.0
    def queue_post_selection_changed(fire_equal_selection)
      display = get_display
      if ((display).nil?)
        return
      end
      @f_number_of_post_selection_changed_events[0] += 1
      display.timer_exec(get_empty_selection_changed_event_delay, Class.new(Runnable.class == Class ? Runnable : Object) do
        local_class_in TextViewer
        include_class_members TextViewer
        include Runnable if Runnable.class == Module
        
        attr_accessor :id
        alias_method :attr_id, :id
        undef_method :id
        alias_method :attr_id=, :id=
        undef_method :id=
        
        typesig { [] }
        define_method :run do
          if ((@id).equal?(self.attr_f_number_of_post_selection_changed_events[0]))
            # Check again because this is executed after the delay
            if (!(get_display).nil?)
              selection = self.attr_f_text_widget.get_selection_range
              if (!(selection).nil?)
                r = widget_range2model_range(self.class::Region.new(selection.attr_x, selection.attr_y))
                if (fire_equal_selection || (!(r).nil? && !(r == self.attr_f_last_sent_post_selection_change)) || (r).nil?)
                  self.attr_f_last_sent_post_selection_change = r
                  fire_post_selection_changed(selection.attr_x, selection.attr_y)
                end
              end
            end
          end
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          @id = 0
          super(*args)
          @id = self.attr_f_number_of_post_selection_changed_events[0]
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sends out a text selection changed event to all registered post selection changed listeners.
    # 
    # @param offset the offset of the newly selected range in the visible document
    # @param length the length of the newly selected range in the visible document
    # @since 3.0
    def fire_post_selection_changed(offset, length_)
      if (redraws)
        r = widget_range2model_range(Region.new(offset, length_))
        selection = !(r).nil? ? TextSelection.new(get_document, r.get_offset, r.get_length) : TextSelection.empty_selection
        event = SelectionChangedEvent.new(self, selection)
        fire_post_selection_changed(event)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sends out a text selection changed event to all registered listeners and
    # registers the selection changed event to be sent out to all post selection
    # listeners.
    # 
    # @param offset the offset of the newly selected range in the visible document
    # @param length the length of the newly selected range in the visible document
    def selection_changed(offset, length_)
      queue_post_selection_changed(true)
      fire_selection_changed(offset, length_)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sends out a text selection changed event to all registered listeners.
    # 
    # @param offset the offset of the newly selected range in the visible document
    # @param length the length of the newly selected range in the visible document
    # @since 3.0
    def fire_selection_changed(offset, length_)
      if (redraws)
        if (length_ < 0)
          length_ = -length_
          offset = offset + length_
        end
        r = widget_range2model_range(Region.new(offset, length_))
        if ((!(r).nil? && !(r == @f_last_sent_selection_change)) || (r).nil?)
          @f_last_sent_selection_change = r
          selection = !(r).nil? ? TextSelection.new(get_document, r.get_offset, r.get_length) : TextSelection.empty_selection
          event = SelectionChangedEvent.new(self, selection)
          fire_selection_changed(event)
        end
      end
    end
    
    typesig { [SelectionChangedEvent] }
    # Sends the given event to all registered post selection changed listeners.
    # 
    # @param event the selection event
    # @since 3.0
    def fire_post_selection_changed(event)
      listeners = @f_post_selection_changed_listeners
      if (!(listeners).nil?)
        listeners = ArrayList.new(listeners)
        i = 0
        while i < listeners.size
          l = listeners.get(i)
          l.selection_changed(event)
          i += 1
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sends out a mark selection changed event to all registered listeners.
    # 
    # @param offset the offset of the mark selection in the visible document, the offset is <code>-1</code> if the mark was cleared
    # @param length the length of the mark selection, may be negative if the caret is before the mark.
    # @since 2.0
    def mark_changed(offset, length_)
      if (redraws)
        if (!(offset).equal?(-1))
          r = widget_range2model_range(Region.new(offset, length_))
          offset = r.get_offset
          length_ = r.get_length
        end
        selection = MarkSelection.new(get_document, offset, length_)
        event = SelectionChangedEvent.new(self, selection)
        fire_selection_changed(event)
      end
    end
    
    typesig { [ITextListener] }
    # ---- Text listeners
    # 
    # @see ITextViewer#addTextListener(ITextListener)
    def add_text_listener(listener)
      Assert.is_not_null(listener)
      if ((@f_text_listeners).nil?)
        @f_text_listeners = ArrayList.new
      end
      if (!@f_text_listeners.contains(listener))
        @f_text_listeners.add(listener)
      end
    end
    
    typesig { [ITextListener] }
    # @see ITextViewer#removeTextListener(ITextListener)
    def remove_text_listener(listener)
      Assert.is_not_null(listener)
      if (!(@f_text_listeners).nil?)
        @f_text_listeners.remove(listener)
        if ((@f_text_listeners.size).equal?(0))
          @f_text_listeners = nil
        end
      end
    end
    
    typesig { [WidgetCommand] }
    # Informs all registered text listeners about the change specified by the
    # widget command. This method does not use a robust iterator.
    # 
    # @param cmd the widget command translated into a text event sent to all text listeners
    def update_text_listeners(cmd)
      text_listeners = @f_text_listeners
      if (!(text_listeners).nil?)
        text_listeners = ArrayList.new(text_listeners)
        event = cmd.attr_event
        if (event.is_a?(SlaveDocumentEvent))
          event = (event).get_master_event
        end
        e = TextEvent.new(cmd.attr_start, cmd.attr_length, cmd.attr_text, cmd.attr_preserved_text, event, redraws)
        i = 0
        while i < text_listeners.size
          l = text_listeners.get(i)
          l.text_changed(e)
          i += 1
        end
      end
    end
    
    typesig { [ITextInputListener] }
    # ---- Text input listeners
    # 
    # @see ITextViewer#addTextInputListener(ITextInputListener)
    def add_text_input_listener(listener)
      Assert.is_not_null(listener)
      if ((@f_text_input_listeners).nil?)
        @f_text_input_listeners = ArrayList.new
      end
      if (!@f_text_input_listeners.contains(listener))
        @f_text_input_listeners.add(listener)
      end
    end
    
    typesig { [ITextInputListener] }
    # @see ITextViewer#removeTextInputListener(ITextInputListener)
    def remove_text_input_listener(listener)
      Assert.is_not_null(listener)
      if (!(@f_text_input_listeners).nil?)
        @f_text_input_listeners.remove(listener)
        if ((@f_text_input_listeners.size).equal?(0))
          @f_text_input_listeners = nil
        end
      end
    end
    
    typesig { [IDocument, IDocument] }
    # Informs all registered text input listeners about the forthcoming input change,
    # This method does not use a robust iterator.
    # 
    # @param oldInput the old input document
    # @param newInput the new input document
    def fire_input_document_about_to_be_changed(old_input, new_input)
      listener = @f_text_input_listeners
      if (!(listener).nil?)
        i = 0
        while i < listener.size
          l = listener.get(i)
          l.input_document_about_to_be_changed(old_input, new_input)
          i += 1
        end
      end
    end
    
    typesig { [IDocument, IDocument] }
    # Informs all registered text input listeners about the successful input change,
    # This method does not use a robust iterator.
    # 
    # @param oldInput the old input document
    # @param newInput the new input document
    def fire_input_document_changed(old_input, new_input)
      listener = @f_text_input_listeners
      if (!(listener).nil?)
        i = 0
        while i < listener.size
          l = listener.get(i)
          l.input_document_changed(old_input, new_input)
          i += 1
        end
      end
    end
    
    typesig { [] }
    # ---- Document
    # 
    # @see Viewer#getInput()
    def get_input
      return get_document
    end
    
    typesig { [] }
    # @see ITextViewer#getDocument()
    def get_document
      return @f_document
    end
    
    typesig { [Object] }
    # @see Viewer#setInput(Object)
    def set_input(input)
      document = nil
      if (input.is_a?(IDocument))
        document = input
      end
      set_document(document)
    end
    
    typesig { [IDocument] }
    # @see ITextViewer#setDocument(IDocument)
    def set_document(document)
      @f_replace_text_presentation = true
      fire_input_document_about_to_be_changed(@f_document, document)
      old_document = @f_document
      @f_document = document
      set_visible_document(@f_document)
      reset_plugins
      input_changed(@f_document, old_document)
      fire_input_document_changed(old_document, @f_document)
      @f_last_sent_selection_change = nil
      @f_replace_text_presentation = false
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # @see ITextViewer#setDocument(IDocument, int, int)
    def set_document(document, model_range_offset, model_range_length)
      @f_replace_text_presentation = true
      fire_input_document_about_to_be_changed(@f_document, document)
      old_document = @f_document
      @f_document = document
      begin
        slave_document = create_slave_document(document)
        update_slave_document(slave_document, model_range_offset, model_range_length)
        set_visible_document(slave_document)
      rescue BadLocationException => x
        raise IllegalArgumentException.new(JFaceTextMessages.get_string("TextViewer.error.invalid_visible_region_1")) # $NON-NLS-1$
      end
      reset_plugins
      input_changed(@f_document, old_document)
      fire_input_document_changed(old_document, @f_document)
      @f_last_sent_selection_change = nil
      @f_replace_text_presentation = false
    end
    
    typesig { [IDocument] }
    # Creates a slave document for the given document if there is a slave document manager
    # associated with this viewer.
    # 
    # @param document the master document
    # @return the newly created slave document
    # @since 2.1
    def create_slave_document(document)
      manager = get_slave_document_manager
      if (!(manager).nil?)
        if (manager.is_slave_document(document))
          return document
        end
        return manager.create_slave_document(document)
      end
      return document
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # Sets the given slave document to the specified range of its master document.
    # 
    # @param visibleDocument the slave document
    # @param visibleRegionOffset the offset of the master document range
    # @param visibleRegionLength the length of the master document range
    # @return <code>true</code> if the slave has been adapted successfully
    # @throws BadLocationException in case the specified range is not valid in the master document
    # @since 2.1
    # @deprecated use <code>updateSlaveDocument</code> instead
    def update_visible_document(visible_document, visible_region_offset, visible_region_length)
      if (visible_document.is_a?(ChildDocument))
        child_document = visible_document
        document = child_document.get_parent_document
        line = document.get_line_of_offset(visible_region_offset)
        offset = document.get_line_offset(line)
        length_ = (visible_region_offset - offset) + visible_region_length
        parent_range = child_document.get_parent_document_range
        if (!(offset).equal?(parent_range.get_offset) || !(length_).equal?(parent_range.get_length))
          child_document.set_parent_document_range(offset, length_)
          return true
        end
      end
      return false
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # Updates the given slave document to show the specified range of its master document.
    # 
    # @param slaveDocument the slave document
    # @param modelRangeOffset the offset of the master document range
    # @param modelRangeLength the length of the master document range
    # @return <code>true</code> if the slave has been adapted successfully
    # @throws BadLocationException in case the specified range is not valid in the master document
    # @since 3.0
    def update_slave_document(slave_document, model_range_offset, model_range_length)
      return update_visible_document(slave_document, model_range_offset, model_range_length)
    end
    
    typesig { [] }
    # ---- View ports
    # 
    # Initializes all listeners and structures required to set up view port listeners.
    def initialize_viewport_update
      if (!(@f_viewport_guard).nil?)
        return
      end
      if (!(@f_text_widget).nil?)
        @f_viewport_guard = ViewportGuard.new_local(self)
        @f_last_top_pixel = -1
        @f_text_widget.add_key_listener(@f_viewport_guard)
        @f_text_widget.add_mouse_listener(@f_viewport_guard)
        @f_scroller = @f_text_widget.get_vertical_bar
        if (!(@f_scroller).nil?)
          @f_scroller.add_selection_listener(@f_viewport_guard)
        end
      end
    end
    
    typesig { [] }
    # Removes all listeners and structures required to set up view port listeners.
    def remove_view_port_update
      if (!(@f_text_widget).nil?)
        @f_text_widget.remove_key_listener(@f_viewport_guard)
        @f_text_widget.remove_mouse_listener(@f_viewport_guard)
        if (!(@f_scroller).nil? && !@f_scroller.is_disposed)
          @f_scroller.remove_selection_listener(@f_viewport_guard)
          @f_scroller = nil
        end
        @f_viewport_guard = nil
      end
    end
    
    typesig { [IViewportListener] }
    # @see ITextViewer#addViewportListener(IViewportListener)
    def add_viewport_listener(listener)
      if ((@f_viewport_listeners).nil?)
        @f_viewport_listeners = ArrayList.new
        initialize_viewport_update
      end
      if (!@f_viewport_listeners.contains(listener))
        @f_viewport_listeners.add(listener)
      end
    end
    
    typesig { [IViewportListener] }
    # @see ITextViewer#removeViewportListener(IVewportListener)
    def remove_viewport_listener(listener)
      if (!(@f_viewport_listeners).nil?)
        @f_viewport_listeners.remove(listener)
      end
    end
    
    typesig { [::Java::Int] }
    # Checks whether the view port changed and if so informs all registered
    # listeners about the change.
    # 
    # @param origin describes under which circumstances this method has been called.
    # 
    # @see IViewportListener
    def update_viewport_listeners(origin)
      if (redraws)
        top_pixel = @f_text_widget.get_top_pixel
        if (top_pixel >= 0 && !(top_pixel).equal?(@f_last_top_pixel))
          if (!(@f_viewport_listeners).nil?)
            i = 0
            while i < @f_viewport_listeners.size
              l = @f_viewport_listeners.get(i)
              l.viewport_changed(top_pixel)
              i += 1
            end
          end
          @f_last_top_pixel = top_pixel
        end
      end
    end
    
    typesig { [] }
    # ---- scrolling and revealing
    # 
    # @see ITextViewer#getTopIndex()
    def get_top_index
      if (!(@f_text_widget).nil?)
        top = @f_text_widget.get_top_index
        return widget_line2model_line(top)
      end
      return -1
    end
    
    typesig { [::Java::Int] }
    # @see ITextViewer#setTopIndex(int)
    def set_top_index(index)
      if (!(@f_text_widget).nil?)
        widget_line = model_line2widget_line(index)
        if ((widget_line).equal?(-1))
          widget_line = get_closest_widget_line_for_model_line(index)
        end
        if (widget_line > -1)
          @f_text_widget.set_top_index(widget_line)
          update_viewport_listeners(INTERNAL)
        end
      end
    end
    
    typesig { [] }
    # Returns the number of lines that can fully fit into the viewport. This is computed by
    # dividing the widget's client area height by the widget's line height. The result is only
    # accurate if the widget does not use variable line heights - for that reason, clients should
    # not use this method any longer and use the client area height of the text widget to find out
    # how much content fits into it.
    # 
    # @return the view port height in lines
    # @deprecated as of 3.2
    def get_visible_lines_in_viewport
      if (!(@f_text_widget).nil?)
        cl_area = @f_text_widget.get_client_area
        if (!cl_area.is_empty)
          return cl_area.attr_height / @f_text_widget.get_line_height
        end
      end
      return -1
    end
    
    typesig { [] }
    # @see ITextViewer#getBottomIndex()
    def get_bottom_index
      if ((@f_text_widget).nil?)
        return -1
      end
      widget_bottom = JFaceTextUtil.get_bottom_index(@f_text_widget)
      return widget_line2model_line(widget_bottom)
    end
    
    typesig { [] }
    # @see ITextViewer#getTopIndexStartOffset()
    def get_top_index_start_offset
      if (!(@f_text_widget).nil?)
        top = @f_text_widget.get_top_index
        begin
          top = get_visible_document.get_line_offset(top)
          return widget_offset2model_offset(top)
        rescue BadLocationException => ex
          if (TRACE_ERRORS)
            System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.getTopIndexStartOffset"))
          end # $NON-NLS-1$
        end
      end
      return -1
    end
    
    typesig { [] }
    # @see ITextViewer#getBottomIndexEndOffset()
    def get_bottom_index_end_offset
      begin
        line = get_document.get_line_information(get_bottom_index)
        bottom_end_offset = line.get_offset + line.get_length - 1
        coverage = get_model_coverage
        if ((coverage).nil?)
          return -1
        end
        coverage_end_offset = coverage.get_offset + coverage.get_length - 1
        return Math.min(coverage_end_offset, bottom_end_offset)
      rescue BadLocationException => ex
        if (TRACE_ERRORS)
          System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.getBottomIndexEndOffset"))
        end # $NON-NLS-1$
        return get_document.get_length - 1
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see ITextViewer#revealRange(int, int)
    def reveal_range(start, length_)
      if ((@f_text_widget).nil? || !redraws)
        return
      end
      model_range = Region.new(start, length_)
      widget_range = model_range2closest_widget_range(model_range)
      if (!(widget_range).nil?)
        range = Array.typed(::Java::Int).new([widget_range.get_offset, widget_range.get_length])
        validate_selection_range(range)
        if (range[0] >= 0)
          internal_reveal_range(range[0], range[0] + range[1])
        end
      else
        coverage = get_model_coverage
        cursor = ((coverage).nil? || start < coverage.get_offset) ? 0 : get_visible_document.get_length
        internal_reveal_range(cursor, cursor)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Reveals the given range of the visible document.
    # 
    # @param start the start offset of the range
    # @param end the end offset of the range
    def internal_reveal_range(start, end_)
      begin
        doc = get_visible_document
        start_line = doc.get_line_of_offset(start)
        end_line = doc.get_line_of_offset(end_)
        top = @f_text_widget.get_top_index
        if (top > -1)
          # scroll vertically
          bottom = JFaceTextUtil.get_bottom_index(@f_text_widget)
          lines = bottom - top
          # if the widget is not scrollable as it is displaying the entire content
          # setTopIndex won't have any effect.
          if (start_line >= top && start_line <= bottom && end_line >= top && end_line <= bottom)
            # do not scroll at all as it is already visible
          else
            delta = Math.max(0, lines - (end_line - start_line))
            @f_text_widget.set_top_index(start_line - delta / 3)
            update_viewport_listeners(INTERNAL)
          end
          # scroll horizontally
          if (end_line < start_line)
            end_line += start_line
            start_line = end_line - start_line
            end_line -= start_line
          end
          start_pixel = -1
          end_pixel = -1
          if (end_line > start_line)
            # reveal the beginning of the range in the start line
            extent = get_extent(start, start)
            start_pixel = extent.get_offset + @f_text_widget.get_horizontal_pixel
            end_pixel = start_pixel
          else
            extent = get_extent(start, end_)
            start_pixel = extent.get_offset + @f_text_widget.get_horizontal_pixel
            end_pixel = start_pixel + extent.get_length
          end
          visible_start = @f_text_widget.get_horizontal_pixel
          visible_end = visible_start + @f_text_widget.get_client_area.attr_width
          # scroll only if not yet visible
          if (start_pixel < visible_start || visible_end < end_pixel)
            # set buffer zone to 10 pixels
            buffer_zone = 10
            new_offset = visible_start
            visible_width = visible_end - visible_start
            selection_pixel_width = end_pixel - start_pixel
            if (start_pixel < visible_start)
              new_offset = start_pixel
            else
              if (selection_pixel_width + buffer_zone < visible_width)
                new_offset = end_pixel + buffer_zone - visible_width
              else
                new_offset = start_pixel
              end
            end
            index = ((new_offset).to_f) / ((get_average_char_width).to_f)
            @f_text_widget.set_horizontal_index(Math.round(index))
          end
        end
      rescue BadLocationException => e
        raise IllegalArgumentException.new(JFaceTextMessages.get_string("TextViewer.error.invalid_range")) # $NON-NLS-1$
      end
    end
    
    typesig { [String] }
    # Returns the width of the text when being drawn into this viewer's widget.
    # 
    # @param text the string to measure
    # @return the width of the presentation of the given string
    # @deprecated use <code>getWidthInPixels(int, int)</code> instead
    def get_width_in_pixels(text)
      gc = SwtGC.new(@f_text_widget)
      gc.set_font(@f_text_widget.get_font)
      extent = gc.text_extent(text)
      gc.dispose
      return extent.attr_x
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the region covered by the given start and end offset.
    # The result is relative to the upper left corner of the widget
    # client area.
    # 
    # @param start offset relative to the start of this viewer's view port
    # 0 <= offset <= getCharCount()
    # @param end offset relative to the start of this viewer's view port
    # 0 <= offset <= getCharCount()
    # @return the region covered by start and end offset
    def get_extent(start, end_)
      if (end_ > 0 && start < end_)
        bounds = @f_text_widget.get_text_bounds(start, end_ - 1)
        return Region.new(bounds.attr_x, bounds.attr_width)
      end
      return Region.new(@f_text_widget.get_location_at_offset(start).attr_x, 0)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the width of the representation of a text range in the
    # visible region of the viewer's document as drawn in this viewer's
    # widget.
    # 
    # @param offset the offset of the text range in the visible region
    # @param length the length of the text range in the visible region
    # @return the width of the presentation of the specified text range
    # @since 2.0
    def get_width_in_pixels(offset, length_)
      return get_extent(offset, offset + length_).get_length
    end
    
    typesig { [] }
    # Returns the average character width of this viewer's widget.
    # 
    # @return the average character width of this viewer's widget
    def get_average_char_width
      return JFaceTextUtil.get_average_char_width(get_text_widget)
    end
    
    typesig { [] }
    # @see Viewer#refresh()
    def refresh
      set_document(get_document)
    end
    
    typesig { [] }
    # ---- visible range support
    # 
    # Returns the slave document manager
    # 
    # @return the slave document manager
    # @since 2.1
    def get_slave_document_manager
      if ((@f_slave_document_manager).nil?)
        @f_slave_document_manager = create_slave_document_manager
      end
      return @f_slave_document_manager
    end
    
    typesig { [] }
    # Creates a new slave document manager. This implementation always
    # returns a <code>ChildDocumentManager</code>.
    # 
    # @return ISlaveDocumentManager
    # @since 2.1
    def create_slave_document_manager
      return ChildDocumentManager.new
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextViewer#invalidateTextPresentation()
    def invalidate_text_presentation
      if (!(@f_visible_document).nil?)
        @f_widget_command.attr_event = nil
        @f_widget_command.attr_start = 0
        @f_widget_command.attr_length = @f_visible_document.get_length
        @f_widget_command.attr_text = @f_visible_document.get
        update_text_listeners(@f_widget_command)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Invalidates the given range of the text presentation.
    # 
    # @param offset the offset of the range to be invalidated
    # @param length the length of the range to be invalidated
    # @since 2.1
    def invalidate_text_presentation(offset, length_)
      if (!(@f_visible_document).nil?)
        widget_range = model_range2widget_range(Region.new(offset, length_))
        if (!(widget_range).nil?)
          @f_widget_command.attr_event = nil
          @f_widget_command.attr_start = widget_range.get_offset
          @f_widget_command.attr_length = widget_range.get_length
          begin
            @f_widget_command.attr_text = @f_visible_document.get(widget_range.get_offset, widget_range.get_length)
            update_text_listeners(@f_widget_command)
          rescue BadLocationException => x
            # can not happen because of previous checking
          end
        end
      end
    end
    
    typesig { [] }
    # Initializes the text widget with the visual document and
    # invalidates the overall presentation.
    def initialize_widget_contents
      if (!(@f_text_widget).nil? && !(@f_visible_document).nil?)
        # set widget content
        if ((@f_document_adapter).nil?)
          @f_document_adapter = create_document_adapter
        end
        @f_document_adapter.set_document(@f_visible_document)
        @f_text_widget.set_content(@f_document_adapter)
        # invalidate presentation
        invalidate_text_presentation
      end
    end
    
    typesig { [IDocument] }
    # Frees the given document if it is a slave document.
    # 
    # @param slave the potential slave document
    # @since 3.0
    def free_slave_document(slave)
      manager = get_slave_document_manager
      if (!(manager).nil? && manager.is_slave_document(slave))
        manager.free_slave_document(slave)
      end
    end
    
    typesig { [IDocument] }
    # Sets this viewer's visible document. The visible document represents the
    # visible region of the viewer's input document.
    # 
    # @param document the visible document
    def set_visible_document(document)
      if ((@f_visible_document).equal?(document) && @f_visible_document.is_a?(ChildDocument))
        # optimization for new child documents
        return
      end
      if (!(@f_visible_document).nil?)
        if (!(@f_visible_document_listener).nil?)
          @f_visible_document.remove_document_listener(@f_visible_document_listener)
        end
        if (!(@f_visible_document).equal?(document))
          free_slave_document(@f_visible_document)
        end
      end
      @f_visible_document = document
      initialize_document_information_mapping(@f_visible_document)
      initialize_widget_contents
      @f_find_replace_document_adapter = nil
      if (!(@f_visible_document).nil? && !(@f_visible_document_listener).nil?)
        @f_visible_document.add_document_listener(@f_visible_document_listener)
      end
    end
    
    typesig { [DocumentEvent] }
    # Hook method called when the visible document is about to be changed.
    # <p>
    # Subclasses may override.
    # 
    # @param event the document event
    # @since 3.0
    def handle_visible_document_about_to_be_changed(event)
    end
    
    typesig { [DocumentEvent] }
    # Hook method called when the visible document has been changed.
    # <p>
    # Subclasses may override.
    # 
    # @param event the document event
    # @since 3.0
    def handle_visible_document_changed(event)
    end
    
    typesig { [IDocument] }
    # Initializes the document information mapping between the given slave document and
    # its master document.
    # 
    # @param visibleDocument the slave document
    # @since 2.1
    def initialize_document_information_mapping(visible_document)
      manager = get_slave_document_manager
      @f_information_mapping = (manager).nil? ? nil : manager.create_master_slave_mapping(visible_document)
    end
    
    typesig { [] }
    # Returns the viewer's visible document.
    # 
    # @return the viewer's visible document
    def get_visible_document
      return @f_visible_document
    end
    
    typesig { [] }
    # Returns the offset of the visible region.
    # 
    # @return the offset of the visible region
    def __get_visible_region_offset
      document = get_visible_document
      if (document.is_a?(ChildDocument))
        cdoc = document
        return cdoc.get_parent_document_range.get_offset
      end
      return 0
    end
    
    typesig { [] }
    # @see ITextViewer#getVisibleRegion()
    def get_visible_region
      document = get_visible_document
      if (document.is_a?(ChildDocument))
        p = (document).get_parent_document_range
        return Region.new(p.get_offset, p.get_length)
      end
      return Region.new(0, (document).nil? ? 0 : document.get_length)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see ITextViewer#overlapsWithVisibleRegion(int, int)
    def overlaps_with_visible_region(start, length_)
      document = get_visible_document
      if (document.is_a?(ChildDocument))
        cdoc = document
        return cdoc.get_parent_document_range.overlaps_with(start, length_)
      else
        if (!(document).nil?)
          size_ = document.get_length
          return (start >= 0 && length_ >= 0 && start + length_ <= size_)
        end
      end
      return false
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see ITextViewer#setVisibleRegion(int, int)
    def set_visible_region(start, length_)
      region = get_visible_region
      if ((start).equal?(region.get_offset) && (length_).equal?(region.get_length))
        # nothing to change
        return
      end
      set_redraw(false)
      begin
        slave_document = create_slave_document(get_visible_document)
        if (update_slave_document(slave_document, start, length_))
          set_visible_document(slave_document)
        end
      rescue BadLocationException => x
        raise IllegalArgumentException.new(JFaceTextMessages.get_string("TextViewer.error.invalid_visible_region_2")) # $NON-NLS-1$
      ensure
        set_redraw(true)
      end
    end
    
    typesig { [] }
    # @see ITextViewer#resetVisibleRegion()
    def reset_visible_region
      manager = get_slave_document_manager
      if (!(manager).nil?)
        slave = get_visible_document
        master = manager.get_master_document(slave)
        if (!(master).nil?)
          set_visible_document(master)
          manager.free_slave_document(slave)
        end
      end
    end
    
    typesig { [ITextDoubleClickStrategy, String] }
    # --------------------------------------
    # 
    # @see ITextViewer#setTextDoubleClickStrategy(ITextDoubleClickStrategy, String)
    def set_text_double_click_strategy(strategy, content_type)
      if (!(strategy).nil?)
        if ((@f_double_click_strategies).nil?)
          @f_double_click_strategies = HashMap.new
        end
        @f_double_click_strategies.put(content_type, strategy)
      else
        if (!(@f_double_click_strategies).nil?)
          @f_double_click_strategies.remove(content_type)
        end
      end
    end
    
    typesig { [::Java::Int, Map] }
    # Selects from the given map the one which is registered under the content type of the
    # partition in which the given offset is located.
    # 
    # @param plugins the map from which to choose
    # @param offset the offset for which to find the plug-in
    # @return the plug-in registered under the offset's content type or <code>null</code> if none
    def select_content_type_plugin(offset, plugins)
      document = get_document
      if ((document).nil?)
        return nil
      end
      begin
        return select_content_type_plugin(TextUtilities.get_content_type(document, get_document_partitioning, offset, true), plugins)
      rescue BadLocationException => x
        if (TRACE_ERRORS)
          System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.selectContentTypePlugin"))
        end # $NON-NLS-1$
      end
      return nil
    end
    
    typesig { [String, Map] }
    # Selects from the given <code>plug-ins</code> this one which is
    # registered for the given content <code>type</code>.
    # 
    # @param type the type to be used as lookup key
    # @param plugins the table to be searched
    # @return the plug-in in the map for the given content type
    def select_content_type_plugin(type, plugins)
      if ((plugins).nil?)
        return nil
      end
      return plugins.get(type)
    end
    
    typesig { [DocumentCommand] }
    # Hook called on receipt of a <code>VerifyEvent</code>. The event has
    # been translated into a <code>DocumentCommand</code> which can now be
    # manipulated by interested parties. By default, the hook forwards the command
    # to the installed instances of <code>IAutoEditStrategy</code>.
    # 
    # @param command the document command representing the verify event
    def customize_document_command(command)
      if (is_ignoring_auto_edit_strategies)
        return
      end
      document = get_document
      if (!(@f_tabs_to_spaces_converter).nil?)
        @f_tabs_to_spaces_converter.customize_document_command(document, command)
      end
      strategies = select_content_type_plugin(command.attr_offset, @f_auto_indent_strategies)
      if ((strategies).nil?)
        return
      end
      case (strategies.size)
      # optimization
      # make iterator robust against adding/removing strategies from within strategies
      when 0
      when 1
        (strategies.iterator.next_).customize_document_command(document, command)
      else
        strategies = ArrayList.new(strategies)
        iterator_ = strategies.iterator
        while iterator_.has_next
          (iterator_.next_).customize_document_command(document, command)
        end
      end
    end
    
    typesig { [VerifyEvent] }
    # Handles the verify event issued by the viewer's text widget.
    # 
    # @see VerifyListener#verifyText(VerifyEvent)
    # @param e the verify event
    def handle_verify_event(e)
      if (!(@f_event_consumer).nil?)
        @f_event_consumer.process_event(e)
        if (!e.attr_doit)
          return
        end
      end
      if (@f_text_widget.get_block_selection && ((e.attr_text).nil? || e.attr_text.length < 2))
        sel = @f_text_widget.get_selection
        if (!(@f_text_widget.get_line_at_offset(sel.attr_x)).equal?(@f_text_widget.get_line_at_offset(sel.attr_y)))
          verify_event_in_block_selection(e)
          return
        end
      end
      model_range = event2_model_range(e)
      @f_document_command.set_event(e, model_range)
      customize_document_command(@f_document_command)
      if (!@f_document_command.fill_event(e, model_range))
        compound_change = @f_document_command.get_command_count > 1
        begin
          @f_verify_listener.forward(false)
          if (compound_change && !(@f_undo_manager).nil?)
            @f_undo_manager.begin_compound_change
          end
          @f_document_command.execute(get_document)
          if (!(@f_text_widget).nil?)
            document_caret = @f_document_command.attr_caret_offset
            if ((document_caret).equal?(-1))
              # old behavior of document command
              document_caret = @f_document_command.attr_offset + ((@f_document_command.attr_text).nil? ? 0 : @f_document_command.attr_text.length)
            end
            widget_caret = model_offset2widget_offset(document_caret)
            if ((widget_caret).equal?(-1))
              # try to move it to the closest spot
              region = get_model_coverage
              if (!(region).nil?)
                if (document_caret <= region.get_offset)
                  widget_caret = 0
                else
                  if (document_caret >= region.get_offset + region.get_length)
                    widget_caret = get_visible_region.get_length
                  end
                end
              end
            end
            if (!(widget_caret).equal?(-1))
              # there is a valid widget caret
              @f_text_widget.set_caret_offset(widget_caret)
            end
            @f_text_widget.show_selection
          end
        rescue BadLocationException => x
          if (TRACE_ERRORS)
            System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.verifyText"))
          end # $NON-NLS-1$
        ensure
          if (compound_change && !(@f_undo_manager).nil?)
            @f_undo_manager.end_compound_change
          end
          @f_verify_listener.forward(true)
        end
      end
    end
    
    typesig { [VerifyEvent] }
    # Simulates typing behavior in block selection mode.
    # 
    # @param e the verify event.
    # @since 3.5
    def verify_event_in_block_selection(e)
      # Implementation Note: StyledText sends a sequence of n events
      # for a single character typed, where n is the number of affected lines. Since
      # the events share no manifest attribute to group them together or to detect the last event
      # of a sequence, we simulate the modification at the first event and veto any following
      # events with an equal event time.
      # 
      # See also bug https://bugs.eclipse.org/bugs/show_bug.cgi?id=268044
      e.attr_doit = false
      is_first = !(e.attr_time).equal?(@f_last_event_time)
      @f_last_event_time = e.attr_time
      if (is_first)
        wrap_compound_change(Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in TextViewer
          include_class_members TextViewer
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            processor = self.class::SelectionProcessor.new(@local_class_parent)
            begin
              # Use the selection instead of the event's coordinates. Is this dangerous?
              selection = get_selection
              length_ = e.attr_text.length
              if ((length_).equal?(0) && (e.attr_character).equal?(Character.new(?\0.ord)))
                # backspace in StyledText block selection mode...
                edit = processor.backspace(selection)
                edit.apply(self.attr_f_document, TextEdit::UPDATE_REGIONS)
                empty = processor.make_empty(selection, true)
                set_selection(empty)
              else
                lines = processor.get_covered_lines(selection)
                delim = self.attr_f_document.get_legal_line_delimiters[0]
                text = self.class::StringBuffer.new(lines * length_ + (lines - 1) * delim.length)
                text.append(e.attr_text)
                i = 0
                while i < lines - 1
                  text.append(delim)
                  text.append(e.attr_text)
                  i += 1
                end
                processor.do_replace(selection, text.to_s)
              end
            rescue self.class::BadLocationException => x
              if (TRACE_ERRORS)
                System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.verifyText"))
              end # $NON-NLS-1$
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
    end
    
    typesig { [] }
    # ---- text manipulation
    # 
    # Returns whether the marked region of this viewer is empty.
    # 
    # @return <code>true</code> if the marked region of this viewer is empty, otherwise <code>false</code>
    # @since 2.0
    def is_marked_region_empty
      return (@f_text_widget).nil? || (@f_mark_position).nil? || @f_mark_position.is_deleted || (model_range2widget_range(@f_mark_position)).nil?
    end
    
    typesig { [::Java::Int] }
    # @see ITextViewer#canDoOperation(int)
    def can_do_operation(operation)
      if ((@f_text_widget).nil? || !redraws)
        return false
      end
      case (operation)
      when CUT
        return is_editable && (@f_text_widget.get_selection_count > 0 || !is_marked_region_empty)
      when COPY
        return @f_text_widget.get_selection_count > 0 || !is_marked_region_empty
      when DELETE, PASTE
        return is_editable
      when SELECT_ALL
        return true
      when SHIFT_LEFT, SHIFT_RIGHT
        return is_editable && !(@f_indent_chars).nil? && are_multiple_lines_selected
      when PREFIX, STRIP_PREFIX
        return is_editable && !(@f_default_prefix_chars).nil?
      when UNDO
        return !(@f_undo_manager).nil? && @f_undo_manager.undoable
      when REDO
        return !(@f_undo_manager).nil? && @f_undo_manager.redoable
      when PRINT
        return is_printable
      end
      return false
    end
    
    typesig { [::Java::Int] }
    # @see ITextViewer#doOperation(int)
    def do_operation(operation)
      if ((@f_text_widget).nil? || !redraws)
        return
      end
      selection = nil
      case (operation)
      when UNDO
        if (!(@f_undo_manager).nil?)
          ignore_auto_edit_strategies(true)
          @f_undo_manager.undo
          ignore_auto_edit_strategies(false)
        end
      when REDO
        if (!(@f_undo_manager).nil?)
          ignore_auto_edit_strategies(true)
          @f_undo_manager.redo_
          ignore_auto_edit_strategies(false)
        end
      when CUT
        if ((@f_text_widget.get_selection_count).equal?(0))
          copy_marked_region(true)
        else
          wrap_compound_change(Class.new(Runnable.class == Class ? Runnable : Object) do
            local_class_in TextViewer
            include_class_members TextViewer
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              self.attr_f_text_widget.cut
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        selection = @f_text_widget.get_selection_range
        fire_selection_changed(selection.attr_x, selection.attr_y)
      when COPY
        if ((@f_text_widget.get_selection_count).equal?(0))
          copy_marked_region(false)
        else
          @f_text_widget.copy
        end
      when PASTE
        paste
      when DELETE
        delete
      when SELECT_ALL
        doc = get_document
        if (!(doc).nil?)
          if (@f_text_widget.get_block_selection)
            # XXX: performance hack: use 1000 for the endColumn - StyledText will not select more than what's possible in the viewport.
            set_selection(BlockTextSelection.new(doc, 0, 0, doc.get_number_of_lines - 1, 1000, @f_text_widget.get_tabs))
          else
            set_selected_range(0, doc.get_length)
          end
        end
      when SHIFT_RIGHT
        shift(false, true, false)
      when SHIFT_LEFT
        shift(false, false, false)
      when PREFIX
        shift(true, true, true)
      when STRIP_PREFIX
        shift(true, false, true)
      when PRINT
        print
      end
    end
    
    typesig { [] }
    def delete
      if (!@f_text_widget.get_block_selection)
        @f_text_widget.invoke_action(ST::DELETE_NEXT)
      else
        wrap_compound_change(Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in TextViewer
          include_class_members TextViewer
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            begin
              self.class::SelectionProcessor.new(@local_class_parent).do_delete(get_selection)
            rescue self.class::BadLocationException => e
              if (TRACE_ERRORS)
                System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.delete"))
              end # $NON-NLS-1$
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
      selection = @f_text_widget.get_selection_range
      fire_selection_changed(selection.attr_x, selection.attr_y)
    end
    
    typesig { [] }
    def paste
      # ignoreAutoEditStrategies(true);
      if (!@f_text_widget.get_block_selection)
        @f_text_widget.paste
      else
        wrap_compound_change(Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in TextViewer
          include_class_members TextViewer
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            processor = self.class::SelectionProcessor.new(@local_class_parent)
            clipboard = self.class::Clipboard.new(get_display)
            begin
              # Paste in block selection mode. If the pasted text is not a multi-line
              # text, pasting behaves like typing, i.e. the pasted text replaces
              # the selection on each line. If the pasted text is multi-line (e.g. from
              # copying a column selection), the selection is replaced, line-by-line, by
              # the corresponding contents of the pasted text. If the selection touches
              # more lines than the pasted text, the selection on the remaining lines
              # is deleted (assuming an empty text being pasted). If the pasted
              # text contains more lines than the selection, the selection is extended
              # to the succeeding lines, or more lines are added to accommodate the
              # paste operation.
              selection = get_selection
              plain_text_transfer = TextTransfer.get_instance
              contents = clipboard.get_contents(plain_text_transfer, DND::CLIPBOARD)
              to_insert = nil
              if (!(TextUtilities.index_of(self.attr_f_document.get_legal_line_delimiters, contents, 0)[0]).equal?(-1))
                # multi-line insertion
                to_insert = contents
              else
                # single-line insertion
                length_ = contents.length
                lines = processor.get_covered_lines(selection)
                delim = self.attr_f_document.get_legal_line_delimiters[0]
                text = self.class::StringBuffer.new(lines * length_ + (lines - 1) * delim.length)
                text.append(contents)
                i = 0
                while i < lines - 1
                  text.append(delim)
                  text.append(contents)
                  i += 1
                end
                to_insert = RJava.cast_to_string(text.to_s)
              end
              processor.do_replace(selection, to_insert)
            rescue self.class::BadLocationException => x
              if (TRACE_ERRORS)
                System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.paste"))
              end # $NON-NLS-1$
            ensure
              clipboard.dispose
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
      selection = @f_text_widget.get_selection_range
      fire_selection_changed(selection.attr_x, selection.attr_y)
      # ignoreAutoEditStrategies(false);
    end
    
    typesig { [Runnable] }
    # If the text widget is in {@link StyledText#getBlockSelection() block selection mode}, the
    # passed code is wrapped into a begin/endCompoundChange undo session on the
    # {@linkplain #getRewriteTarget() rewrite target}; otherwise, the runnable is executed
    # directly.
    # 
    # @param runnable the code to wrap when in block selection mode
    # @since 3.5
    def wrap_compound_change(runnable)
      if (!@f_text_widget.get_block_selection)
        runnable.run
        return
      end
      target = get_rewrite_target
      target.begin_compound_change
      begin
        runnable.run
      ensure
        target.end_compound_change
      end
    end
    
    typesig { [::Java::Boolean] }
    # Tells this viewer whether the registered auto edit strategies should be ignored.
    # 
    # @param ignore <code>true</code> if the strategies should be ignored.
    # @since 2.1
    def ignore_auto_edit_strategies(ignore)
      if ((@f_ignore_auto_indent).equal?(ignore))
        return
      end
      @f_ignore_auto_indent = ignore
      document = get_document
      if (document.is_a?(IDocumentExtension2))
        extension = document
        if (ignore)
          extension.ignore_post_notification_replaces
        else
          extension.accept_post_notification_replaces
        end
      end
    end
    
    typesig { [] }
    # Returns whether this viewer ignores the registered auto edit strategies.
    # 
    # @return <code>true</code> if the strategies are ignored
    # @since 2.1
    def is_ignoring_auto_edit_strategies
      return @f_ignore_auto_indent
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # @see ITextOperationTargetExtension#enableOperation(int, boolean)
    # @since 2.0
    def enable_operation(operation, enable)
      # NO-OP by default.
      # Will be changed to regularly disable the known operations.
    end
    
    typesig { [::Java::Boolean] }
    # Copies/cuts the marked region.
    # 
    # @param delete <code>true</code> if the region should be deleted rather than copied.
    # @since 2.0
    def copy_marked_region(delete_)
      if ((@f_text_widget).nil?)
        return
      end
      if ((@f_mark_position).nil? || @f_mark_position.is_deleted || (model_range2widget_range(@f_mark_position)).nil?)
        return
      end
      widget_mark_offset = model_offset2widget_offset(@f_mark_position.attr_offset)
      selection = @f_text_widget.get_selection
      if (selection.attr_x <= widget_mark_offset)
        @f_text_widget.set_selection(selection.attr_x, widget_mark_offset)
      else
        @f_text_widget.set_selection(widget_mark_offset, selection.attr_x)
      end
      if (delete_)
        wrap_compound_change(Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in TextViewer
          include_class_members TextViewer
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            self.attr_f_text_widget.cut
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        @f_text_widget.copy
        @f_text_widget.set_selection(selection.attr_x) # restore old cursor position
      end
    end
    
    typesig { [] }
    # Deletes the current selection. If the selection has the length 0
    # the selection is automatically extended to the right - either by 1
    # or by the length of line delimiter if at the end of a line.
    # 
    # @deprecated use <code>StyledText.invokeAction</code> instead
    def delete_text
      @f_text_widget.invoke_action(ST::DELETE_NEXT)
    end
    
    typesig { [] }
    # A block is selected if the character preceding the start of the
    # selection is a new line character.
    # 
    # @return <code>true</code> if a block is selected
    def is_block_selected
      s = get_selected_range
      if ((s.attr_y).equal?(0))
        return false
      end
      begin
        document = get_document
        line = document.get_line_of_offset(s.attr_x)
        start = document.get_line_offset(line)
        return ((s.attr_x).equal?(start))
      rescue BadLocationException => x
      end
      return false
    end
    
    typesig { [] }
    # Returns <code>true</code> if one line is completely selected or if multiple lines are selected.
    # Being completely selected means that all characters except the new line characters are
    # selected.
    # 
    # @return <code>true</code> if one or multiple lines are selected
    # @since 2.0
    def are_multiple_lines_selected
      s = get_selected_range
      if ((s.attr_y).equal?(0))
        return false
      end
      begin
        document = get_document
        start_line = document.get_line_of_offset(s.attr_x)
        end_line = document.get_line_of_offset(s.attr_x + s.attr_y)
        line = document.get_line_information(start_line)
        return !(start_line).equal?(end_line) || ((s.attr_x).equal?(line.get_offset) && (s.attr_y).equal?(line.get_length))
      rescue BadLocationException => x
      end
      return false
    end
    
    typesig { [IRegion] }
    # Returns the index of the first line whose start offset is in the given text range.
    # 
    # @param region the text range in characters where to find the line
    # @return the first line whose start index is in the given range, -1 if there is no such line
    def get_first_complete_line_of_region(region)
      begin
        d = get_document
        start_line = d.get_line_of_offset(region.get_offset)
        offset = d.get_line_offset(start_line)
        if (offset >= region.get_offset)
          return start_line
        end
        offset = d.get_line_offset(start_line + 1)
        return (offset > region.get_offset + region.get_length ? -1 : start_line + 1)
      rescue BadLocationException => x
        if (TRACE_ERRORS)
          System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.getFirstCompleteLineOfRegion"))
        end # $NON-NLS-1$
      end
      return -1
    end
    
    typesig { [ITextSelection] }
    # Creates a region describing the text block (something that starts at
    # the beginning of a line) completely containing the current selection.
    # 
    # @param selection the selection to use
    # @return the region describing the text block comprising the given selection
    # @since 2.0
    def get_text_block_from_selection(selection)
      begin
        document = get_document
        start = document.get_line_offset(selection.get_start_line)
        end_line = selection.get_end_line
        end_line_info = document.get_line_information(end_line)
        end_ = end_line_info.get_offset + end_line_info.get_length
        return Region.new(start, end_ - start)
      rescue BadLocationException => x
      end
      return nil
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # Shifts a text block to the right or left using the specified set of prefix characters.
    # The prefixes must start at the beginning of the line.
    # 
    # @param useDefaultPrefixes says whether the configured default or indent prefixes should be used
    # @param right says whether to shift to the right or the left
    # 
    # @deprecated use shift(boolean, boolean, boolean) instead
    def shift(use_default_prefixes, right)
      shift(use_default_prefixes, right, false)
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Shifts a text block to the right or left using the specified set of prefix characters.
    # If white space should be ignored the prefix characters must not be at the beginning of
    # the line when shifting to the left. There may be whitespace in front of the prefixes.
    # 
    # @param useDefaultPrefixes says whether the configured default or indent prefixes should be used
    # @param right says whether to shift to the right or the left
    # @param ignoreWhitespace says whether whitespace in front of prefixes is allowed
    # @since 2.0
    def shift(use_default_prefixes, right, ignore_whitespace)
      if (!(@f_undo_manager).nil?)
        @f_undo_manager.begin_compound_change
      end
      d = get_document
      partitioners = nil
      rewrite_session = nil
      begin
        selection = get_selection
        block = get_text_block_from_selection(selection)
        regions = TextUtilities.compute_partitioning(d, get_document_partitioning, block.get_offset, block.get_length, false)
        line_count = 0
        lines = Array.typed(::Java::Int).new(regions.attr_length * 2) { 0 } # [start line, end line, start line, end line, ...]
        i = 0
        j = 0
        while i < regions.attr_length
          # start line of region
          lines[j] = get_first_complete_line_of_region(regions[i])
          # end line of region
          length_ = regions[i].get_length
          offset = regions[i].get_offset + length_
          if (length_ > 0)
            offset -= 1
          end
          lines[j + 1] = ((lines[j]).equal?(-1) ? -1 : d.get_line_of_offset(offset))
          line_count += lines[j + 1] - lines[j] + 1
          i += 1
          j += 2
        end
        if (d.is_a?(IDocumentExtension4))
          extension = d
          rewrite_session = extension.start_rewrite_session(DocumentRewriteSessionType::SEQUENTIAL)
        else
          set_redraw(false)
          start_sequential_rewrite_mode(true)
        end
        if (line_count >= 20)
          partitioners = TextUtilities.remove_document_partitioners(d)
        end
        # Perform the shift operation.
        map = (use_default_prefixes ? @f_default_prefix_chars : @f_indent_chars)
        i_ = 0
        j_ = 0
        while i_ < regions.attr_length
          prefixes = select_content_type_plugin(regions[i_].get_type, map)
          if (!(prefixes).nil? && prefixes.attr_length > 0 && lines[j_] >= 0 && lines[j_ + 1] >= 0)
            if (right)
              shift_right(lines[j_], lines[j_ + 1], prefixes[0])
            else
              shift_left(lines[j_], lines[j_ + 1], prefixes, ignore_whitespace)
            end
          end
          i_ += 1
          j_ += 2
        end
      rescue BadLocationException => x
        if (TRACE_ERRORS)
          System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.shift_1"))
        end # $NON-NLS-1$
      ensure
        if (!(partitioners).nil?)
          TextUtilities.add_document_partitioners(d, partitioners)
        end
        if (d.is_a?(IDocumentExtension4))
          extension = d
          extension.stop_rewrite_session(rewrite_session)
        else
          stop_sequential_rewrite_mode
          set_redraw(true)
        end
        if (!(@f_undo_manager).nil?)
          @f_undo_manager.end_compound_change
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # Shifts the specified lines to the right inserting the given prefix
    # at the beginning of each line
    # 
    # @param prefix the prefix to be inserted
    # @param startLine the first line to shift
    # @param endLine the last line to shift
    # @since 2.0
    def shift_right(start_line, end_line, prefix)
      begin
        d = get_document
        while (start_line <= end_line)
          d.replace(d.get_line_offset(((start_line += 1) - 1)), 0, prefix)
        end
      rescue BadLocationException => x
        if (TRACE_ERRORS)
          System.out.println("TextViewer.shiftRight: BadLocationException")
        end # $NON-NLS-1$
      end
    end
    
    typesig { [::Java::Int, ::Java::Int, Array.typed(String), ::Java::Boolean] }
    # Shifts the specified lines to the right or to the left. On shifting to the right
    # it insert <code>prefixes[0]</code> at the beginning of each line. On shifting to the
    # left it tests whether each of the specified lines starts with one of the specified
    # prefixes and if so, removes the prefix.
    # 
    # @param startLine the first line to shift
    # @param endLine the last line to shift
    # @param prefixes the prefixes to be used for shifting
    # @param ignoreWhitespace <code>true</code> if whitespace should be ignored, <code>false</code> otherwise
    # @since 2.0
    def shift_left(start_line, end_line, prefixes, ignore_whitespace)
      d = get_document
      begin
        occurrences = Array.typed(IRegion).new(end_line - start_line + 1) { nil }
        # find all the first occurrences of prefix in the given lines
        i = 0
        while i < occurrences.attr_length
          line = d.get_line_information(start_line + i)
          text = d.get(line.get_offset, line.get_length)
          index = -1
          found = TextUtilities.index_of(prefixes, text, 0)
          if (!(found[0]).equal?(-1))
            if (ignore_whitespace)
              s = d.get(line.get_offset, found[0])
              s = RJava.cast_to_string(s.trim)
              if ((s.length).equal?(0))
                index = line.get_offset + found[0]
              end
            else
              if ((found[0]).equal?(0))
                index = line.get_offset
              end
            end
          end
          if (index > -1)
            # remember where prefix is in line, so that it can be removed
            length_ = prefixes[found[1]].length
            if ((length_).equal?(0) && !ignore_whitespace && line.get_length > 0)
              # found a non-empty line which cannot be shifted
              return
            end
            occurrences[i] = Region.new(index, length_)
          else
            # found a line which cannot be shifted
            return
          end
          i += 1
        end
        # OK - change the document
        decrement = 0
        i_ = 0
        while i_ < occurrences.attr_length
          r = occurrences[i_]
          d.replace(r.get_offset - decrement, r.get_length, "") # $NON-NLS-1$
          decrement += r.get_length
          i_ += 1
        end
      rescue BadLocationException => x
        if (TRACE_ERRORS)
          System.out.println("TextViewer.shiftLeft: BadLocationException")
        end # $NON-NLS-1$
      end
    end
    
    typesig { [] }
    # Returns whether the shown text can be printed.
    # 
    # @return the viewer's printable mode
    def is_printable
      return true # see bug https://bugs.eclipse.org/bugs/show_bug.cgi?id=250528
    end
    
    typesig { [StyledTextPrintOptions] }
    # {@inheritDoc}
    # 
    # @since 3.4
    def print(options)
      shell = @f_text_widget.get_shell
      if ((Printer.get_printer_list.attr_length).equal?(0))
        title = JFaceTextMessages.get_string("TextViewer.warning.noPrinter.title") # $NON-NLS-1$
        msg = JFaceTextMessages.get_string("TextViewer.warning.noPrinter.message") # $NON-NLS-1$
        MessageDialog.open_warning(shell, title, msg)
        return
      end
      dialog = PrintDialog.new(shell, SWT::PRIMARY_MODAL)
      data = dialog.open
      if (!(data).nil?)
        printer = Printer.new(data)
        styled_text_printer = @f_text_widget.print(printer, options)
        printing_thread = Class.new(JavaThread.class == Class ? JavaThread : Object) do
          local_class_in TextViewer
          include_class_members TextViewer
          include JavaThread if JavaThread.class == Module
          
          typesig { [] }
          # $NON-NLS-1$
          define_method :run do
            styled_text_printer.run
            printer.dispose
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self, "Printing")
        printing_thread.start
      end
    end
    
    typesig { [] }
    # Brings up a print dialog and calls <code>printContents(Printer)</code>
    # which performs the actual print.
    def print
      options = StyledTextPrintOptions.new
      options.attr_print_text_font_style = true
      options.attr_print_text_foreground = true
      print(options)
    end
    
    typesig { [] }
    # ------ find support
    # 
    # Adheres to the contract of {@link IFindReplaceTarget#canPerformFind()}.
    # 
    # @return <code>true</code> if find can be performed, <code>false</code> otherwise
    def can_perform_find
      d = get_visible_document
      return (!(@f_text_widget).nil? && !(d).nil? && d.get_length > 0)
    end
    
    typesig { [::Java::Int, String, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Adheres to the contract of {@link IFindReplaceTarget#findAndSelect(int, String, boolean, boolean, boolean)}.
    # 
    # @param startPosition the start position
    # @param findString the find string specification
    # @param forwardSearch the search direction
    # @param caseSensitive <code>true</code> if case sensitive, <code>false</code> otherwise
    # @param wholeWord <code>true</code> if match must be whole words, <code>false</code> otherwise
    # @return the model offset of the first match
    # @deprecated as of 3.0 use {@link #findAndSelect(int, String, boolean, boolean, boolean, boolean)}
    def find_and_select(start_position, find_string, forward_search, case_sensitive, whole_word)
      begin
        return find_and_select(start_position, find_string, forward_search, case_sensitive, whole_word, false)
      rescue IllegalStateException => ex
        return -1
      rescue PatternSyntaxException => ex
        return -1
      end
    end
    
    typesig { [::Java::Int, String, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Adheres to the contract of
    # {@link org.eclipse.jface.text.IFindReplaceTargetExtension3#findAndSelect(int, String, boolean, boolean, boolean, boolean)}.
    # 
    # @param startPosition the start position
    # @param findString the find string specification
    # @param forwardSearch the search direction
    # @param caseSensitive <code>true</code> if case sensitive, <code>false</code> otherwise
    # @param wholeWord <code>true</code> if matches must be whole words, <code>false</code> otherwise
    # @param regExSearch <code>true</code> if <code>findString</code> is a regular expression, <code>false</code> otherwise
    # @return the model offset of the first match
    def find_and_select(start_position, find_string, forward_search, case_sensitive, whole_word, reg_ex_search)
      if ((@f_text_widget).nil?)
        return -1
      end
      begin
        widget_offset = ((start_position).equal?(-1) ? start_position : model_offset2widget_offset(start_position))
        adapter = get_find_replace_document_adapter
        match_region = adapter.find(widget_offset, find_string, forward_search, case_sensitive, whole_word, reg_ex_search)
        if (!(match_region).nil?)
          widget_pos = match_region.get_offset
          length_ = match_region.get_length
          # Prevents setting of widget selection with line delimiters at beginning or end
          start_char = adapter.char_at(widget_pos)
          end_char = adapter.char_at(widget_pos + length_ - 1)
          border_has_line_delimiter = (start_char).equal?(Character.new(?\n.ord)) || (start_char).equal?(Character.new(?\r.ord)) || (end_char).equal?(Character.new(?\n.ord)) || (end_char).equal?(Character.new(?\r.ord))
          redraws_ = redraws
          if (border_has_line_delimiter && redraws_)
            set_redraw(false)
          end
          if (redraws)
            @f_text_widget.set_selection_range(widget_pos, length_)
            internal_reveal_range(widget_pos, widget_pos + length_)
            selection_changed(widget_pos, length_)
          else
            set_selected_range(widget_offset2model_offset(widget_pos), length_)
            if (redraws_)
              set_redraw(true)
            end
          end
          return widget_offset2model_offset(widget_pos)
        end
      rescue BadLocationException => x
        if (TRACE_ERRORS)
          System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.findAndSelect"))
        end # $NON-NLS-1$
      end
      return -1
    end
    
    typesig { [::Java::Int, String, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Adheres to the contract of {@link org.eclipse.jface.text.IFindReplaceTargetExtension3#findAndSelect(int, String, boolean, boolean, boolean, boolean)}.
    # 
    # @param startPosition the start position
    # @param findString the find string specification
    # @param forwardSearch the search direction
    # @param caseSensitive <code>true</code> if case sensitive, <code>false</code> otherwise
    # @param wholeWord <code>true</code> if matches must be whole words, <code>false</code> otherwise
    # @param rangeOffset the search scope offset
    # @param rangeLength the search scope length
    # @param regExSearch <code>true</code> if <code>findString</code> is a regular expression, <code>false</code> otherwise
    # @return the model offset of the first match
    # @since 3.0
    def find_and_select_in_range(start_position, find_string, forward_search, case_sensitive, whole_word, range_offset, range_length, reg_ex_search)
      if ((@f_text_widget).nil?)
        return -1
      end
      begin
        model_offset = 0
        if (forward_search && ((start_position).equal?(-1) || start_position < range_offset))
          model_offset = range_offset
        else
          if (!forward_search && ((start_position).equal?(-1) || start_position > range_offset + range_length))
            model_offset = range_offset + range_length
          else
            model_offset = start_position
          end
        end
        widget_offset = model_offset2widget_offset(model_offset)
        if ((widget_offset).equal?(-1))
          return -1
        end
        adapter = get_find_replace_document_adapter
        match_region = adapter.find(widget_offset, find_string, forward_search, case_sensitive, whole_word, reg_ex_search)
        widget_pos = -1
        length_ = 0
        if (!(match_region).nil?)
          widget_pos = match_region.get_offset
          length_ = match_region.get_length
        end
        model_pos = (widget_pos).equal?(-1) ? -1 : widget_offset2model_offset(widget_pos)
        if (!(widget_pos).equal?(-1) && (model_pos < range_offset || model_pos + length_ > range_offset + range_length))
          widget_pos = -1
        end
        if (widget_pos > -1)
          # Prevents setting of widget selection with line delimiters at beginning or end
          start_char = adapter.char_at(widget_pos)
          end_char = adapter.char_at(widget_pos + length_ - 1)
          border_has_line_delimiter = (start_char).equal?(Character.new(?\n.ord)) || (start_char).equal?(Character.new(?\r.ord)) || (end_char).equal?(Character.new(?\n.ord)) || (end_char).equal?(Character.new(?\r.ord))
          redraws_ = redraws
          if (border_has_line_delimiter && redraws_)
            set_redraw(false)
          end
          if (redraws)
            @f_text_widget.set_selection_range(widget_pos, length_)
            internal_reveal_range(widget_pos, widget_pos + length_)
            selection_changed(widget_pos, length_)
          else
            set_selected_range(model_pos, length_)
            if (redraws_)
              set_redraw(true)
            end
          end
          return model_pos
        end
      rescue BadLocationException => x
        if (TRACE_ERRORS)
          System.out.println(JFaceTextMessages.get_string("TextViewer.error.bad_location.findAndSelect"))
        end # $NON-NLS-1$
      end
      return -1
    end
    
    typesig { [Color] }
    # ---------- text presentation support
    # 
    # @see ITextViewer#setTextColor(Color)
    def set_text_color(color)
      if (!(color).nil?)
        set_text_color(color, 0, get_document.get_length, true)
      end
    end
    
    typesig { [Color, ::Java::Int, ::Java::Int, ::Java::Boolean] }
    # @see ITextViewer#setTextColor(Color, start, length, boolean)
    def set_text_color(color, start_, length_, control_redraw)
      if (!(@f_text_widget).nil?)
        s = StyleRange.new
        s.attr_foreground = color
        s.attr_start = start_
        s.attr_length = length_
        s = model_style_range2widget_style_range(s)
        if (!(s).nil?)
          if (control_redraw)
            @f_text_widget.set_redraw(false)
          end
          begin
            @f_text_widget.set_style_range(s)
          ensure
            if (control_redraw)
              @f_text_widget.set_redraw(true)
            end
          end
        end
      end
    end
    
    typesig { [TextPresentation] }
    # Adds the given presentation to the viewer's style information.
    # 
    # @param presentation the presentation to be added
    def add_presentation(presentation)
      range = presentation.get_default_style_range
      if (!(range).nil?)
        range = model_style_range2widget_style_range(range)
        if (!(range).nil?)
          @f_text_widget.set_style_range(range)
        end
        ranges = ArrayList.new(presentation.get_denumerable_ranges)
        e = presentation.get_non_default_style_range_iterator
        while (e.has_next)
          range = e.next_
          range = model_style_range2widget_style_range(range)
          if (!(range).nil?)
            ranges.add(range)
          end
        end
        if (!ranges.is_empty)
          @f_text_widget.replace_style_ranges(0, 0, ranges.to_array(Array.typed(StyleRange).new(ranges.size) { nil }))
        end
      else
        region = model_range2widget_range(presentation.get_coverage)
        if ((region).nil?)
          return
        end
        list = ArrayList.new(presentation.get_denumerable_ranges)
        e = presentation.get_all_style_range_iterator
        while (e.has_next)
          range = e.next_
          range = model_style_range2widget_style_range(range)
          if (!(range).nil?)
            list.add(range)
          end
        end
        if (!list.is_empty)
          ranges = Array.typed(StyleRange).new(list.size) { nil }
          list.to_array(ranges)
          @f_text_widget.replace_style_ranges(region.get_offset, region.get_length, ranges)
        end
      end
    end
    
    typesig { [TextPresentation] }
    # Applies the given presentation to the given text widget. Helper method.
    # 
    # @param presentation the style information
    # @since 2.1
    def apply_text_presentation(presentation)
      list = ArrayList.new(presentation.get_denumerable_ranges)
      e = presentation.get_all_style_range_iterator
      while (e.has_next)
        range = e.next_
        range = model_style_range2widget_style_range(range)
        if (!(range).nil?)
          list.add(range)
        end
      end
      if (!list.is_empty)
        ranges = Array.typed(StyleRange).new(list.size) { nil }
        list.to_array(ranges)
        @f_text_widget.set_style_ranges(ranges)
      end
    end
    
    typesig { [] }
    # Returns the visible region if it is not equal to the whole document.
    # Otherwise returns <code>null</code>.
    # 
    # @return the viewer's visible region if smaller than input document, otherwise <code>null</code>
    def __internal_get_visible_region
      document = get_visible_document
      if (document.is_a?(ChildDocument))
        p = (document).get_parent_document_range
        return Region.new(p.get_offset, p.get_length)
      end
      return nil
    end
    
    typesig { [TextPresentation, ::Java::Boolean] }
    # @see ITextViewer#changeTextPresentation(TextPresentation, boolean)
    def change_text_presentation(presentation, control_redraw)
      if ((presentation).nil? || !redraws)
        return
      end
      if ((@f_text_widget).nil?)
        return
      end
      # Call registered text presentation listeners
      # and let them apply their presentation.
      if (!(@f_text_presentation_listeners).nil?)
        listeners = ArrayList.new(@f_text_presentation_listeners)
        i = 0
        size_ = listeners.size
        while i < size_
          listener = listeners.get(i)
          listener.apply_text_presentation(presentation)
          i += 1
        end
      end
      if (presentation.is_empty)
        return
      end
      if (control_redraw)
        @f_text_widget.set_redraw(false)
      end
      if (@f_replace_text_presentation)
        apply_text_presentation(presentation)
      else
        add_presentation(presentation)
      end
      if (control_redraw)
        @f_text_widget.set_redraw(true)
      end
    end
    
    typesig { [] }
    # @see ITextViewer#getFindReplaceTarget()
    def get_find_replace_target
      if ((@f_find_replace_target).nil?)
        @f_find_replace_target = FindReplaceTarget.new_local(self)
      end
      return @f_find_replace_target
    end
    
    typesig { [] }
    # Returns the find/replace document adapter.
    # 
    # @return the find/replace document adapter.
    # @since 3.0
    def get_find_replace_document_adapter
      if ((@f_find_replace_document_adapter).nil?)
        @f_find_replace_document_adapter = FindReplaceDocumentAdapter.new(get_visible_document)
      end
      return @f_find_replace_document_adapter
    end
    
    typesig { [] }
    # @see ITextViewer#getTextOperationTarget()
    def get_text_operation_target
      return self
    end
    
    typesig { [VerifyKeyListener] }
    # @see ITextViewerExtension#appendVerifyKeyListener(VerifyKeyListener)
    # @since 2.0
    def append_verify_key_listener(listener)
      index = @f_verify_key_listeners_manager.number_of_listeners
      @f_verify_key_listeners_manager.insert_listener(listener, index)
    end
    
    typesig { [VerifyKeyListener] }
    # @see ITextViewerExtension#prependVerifyKeyListener(VerifyKeyListener)
    # @since 2.0
    def prepend_verify_key_listener(listener)
      @f_verify_key_listeners_manager.insert_listener(listener, 0)
    end
    
    typesig { [VerifyKeyListener] }
    # @see ITextViewerExtension#removeVerifyKeyListener(VerifyKeyListener)
    # @since 2.0
    def remove_verify_key_listener(listener)
      @f_verify_key_listeners_manager.remove_listener(listener)
    end
    
    typesig { [] }
    # @see ITextViewerExtension#getMark()
    # @since 2.0
    def get_mark
      return (@f_mark_position).nil? || @f_mark_position.is_deleted ? -1 : @f_mark_position.get_offset
    end
    
    typesig { [::Java::Int] }
    # @see ITextViewerExtension#setMark(int)
    # @since 2.0
    def set_mark(offset)
      # clear
      if ((offset).equal?(-1))
        if (!(@f_mark_position).nil? && !@f_mark_position.is_deleted)
          document = get_document
          if (!(document).nil?)
            document.remove_position(@f_mark_position)
          end
        end
        @f_mark_position = nil
        mark_changed(-1, 0)
        # set
      else
        document = get_document
        if ((document).nil?)
          @f_mark_position = nil
          return
        end
        if (!(@f_mark_position).nil?)
          document.remove_position(@f_mark_position)
        end
        @f_mark_position = nil
        begin
          position = Position.new(offset)
          document.add_position(@mark_position_category, position)
          @f_mark_position = position
        rescue BadLocationException => e
          return
        rescue BadPositionCategoryException => e
          return
        end
        mark_changed(model_offset2widget_offset(@f_mark_position.attr_offset), 0)
      end
    end
    
    typesig { [Object, Object] }
    # @see Viewer#inputChanged(Object, Object)
    # @since 2.0
    def input_changed(new_input, old_input)
      old_document = old_input
      if (!(old_document).nil?)
        if (!(@f_mark_position).nil? && !@f_mark_position.is_deleted)
          old_document.remove_position(@f_mark_position)
        end
        begin
          old_document.remove_position_updater(@f_mark_position_updater)
          old_document.remove_position_category(@mark_position_category)
        rescue BadPositionCategoryException => e
        end
      end
      @f_mark_position = nil
      if (old_document.is_a?(IDocumentExtension4))
        document = old_document
        document.remove_document_rewrite_session_listener(@f_document_rewrite_session_listener)
      end
      super(new_input, old_input)
      if (new_input.is_a?(IDocumentExtension4))
        document = new_input
        document.add_document_rewrite_session_listener(@f_document_rewrite_session_listener)
      end
      new_document = new_input
      if (!(new_document).nil?)
        new_document.add_position_category(@mark_position_category)
        new_document.add_position_updater(@f_mark_position_updater)
      end
    end
    
    typesig { [] }
    # Informs all text listeners about the change of the viewer's redraw state.
    # @since 2.0
    def fire_redraw_changed
      @f_widget_command.attr_start = 0
      @f_widget_command.attr_length = 0
      @f_widget_command.attr_text = nil
      @f_widget_command.attr_event = nil
      update_text_listeners(@f_widget_command)
    end
    
    typesig { [] }
    # Enables the redrawing of this text viewer.
    # @since 2.0
    def enabled_redrawing
      enabled_redrawing(-1)
    end
    
    typesig { [::Java::Int] }
    # Enables the redrawing of this text viewer.
    # 
    # @param topIndex the top index to be set or <code>-1</code>
    # @since 3.0
    def enabled_redrawing(top_index)
      if (@f_document_adapter.is_a?(IDocumentAdapterExtension))
        extension = @f_document_adapter
        text_widget = get_text_widget
        if (!(text_widget).nil? && !text_widget.is_disposed)
          extension.resume_forwarding_document_changes
          if (top_index > -1)
            begin
              set_top_index(top_index)
            rescue IllegalArgumentException => x
              # changes don't allow for the previous top pixel
            end
          end
        end
      end
      if (!(@f_viewer_state).nil?)
        @f_viewer_state.restore((top_index).equal?(-1))
        @f_viewer_state = nil
      end
      if (!(@f_text_widget).nil? && !@f_text_widget.is_disposed)
        @f_text_widget.set_redraw(true)
      end
      fire_redraw_changed
    end
    
    typesig { [] }
    # Disables the redrawing of this text viewer. Subclasses may extend.
    # @since 2.0
    def disable_redrawing
      if ((@f_viewer_state).nil?)
        @f_viewer_state = ViewerState.new_local(self)
      end
      if (@f_document_adapter.is_a?(IDocumentAdapterExtension))
        extension = @f_document_adapter
        extension.stop_forwarding_document_changes
      end
      if (!(@f_text_widget).nil? && !@f_text_widget.is_disposed)
        @f_text_widget.set_redraw(false)
      end
      fire_redraw_changed
    end
    
    typesig { [::Java::Boolean] }
    # @see ITextViewerExtension#setRedraw(boolean)
    # @since 2.0
    def set_redraw(redraw)
      set_redraw(redraw, -1)
    end
    
    typesig { [::Java::Boolean, ::Java::Int] }
    # Basically same functionality as <code>ITextViewerExtension.setRedraw(boolean)</code>. Adds a
    # way for subclasses to pass in a desired top index that should be used when
    # <code>redraw</code> is <code>true</code>. If <code>topIndex</code> is -1, this method is
    # identical to <code>ITextViewerExtension.setRedraw(boolean)</code>.
    # 
    # @see ITextViewerExtension#setRedraw(boolean)
    # 
    # @param redraw <code>true</code> if redraw is enabled
    # @param topIndex the top index
    # @since 3.0
    def set_redraw(redraw, top_index)
      if (!redraw)
        (@f_redraw_counter += 1)
        if ((@f_redraw_counter).equal?(1))
          disable_redrawing
        end
      else
        (@f_redraw_counter -= 1)
        if ((@f_redraw_counter).equal?(0))
          if ((top_index).equal?(-1))
            enabled_redrawing
          else
            enabled_redrawing(top_index)
          end
        end
      end
    end
    
    typesig { [] }
    # Returns whether this viewer redraws itself.
    # 
    # @return <code>true</code> if this viewer redraws itself
    # @since 2.0
    def redraws
      return @f_redraw_counter <= 0
    end
    
    typesig { [::Java::Boolean] }
    # Starts  the sequential rewrite mode of the viewer's document.
    # 
    # @param normalized <code>true</code> if the rewrite is performed from the start to the end of the document
    # @since 2.0
    # @deprecated since 3.1 use {@link IDocumentExtension4#startRewriteSession(DocumentRewriteSessionType)} instead
    def start_sequential_rewrite_mode(normalized)
      document = get_document
      if (document.is_a?(IDocumentExtension))
        extension = document
        extension.start_sequential_rewrite(normalized)
      end
    end
    
    typesig { [] }
    # Sets the sequential rewrite mode of the viewer's document.
    # 
    # @since 2.0
    # @deprecated since 3.1 use {@link IDocumentExtension4#stopRewriteSession(DocumentRewriteSession)} instead
    def stop_sequential_rewrite_mode
      document = get_document
      if (document.is_a?(IDocumentExtension))
        extension = document
        extension.stop_sequential_rewrite
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextViewerExtension#getRewriteTarget()
    # @since 2.0
    def get_rewrite_target
      if ((@f_rewrite_target).nil?)
        @f_rewrite_target = RewriteTarget.new_local(self)
      end
      return @f_rewrite_target
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextViewerExtension2#getCurrentTextHover()
    def get_current_text_hover
      if ((@f_text_hover_manager).nil?)
        return nil
      end
      return @f_text_hover_manager.get_current_text_hover
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextViewerExtension2#getHoverEventLocation()
    def get_hover_event_location
      if ((@f_text_hover_manager).nil?)
        return nil
      end
      return @f_text_hover_manager.get_hover_event_location
    end
    
    typesig { [] }
    # Returns the paint manager of this viewer.
    # 
    # @return the paint manager of this viewer
    # @since 2.1
    def get_paint_manager
      if ((@f_paint_manager).nil?)
        @f_paint_manager = PaintManager.new(self)
      end
      return @f_paint_manager
    end
    
    typesig { [IPainter] }
    # Adds the given  painter to this viewer. If the painter is already registered
    # this method is without effect.
    # 
    # @param painter the painter to be added
    # @since 2.1
    def add_painter(painter)
      get_paint_manager.add_painter(painter)
    end
    
    typesig { [IPainter] }
    # Removes the given painter from this viewer. If the painter has previously not been
    # added to this viewer this method is without effect.
    # 
    # @param painter the painter to be removed
    # @since 2.1
    def remove_painter(painter)
      get_paint_manager.remove_painter(painter)
    end
    
    typesig { [::Java::Int] }
    # ----------------------------------- conversions -------------------------------------------------------
    # 
    # Implements the contract of {@link ITextViewerExtension5#modelLine2WidgetLine(int)}.
    # 
    # @param modelLine the model line
    # @return the corresponding widget line or <code>-1</code>
    # @since 2.1
    def model_line2widget_line(model_line)
      if ((@f_information_mapping).nil?)
        return model_line
      end
      begin
        return @f_information_mapping.to_image_line(model_line)
      rescue BadLocationException => x
      end
      return -1
    end
    
    typesig { [::Java::Int] }
    # Implements the contract of {@link ITextViewerExtension5#modelOffset2WidgetOffset(int)}.
    # 
    # @param modelOffset the model offset
    # @return the corresponding widget offset or <code>-1</code>
    # @since 2.1
    def model_offset2widget_offset(model_offset)
      if ((@f_information_mapping).nil?)
        return model_offset
      end
      begin
        return @f_information_mapping.to_image_offset(model_offset)
      rescue BadLocationException => x
      end
      return -1
    end
    
    typesig { [IRegion] }
    # Implements the contract of {@link ITextViewerExtension5#modelRange2WidgetRange(IRegion)}.
    # 
    # @param modelRange the model range
    # @return the corresponding widget range or <code>null</code>
    # @since 2.1
    def model_range2widget_range(model_range)
      if ((@f_information_mapping).nil?)
        return model_range
      end
      begin
        if (model_range.get_length < 0)
          reversed = Region.new(model_range.get_offset + model_range.get_length, -model_range.get_length)
          result = @f_information_mapping.to_image_region(reversed)
          if (!(result).nil?)
            return Region.new(result.get_offset + result.get_length, -result.get_length)
          end
        end
        return @f_information_mapping.to_image_region(model_range)
      rescue BadLocationException => x
      end
      return nil
    end
    
    typesig { [IRegion] }
    # Similar to {@link #modelRange2WidgetRange(IRegion)}, but more forgiving:
    # if <code>modelRange</code> describes a region entirely hidden in the
    # image, then this method returns the zero-length region at the offset of
    # the folded region.
    # 
    # @param modelRange the model range
    # @return the corresponding widget range, or <code>null</code>
    # @since 3.1
    def model_range2closest_widget_range(model_range)
      if (!(@f_information_mapping.is_a?(IDocumentInformationMappingExtension2)))
        return model_range2widget_range(model_range)
      end
      begin
        if (model_range.get_length < 0)
          reversed = Region.new(model_range.get_offset + model_range.get_length, -model_range.get_length)
          result = (@f_information_mapping).to_closest_image_region(reversed)
          if (!(result).nil?)
            return Region.new(result.get_offset + result.get_length, -result.get_length)
          end
        end
        return (@f_information_mapping).to_closest_image_region(model_range)
      rescue BadLocationException => x
      end
      return nil
    end
    
    typesig { [::Java::Int] }
    # Implements the contract of {@link ITextViewerExtension5#widgetLine2ModelLine(int)}.
    # 
    # @param widgetLine the widget line
    # @return the corresponding model line
    # @since 2.1
    def widgetl_line2model_line(widget_line)
      return widget_line2model_line(widget_line)
    end
    
    typesig { [::Java::Int] }
    # Implements the contract of {@link ITextViewerExtension5#widgetLine2ModelLine(int)}.
    # 
    # @param widgetLine the widget line
    # @return the corresponding model line or <code>-1</code>
    # @since 3.0
    def widget_line2model_line(widget_line)
      if ((@f_information_mapping).nil?)
        return widget_line
      end
      begin
        return @f_information_mapping.to_origin_line(widget_line)
      rescue BadLocationException => x
      end
      return -1
    end
    
    typesig { [::Java::Int] }
    # Implements the contract of {@link ITextViewerExtension5#widgetOffset2ModelOffset(int)}.
    # 
    # @param widgetOffset the widget offset
    # @return the corresponding model offset or <code>-1</code>
    # @since 2.1
    def widget_offset2model_offset(widget_offset)
      if ((@f_information_mapping).nil?)
        return widget_offset
      end
      begin
        return @f_information_mapping.to_origin_offset(widget_offset)
      rescue BadLocationException => x
        if ((widget_offset).equal?(get_visible_document.get_length))
          coverage = @f_information_mapping.get_coverage
          return coverage.get_offset + coverage.get_length
        end
      end
      return -1
    end
    
    typesig { [IRegion] }
    # Implements the contract of {@link ITextViewerExtension5#widgetRange2ModelRange(IRegion)}.
    # 
    # @param widgetRange the widget range
    # @return the corresponding model range or <code>null</code>
    # @since 2.1
    def widget_range2model_range(widget_range)
      if ((@f_information_mapping).nil?)
        return widget_range
      end
      begin
        if (widget_range.get_length < 0)
          reveresed = Region.new(widget_range.get_offset + widget_range.get_length, -widget_range.get_length)
          result = @f_information_mapping.to_origin_region(reveresed)
          return Region.new(result.get_offset + result.get_length, -result.get_length)
        end
        return @f_information_mapping.to_origin_region(widget_range)
      rescue BadLocationException => x
        model_offset = widget_offset2model_offset(widget_range.get_offset)
        if (model_offset > -1)
          model_end_offset = widget_offset2model_offset(widget_range.get_offset + widget_range.get_length)
          if (model_end_offset > -1)
            return Region.new(model_offset, model_end_offset - model_offset)
          end
        end
      end
      return nil
    end
    
    typesig { [] }
    # Implements the contract of {@link ITextViewerExtension5#getModelCoverage()}.
    # 
    # @return the model coverage
    # @since 2.1
    def get_model_coverage
      if ((@f_information_mapping).nil?)
        document = get_document
        if ((document).nil?)
          return nil
        end
        return Region.new(0, document.get_length)
      end
      return @f_information_mapping.get_coverage
    end
    
    typesig { [::Java::Int] }
    # Returns the line of the widget whose corresponding line in the viewer's document
    # is closest to the given line in the viewer's document or <code>-1</code>.
    # 
    # @param modelLine the line in the viewer's document
    # @return the line in the widget that corresponds best to the given line in the viewer's document or <code>-1</code>
    # @since 2.1
    def get_closest_widget_line_for_model_line(model_line)
      if ((@f_information_mapping).nil?)
        return model_line
      end
      begin
        return @f_information_mapping.to_closest_image_line(model_line)
      rescue BadLocationException => x
      end
      return -1
    end
    
    typesig { [StyleRange] }
    # Translates a style range given relative to the viewer's document into style
    # ranges relative to the viewer's widget or <code>null</code>.
    # 
    # @param range the style range in the coordinates of the viewer's document
    # @return the style range in the coordinates of the viewer's widget or <code>null</code>
    # @since 2.1
    def model_style_range2widget_style_range(range)
      region = model_range2widget_range(Region.new(range.attr_start, range.attr_length))
      if (!(region).nil?)
        result = range.clone
        result.attr_start = region.get_offset
        result.attr_length = region.get_length
        return result
      end
      return nil
    end
    
    typesig { [Position] }
    # Same as {@link #modelRange2WidgetRange(IRegion)} just for a {@link org.eclipse.jface.text.Position}.
    # 
    # @param modelPosition the position describing a range in the viewer's document
    # @return a region describing a range in the viewer's widget
    # @since 2.1
    def model_range2widget_range(model_position)
      return model_range2widget_range(Region.new(model_position.get_offset, model_position.get_length))
    end
    
    typesig { [VerifyEvent] }
    # Translates the widget region of the given verify event into
    # the corresponding region of the viewer's document.
    # 
    # @param event the verify event
    # @return the region of the viewer's document corresponding to the verify event
    # @since 2.1
    def event2_model_range(event)
      region = nil
      if (event.attr_start <= event.attr_end)
        region = Region.new(event.attr_start, event.attr_end - event.attr_start)
      else
        region = Region.new(event.attr_end, event.attr_start - event.attr_end)
      end
      return widget_range2model_range(region)
    end
    
    typesig { [Point] }
    # Translates the given widget selection into the corresponding region
    # of the viewer's document or returns <code>null</code> if this fails.
    # 
    # @param widgetSelection the widget selection
    # @return the region of the viewer's document corresponding to the widget selection or <code>null</code>
    # @since 2.1
    def widget_selection2model_selection(widget_selection)
      region = Region.new(widget_selection.attr_x, widget_selection.attr_y)
      region = widget_range2model_range(region)
      return (region).nil? ? nil : Point.new(region.get_offset, region.get_length)
    end
    
    typesig { [Point] }
    # Translates the given selection range of the viewer's document into
    # the corresponding widget range or returns <code>null</code> of this fails.
    # 
    # @param modelSelection the selection range of the viewer's document
    # @return the widget range corresponding to the selection range or <code>null</code>
    # @since 2.1
    def model_selection2widget_selection(model_selection)
      if ((@f_information_mapping).nil?)
        return model_selection
      end
      begin
        region = Region.new(model_selection.attr_x, model_selection.attr_y)
        region = @f_information_mapping.to_image_region(region)
        if (!(region).nil?)
          return Point.new(region.get_offset, region.get_length)
        end
      rescue BadLocationException => x
      end
      return nil
    end
    
    typesig { [::Java::Int] }
    # Implements the contract of {@link ITextViewerExtension5#widgetLineOfWidgetOffset(int)}.
    # 
    # @param widgetOffset the widget offset
    # @return  the corresponding widget line or <code>-1</code>
    # @since 2.1
    def widget_line_of_widget_offset(widget_offset)
      document = get_visible_document
      if (!(document).nil?)
        begin
          return document.get_line_of_offset(widget_offset)
        rescue BadLocationException => e
        end
      end
      return -1
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.ITextViewerExtension4#moveFocusToWidgetToken()
    # @since 3.0
    def move_focus_to_widget_token
      if (@f_widget_token_keeper.is_a?(IWidgetTokenKeeperExtension))
        extension = @f_widget_token_keeper
        return extension.set_focus(self)
      end
      return false
    end
    
    typesig { [String] }
    # Sets the document partitioning of this viewer. The partitioning is used by this viewer to
    # access partitioning information of the viewers input document.
    # 
    # @param partitioning the partitioning name
    # @since 3.0
    def set_document_partitioning(partitioning)
      @f_partitioning = partitioning
    end
    
    typesig { [] }
    # Returns the document partitioning for this viewer.
    # 
    # @return the document partitioning for this viewer
    # @since 3.0
    def get_document_partitioning
      return @f_partitioning
    end
    
    typesig { [ITextPresentationListener] }
    # ---- Text presentation listeners ----
    # 
    # @see ITextViewerExtension4#addTextPresentationListener(ITextPresentationListener)
    # @since 3.0
    def add_text_presentation_listener(listener)
      Assert.is_not_null(listener)
      if ((@f_text_presentation_listeners).nil?)
        @f_text_presentation_listeners = ArrayList.new
      end
      if (!@f_text_presentation_listeners.contains(listener))
        @f_text_presentation_listeners.add(listener)
      end
    end
    
    typesig { [ITextPresentationListener] }
    # @see ITextViewerExtension4#removeTextPresentationListener(ITextPresentationListener)
    # @since 3.0
    def remove_text_presentation_listener(listener)
      Assert.is_not_null(listener)
      if (!(@f_text_presentation_listeners).nil?)
        @f_text_presentation_listeners.remove(listener)
        if ((@f_text_presentation_listeners.size).equal?(0))
          @f_text_presentation_listeners = nil
        end
      end
    end
    
    typesig { [IEditingSupport] }
    # @see org.eclipse.jface.text.IEditingSupportRegistry#registerHelper(org.eclipse.jface.text.IEditingSupport)
    # @since 3.1
    def register(helper)
      Assert.is_legal(!(helper).nil?)
      @f_editor_helpers.add(helper)
    end
    
    typesig { [IEditingSupport] }
    # @see org.eclipse.jface.text.IEditingSupportRegistry#deregisterHelper(org.eclipse.jface.text.IEditingSupport)
    # @since 3.1
    def unregister(helper)
      @f_editor_helpers.remove(helper)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IEditingSupportRegistry#getCurrentHelpers()
    # @since 3.1
    def get_registered_supports
      return @f_editor_helpers.to_array(Array.typed(IEditingSupport).new(@f_editor_helpers.size) { nil })
    end
    
    typesig { [Array.typed(IHyperlinkDetector), ::Java::Int] }
    # @see org.eclipse.jface.text.ITextViewerExtension6#setHyperlinkDetectors(org.eclipse.jface.text.hyperlink.IHyperlinkDetector[], int)
    # @since 3.1
    def set_hyperlink_detectors(hyperlink_detectors, event_state_mask)
      if (!(@f_hyperlink_detectors).nil?)
        i = 0
        while i < @f_hyperlink_detectors.attr_length
          if (@f_hyperlink_detectors[i].is_a?(IHyperlinkDetectorExtension))
            (@f_hyperlink_detectors[i]).dispose
          end
          i += 1
        end
      end
      enable = !(hyperlink_detectors).nil? && hyperlink_detectors.attr_length > 0
      @f_hyperlink_state_mask = event_state_mask
      @f_hyperlink_detectors = hyperlink_detectors
      if (enable)
        if (!(@f_hyperlink_manager).nil?)
          @f_hyperlink_manager.set_hyperlink_detectors(@f_hyperlink_detectors)
          @f_hyperlink_manager.set_hyperlink_state_mask(@f_hyperlink_state_mask)
        end
        ensure_hyperlink_manager_installed
      else
        if (!(@f_hyperlink_manager).nil?)
          @f_hyperlink_manager.uninstall
        end
        @f_hyperlink_manager = nil
      end
    end
    
    typesig { [IHyperlinkPresenter] }
    # Sets the hyperlink presenter.
    # <p>
    # This is only valid as long as the hyperlink manager hasn't
    # been created yet.
    # </p>
    # 
    # @param hyperlinkPresenter the hyperlink presenter
    # @throws IllegalStateException if the hyperlink manager has already been created
    # @since 3.1
    def set_hyperlink_presenter(hyperlink_presenter)
      if (!(@f_hyperlink_manager).nil?)
        raise IllegalStateException.new
      end
      @f_hyperlink_presenter = hyperlink_presenter
      ensure_hyperlink_manager_installed
    end
    
    typesig { [] }
    # Ensures that the hyperlink manager has been
    # installed if a hyperlink detector is available.
    # 
    # @since 3.1
    def ensure_hyperlink_manager_installed
      if (!(@f_hyperlink_detectors).nil? && @f_hyperlink_detectors.attr_length > 0 && !(@f_hyperlink_presenter).nil? && (@f_hyperlink_manager).nil?)
        strategy = @f_hyperlink_presenter.can_show_multiple_hyperlinks ? HyperlinkManager::ALL : HyperlinkManager::FIRST
        @f_hyperlink_manager = HyperlinkManager.new(strategy)
        @f_hyperlink_manager.install(self, @f_hyperlink_presenter, @f_hyperlink_detectors, @f_hyperlink_state_mask)
      end
    end
    
    typesig { [IAutoEditStrategy] }
    # @see org.eclipse.jface.text.ITextViewerExtension7#setTabsToSpacesConverter(org.eclipse.jface.text.IAutoEditStrategy)
    # @since 3.3
    def set_tabs_to_spaces_converter(converter)
      @f_tabs_to_spaces_converter = converter
    end
    
    private
    alias_method :initialize__text_viewer, :initialize
  end
  
end
