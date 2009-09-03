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
  module ILineTrackerExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.ILineTracker}. Adds the
  # concept of rewrite sessions. A rewrite session is a sequence of replace
  # operations that form a semantic unit.
  # 
  # @since 3.1
  module ILineTrackerExtension
    include_class_members ILineTrackerExtensionImports
    
    typesig { [DocumentRewriteSession] }
    # Tells the line tracker that a rewrite session started. A rewrite session
    # is a sequence of replace operations that form a semantic unit. The line
    # tracker is allowed to use that information for internal optimization.
    # 
    # @param session the rewrite session
    # @throws IllegalStateException in case there is already an active rewrite
    # session
    def start_rewrite_session(session)
      raise NotImplementedError
    end
    
    typesig { [DocumentRewriteSession, String] }
    # Tells the line tracker that the rewrite session has finished. This method
    # is only called when <code>startRewriteSession</code> has been called
    # before. The text resulting from the rewrite session is passed to the line
    # tracker.
    # 
    # @param session the rewrite session
    # @param text the text with which to re-initialize the line tracker
    def stop_rewrite_session(session, text)
      raise NotImplementedError
    end
  end
  
end
