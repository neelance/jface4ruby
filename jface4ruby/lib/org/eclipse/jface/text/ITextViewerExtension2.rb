require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module ITextViewerExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt::Graphics, :Point
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.ITextViewer}.
  # <p>
  # It provides
  # <ul>
  # <li>text presentation invalidation enhancements</li>
  # <li>text hover management enhancements</li>
  # <li>a replacement for auto indent strategies</li>
  # <li>support for custom painters</li>
  # </ul>
  # 
  # It extends the means for text presentation invalidation by allowing a
  # specific region of the presentation to get invalidated. It replaces
  # {@link org.eclipse.jface.text.ITextViewer#setTextHover(ITextHover, String)}
  # with a new method that allows to specify state masks for a better control of
  # the hover behavior.
  # <p>
  # An {@link org.eclipse.jface.text.IAutoEditStrategy} is a generalization of
  # the original {@link org.eclipse.jface.text.IAutoIndentStrategy}. Auto edit
  # strategies can be arranged in a list that is executed like a pipeline when
  # the viewer content is changed.
  # <p>
  # A {@link org.eclipse.jface.text.IPainter}is creating and managing visual
  # decorations on the viewer's text widget. Viewer's can have an open number of
  # painters. Painters are informed about changes to the viewer content and state
  # and can take the necessary action in responds to the notification.
  # 
  # @since 2.1
  module ITextViewerExtension2
    include_class_members ITextViewerExtension2Imports
    
    class_module.module_eval {
      # The state mask of the default hover (value <code>0xff</code>).
      const_set_lazy(:DEFAULT_HOVER_STATE_MASK) { 0xff }
      const_attr_reader  :DEFAULT_HOVER_STATE_MASK
    }
    
    typesig { [::Java::Int, ::Java::Int] }
    # Invalidates the viewer's text presentation for the given range.
    # 
    # @param offset the offset of the first character to be redrawn
    # @param length the length of the range to be redrawn
    def invalidate_text_presentation(offset, length)
      raise NotImplementedError
    end
    
    typesig { [ITextHover, String, ::Java::Int] }
    # Sets this viewer's text hover for the given content type and the given state mask. If the given text hover
    # is <code>null</code>, any hover installed for the given content type and state mask is removed.
    # 
    # @param textViewerHover the new hover or <code>null</code>
    # @param contentType the type for which the hover is to be registered or unregistered
    # @param stateMask the SWT event state mask; <code>DEFAULT_HOVER_STATE_MASK</code> indicates that
    # the hover is installed as the default hover.
    def set_text_hover(text_viewer_hover, content_type, state_mask)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Removes all text hovers for the given content type independent from their state mask.
    # <p>
    # Note: To remove a hover for a given content type and state mask
    # use {@link #setTextHover(ITextHover, String, int)} with <code>null</code>
    # as parameter for the text hover.
    # </p>
    # @param contentType the type for which all text hovers are to be unregistered
    def remove_text_hovers(content_type)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the currently displayed text hover if any, <code>null</code> otherwise.
    # 
    # @return the currently displayed text hover or <code>null</code>
    def get_current_text_hover
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the location at which the most recent mouse hover event
    # has occurred.
    # 
    # @return the location of the most recent mouse hover event
    def get_hover_event_location
      raise NotImplementedError
    end
    
    typesig { [IAutoEditStrategy, String] }
    # Prepends the given auto edit strategy to the existing list of strategies
    # for the specified content type. The strategies are called in the order in
    # which they appear in the list of strategies.
    # 
    # @param strategy the auto edit strategy
    # @param contentType the content type
    def prepend_auto_edit_strategy(strategy, content_type)
      raise NotImplementedError
    end
    
    typesig { [IAutoEditStrategy, String] }
    # Removes the first occurrence of the given auto edit strategy in the list of strategies
    # registered under the specified content type.
    # 
    # @param strategy the auto edit strategy
    # @param contentType the content type
    def remove_auto_edit_strategy(strategy, content_type)
      raise NotImplementedError
    end
    
    typesig { [IPainter] }
    # Adds the given painter to this viewer.
    # 
    # @param painter the painter to be added
    def add_painter(painter)
      raise NotImplementedError
    end
    
    typesig { [IPainter] }
    # Removes the given painter from this viewer. If the painter has not been
    # added to this viewer, this call is without effect.
    # 
    # @param painter the painter to be removed
    def remove_painter(painter)
      raise NotImplementedError
    end
  end
  
end
