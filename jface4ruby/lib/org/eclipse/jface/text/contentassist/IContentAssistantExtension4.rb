require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Contentassist
  module IContentAssistantExtension4Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Core::Commands, :IHandler
    }
  end
  
  # Extends {@link org.eclipse.jface.text.contentassist.IContentAssistant} with
  # the following function:
  # <ul>
  # <li>allows to get a handler for the given command identifier</li>
  # </ul>
  # 
  # @since 3.4
  module IContentAssistantExtension4
    include_class_members IContentAssistantExtension4Imports
    
    typesig { [String] }
    # Returns the handler for the given command identifier.
    # <p>
    # The same handler instance will be returned when called a more than once
    # with the same command identifier.
    # </p>
    # 
    # @param commandId the command identifier
    # @return the handler for the given command identifier
    # @throws IllegalArgumentException if the command is not supported by this
    # content assistant
    # @throws IllegalStateException if called when this content assistant is
    # uninstalled
    def get_handler(command_id)
      raise NotImplementedError
    end
  end
  
end
