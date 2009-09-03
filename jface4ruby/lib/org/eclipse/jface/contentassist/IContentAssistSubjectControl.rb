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
  module IContentAssistSubjectControlImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Contentassist
      include_const ::Org::Eclipse::Swt::Custom, :VerifyKeyListener
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :SelectionListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IEventConsumer
    }
  end
  
  # A content assist subject control can request assistance provided by a
  # {@linkplain org.eclipse.jface.contentassist.ISubjectControlContentAssistant subject control content assistant}.
  # 
  # @since 3.0
  module IContentAssistSubjectControl
    include_class_members IContentAssistSubjectControlImports
    
    typesig { [] }
    # Returns the control of this content assist subject control.
    # 
    # @return the control of this content assist subject control
    def get_control
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the line height.
    # 
    # @return line height in pixel
    # @throws org.eclipse.swt.SWTException in these cases:
    # <ul>
    # <li>{@link org.eclipse.swt.SWT#ERROR_WIDGET_DISPOSED} - if the receiver has been
    # disposed</li>
    # <li>{@link org.eclipse.swt.SWT#ERROR_THREAD_INVALID_ACCESS} - if not called from the
    # thread that created the receiver</li>
    # </ul>
    def get_line_height
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the caret position relative to the start of the text in widget
    # coordinates.
    # 
    # @return the caret position relative to the start of the text in widget
    # coordinates
    # @throws org.eclipse.swt.SWTException in these cases:
    # <ul>
    # <li>{@link org.eclipse.swt.SWT#ERROR_WIDGET_DISPOSED} - if the receiver has been
    # disposed</li>
    # <li>{@link org.eclipse.swt.SWT#ERROR_THREAD_INVALID_ACCESS} - if not called from the
    # thread that created the receiver</li>
    # </ul>
    def get_caret_offset
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the x, y location of the upper left corner of the character
    # bounding box at the specified offset in the text. The point is relative
    # to the upper left corner of the widget client area.
    # 
    # @param offset widget offset relative to the start of the content 0
    # <= offset <= getCharCount()
    # @return x, y location of the upper left corner of the character bounding
    # box at the specified offset in the text
    # @throws org.eclipse.swt.SWTException in these cases:
    # <ul>
    # <li>{@link org.eclipse.swt.SWT#ERROR_WIDGET_DISPOSED} - if the receiver has been disposed</li>
    # <li>{@link org.eclipse.swt.SWT#ERROR_THREAD_INVALID_ACCESS} - if not called from the thread that created the receiver</li>
    # </ul>
    # @exception IllegalArgumentException when the offset is outside the valid range
    def get_location_at_offset(offset)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the line delimiter used for entering new lines by key down or
    # paste operation.
    # 
    # @return line delimiter used for entering new lines by key down or paste
    # operation
    # @throws org.eclipse.swt.SWTException in these cases:
    # <ul>
    # <li>{@link org.eclipse.swt.SWT#ERROR_WIDGET_DISPOSED} - if the receiver has been disposed</li>
    # <li>{@link org.eclipse.swt.SWT#ERROR_THREAD_INVALID_ACCESS} - if not called from the thread that created the receiver</li>
    # </ul>
    def get_line_delimiter
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the selected range in the subject's widget.
    # 
    # @return start and length of the selection, x is the offset of the
    # @throws org.eclipse.swt.SWTException in these cases:
    # <ul>
    # <li>{@link org.eclipse.swt.SWT#ERROR_WIDGET_DISPOSED} - if the receiver has been disposed</li>
    # <li>{@link org.eclipse.swt.SWT#ERROR_THREAD_INVALID_ACCESS} - if not called from the thread that created the receiver</li>
    # </ul>
    def get_widget_selection_range
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the selected range.
    # 
    # @return start and length of the selection, x is the offset and y the
    # length based on the subject's model (e.g. document)
    def get_selected_range
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Sets the selected range. Offset and length based on the subject's
    # model (e.g. document).
    # 
    # @param offset the offset of the selection based on the subject's model e.g. document
    # @param length the length of the selection based on the subject's model e.g. document
    def set_selected_range(offset, length)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Reveals the given region. Offset and length based on the subject's
    # model (e.g. document).
    # 
    # @param offset the offset of the selection based on the subject's model e.g. document
    # @param length the length of the selection based on the subject's model e.g. document
    def reveal_range(offset, length)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns this content assist subject control's document.
    # 
    # @return the viewer's input document
    def get_document
      raise NotImplementedError
    end
    
    typesig { [VerifyKeyListener] }
    # If supported, appends a verify key listener to the viewer's list of verify key
    # listeners. If the listener is already registered with the viewer this
    # call moves the listener to the end of the list.
    # <p>
    # Note: This content assist subject control may not support appending a verify
    # listener, in which case <code>false</code> will be returned. If this
    # content assist subject control only supports <code>addVerifyKeyListener</code>
    # then this method can be used but <code>prependVerifyKeyListener</code>
    # must return <code>false</code>.
    # </p>
    # 
    # @param verifyKeyListener the listener to be added
    # @return <code>true</code> if the listener was added
    def append_verify_key_listener(verify_key_listener)
      raise NotImplementedError
    end
    
    typesig { [VerifyKeyListener] }
    # If supported, inserts the verify key listener at the beginning of this content assist
    # subject's list of verify key listeners. If the listener is already
    # registered with the viewer this call moves the listener to the beginning
    # of the list.
    # <p>
    # Note: This content assist subject control may not support prepending a verify
    # listener, in which case <code>false</code> will be returned. However,
    # {@link #appendVerifyKeyListener(VerifyKeyListener)} might work.
    # </p>
    # 
    # @param verifyKeyListener the listener to be inserted
    # @return <code>true</code> if the listener was added
    def prepend_verify_key_listener(verify_key_listener)
      raise NotImplementedError
    end
    
    typesig { [VerifyKeyListener] }
    # Removes the verify key listener from this content assist subject control's
    # list of verify key listeners. If the listener is not registered, this
    # call has no effect.
    # 
    # @param verifyKeyListener the listener to be removed
    def remove_verify_key_listener(verify_key_listener)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tests whether a verify key listener can be added either using <code>prependVerifyKeyListener</code>
    # or {@link #appendVerifyKeyListener(VerifyKeyListener)}.
    # 
    # @return <code>true</code> if adding verify key listeners is supported
    def supports_verify_key_listener
      raise NotImplementedError
    end
    
    typesig { [KeyListener] }
    # Adds the listener to the collection of listeners who will be notified
    # when keys are pressed and released on the system keyboard, by sending it
    # one of the messages defined in the {@link KeyListener} interface.
    # 
    # @param keyListener the listener which should be notified
    # @exception IllegalArgumentException if the listener is <code>null</code>
    # @throws org.eclipse.swt.SWTException in these cases:
    # <ul>
    # <li>{@link org.eclipse.swt.SWT#ERROR_WIDGET_DISPOSED} - if the receiver has been disposed</li>
    # <li>{@link org.eclipse.swt.SWT#ERROR_THREAD_INVALID_ACCESS} - if not called from the thread that created the receiver</li>
    # </ul>
    # 
    # @see KeyListener
    # @see #removeKeyListener(KeyListener)
    def add_key_listener(key_listener)
      raise NotImplementedError
    end
    
    typesig { [KeyListener] }
    # Removes the listener from the collection of listeners who will be
    # notified when keys are pressed and released on the system keyboard.
    # 
    # @param keyListener the listener which should be notified
    # @exception IllegalArgumentException if the listener is null</li>
    # @throws org.eclipse.swt.SWTException in these cases:
    # <ul>
    # <li>{@link org.eclipse.swt.SWT#ERROR_WIDGET_DISPOSED} - if the receiver has been disposed</li>
    # <li>{@link org.eclipse.swt.SWT#ERROR_THREAD_INVALID_ACCESS} - if not called from the thread that created the receiver</li>
    # </ul>
    # @see KeyListener
    # @see #addKeyListener(KeyListener)
    def remove_key_listener(key_listener)
      raise NotImplementedError
    end
    
    typesig { [IEventConsumer] }
    # If supported, registers an event consumer with this content assist
    # subject.
    # 
    # @param eventConsumer the content assist subject control's event consumer. <code>null</code>
    # is a valid argument.
    def set_event_consumer(event_consumer)
      raise NotImplementedError
    end
    
    typesig { [SelectionListener] }
    # Removes the specified selection listener.
    # <p>
    # 
    # @param selectionListener the listener
    # @exception org.eclipse.swt.SWTException <ul>
    # <ul>
    # <li>{@link org.eclipse.swt.SWT#ERROR_WIDGET_DISPOSED} - if the receiver has been disposed</li>
    # <li>{@link org.eclipse.swt.SWT#ERROR_THREAD_INVALID_ACCESS} - if not called from the thread that created the receiver</li>
    # </ul>
    # @exception IllegalArgumentException if listener is <code>null</code>
    def remove_selection_listener(selection_listener)
      raise NotImplementedError
    end
    
    typesig { [SelectionListener] }
    # If supported, adds a selection listener. A Selection event is sent by the widget when the
    # selection has changed.
    # <p>
    # 
    # @param selectionListener the listener
    # @return <code>true</code> if adding a selection listener is supported
    # <ul>
    # <li>{@link org.eclipse.swt.SWT#ERROR_WIDGET_DISPOSED} - if the receiver has been disposed</li>
    # <li>{@link org.eclipse.swt.SWT#ERROR_THREAD_INVALID_ACCESS} - if not called from the thread that created the receiver</li>
    # </ul>
    # @exception IllegalArgumentException if listener is <code>null</code>
    def add_selection_listener(selection_listener)
      raise NotImplementedError
    end
  end
  
end
