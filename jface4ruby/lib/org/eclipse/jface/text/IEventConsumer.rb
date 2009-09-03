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
  module IEventConsumerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt::Events, :VerifyEvent
    }
  end
  
  # Implementers can register with a text viewer and receive
  # <code>VerifyEvent</code>s before the text viewer they are registered with.
  # If the event consumer marks events as processed by turning their
  # <code>doit</code> field to <code>false</code> the text viewer
  # subsequently ignores them.</p>
  # <p>
  # Clients may implement this interface.</p>
  # <p>
  # {@link org.eclipse.jface.text.ITextViewerExtension2}allows clients to manage
  # the {@link org.eclipse.swt.events.VerifyListener}s of a text viewer. This
  # makes <code>IEventConsumer</code> obsolete.</p>
  # 
  # @see org.eclipse.jface.text.ITextViewer
  # @see org.eclipse.jface.text.ITextViewerExtension2
  # @see org.eclipse.swt.events.VerifyEvent
  module IEventConsumer
    include_class_members IEventConsumerImports
    
    typesig { [VerifyEvent] }
    # Processes the given event and marks it as done if it should
    # be ignored by subsequent receivers.
    # 
    # @param event the verify event which will be investigated
    def process_event(event)
      raise NotImplementedError
    end
  end
  
end
