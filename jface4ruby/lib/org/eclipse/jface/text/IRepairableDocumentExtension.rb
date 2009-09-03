require "rjava"

# Copyright (c) 2007, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module IRepairableDocumentExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.IRepairableDocument}.
  # <p>
  # Adds the ability to query whether the repairable document needs to be
  # repaired.
  # 
  # @see org.eclipse.jface.text.IRepairableDocument
  # @since 3.4
  module IRepairableDocumentExtension
    include_class_members IRepairableDocumentExtensionImports
    
    typesig { [::Java::Int, ::Java::Int, String] }
    # Tells whether the line information of the document implementing this
    # interface needs to be repaired.
    # 
    # @param offset the document offset
    # @param length the length of the specified range
    # @param text the substitution text to check
    # @return <code>true</code> if the line information must be repaired
    # @throws BadLocationException if the offset is invalid in this document
    # @see IRepairableDocument#repairLineInformation()
    def is_line_information_repair_needed(offset, length, text)
      raise NotImplementedError
    end
  end
  
end
