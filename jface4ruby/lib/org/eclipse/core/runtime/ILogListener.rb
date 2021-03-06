require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module ILogListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
      include_const ::Java::Util, :EventListener
    }
  end
  
  # A log listener is notified of entries added to a plug-in's log.
  # <p>
  # This interface can be used without OSGi running.
  # </p><p>
  # Clients may implement this interface.
  # </p>
  module ILogListener
    include_class_members ILogListenerImports
    include EventListener
    
    typesig { [IStatus, String] }
    # Notifies this listener that given status has been logged by
    # a plug-in.  The listener is free to retain or ignore this status.
    # 
    # @param status the status being logged
    # @param plugin the plugin of the log which generated this event
    def logging(status, plugin)
      raise NotImplementedError
    end
  end
  
end
