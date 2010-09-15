require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module TextViewerUndoManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Core::Commands, :ExecutionException
      include_const ::Org::Eclipse::Core::Commands::Operations, :IUndoContext
      include_const ::Org::Eclipse::Text::Undo, :DocumentUndoEvent
      include_const ::Org::Eclipse::Text::Undo, :DocumentUndoManager
      include_const ::Org::Eclipse::Text::Undo, :DocumentUndoManagerRegistry
      include_const ::Org::Eclipse::Text::Undo, :IDocumentUndoListener
      include_const ::Org::Eclipse::Text::Undo, :IDocumentUndoManager
      include_const ::Org::Eclipse::Jface::Dialogs, :MessageDialog
    }
  end
  
  # Implementation of {@link org.eclipse.jface.text.IUndoManager} using the shared
  # document undo manager.
  # <p>
  # It registers with the connected text viewer as text input listener, and obtains
  # its undo manager from the current document.  It also monitors mouse and keyboard
  # activities in order to partition the stream of text changes into undo-able
  # edit commands.
  # <p>
  # This class is not intended to be subclassed.
  # </p>
  # 
  # @see ITextViewer
  # @see ITextInputListener
  # @see IDocumentUndoManager
  # @see MouseListener
  # @see KeyListener
  # @see DocumentUndoManager
  # 
  # @since 3.2
  # @noextend This class is not intended to be subclassed by clients.
  class TextViewerUndoManager 
    include_class_members TextViewerUndoManagerImports
    include IUndoManager
    include IUndoManagerExtension
    
    class_module.module_eval {
      # Internal listener to mouse and key events.
      const_set_lazy(:KeyAndMouseListener) { Class.new do
        local_class_in TextViewerUndoManager
        include_class_members TextViewerUndoManager
        include MouseListener
        include KeyListener
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDoubleClick
        def mouse_double_click(e)
        end
        
        typesig { [class_self::MouseEvent] }
        # If the right mouse button is pressed, the current editing command is closed
        # @see MouseListener#mouseDown
        def mouse_down(e)
          if ((e.attr_button).equal?(1))
            if (is_connected)
              self.attr_f_document_undo_manager.commit
            end
          end
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseUp
        def mouse_up(e)
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyPressed
        def key_released(e)
        end
        
        typesig { [class_self::KeyEvent] }
        # On cursor keys, the current editing command is closed
        # @see KeyListener#keyPressed
        def key_pressed(e)
          case (e.attr_key_code)
          when SWT::ARROW_UP, SWT::ARROW_DOWN, SWT::ARROW_LEFT, SWT::ARROW_RIGHT
            if (is_connected)
              self.attr_f_document_undo_manager.commit
            end
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__key_and_mouse_listener, :initialize
      end }
      
      # Internal text input listener.
      const_set_lazy(:TextInputListener) { Class.new do
        local_class_in TextViewerUndoManager
        include_class_members TextViewerUndoManager
        include ITextInputListener
        
        typesig { [class_self::IDocument, class_self::IDocument] }
        # @see org.eclipse.jface.text.ITextInputListener#inputDocumentAboutToBeChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
        def input_document_about_to_be_changed(old_input, new_input)
          disconnect_document_undo_manager
        end
        
        typesig { [class_self::IDocument, class_self::IDocument] }
        # @see org.eclipse.jface.text.ITextInputListener#inputDocumentChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
        def input_document_changed(old_input, new_input)
          connect_document_undo_manager(new_input)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__text_input_listener, :initialize
      end }
      
      # Internal document undo listener.
      const_set_lazy(:DocumentUndoListener) { Class.new do
        local_class_in TextViewerUndoManager
        include_class_members TextViewerUndoManager
        include IDocumentUndoListener
        
        typesig { [class_self::DocumentUndoEvent] }
        # @see org.eclipse.jface.text.IDocumentUndoListener#documentUndoNotification(DocumentUndoEvent)
        def document_undo_notification(event)
          if (!is_connected)
            return
          end
          event_type = event.get_event_type
          if ((!((event_type & DocumentUndoEvent::ABOUT_TO_UNDO)).equal?(0)) || (!((event_type & DocumentUndoEvent::ABOUT_TO_REDO)).equal?(0)))
            if (event.is_compound)
              extension = nil
              if (self.attr_f_text_viewer.is_a?(self.class::ITextViewerExtension))
                extension = self.attr_f_text_viewer
              end
              if (!(extension).nil?)
                extension.set_redraw(false)
              end
            end
            self.attr_f_text_viewer.get_text_widget.get_display.sync_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
              local_class_in DocumentUndoListener
              include_class_members DocumentUndoListener
              include class_self::Runnable if class_self::Runnable.class == Module
              
              typesig { [] }
              define_method :run do
                if (self.attr_f_text_viewer.is_a?(self.class::TextViewer))
                  (self.attr_f_text_viewer).ignore_auto_edit_strategies(true)
                end
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          else
            if ((!((event_type & DocumentUndoEvent::UNDONE)).equal?(0)) || (!((event_type & DocumentUndoEvent::REDONE)).equal?(0)))
              self.attr_f_text_viewer.get_text_widget.get_display.sync_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
                local_class_in DocumentUndoListener
                include_class_members DocumentUndoListener
                include class_self::Runnable if class_self::Runnable.class == Module
                
                typesig { [] }
                define_method :run do
                  if (self.attr_f_text_viewer.is_a?(self.class::TextViewer))
                    (self.attr_f_text_viewer).ignore_auto_edit_strategies(false)
                  end
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
              if (event.is_compound)
                extension = nil
                if (self.attr_f_text_viewer.is_a?(self.class::ITextViewerExtension))
                  extension = self.attr_f_text_viewer
                end
                if (!(extension).nil?)
                  extension.set_redraw(true)
                end
              end
              # Reveal the change if this manager's viewer has the focus.
              if (!(self.attr_f_text_viewer).nil?)
                widget = self.attr_f_text_viewer.get_text_widget
                if (!(widget).nil? && !widget.is_disposed && (widget.is_focus_control))
                  # || fTextViewer.getTextWidget() == control))
                  select_and_reveal(event.get_offset, (event.get_text).nil? ? 0 : event.get_text.length)
                end
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__document_undo_listener, :initialize
      end }
    }
    
    # The internal key and mouse event listener
    attr_accessor :f_key_and_mouse_listener
    alias_method :attr_f_key_and_mouse_listener, :f_key_and_mouse_listener
    undef_method :f_key_and_mouse_listener
    alias_method :attr_f_key_and_mouse_listener=, :f_key_and_mouse_listener=
    undef_method :f_key_and_mouse_listener=
    
    # The internal text input listener
    attr_accessor :f_text_input_listener
    alias_method :attr_f_text_input_listener, :f_text_input_listener
    undef_method :f_text_input_listener
    alias_method :attr_f_text_input_listener=, :f_text_input_listener=
    undef_method :f_text_input_listener=
    
    # The text viewer the undo manager is connected to
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    # The undo level
    attr_accessor :f_undo_level
    alias_method :attr_f_undo_level, :f_undo_level
    undef_method :f_undo_level
    alias_method :attr_f_undo_level=, :f_undo_level=
    undef_method :f_undo_level=
    
    # The document undo manager that is active.
    attr_accessor :f_document_undo_manager
    alias_method :attr_f_document_undo_manager, :f_document_undo_manager
    undef_method :f_document_undo_manager
    alias_method :attr_f_document_undo_manager=, :f_document_undo_manager=
    undef_method :f_document_undo_manager=
    
    # The document that is active.
    attr_accessor :f_document
    alias_method :attr_f_document, :f_document
    undef_method :f_document
    alias_method :attr_f_document=, :f_document=
    undef_method :f_document=
    
    # The document undo listener
    attr_accessor :f_document_undo_listener
    alias_method :attr_f_document_undo_listener, :f_document_undo_listener
    undef_method :f_document_undo_listener
    alias_method :attr_f_document_undo_listener=, :f_document_undo_listener=
    undef_method :f_document_undo_listener=
    
    typesig { [::Java::Int] }
    # Creates a new undo manager who remembers the specified number of edit commands.
    # 
    # @param undoLevel the length of this manager's history
    def initialize(undo_level)
      @f_key_and_mouse_listener = nil
      @f_text_input_listener = nil
      @f_text_viewer = nil
      @f_undo_level = 0
      @f_document_undo_manager = nil
      @f_document = nil
      @f_document_undo_listener = nil
      @f_undo_level = undo_level
    end
    
    typesig { [] }
    # Returns whether this undo manager is connected to a text viewer.
    # 
    # @return <code>true</code> if connected, <code>false</code> otherwise
    def is_connected
      return !(@f_text_viewer).nil? && !(@f_document_undo_manager).nil?
    end
    
    typesig { [] }
    # @see IUndoManager#beginCompoundChange
    def begin_compound_change
      if (is_connected)
        @f_document_undo_manager.begin_compound_change
      end
    end
    
    typesig { [] }
    # @see IUndoManager#endCompoundChange
    def end_compound_change
      if (is_connected)
        @f_document_undo_manager.end_compound_change
      end
    end
    
    typesig { [] }
    # Registers all necessary listeners with the text viewer.
    def add_listeners
      text = @f_text_viewer.get_text_widget
      if (!(text).nil?)
        @f_key_and_mouse_listener = KeyAndMouseListener.new_local(self)
        text.add_mouse_listener(@f_key_and_mouse_listener)
        text.add_key_listener(@f_key_and_mouse_listener)
        @f_text_input_listener = TextInputListener.new_local(self)
        @f_text_viewer.add_text_input_listener(@f_text_input_listener)
      end
    end
    
    typesig { [] }
    # Unregister all previously installed listeners from the text viewer.
    def remove_listeners
      text = @f_text_viewer.get_text_widget
      if (!(text).nil?)
        if (!(@f_key_and_mouse_listener).nil?)
          text.remove_mouse_listener(@f_key_and_mouse_listener)
          text.remove_key_listener(@f_key_and_mouse_listener)
          @f_key_and_mouse_listener = nil
        end
        if (!(@f_text_input_listener).nil?)
          @f_text_viewer.remove_text_input_listener(@f_text_input_listener)
          @f_text_input_listener = nil
        end
      end
    end
    
    typesig { [String, JavaException] }
    # Shows the given exception in an error dialog.
    # 
    # @param title the dialog title
    # @param ex the exception
    def open_error_dialog(title, ex)
      shell = nil
      if (is_connected)
        st = @f_text_viewer.get_text_widget
        if (!(st).nil? && !st.is_disposed)
          shell = st.get_shell
        end
      end
      if (!(Display.get_current).nil?)
        MessageDialog.open_error(shell, title, ex.get_localized_message)
      else
        display = nil
        final_shell = shell
        if (!(final_shell).nil?)
          display = final_shell.get_display
        else
          display = Display.get_default
        end
        display.sync_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in TextViewerUndoManager
          include_class_members TextViewerUndoManager
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            MessageDialog.open_error(final_shell, title, ex.get_localized_message)
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
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IUndoManager#setMaximalUndoLevel(int)
    def set_maximal_undo_level(undo_level)
      @f_undo_level = Math.max(0, undo_level)
      if (is_connected)
        @f_document_undo_manager.set_maximal_undo_level(@f_undo_level)
      end
    end
    
    typesig { [ITextViewer] }
    # @see org.eclipse.jface.text.IUndoManager#connect(org.eclipse.jface.text.ITextViewer)
    def connect(text_viewer)
      if ((@f_text_viewer).nil? && !(text_viewer).nil?)
        @f_text_viewer = text_viewer
        add_listeners
      end
      doc = @f_text_viewer.get_document
      connect_document_undo_manager(doc)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManager#disconnect()
    def disconnect
      if (!(@f_text_viewer).nil?)
        remove_listeners
        @f_text_viewer = nil
      end
      disconnect_document_undo_manager
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManager#reset()
    def reset
      if (is_connected)
        @f_document_undo_manager.reset
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManager#redoable()
    def redoable
      if (is_connected)
        return @f_document_undo_manager.redoable
      end
      return false
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManager#undoable()
    def undoable
      if (is_connected)
        return @f_document_undo_manager.undoable
      end
      return false
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManager#redo()
    def redo_
      if (is_connected)
        begin
          @f_document_undo_manager.redo_
        rescue ExecutionException => ex
          open_error_dialog(JFaceTextMessages.get_string("DefaultUndoManager.error.redoFailed.title"), ex) # $NON-NLS-1$
        end
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManager#undo()
    def undo
      if (is_connected)
        begin
          @f_document_undo_manager.undo
        rescue ExecutionException => ex
          open_error_dialog(JFaceTextMessages.get_string("DefaultUndoManager.error.undoFailed.title"), ex) # $NON-NLS-1$
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Selects and reveals the specified range.
    # 
    # @param offset the offset of the range
    # @param length the length of the range
    def select_and_reveal(offset, length)
      if (@f_text_viewer.is_a?(ITextViewerExtension5))
        extension = @f_text_viewer
        extension.expose_model_range(Region.new(offset, length))
      else
        if (!@f_text_viewer.overlaps_with_visible_region(offset, length))
          @f_text_viewer.reset_visible_region
        end
      end
      @f_text_viewer.set_selected_range(offset, length)
      @f_text_viewer.reveal_range(offset, length)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IUndoManagerExtension#getUndoContext()
    def get_undo_context
      if (is_connected)
        return @f_document_undo_manager.get_undo_context
      end
      return nil
    end
    
    typesig { [IDocument] }
    def connect_document_undo_manager(document)
      disconnect_document_undo_manager
      if (!(document).nil?)
        @f_document = document
        DocumentUndoManagerRegistry.connect(@f_document)
        @f_document_undo_manager = DocumentUndoManagerRegistry.get_document_undo_manager(@f_document)
        @f_document_undo_manager.connect(self)
        set_maximal_undo_level(@f_undo_level)
        @f_document_undo_listener = DocumentUndoListener.new_local(self)
        @f_document_undo_manager.add_document_undo_listener(@f_document_undo_listener)
      end
    end
    
    typesig { [] }
    def disconnect_document_undo_manager
      if (!(@f_document_undo_manager).nil?)
        @f_document_undo_manager.disconnect(self)
        DocumentUndoManagerRegistry.disconnect(@f_document)
        @f_document_undo_manager.remove_document_undo_listener(@f_document_undo_listener)
        @f_document_undo_listener = nil
        @f_document_undo_manager = nil
      end
    end
    
    private
    alias_method :initialize__text_viewer_undo_manager, :initialize
  end
  
end
