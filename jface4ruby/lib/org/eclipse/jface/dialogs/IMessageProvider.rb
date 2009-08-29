require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module IMessageProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
    }
  end
  
  # Minimal interface to a message provider. Used for dialog pages which can
  # provide a message with an icon.
  # 
  # @since 2.0
  module IMessageProvider
    include_class_members IMessageProviderImports
    
    class_module.module_eval {
      # Constant for a regular message (value 0).
      # <p>
      # Typically this indicates that the message should be shown without an
      # icon.
      # </p>
      const_set_lazy(:NONE) { 0 }
      const_attr_reader  :NONE
      
      # Constant for an info message (value 1).
      const_set_lazy(:INFORMATION) { 1 }
      const_attr_reader  :INFORMATION
      
      # Constant for a warning message (value 2).
      const_set_lazy(:WARNING) { 2 }
      const_attr_reader  :WARNING
      
      # Constant for an error message (value 3).
      const_set_lazy(:ERROR) { 3 }
      const_attr_reader  :ERROR
    }
    
    typesig { [] }
    # Returns the current message for this message provider.
    # <p>
    # A message provides instruction or information to the user.
    # </p>
    # 
    # @return the message, or <code>null</code> if none
    def get_message
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a value indicating if the message is a an information message, a
    # warning message, or an error message.
    # <p>
    # Returns one of <code>NONE</code>,<code>INFORMATION</code>,
    # <code>WARNING</code>, or <code>ERROR</code>.
    # </p>
    # 
    # @return the message type
    def get_message_type
      raise NotImplementedError
    end
  end
  
end
