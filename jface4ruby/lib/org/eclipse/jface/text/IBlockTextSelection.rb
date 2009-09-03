require "rjava"

# Copyright (c) 2009 Avaloq Evolution AG and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# Tom Eicher (Avaloq Evolution AG) - initial API and implementation
module Org::Eclipse::Jface::Text
  module IBlockTextSelectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # A rectangular selection in a text document. A column selection spans the visually identical range
  # of columns on a contiguous range of lines. The character count of the same visually perceived
  # column may not be equal for two different lines, therefore computing the set of disjunct
  # character ranges covered by a column selection is influenced by the used font and tabulator
  # width. Using column selections with proportional fonts may render unexpected results.
  # <h5><a name="virtual">Virtual Spaces</a></h5>
  # The {@linkplain #getStartColumn() start column} and {@linkplain #getEndColumn() end column} may
  # refer to &quot;virtual offsets&quot; in the white space beyond the end of the line. Such an
  # offset can be realized by inserting a space for each missing character.
  # <p>
  # The {@linkplain ITextSelection#getOffset() offset} and
  # {@linkplain ITextSelection#getLength() length} of an {@link IBlockTextSelection} refer to the
  # smallest non-virtual range that comprises the entire rectangular selection.
  # </p>
  # <p>
  # Clients may implement this interface or use the default implementation provided by
  # {@link org.eclipse.jface.text.BlockTextSelection}.
  # </p>
  # 
  # @see org.eclipse.jface.text.BlockTextSelection
  # @since 3.5
  module IBlockTextSelection
    include_class_members IBlockTextSelectionImports
    include ITextSelection
    
    typesig { [] }
    # Returns the column on the {@linkplain ITextSelection#getStartLine() start line} at which the
    # selection starts. The returned column is a character count measured from the start of the
    # line. It may be larger than the length of the line, in which case it is a <a
    # href="#virtual">virtual</a> offset.
    # 
    # @return the start column measured from the line start
    def get_start_column
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the exclusive column on the {@linkplain ITextSelection#getEndLine() end line} at which the
    # selection ends. The returned column is a character count measured from the start of the
    # line. It may be larger than the length of the line, in which case it is a <a
    # href="#virtual">virtual</a> offset.
    # 
    # @return the end column measured from the line start
    def get_end_column
      raise NotImplementedError
    end
    
    typesig { [] }
    # {@inheritDoc}
    # <p>
    # The returned text does not necessarily correspond to the total
    # {@linkplain ITextSelection#getOffset() offset} and {@link ITextSelection#getLength() length},
    # as only the text within the selected columns is returned.
    # <p>
    # Any <a href="#virtual">virtual</a> spaces beyond the end of the selected lines are
    # materialized and returned as text.
    # </p>
    # 
    # @see org.eclipse.jface.text.ITextSelection#getText()
    def get_text
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a non-empty array containing the selected text range for each line covered by the
    # selection.
    # 
    # @return an array containing a the covered text range for each line covered by the receiver
    def get_regions
      raise NotImplementedError
    end
  end
  
end
