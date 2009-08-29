require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Operation
  module IThreadListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Operation
    }
  end
  
  # A thread listener is an object that is interested in receiving notifications
  # of thread changes.  For example, a thread listener can be used to notify a
  # runnable of the thread that will execute it, allowing the runnable to transfer
  # thread-local state from the calling thread before control passes to the new thread.
  # 
  # @since 3.1
  module IThreadListener
    include_class_members IThreadListenerImports
    
    typesig { [JavaThread] }
    # Notification that a thread change is occurring.
    # 
    # @param thread The new thread
    def thread_change(thread)
      raise NotImplementedError
    end
  end
  
end
