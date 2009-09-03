require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module ILineRangeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
    }
  end
  
  # Describes a range of lines.
  # <p>
  # Note that the number of lines is 1-based, e.g. <code>getStartLine() + getNumberOfLines()</code>
  # computes the first line <em>after</em> the range, and a range with
  # <code>getNumberOfLines() == 0</code> is empty.
  # </p>
  # 
  # @since 3.0
  module ILineRange
    include_class_members ILineRangeImports
    
    typesig { [] }
    # Returns the start line of this line range or <code>-1</code>.
    # 
    # @return the start line of this line range or <code>-1</code> if this line range is invalid.
    def get_start_line
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of lines of this line range or <code>-1</code>.
    # 
    # @return the number of lines in this line range or <code>-1</code> if this line range is invalid.
    def get_number_of_lines
      raise NotImplementedError
    end
  end
  
end
