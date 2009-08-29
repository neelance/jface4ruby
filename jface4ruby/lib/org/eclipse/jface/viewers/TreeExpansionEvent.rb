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
  module TreeExpansionEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :EventObject
    }
  end
  
  # Event object describing a tree node being expanded
  # or collapsed. The source of these events is the tree viewer.
  # 
  # @see ITreeViewerListener
  class TreeExpansionEvent < TreeExpansionEventImports.const_get :EventObject
    include_class_members TreeExpansionEventImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3618414930227835185 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The element that was expanded or collapsed.
    attr_accessor :element
    alias_method :attr_element, :element
    undef_method :element
    alias_method :attr_element=, :element=
    undef_method :element=
    
    typesig { [AbstractTreeViewer, Object] }
    # Creates a new event for the given source and element.
    # 
    # @param source the tree viewer
    # @param element the element
    def initialize(source, element)
      @element = nil
      super(source)
      @element = element
    end
    
    typesig { [] }
    # Returns the element that got expanded or collapsed.
    # 
    # @return the element
    def get_element
      return @element
    end
    
    typesig { [] }
    # Returns the originator of the event.
    # 
    # @return the originating tree viewer
    def get_tree_viewer
      return self.attr_source
    end
    
    private
    alias_method :initialize__tree_expansion_event, :initialize
  end
  
end
