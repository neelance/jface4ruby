require "rjava"

# Copyright (c) 2006, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module IContentAssistantExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
    }
  end
  
  # Extends {@link org.eclipse.jface.text.contentassist.IContentAssistant} with the following
  # functions:
  # <ul>
  # <li>completion listeners</li>
  # <li>repeated invocation mode</li>
  # <li>a local status line for the completion popup</li>
  # <li>control over the behavior when no proposals are available</li>
  # </ul>
  # 
  # @since 3.2
  module IContentAssistantExtension2
    include_class_members IContentAssistantExtension2Imports
    
    typesig { [ICompletionListener] }
    # Adds a completion listener that will be informed before proposals are computed.
    # 
    # @param listener the listener
    def add_completion_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [ICompletionListener] }
    # Removes a completion listener.
    # 
    # @param listener the listener to remove
    def remove_completion_listener(listener)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Enables repeated invocation mode, which will trigger re-computation of the proposals when
    # code assist is executed repeatedly. The default is no <code>false</code>.
    # 
    # @param cycling <code>true</code> to enable repetition mode, <code>false</code> to disable
    def set_repeated_invocation_mode(cycling)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Enables displaying an empty completion proposal pop-up. The default is not to show an empty
    # list.
    # 
    # @param showEmpty <code>true</code> to show empty lists
    def set_show_empty_list(show_empty)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Enables displaying a status line below the proposal popup. The default is not to show the
    # status line. The contents of the status line may be set via {@link #setStatusMessage(String)}.
    # 
    # @param show <code>true</code> to show a message line, <code>false</code> to not show one.
    def set_status_line_visible(show)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Sets the caption message displayed at the bottom of the completion proposal popup.
    # 
    # @param message the message
    def set_status_message(message)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Sets the text to be shown if no proposals are available and
    # {@link #setShowEmptyList(boolean) empty lists} are displayed.
    # 
    # @param message the text for the empty list
    def set_empty_message(message)
      raise NotImplementedError
    end
  end
  
end
