require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Contentassist
  module ComboContentAssistSubjectAdapterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Contentassist
      include_const ::Java::Util, :HashMap
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :ModifyEvent
      include_const ::Org::Eclipse::Swt::Events, :ModifyListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Combo
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :Document
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # Adapts a {@link org.eclipse.swt.widgets.Combo} to a {@link org.eclipse.jface.contentassist.IContentAssistSubjectControl}.
  # 
  # <p>
  # Known issues:
  # <ul>
  # <li>https://bugs.eclipse.org/bugs/show_bug.cgi?id=50121
  # = &gt; Combo doesn't get Arrow_up/Down keys on GTK</li>
  # 
  # <li>https://bugs.eclipse.org/bugs/show_bug.cgi?id=50123
  # = &gt; Combo broken on MacOS X</li>
  # </ul>
  # </p>
  # 
  # @since 3.0
  # @deprecated As of 3.2, replaced by Platform UI's field assist support
  class ComboContentAssistSubjectAdapter < ComboContentAssistSubjectAdapterImports.const_get :AbstractControlContentAssistSubjectAdapter
    include_class_members ComboContentAssistSubjectAdapterImports
    
    class_module.module_eval {
      # The document of {@link #fCombo}'s contents.
      const_set_lazy(:InternalDocument) { Class.new(Document) do
        extend LocalClass
        include_class_members ComboContentAssistSubjectAdapter
        
        # Updates this document with changes in {@link #fCombo}.
        attr_accessor :f_modify_listener
        alias_method :attr_f_modify_listener, :f_modify_listener
        undef_method :f_modify_listener
        alias_method :attr_f_modify_listener=, :f_modify_listener=
        undef_method :f_modify_listener=
        
        typesig { [] }
        def initialize
          @f_modify_listener = nil
          super(self.attr_f_combo.get_text)
          @f_modify_listener = Class.new(self.class::ModifyListener.class == Class ? self.class::ModifyListener : Object) do
            extend LocalClass
            include_class_members InternalDocument
            include class_self::ModifyListener if class_self::ModifyListener.class == Module
            
            typesig { [class_self::ModifyEvent] }
            # @see org.eclipse.swt.events.ModifyListener#modifyText(org.eclipse.swt.events.ModifyEvent)
            define_method :modify_text do |e|
              set(self.attr_f_combo.get_text)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
          self.attr_f_combo.add_modify_listener(@f_modify_listener)
        end
        
        typesig { [::Java::Int, ::Java::Int, String] }
        # @see org.eclipse.jface.text.AbstractDocument#replace(int, int, java.lang.String)
        def replace(pos, length, text)
          super(pos, length, text)
          self.attr_f_combo.remove_modify_listener(@f_modify_listener)
          self.attr_f_combo.set_text(get)
          self.attr_f_combo.add_modify_listener(@f_modify_listener)
        end
        
        private
        alias_method :initialize__internal_document, :initialize
      end }
    }
    
    # The combo widget.
    attr_accessor :f_combo
    alias_method :attr_f_combo, :f_combo
    undef_method :f_combo
    alias_method :attr_f_combo=, :f_combo=
    undef_method :f_combo=
    
    attr_accessor :f_modify_listeners
    alias_method :attr_f_modify_listeners, :f_modify_listeners
    undef_method :f_modify_listeners
    alias_method :attr_f_modify_listeners=, :f_modify_listeners=
    undef_method :f_modify_listeners=
    
    typesig { [Combo] }
    # Creates a content assist subject control adapter for the given combo.
    # 
    # @param combo the combo to adapt
    def initialize(combo)
      @f_combo = nil
      @f_modify_listeners = nil
      super()
      Assert.is_not_null(combo)
      @f_combo = combo
      @f_modify_listeners = HashMap.new
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#getControl()
    def get_control
      return @f_combo
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#getLineHeight()
    def get_line_height
      return @f_combo.get_text_height
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#getCaretOffset()
    def get_caret_offset
      return @f_combo.get_selection.attr_y
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#getLocationAtOffset(int)
    def get_location_at_offset(offset)
      combo_string = @f_combo.get_text
      gc = GC.new(@f_combo)
      gc.set_font(@f_combo.get_font)
      extent = gc.text_extent(combo_string.substring(0, Math.min(offset, combo_string.length)))
      space_width = gc.text_extent(" ").attr_x # $NON-NLS-1$
      gc.dispose
      # XXX: the two space widths below is a workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=44072
      x = 2 * space_width + @f_combo.get_client_area.attr_x + @f_combo.get_border_width + extent.attr_x
      return Point.new(x, @f_combo.get_client_area.attr_y)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#getSelectionRange()
    def get_widget_selection_range
      return Point.new(@f_combo.get_selection.attr_x, Math.abs(@f_combo.get_selection.attr_y - @f_combo.get_selection.attr_x))
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#getSelectedRange()
    def get_selected_range
      return Point.new(@f_combo.get_selection.attr_x, Math.abs(@f_combo.get_selection.attr_y - @f_combo.get_selection.attr_x))
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#getDocument()
    def get_document
      document = @f_combo.get_data("document") # $NON-NLS-1$
      if ((document).nil?)
        document = InternalDocument.new_local(self)
        @f_combo.set_data("document", document) # $NON-NLS-1$
      end
      return document
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#setSelectedRange(int, int)
    def set_selected_range(i, j)
      @f_combo.set_selection(Point.new(i, i + j))
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#revealRange(int, int)
    def reveal_range(i, j)
      # XXX: this should be improved
      @f_combo.set_selection(Point.new(i, i + j))
    end
    
    typesig { [SelectionListener] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#addSelectionListener(org.eclipse.swt.events.SelectionListener)
    def add_selection_listener(selection_listener)
      @f_combo.add_selection_listener(selection_listener)
      listener = Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members ComboContentAssistSubjectAdapter
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        # @see org.eclipse.swt.events.ModifyListener#modifyText(org.eclipse.swt.events.ModifyEvent)
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
      @f_combo.add_listener(SWT::Modify, listener)
      @f_modify_listeners.put(selection_listener, listener)
      return true
    end
    
    typesig { [SelectionListener] }
    # @see org.eclipse.jface.text.contentassist.IContentAssistSubjectControl#removeSelectionListener(org.eclipse.swt.events.SelectionListener)
    def remove_selection_listener(selection_listener)
      @f_combo.remove_selection_listener(selection_listener)
      listener = @f_modify_listeners.get(selection_listener)
      if (listener.is_a?(Listener))
        @f_combo.remove_listener(SWT::Modify, listener)
      end
    end
    
    private
    alias_method :initialize__combo_content_assist_subject_adapter, :initialize
  end
  
end
