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
  module TextEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # This event is sent to implementers of
  # {@link org.eclipse.jface.text.ITextListener}. It represents a change applied
  # to text viewer. The change is specified as a replace command using offset,
  # length, inserted text, and replaced text. The text viewer issues a text event
  # after the viewer has been changed either in response to a change of the
  # viewer's document or when the viewer's visual content has been changed. In
  # the first case, the text event also carries the original document event.
  # Depending on the viewer's presentation mode, the text event coordinates are
  # different from the document event's coordinates.
  # <p>
  # An empty text event usually indicates a change of the viewer's redraw state.</p>
  # <p>
  # Clients other than text viewer's don't create instances of this class.</p>
  # 
  # @see org.eclipse.jface.text.ITextListener
  # @see org.eclipse.jface.text.ITextViewer
  # @see org.eclipse.jface.text.DocumentEvent
  class TextEvent 
    include_class_members TextEventImports
    
    # Start offset of the change
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    # The length of the change
    attr_accessor :f_length
    alias_method :attr_f_length, :f_length
    undef_method :f_length
    alias_method :attr_f_length=, :f_length=
    undef_method :f_length=
    
    # Inserted text
    attr_accessor :f_text
    alias_method :attr_f_text, :f_text
    undef_method :f_text
    alias_method :attr_f_text=, :f_text=
    undef_method :f_text=
    
    # Replaced text
    attr_accessor :f_replaced_text
    alias_method :attr_f_replaced_text, :f_replaced_text
    undef_method :f_replaced_text
    alias_method :attr_f_replaced_text=, :f_replaced_text=
    undef_method :f_replaced_text=
    
    # The original document event, may by null
    attr_accessor :f_document_event
    alias_method :attr_f_document_event, :f_document_event
    undef_method :f_document_event
    alias_method :attr_f_document_event=, :f_document_event=
    undef_method :f_document_event=
    
    # The redraw state of the viewer issuing this event
    # @since 2.0
    attr_accessor :f_viewer_redraw_state
    alias_method :attr_f_viewer_redraw_state, :f_viewer_redraw_state
    undef_method :f_viewer_redraw_state
    alias_method :attr_f_viewer_redraw_state=, :f_viewer_redraw_state=
    undef_method :f_viewer_redraw_state=
    
    typesig { [::Java::Int, ::Java::Int, String, String, DocumentEvent, ::Java::Boolean] }
    # Creates a new <code>TextEvent</code> based on the specification.
    # 
    # @param offset the offset
    # @param length the length
    # @param text the inserted text
    # @param replacedText the replaced text
    # @param event the associated document event or <code>null</code> if none
    # @param viewerRedrawState the redraw state of the viewer
    def initialize(offset, length, text, replaced_text, event, viewer_redraw_state)
      @f_offset = 0
      @f_length = 0
      @f_text = nil
      @f_replaced_text = nil
      @f_document_event = nil
      @f_viewer_redraw_state = false
      @f_offset = offset
      @f_length = length
      @f_text = text
      @f_replaced_text = replaced_text
      @f_document_event = event
      @f_viewer_redraw_state = viewer_redraw_state
    end
    
    typesig { [] }
    # Returns the offset of the event.
    # 
    # @return the offset of the event
    def get_offset
      return @f_offset
    end
    
    typesig { [] }
    # Returns the length of the event.
    # 
    # @return the length of the event
    def get_length
      return @f_length
    end
    
    typesig { [] }
    # Returns the text of the event.
    # 
    # @return the text of the event
    def get_text
      return @f_text
    end
    
    typesig { [] }
    # Returns the text replaced by this event.
    # 
    # @return the text replaced by this event
    def get_replaced_text
      return @f_replaced_text
    end
    
    typesig { [] }
    # Returns the corresponding document event that caused the viewer change
    # 
    # @return the corresponding document event, <code>null</code> if a visual change only
    def get_document_event
      return @f_document_event
    end
    
    typesig { [] }
    # Returns the viewer's redraw state.
    # 
    # @return <code>true</code> if the viewer's redraw state is <code>true</code>
    # @since 2.0
    def get_viewer_redraw_state
      return @f_viewer_redraw_state
    end
    
    private
    alias_method :initialize__text_event, :initialize
  end
  
end
