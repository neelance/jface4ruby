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
  module IRewriteTargetImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # A target publishing the required functions to modify a document that is displayed
  # in a text viewer. It provides access to the document and control
  # over the redraw behavior and the grouping of document changes into undo commands.
  # 
  # @see org.eclipse.jface.text.ITextViewer
  # @see org.eclipse.jface.text.IDocument
  # @see org.eclipse.jface.text.IUndoManager
  # @since 2.0
  module IRewriteTarget
    include_class_members IRewriteTargetImports
    
    typesig { [] }
    # Returns the document of this target.
    # 
    # @return the document of this target
    def get_document
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Disables/enables redrawing while modifying the target's document.
    # 
    # @param redraw <code>true</code> if the document's visible presentation
    # should be updated, <code>false</code> otherwise
    def set_redraw(redraw)
      raise NotImplementedError
    end
    
    typesig { [] }
    # If an undo manager is connected to the document's visible presentation,
    # this method tells the undo manager to fold all subsequent changes into
    # one single undo command until <code>endCompoundChange</code> is called.
    def begin_compound_change
      raise NotImplementedError
    end
    
    typesig { [] }
    # If an undo manager is connected to the document's visible presentation,
    # this method tells the undo manager to stop the folding of changes into a
    # single undo command. After this call, all subsequent changes are
    # considered to be individually undo-able.
    def end_compound_change
      raise NotImplementedError
    end
  end
  
end
