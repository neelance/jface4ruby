require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module IMarkSelectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Jface::Viewers, :ISelection
    }
  end
  
  # A mark selection can be sent out by text viewers. By checking the
  # type of the selection selection listeners can determine whether a selection
  # event is about a mark or a normal text selection.
  # <p>
  # This interface is not intended to be implemented by clients other than
  # {@link org.eclipse.jface.text.ITextViewer} implementers.
  # </p>
  # 
  # @since 2.0
  module IMarkSelection
    include_class_members IMarkSelectionImports
    include ISelection
    
    typesig { [] }
    # Returns the marked document.
    # 
    # @return the marked document
    def get_document
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the mark position. The offset may be <code>-1</code> if there's no marked region.
    # 
    # @return the mark position or <code>-1</code> if there is no marked region
    def get_offset
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the length of the mark selection. The length may be negative, if the caret
    # is before the mark position. The length has no meaning if <code>getOffset()</code>
    # returns <code>-1</code>.
    # 
    # @return the length of the mark selection. Result is undefined for <code>getOffset == -1</code>
    def get_length
      raise NotImplementedError
    end
  end
  
end
