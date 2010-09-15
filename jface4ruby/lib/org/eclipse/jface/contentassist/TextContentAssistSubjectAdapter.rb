require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Contentassist
  module TextContentAssistSubjectAdapterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Contentassist
      include_const ::Java::Util, :HashMap
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :ModifyEvent
      include_const ::Org::Eclipse::Swt::Events, :ModifyListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Text
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :Document
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # Adapts a {@link org.eclipse.swt.widgets.Text} to an {@link org.eclipse.jface.contentassist.IContentAssistSubjectControl}.
  # 
  # @see org.eclipse.swt.widgets.Text
  # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl
  # @since 3.0
  # @deprecated As of 3.2, replaced by Platform UI's field assist support
  class TextContentAssistSubjectAdapter < TextContentAssistSubjectAdapterImports.const_get :AbstractControlContentAssistSubjectAdapter
    include_class_members TextContentAssistSubjectAdapterImports
    
    class_module.module_eval {
      # The document backing this adapter's text widget.
      const_set_lazy(:InternalDocument) { Class.new(Document) do
        local_class_in TextContentAssistSubjectAdapter
        include_class_members TextContentAssistSubjectAdapter
        
        # Updates this document with changes in this adapter's text widget.
        attr_accessor :f_modify_listener
        alias_method :attr_f_modify_listener, :f_modify_listener
        undef_method :f_modify_listener
        alias_method :attr_f_modify_listener=, :f_modify_listener=
        undef_method :f_modify_listener=
        
        typesig { [] }
        def initialize
          @f_modify_listener = nil
          super(self.attr_f_text.get_text)
          @f_modify_listener = Class.new(self.class::ModifyListener.class == Class ? self.class::ModifyListener : Object) do
            local_class_in InternalDocument
            include_class_members InternalDocument
            include class_self::ModifyListener if class_self::ModifyListener.class == Module
            
            typesig { [class_self::ModifyEvent] }
            # @see org.eclipse.swt.events.ModifyListener#modifyText(org.eclipse.swt.events.ModifyEvent)
            define_method :modify_text do |e|
              set(self.attr_f_text.get_text)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
          self.attr_f_text.add_modify_listener(@f_modify_listener)
        end
        
        typesig { [::Java::Int, ::Java::Int, String] }
        # @see org.eclipse.jface.text.AbstractDocument#replace(int, int, java.lang.String)
        def replace(pos, length, text)
          super(pos, length, text)
          self.attr_f_text.remove_modify_listener(@f_modify_listener)
          self.attr_f_text.set_text(get)
          self.attr_f_text.add_modify_listener(@f_modify_listener)
        end
        
        private
        alias_method :initialize__internal_document, :initialize
      end }
    }
    
    # The text.
    attr_accessor :f_text
    alias_method :attr_f_text, :f_text
    undef_method :f_text
    alias_method :attr_f_text=, :f_text=
    undef_method :f_text=
    
    # The modify listeners.
    attr_accessor :f_modify_listeners
    alias_method :attr_f_modify_listeners, :f_modify_listeners
    undef_method :f_modify_listeners
    alias_method :attr_f_modify_listeners=, :f_modify_listeners=
    undef_method :f_modify_listeners=
    
    typesig { [Text] }
    # Creates a content assist subject control adapter for the given text widget.
    # 
    # @param text the text widget to adapt
    def initialize(text)
      @f_text = nil
      @f_modify_listeners = nil
      super()
      @f_modify_listeners = HashMap.new
      Assert.is_not_null(text)
      @f_text = text
    end
    
    typesig { [] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#getControl()
    def get_control
      return @f_text
    end
    
    typesig { [] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#getLineHeight()
    def get_line_height
      return @f_text.get_line_height
    end
    
    typesig { [] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#getCaretOffset()
    def get_caret_offset
      return @f_text.get_caret_position
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#getLocationAtOffset(int)
    def get_location_at_offset(offset)
      caret_location = @f_text.get_caret_location
      # XXX: workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=52520
      caret_location.attr_y += 2
      return caret_location
    end
    
    typesig { [] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#getWidgetSelectionRange()
    def get_widget_selection_range
      return Point.new(@f_text.get_selection.attr_x, Math.abs(@f_text.get_selection.attr_y - @f_text.get_selection.attr_x))
    end
    
    typesig { [] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#getSelectedRange()
    def get_selected_range
      return Point.new(@f_text.get_selection.attr_x, Math.abs(@f_text.get_selection.attr_y - @f_text.get_selection.attr_x))
    end
    
    typesig { [] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#getDocument()
    def get_document
      document = @f_text.get_data("document") # $NON-NLS-1$
      if ((document).nil?)
        document = InternalDocument.new_local(self)
        @f_text.set_data("document", document) # $NON-NLS-1$
      end
      return document
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#setSelectedRange(int, int)
    def set_selected_range(i, j)
      @f_text.set_selection(Point.new(i, i + j))
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#revealRange(int, int)
    def reveal_range(i, j)
      # XXX: this should be improved
      @f_text.set_selection(Point.new(i, i + j))
    end
    
    typesig { [SelectionListener] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#addSelectionListener(org.eclipse.swt.events.SelectionListener)
    def add_selection_listener(selection_listener)
      @f_text.add_selection_listener(selection_listener)
      listener = Class.new(Listener.class == Class ? Listener : Object) do
        local_class_in TextContentAssistSubjectAdapter
        include_class_members TextContentAssistSubjectAdapter
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        # @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
        define_method :handle_event do |e|
          selection_listener.widget_selected(self.class::SelectionEvent.new(e))
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @f_text.add_listener(SWT::Modify, listener)
      @f_modify_listeners.put(selection_listener, listener)
      return true
    end
    
    typesig { [SelectionListener] }
    # @see org.eclipse.jface.contentassist.IContentAssistSubjectControl#removeSelectionListener(org.eclipse.swt.events.SelectionListener)
    def remove_selection_listener(selection_listener)
      @f_text.remove_selection_listener(selection_listener)
      listener = @f_modify_listeners.get(selection_listener)
      if (listener.is_a?(Listener))
        @f_text.remove_listener(SWT::Modify, listener)
      end
    end
    
    private
    alias_method :initialize__text_content_assist_subject_adapter, :initialize
  end
  
end
