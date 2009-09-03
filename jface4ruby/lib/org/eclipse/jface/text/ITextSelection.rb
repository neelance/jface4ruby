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
  module ITextSelectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Jface::Viewers, :ISelection
    }
  end
  
  # This interface represents a textual selection. A text selection is a range of
  # characters. Although a text selection is a snapshot taken at a particular
  # point in time, it must not copy the line information and the selected text
  # from the selection provider.
  # <p>
  # If, for example, the selection provider is a text viewer (
  # {@link org.eclipse.jface.text.ITextViewer}), and a text selection is created
  # for the range [5, 10], the line formation for the 5th character must not be
  # determined and remembered at the point of creation. It can rather be
  # determined at the point, when <code>getStartLine</code> is called. If the
  # source viewer range [0, 15] has been changed in the meantime between the
  # creation of the text selection object and the invocation of
  # <code>getStartLine</code>, the returned line number may differ from the
  # line number of the 5th character at the point of creation of the text
  # selection object.
  # <p>
  # The contract of this interface is that weak in order to allow for efficient
  # implementations.</p>
  # <p>
  # Clients may implement this interface or use the default implementation
  # provided by {@link org.eclipse.jface.text.TextSelection}.</p>
  # 
  # @see org.eclipse.jface.text.TextSelection
  module ITextSelection
    include_class_members ITextSelectionImports
    include ISelection
    
    typesig { [] }
    # Returns the offset of the selected text.
    # 
    # @return the offset of the selected text or -1 if there is no valid text information
    def get_offset
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the length of the selected text.
    # 
    # @return the length of the selected text or -1 if there is no valid text information
    def get_length
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns number of the line containing the offset of the selected text.
    # If the underlying text has been changed between the creation of this
    # selection object and the call of this method, the value returned might
    # differ from what it would have been at the point of creation.
    # 
    # @return the start line of this selection or -1 if there is no valid line information
    def get_start_line
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of the line containing the last character of the selected text.
    # If the underlying text has been changed between the creation of this
    # selection object and the call of this method, the value returned might
    # differ from what it would have been at the point of creation.
    # 
    # @return the end line of this selection or -1 if there is no valid line information
    def get_end_line
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the selected text.
    # If the underlying text has been changed between the creation of this
    # selection object and the call of this method, the value returned might
    # differ from what it would have been at the point of creation.
    # 
    # @return the selected text or <code>null</code> if there is no valid text information
    def get_text
      raise NotImplementedError
    end
  end
  
end
