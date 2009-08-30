require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module NotEnabledExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Org::Eclipse::Core::Commands::Common, :CommandException
    }
  end
  
  # Signals that an attempt was made to execute a command that is not enabled.
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @since 3.2
  class NotEnabledException < NotEnabledExceptionImports.const_get :CommandException
    include_class_members NotEnabledExceptionImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      # 
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3257572788998124596 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    # Creates a new instance of this class with the specified detail message.
    # 
    # @param s
    # the detail message; may be <code>null</code>.
    def initialize(s)
      super(s)
    end
    
    private
    alias_method :initialize__not_enabled_exception, :initialize
  end
  
end
