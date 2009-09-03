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
  module ITextViewerExtension4Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.ITextViewer}.
  # Introduces the concept of text presentation listeners and improves focus
  # handling among widget token keepers.
  # <p>
  # A {@link org.eclipse.jface.text.ITextPresentationListener}is a listener that
  # is informed by the viewer that a text presentation is about to be applied.
  # During this callback the listener is allowed to modify the presentation. Text
  # presentation listeners are thus a mean to participate in the process of text
  # presentation creation.
  # 
  # @since 3.0
  module ITextViewerExtension4
    include_class_members ITextViewerExtension4Imports
    
    typesig { [] }
    # Instructs the receiver to request the {@link IWidgetTokenKeeper}
    # currently holding the widget token to take the keyboard focus.
    # 
    # @return <code>true</code> if there was any
    # <code>IWidgetTokenKeeper</code> that was asked to take the
    # focus, <code>false</code> otherwise
    def move_focus_to_widget_token
      raise NotImplementedError
    end
    
    typesig { [ITextPresentationListener] }
    # Adds the given text presentation listener to this text viewer.
    # This call has no effect if the listener is already registered
    # with this text viewer.
    # 
    # @param listener the text presentation listener
    def add_text_presentation_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [ITextPresentationListener] }
    # Removes the given text presentation listener from this text viewer.
    # This call has no effect if the listener is not registered with this
    # text viewer.
    # 
    # @param listener the text presentation listener
    def remove_text_presentation_listener(listener)
      raise NotImplementedError
    end
  end
  
end
