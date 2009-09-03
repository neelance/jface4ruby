require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module IAnnotationHoverExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.source.IAnnotationHover} for
  # <ul>
  # <li>providing its own information control creator</li>
  # <li>providing the range of lines for which the hover for a given line is valid</li>
  # <li>providing whether the information control can interact with the mouse cursor</li>
  # </ul>
  # 
  # @see org.eclipse.jface.text.IInformationControlCreator
  # @see org.eclipse.jface.text.source.IAnnotationHover
  # @since 3.0
  module IAnnotationHoverExtension
    include_class_members IAnnotationHoverExtensionImports
    
    typesig { [] }
    # Returns the hover control creator of this annotation hover.
    # 
    # @return the hover control creator
    def get_hover_control_creator
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether the provided information control can interact with the mouse cursor. I.e. the
    # hover must implement custom information control management.
    # 
    # @return <code>true</code> if the mouse cursor can be handled
    def can_handle_mouse_cursor
      raise NotImplementedError
    end
    
    typesig { [ISourceViewer, ILineRange, ::Java::Int] }
    # Returns the object which should be presented in the a
    # hover popup window. The information is requested based on
    # the specified line range.
    # 
    # @param sourceViewer the source viewer this hover is registered with
    # @param lineRange the line range for which information is requested
    # @param visibleNumberOfLines the number of visible lines
    # @return the requested information or <code>null</code> if no such information exists
    def get_hover_info(source_viewer, line_range, visible_number_of_lines)
      raise NotImplementedError
    end
    
    typesig { [ISourceViewer, ::Java::Int] }
    # Returns the range of lines that include the given line number for which
    # the same hover information is valid.
    # 
    # @param viewer the viewer which the hover is queried for
    # @param lineNumber the line number of the line for which a hover is displayed for
    # @return the computed line range or <code>null</code> for no range
    def get_hover_line_range(viewer, line_number)
      raise NotImplementedError
    end
  end
  
end
