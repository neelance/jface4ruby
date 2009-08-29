require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
# fixes in bug: 178946
module Org::Eclipse::Jface::Viewers
  module ColumnViewerEditorDeactivationEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :EventObject
    }
  end
  
  # This event is fired when an editor deactivated
  # 
  # @since 3.3
  # @noextend This class is not intended to be subclassed by clients.
  class ColumnViewerEditorDeactivationEvent < ColumnViewerEditorDeactivationEventImports.const_get :EventObject
    include_class_members ColumnViewerEditorDeactivationEventImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 1 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The event type
    # @since 3.4
    attr_accessor :event_type
    alias_method :attr_event_type, :event_type
    undef_method :event_type
    alias_method :attr_event_type=, :event_type=
    undef_method :event_type=
    
    class_module.module_eval {
      # Event when editor is canceled
      # @since 3.4
      const_set_lazy(:EDITOR_CANCELED) { 1 }
      const_attr_reader  :EDITOR_CANCELED
      
      # Event when editor is saved
      # @since 3.4
      const_set_lazy(:EDITOR_SAVED) { 2 }
      const_attr_reader  :EDITOR_SAVED
    }
    
    typesig { [Object] }
    # @param source
    def initialize(source)
      @event_type = 0
      super(source)
    end
    
    private
    alias_method :initialize__column_viewer_editor_deactivation_event, :initialize
  end
  
end
