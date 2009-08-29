require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ILabelProviderListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # A listener which is notified when a label provider's state changes.
  # 
  # @see IBaseLabelProvider#addListener
  # @see IBaseLabelProvider#removeListener
  module ILabelProviderListener
    include_class_members ILabelProviderListenerImports
    
    typesig { [LabelProviderChangedEvent] }
    # Notifies this listener that the state of the label provider
    # has changed in a way that affects the labels it computes.
    # <p>
    # A typical response would be to refresh all labels by
    # re-requesting them from the label provider.
    # </p>
    # 
    # @param event the label provider change event
    def label_provider_changed(event)
      raise NotImplementedError
    end
  end
  
end
