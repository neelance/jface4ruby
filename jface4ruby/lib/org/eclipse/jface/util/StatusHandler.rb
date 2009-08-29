require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Util
  module StatusHandlerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
    }
  end
  
  # A mechanism to handle statuses throughout JFace.
  # <p>
  # Clients may provide their own implementation to change how statuses are
  # handled from within JFace.
  # </p>
  # 
  # @see org.eclipse.jface.util.Policy#getStatusHandler()
  # @see org.eclipse.jface.util.Policy#setStatusHandler(StatusHandler)
  # 
  # @since 3.4
  class StatusHandler 
    include_class_members StatusHandlerImports
    
    typesig { [IStatus, String] }
    # Show the given status.
    # 
    # @param status
    # status to handle
    # @param title
    # title for the status
    def show(status, title)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__status_handler, :initialize
  end
  
end
