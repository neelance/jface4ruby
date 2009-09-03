require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module ILineTrackerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # A line tracker maps character positions to line numbers and vice versa.
  # Initially the line tracker is informed about its underlying text in order to
  # initialize the mapping information. After that, the line tracker is informed
  # about all changes of the underlying text allowing for incremental updates of
  # the mapping information. It is the client's responsibility to actively inform
  # the line tacker about text changes. For example, when using a line tracker in
  # combination with a document the document controls the line tracker.
  # <p>
  # In order to provide backward compatibility for clients of <code>ILineTracker</code>, extension
  # interfaces are used to provide a means of evolution. The following extension interfaces
  # exist:
  # <ul>
  # <li> {@link org.eclipse.jface.text.ILineTrackerExtension} since version 3.1 introducing the concept
  # of rewrite sessions.</li>
  # </ul>
  # <p>
  # Clients may implement this interface or use the standard implementation
  # </p>
  # {@link org.eclipse.jface.text.DefaultLineTracker}or
  # {@link org.eclipse.jface.text.ConfigurableLineTracker}.
  module ILineTracker
    include_class_members ILineTrackerImports
    
    typesig { [] }
    # Returns the strings this tracker considers as legal line delimiters.
    # 
    # @return the legal line delimiters
    def get_legal_line_delimiters
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the line delimiter of the specified line. Returns <code>null</code> if the
    # line is not closed with a line delimiter.
    # 
    # @param line the line whose line delimiter is queried
    # @return the line's delimiter or <code>null</code> if line does not have a delimiter
    # @exception BadLocationException if the line number is invalid in this tracker's line structure
    def get_line_delimiter(line)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Computes the number of lines in the given text.
    # 
    # @param text the text whose number of lines should be computed
    # @return the number of lines in the given text
    def compute_number_of_lines(text)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of lines.
    # <p>
    # Note that a document always has at least one line.
    # </p>
    # 
    # @return the number of lines in this tracker's line structure
    def get_number_of_lines
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns the number of lines which are occupied by a given text range.
    # 
    # @param offset the offset of the specified text range
    # @param length the length of the specified text range
    # @return the number of lines occupied by the specified range
    # @exception BadLocationException if specified range is unknown to this tracker
    def get_number_of_lines(offset, length)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the position of the first character of the specified line.
    # 
    # @param line the line of interest
    # @return offset of the first character of the line
    # @exception BadLocationException if the line is unknown to this tracker
    def get_line_offset(line)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns length of the specified line including the line's delimiter.
    # 
    # @param line the line of interest
    # @return the length of the line
    # @exception BadLocationException if line is unknown to this tracker
    def get_line_length(line)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the line number the character at the given offset belongs to.
    # 
    # @param offset the offset whose line number to be determined
    # @return the number of the line the offset is on
    # @exception BadLocationException if the offset is invalid in this tracker
    def get_line_number_of_offset(offset)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns a line description of the line at the given offset.
    # The description contains the start offset and the length of the line
    # excluding the line's delimiter.
    # 
    # @param offset the offset whose line should be described
    # @return a region describing the line
    # @exception BadLocationException if offset is invalid in this tracker
    def get_line_information_of_offset(offset)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns a line description of the given line. The description
    # contains the start offset and the length of the line excluding the line's
    # delimiter.
    # 
    # @param line the line that should be described
    # @return a region describing the line
    # @exception BadLocationException if line is unknown to this tracker
    def get_line_information(line)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # Informs the line tracker about the specified change in the tracked text.
    # 
    # @param offset the offset of the replaced text
    # @param length the length of the replaced text
    # @param text the substitution text
    # @exception BadLocationException if specified range is unknown to this tracker
    def replace(offset, length, text)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Sets the tracked text to the specified text.
    # 
    # @param text the new tracked text
    def set(text)
      raise NotImplementedError
    end
  end
  
end
