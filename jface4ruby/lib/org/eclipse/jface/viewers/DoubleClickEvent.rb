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
  module DoubleClickEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :EventObject
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # Event object describing a double-click. The source of these
  # events is a viewer.
  # 
  # @see IDoubleClickListener
  class DoubleClickEvent < DoubleClickEventImports.const_get :EventObject
    include_class_members DoubleClickEventImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3258408443605038133 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The selection.
    attr_accessor :selection
    alias_method :attr_selection, :selection
    undef_method :selection
    alias_method :attr_selection=, :selection=
    undef_method :selection=
    
    typesig { [Viewer, ISelection] }
    # Creates a new event for the given source and selection.
    # 
    # @param source the viewer
    # @param selection the selection
    def initialize(source, selection)
      @selection = nil
      super(source)
      Assert.is_not_null(selection)
      @selection = selection
    end
    
    typesig { [] }
    # Returns the selection.
    # 
    # @return the selection
    def get_selection
      return @selection
    end
    
    typesig { [] }
    # Returns the viewer that is the source of this event.
    # 
    # @return the originating viewer
    def get_viewer
      return get_source
    end
    
    private
    alias_method :initialize__double_click_event, :initialize
  end
  
end
