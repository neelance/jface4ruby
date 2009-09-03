require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module PaintManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionChangedListener
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionProvider
      include_const ::Org::Eclipse::Jface::Viewers, :SelectionChangedEvent
    }
  end
  
  # Manages the {@link org.eclipse.jface.text.IPainter} object registered with an
  # {@link org.eclipse.jface.text.ITextViewer}.
  # <p>
  # Clients usually instantiate and configure objects of this type.</p>
  # 
  # @since 2.1
  class PaintManager 
    include_class_members PaintManagerImports
    include KeyListener
    include MouseListener
    include ISelectionChangedListener
    include ITextListener
    include ITextInputListener
    
    class_module.module_eval {
      # Position updater used by the position manager. This position updater differs from the default position
      # updater in that it extends a position when an insertion happens at the position's offset and right behind
      # the position.
      const_set_lazy(:PaintPositionUpdater) { Class.new(DefaultPositionUpdater) do
        include_class_members PaintManager
        
        typesig { [String] }
        # Creates the position updater for the given category.
        # 
        # @param category the position category
        def initialize(category)
          super(category)
        end
        
        typesig { [] }
        # If an insertion happens at a position's offset, the
        # position is extended rather than shifted. Also, if something is added
        # right behind the end of the position, the position is extended rather
        # than kept stable.
        def adapt_to_insert
          my_start = self.attr_f_position.attr_offset
          my_end = self.attr_f_position.attr_offset + self.attr_f_position.attr_length
          my_end = Math.max(my_start, my_end)
          yours_start = self.attr_f_offset
          yours_end = self.attr_f_offset + self.attr_f_replace_length # - 1;
          yours_end = Math.max(yours_start, yours_end)
          if (my_end < yours_start)
            return
          end
          if (my_start <= yours_start)
            self.attr_f_position.attr_length += self.attr_f_replace_length
          else
            self.attr_f_position.attr_offset += self.attr_f_replace_length
          end
        end
        
        private
        alias_method :initialize__paint_position_updater, :initialize
      end }
      
      # The paint position manager used by this paint manager. The paint position
      # manager is installed on a single document and control the creation/disposed
      # and updating of a position category that will be used for managing positions.
      const_set_lazy(:PositionManager) { Class.new do
        include_class_members PaintManager
        include IPaintPositionManager
        
        # /** The document this position manager works on */
        attr_accessor :f_document
        alias_method :attr_f_document, :f_document
        undef_method :f_document
        alias_method :attr_f_document=, :f_document=
        undef_method :f_document=
        
        # The position updater used for the managing position category
        attr_accessor :f_position_updater
        alias_method :attr_f_position_updater, :f_position_updater
        undef_method :f_position_updater
        alias_method :attr_f_position_updater=, :f_position_updater=
        undef_method :f_position_updater=
        
        # The managing position category
        attr_accessor :f_category
        alias_method :attr_f_category, :f_category
        undef_method :f_category
        alias_method :attr_f_category=, :f_category=
        undef_method :f_category=
        
        typesig { [] }
        # Creates a new position manager. Initializes the managing
        # position category using its class name and its hash value.
        def initialize
          @f_document = nil
          @f_position_updater = nil
          @f_category = nil
          @f_category = RJava.cast_to_string(get_class.get_name + hash_code)
          @f_position_updater = self.class::PaintPositionUpdater.new(@f_category)
        end
        
        typesig { [class_self::IDocument] }
        # Installs this position manager in the given document. The position manager stays
        # active until <code>uninstall</code> or <code>dispose</code>
        # is called.
        # 
        # @param document the document to be installed on
        def install(document)
          @f_document = document
          @f_document.add_position_category(@f_category)
          @f_document.add_position_updater(@f_position_updater)
        end
        
        typesig { [] }
        # Disposes this position manager. The position manager is automatically
        # removed from the document it has previously been installed
        # on.
        def dispose
          uninstall(@f_document)
        end
        
        typesig { [class_self::IDocument] }
        # Uninstalls this position manager form the given document. If the position
        # manager has no been installed on this document, this method is without effect.
        # 
        # @param document the document form which to uninstall
        def uninstall(document)
          if ((document).equal?(@f_document) && !(document).nil?)
            begin
              @f_document.remove_position_updater(@f_position_updater)
              @f_document.remove_position_category(@f_category)
            rescue self.class::BadPositionCategoryException => x
              # should not happen
            end
            @f_document = nil
          end
        end
        
        typesig { [class_self::Position] }
        # @see IPositionManager#addManagedPosition(Position)
        def manage_position(position)
          begin
            @f_document.add_position(@f_category, position)
          rescue self.class::BadPositionCategoryException => x
            # should not happen
          rescue self.class::BadLocationException => x
            # should not happen
          end
        end
        
        typesig { [class_self::Position] }
        # @see IPositionManager#removeManagedPosition(Position)
        def unmanage_position(position)
          begin
            @f_document.remove_position(@f_category, position)
          rescue self.class::BadPositionCategoryException => x
            # should not happen
          end
        end
        
        private
        alias_method :initialize__position_manager, :initialize
      end }
    }
    
    # The painters managed by this paint manager.
    attr_accessor :f_painters
    alias_method :attr_f_painters, :f_painters
    undef_method :f_painters
    alias_method :attr_f_painters=, :f_painters=
    undef_method :f_painters=
    
    # The position manager used by this paint manager
    attr_accessor :f_manager
    alias_method :attr_f_manager, :f_manager
    undef_method :f_manager
    alias_method :attr_f_manager=, :f_manager=
    undef_method :f_manager=
    
    # The associated text viewer
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    typesig { [ITextViewer] }
    # Creates a new paint manager for the given text viewer.
    # 
    # @param textViewer the text viewer associated to this newly created paint manager
    def initialize(text_viewer)
      @f_painters = ArrayList.new(2)
      @f_manager = nil
      @f_text_viewer = nil
      @f_text_viewer = text_viewer
    end
    
    typesig { [IPainter] }
    # Adds the given painter to the list of painters managed by this paint manager.
    # If the painter is already registered with this paint manager, this method is
    # without effect.
    # 
    # @param painter the painter to be added
    def add_painter(painter)
      if (!@f_painters.contains(painter))
        @f_painters.add(painter)
        if ((@f_painters.size).equal?(1))
          install
        end
        painter.set_position_manager(@f_manager)
        painter.paint(IPainter::INTERNAL)
      end
    end
    
    typesig { [IPainter] }
    # Removes the given painter from the list of painters managed by this
    # paint manager. If the painter has not previously been added to this
    # paint manager, this method is without effect.
    # 
    # @param painter the painter to be removed
    def remove_painter(painter)
      if (@f_painters.remove(painter))
        painter.deactivate(true)
        painter.set_position_manager(nil)
      end
      if ((@f_painters.size).equal?(0))
        dispose
      end
    end
    
    typesig { [] }
    # Installs/activates this paint manager. Is called as soon as the
    # first painter is to be managed by this paint manager.
    def install
      @f_manager = PositionManager.new
      if (!(@f_text_viewer.get_document).nil?)
        @f_manager.install(@f_text_viewer.get_document)
      end
      @f_text_viewer.add_text_input_listener(self)
      add_listeners
    end
    
    typesig { [] }
    # Installs our listener set on the text viewer and the text widget,
    # respectively.
    def add_listeners
      provider = @f_text_viewer.get_selection_provider
      provider.add_selection_changed_listener(self)
      @f_text_viewer.add_text_listener(self)
      text = @f_text_viewer.get_text_widget
      text.add_key_listener(self)
      text.add_mouse_listener(self)
    end
    
    typesig { [] }
    # Disposes this paint manager. The paint manager uninstalls itself
    # and clears all registered painters. This method is also called when the
    # last painter is removed from the list of managed painters.
    def dispose
      if (!(@f_manager).nil?)
        @f_manager.dispose
        @f_manager = nil
      end
      e = @f_painters.iterator
      while e.has_next
        (e.next_).dispose
      end
      @f_painters.clear
      @f_text_viewer.remove_text_input_listener(self)
      remove_listeners
    end
    
    typesig { [] }
    # Removes our set of listeners from the text viewer and widget,
    # respectively.
    def remove_listeners
      provider = @f_text_viewer.get_selection_provider
      if (!(provider).nil?)
        provider.remove_selection_changed_listener(self)
      end
      @f_text_viewer.remove_text_listener(self)
      text = @f_text_viewer.get_text_widget
      if (!(text).nil? && !text.is_disposed)
        text.remove_key_listener(self)
        text.remove_mouse_listener(self)
      end
    end
    
    typesig { [::Java::Int] }
    # Triggers all registered painters for the given reason.
    # 
    # @param reason the reason
    # @see IPainter
    def paint(reason)
      e = @f_painters.iterator
      while e.has_next
        (e.next_).paint(reason)
      end
    end
    
    typesig { [KeyEvent] }
    # @see KeyListener#keyPressed(KeyEvent)
    def key_pressed(e)
      paint(IPainter::KEY_STROKE)
    end
    
    typesig { [KeyEvent] }
    # @see KeyListener#keyReleased(KeyEvent)
    def key_released(e)
    end
    
    typesig { [MouseEvent] }
    # @see MouseListener#mouseDoubleClick(MouseEvent)
    def mouse_double_click(e)
    end
    
    typesig { [MouseEvent] }
    # @see MouseListener#mouseDown(MouseEvent)
    def mouse_down(e)
      paint(IPainter::MOUSE_BUTTON)
    end
    
    typesig { [MouseEvent] }
    # @see MouseListener#mouseUp(MouseEvent)
    def mouse_up(e)
    end
    
    typesig { [SelectionChangedEvent] }
    # @see ISelectionChangedListener#selectionChanged(SelectionChangedEvent)
    def selection_changed(event)
      paint(IPainter::SELECTION)
    end
    
    typesig { [TextEvent] }
    # @see ITextListener#textChanged(TextEvent)
    def text_changed(event)
      if (!event.get_viewer_redraw_state)
        return
      end
      control = @f_text_viewer.get_text_widget
      if (!(control).nil?)
        control.get_display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
          extend LocalClass
          include_class_members PaintManager
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            if (!(self.attr_f_text_viewer).nil?)
              paint(IPainter::TEXT_CHANGE)
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
    
    typesig { [IDocument, IDocument] }
    # @see ITextInputListener#inputDocumentAboutToBeChanged(IDocument, IDocument)
    def input_document_about_to_be_changed(old_input, new_input)
      if (!(old_input).nil?)
        e = @f_painters.iterator
        while e.has_next
          (e.next_).deactivate(false)
        end
        @f_manager.uninstall(old_input)
        remove_listeners
      end
    end
    
    typesig { [IDocument, IDocument] }
    # @see ITextInputListener#inputDocumentChanged(IDocument, IDocument)
    def input_document_changed(old_input, new_input)
      if (!(new_input).nil?)
        @f_manager.install(new_input)
        paint(IPainter::TEXT_CHANGE)
        add_listeners
      end
    end
    
    private
    alias_method :initialize__paint_manager, :initialize
  end
  
end
