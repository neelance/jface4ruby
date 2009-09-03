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
  module DocumentImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Default document implementation. Uses a {@link org.eclipse.jface.text.GapTextStore} wrapped
  # inside a {@link org.eclipse.jface.text.CopyOnWriteTextStore} as text store.
  # <p>
  # The used line tracker considers the following strings as line delimiters: "\n", "\r", "\r\n".
  # </p>
  # <p>
  # The document is ready to use. It has a default position category for which a default position
  # updater is installed.
  # </p>
  # <p>
  # <strong>Performance:</strong> The implementation should perform reasonably well for typical
  # source code documents. It is not designed for very large documents of a size of several
  # megabytes. Space-saving implementations are initially used for both the text store and the line
  # tracker; the first modification after a {@link #set(String) set} incurs the cost to transform the
  # document structures to efficiently handle updates.
  # </p>
  # <p>
  # See {@link GapTextStore} and <code>TreeLineTracker</code> for algorithmic behavior of the used
  # document structures.
  # </p>
  # 
  # @see org.eclipse.jface.text.GapTextStore
  # @see org.eclipse.jface.text.CopyOnWriteTextStore
  class Document < DocumentImports.const_get :AbstractDocument
    include_class_members DocumentImports
    
    typesig { [] }
    # Creates a new empty document.
    def initialize
      super()
      set_text_store(CopyOnWriteTextStore.new(GapTextStore.new))
      set_line_tracker(DefaultLineTracker.new)
      complete_initialization
    end
    
    typesig { [String] }
    # Creates a new document with the given initial content.
    # 
    # @param initialContent the document's initial content
    def initialize(initial_content)
      super()
      set_text_store(CopyOnWriteTextStore.new(GapTextStore.new))
      set_line_tracker(DefaultLineTracker.new)
      get_store.set(initial_content)
      get_tracker.set(initial_content)
      complete_initialization
    end
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # @see org.eclipse.jface.text.IRepairableDocumentExtension#isLineInformationRepairNeeded(int, int, java.lang.String)
    # @since 3.4
    def is_line_information_repair_needed(offset, length, text)
      if ((0 > offset) || (0 > length) || (offset + length > get_length))
        raise BadLocationException.new
      end
      return is_line_information_repair_needed(text) || is_line_information_repair_needed(get(offset, length))
    end
    
    typesig { [String] }
    # Checks whether the line information needs to be repaired.
    # 
    # @param text the text to check
    # @return <code>true</code> if the line information must be repaired
    # @since 3.4
    def is_line_information_repair_needed(text)
      if ((text).nil?)
        return false
      end
      length_ = text.length
      if ((length_).equal?(0))
        return false
      end
      r_index = text.index_of(Character.new(?\r.ord))
      n_index = text.index_of(Character.new(?\n.ord))
      if ((r_index).equal?(-1) && (n_index).equal?(-1))
        return false
      end
      if (r_index > 0 && r_index < length_ - 1 && n_index > 1 && r_index < length_ - 2)
        return false
      end
      default_ld = nil
      begin
        default_ld = RJava.cast_to_string(get_line_delimiter(0))
      rescue BadLocationException => x
        return true
      end
      if ((default_ld).nil?)
        return false
      end
      default_ld = RJava.cast_to_string(get_default_line_delimiter)
      if ((default_ld.length).equal?(1))
        if (!(r_index).equal?(-1) && !("\r" == default_ld))
          # $NON-NLS-1$
          return true
        end
        if (!(n_index).equal?(-1) && !("\n" == default_ld))
          # $NON-NLS-1$
          return true
        end
      else
        if ((default_ld.length).equal?(2))
          return (r_index).equal?(-1) || !(n_index - r_index).equal?(1)
        end
      end
      return false
    end
    
    private
    alias_method :initialize__document, :initialize
  end
  
end
