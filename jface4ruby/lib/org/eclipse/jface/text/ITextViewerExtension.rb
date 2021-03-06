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
  module ITextViewerExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt::Custom, :VerifyKeyListener
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.ITextViewer}.
  # <p>
  # This extension interface replaces the event consumer mechanism (
  # {@link org.eclipse.jface.text.ITextViewer#setEventConsumer(IEventConsumer)})
  # with a set of methods that allow to manage a sequence of
  # {@link org.eclipse.swt.custom.VerifyKeyListener}objects. It also adds
  # <ul>
  # <li>access to the control of this viewer</li>
  # <li>marked region support as in emacs</li>
  # <li>control of the viewer's redraw behavior by introducing
  # <code>setRedraw(boolean)</code>
  # <li>access to the viewer's rewrite target.
  # </ul>
  # 
  # A rewrite target ({@link org.eclipse.jface.text.IRewriteTarget}) represents
  # an facade offering the necessary methods to manipulate a document that is the
  # input document of a text viewer.
  # 
  # @since 2.0
  module ITextViewerExtension
    include_class_members ITextViewerExtensionImports
    
    typesig { [VerifyKeyListener] }
    # Inserts the verify key listener at the beginning of the viewer's list of
    # verify key listeners. If the listener is already registered with the
    # viewer this call moves the listener to the beginning of the list.
    # 
    # @param listener the listener to be inserted
    def prepend_verify_key_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [VerifyKeyListener] }
    # Appends a verify key listener to the viewer's list of verify key
    # listeners. If the listener is already registered with the viewer this
    # call moves the listener to the end of the list.
    # 
    # @param listener the listener to be added
    def append_verify_key_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [VerifyKeyListener] }
    # Removes the verify key listener from the viewer's list of verify key listeners.
    # If the listener is not registered with this viewer, this call has no effect.
    # 
    # @param listener the listener to be removed
    def remove_verify_key_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the control of this viewer.
    # 
    # @return the control of this viewer
    def get_control
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Sets a mark at the given offset or clears the mark if the specified
    # offset is <code>-1</code>. If a mark is set and the selection is
    # empty, cut and copy actions performed on this text viewer work on the
    # region described by the positions of the mark and the cursor.
    # 
    # @param offset the offset of the mark
    def set_mark(offset)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the position of the mark, <code>-1</code> if the mark is not set.
    # 
    # @return the position of the mark or <code>-1</code> if no mark is set
    def get_mark
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Enables/disables the redrawing of this text viewer. This temporarily
    # disconnects the viewer from its underlying
    # {@link org.eclipse.swt.custom.StyledText}widget. While being
    # disconnected only the viewer's selection may be changed using
    # <code>setSelectedRange</code>. Any direct manipulation of the widget
    # as well as calls to methods that change the viewer's presentation state
    # (such as enabling the segmented view) are not allowed. When redrawing is
    # disabled the viewer does not send out any selection or view port change
    # notification. When redrawing is enabled again, a selection change
    # notification is sent out for the selected range and this range is
    # revealed causing a view port changed notification.
    # 
    # @param redraw <code>true</code> to enable redrawing, <code>false</code>
    # otherwise
    def set_redraw(redraw)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the viewer's rewrite target.
    # 
    # @return the viewer's rewrite target
    def get_rewrite_target
      raise NotImplementedError
    end
  end
  
end
