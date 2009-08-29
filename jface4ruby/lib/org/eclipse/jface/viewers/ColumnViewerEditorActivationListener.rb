require "rjava"

# Copyright (c) 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ColumnViewerEditorActivationListenerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # Parties interested in activation and deactivation of editors extend this
  # class and implement any or all of the methods
  # 
  # @since 3.3
  class ColumnViewerEditorActivationListener 
    include_class_members ColumnViewerEditorActivationListenerImports
    
    typesig { [ColumnViewerEditorActivationEvent] }
    # Called before an editor is activated
    # 
    # @param event
    # the event
    def before_editor_activated(event)
      raise NotImplementedError
    end
    
    typesig { [ColumnViewerEditorActivationEvent] }
    # Called after an editor has been activated
    # 
    # @param event the event
    def after_editor_activated(event)
      raise NotImplementedError
    end
    
    typesig { [ColumnViewerEditorDeactivationEvent] }
    # Called before an editor is deactivated
    # 
    # @param event
    # the event
    def before_editor_deactivated(event)
      raise NotImplementedError
    end
    
    typesig { [ColumnViewerEditorDeactivationEvent] }
    # Called after an editor is deactivated
    # 
    # @param event the event
    def after_editor_deactivated(event)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__column_viewer_editor_activation_listener, :initialize
  end
  
end
