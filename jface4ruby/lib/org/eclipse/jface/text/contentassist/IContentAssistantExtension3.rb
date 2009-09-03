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
  module IContentAssistantExtension3Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Contentassist
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeySequence
    }
  end
  
  # Extends {@link org.eclipse.jface.text.contentassist.IContentAssistant} with the following
  # function:
  # <ul>
  # <li>a key-sequence to listen for in repeated invocation mode</li>
  # </ul>
  # 
  # @since 3.2
  module IContentAssistantExtension3
    include_class_members IContentAssistantExtension3Imports
    
    typesig { [KeySequence] }
    # Sets the key sequence to listen for in repeated invocation mode. If the key sequence is
    # encountered, a step in the repetition iteration is triggered.
    # 
    # @param sequence the key sequence used for the repeated invocation mode or <code>null</code> if none
    def set_repeated_invocation_trigger(sequence)
      raise NotImplementedError
    end
  end
  
end
