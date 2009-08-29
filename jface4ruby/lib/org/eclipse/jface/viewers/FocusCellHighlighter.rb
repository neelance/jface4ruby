require "rjava"

# Copyright (c) 2007, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
# bugfix in: 182800
module Org::Eclipse::Jface::Viewers
  module FocusCellHighlighterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
    }
  end
  
  # @since 3.3
  class FocusCellHighlighter 
    include_class_members FocusCellHighlighterImports
    
    attr_accessor :viewer
    alias_method :attr_viewer, :viewer
    undef_method :viewer
    alias_method :attr_viewer=, :viewer=
    undef_method :viewer=
    
    attr_accessor :mgr
    alias_method :attr_mgr, :mgr
    undef_method :mgr
    alias_method :attr_mgr=, :mgr=
    undef_method :mgr=
    
    typesig { [ColumnViewer] }
    # @param viewer
    def initialize(viewer)
      @viewer = nil
      @mgr = nil
      @viewer = viewer
    end
    
    typesig { [SWTFocusCellManager] }
    def set_mgr(mgr)
      @mgr = mgr
    end
    
    typesig { [] }
    # @return the focus cell
    def get_focus_cell
      # Mgr is normally not null because the highlighter is passed
      # to the SWTFocusCellManager instance
      if (!(@mgr).nil?)
        # Use this method because it ensure that no
        # cell update (which might cause scrolling) happens
        return @mgr.__get_focus_cell
      end
      return @viewer.get_column_viewer_editor.get_focus_cell
    end
    
    typesig { [ViewerCell] }
    # Called by the framework when the focus cell has changed. Subclasses may
    # extend.
    # 
    # @param cell
    # the new focus cell
    # @deprecated use {@link #focusCellChanged(ViewerCell, ViewerCell)} instead
    def focus_cell_changed(cell)
    end
    
    typesig { [ViewerCell, ViewerCell] }
    # Called by the framework when the focus cell has changed. Subclasses may
    # extend.
    # <p>
    # <b>The default implementation for this method calls
    # focusCellChanged(ViewerCell). Subclasses should override this method
    # rather than {@link #focusCellChanged(ViewerCell)} .</b>
    # 
    # @param newCell
    # the new focus cell or <code>null</code> if no new cell
    # receives the focus
    # @param oldCell
    # the old focus cell or <code>null</code> if no cell has been
    # focused before
    # @since 3.4
    def focus_cell_changed(new_cell, old_cell)
      focus_cell_changed(new_cell)
    end
    
    typesig { [] }
    # This method is called by the framework to initialize this cell
    # highlighter object. Subclasses may extend.
    def init
    end
    
    private
    alias_method :initialize__focus_cell_highlighter, :initialize
  end
  
end
