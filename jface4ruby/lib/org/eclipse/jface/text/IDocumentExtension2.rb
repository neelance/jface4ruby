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
  module IDocumentExtension2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.IDocument}.<p>
  # 
  # It adds configuration methods to post notification replaces and document
  # listener notification.
  # 
  # @since 2.1
  module IDocumentExtension2
    include_class_members IDocumentExtension2Imports
    
    typesig { [] }
    # Tells the receiver to ignore calls to
    # <code>registerPostNotificationReplace</code> until
    # <code>acceptPostNotificationReplaces</code> is called.
    def ignore_post_notification_replaces
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells the receiver to accept calls to
    # <code>registerPostNotificationReplace</code> until
    # <code>ignorePostNotificationReplaces</code> is called.
    def accept_post_notification_replaces
      raise NotImplementedError
    end
    
    typesig { [] }
    # Can be called prior to a <code>replace</code> operation. After the
    # <code>replace</code> <code>resumeListenerNotification</code> must be
    # called. The affect of these calls is that no document listener is notified
    # until <code>resumeListenerNotification</code> is called. This allows clients
    # to update structure before any listener is informed about the change.<p>
    # Listener notification can only be stopped for a single <code>replace</code> operation.
    # Otherwise, document change notifications will be lost.
    def stop_listener_notification
      raise NotImplementedError
    end
    
    typesig { [] }
    # Resumes the notification of document listeners which must previously
    # have been stopped by a call to <code>stopListenerNotification</code>.
    def resume_listener_notification
      raise NotImplementedError
    end
  end
  
end
