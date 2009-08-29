require "rjava"

# Copyright (c) 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module StructuredViewerInternalsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # This class is not part of the public API of JFace. See bug 267722.
  # 
  # @since 3.5
  # @noextend This class is not intended to be subclassed by clients.
  # @noinstantiate This class is not intended to be instantiated by clients.
  class StructuredViewerInternals 
    include_class_members StructuredViewerInternalsImports
    
    class_module.module_eval {
      # Nothing to see here.
      # 
      # @since 3.5
      # @noextend This interface is not intended to be extended by clients.
      # @noimplement This interface is not intended to be implemented by clients.
      const_set_lazy(:AssociateListener) { Module.new do
        include_class_members StructuredViewerInternals
        
        typesig { [Object, Item] }
        # Call when an element is associated with an Item
        # 
        # @param element
        # @param item
        def associate(element, item)
          raise NotImplementedError
        end
        
        typesig { [Item] }
        # Called when an Item is no longer associated
        # 
        # @param item
        def disassociate(item)
          raise NotImplementedError
        end
      end }
      
      typesig { [StructuredViewer, AssociateListener] }
      # Nothing to see here. Sets or resets the AssociateListener for the given
      # Viewer.
      # 
      # @param viewer
      # the viewer
      # @param listener
      # the {@link AssociateListener}
      # @noreference This method is not intended to be referenced by clients.
      def set_associate_listener(viewer, listener)
        viewer.set_associate_listener(listener)
      end
      
      typesig { [StructuredViewer, Object] }
      # Nothing to see here. Returns the items for the given element.
      # 
      # @param viewer
      # @param element
      # @return the Widgets corresponding to the element
      # 
      # @noreference This method is not intended to be referenced by clients.
      def get_items(viewer, element)
        return viewer.find_items(element)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__structured_viewer_internals, :initialize
  end
  
end
