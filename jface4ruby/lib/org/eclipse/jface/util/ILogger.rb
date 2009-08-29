require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Chris Gross (schtoo@schtoo.com) - initial API and implementation
# (bug 49497 [RCP] JFace dependency on org.eclipse.core.runtime enlarges standalone JFace applications)
module Org::Eclipse::Jface::Util
  module ILoggerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
    }
  end
  
  # A mechanism to log errors throughout JFace.
  # <p>
  # Clients may provide their own implementation to change
  # how errors are logged from within JFace.
  # </p>
  # 
  # @see org.eclipse.jface.util.Policy#getLog()
  # @see org.eclipse.jface.util.Policy#setLog(ILogger)
  # @since 3.1
  module ILogger
    include_class_members ILoggerImports
    
    typesig { [IStatus] }
    # Logs the given status.
    # 
    # @param status the status to log
    def log(status)
      raise NotImplementedError
    end
  end
  
end
