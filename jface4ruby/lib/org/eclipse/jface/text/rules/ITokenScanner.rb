require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Rules
  module ITokenScannerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # A token scanner scans a range of a document and reports about the token it finds.
  # A scanner has state. When asked, the scanner returns the offset and the length of the
  # last found token.
  # 
  # @see org.eclipse.jface.text.rules.IToken
  # @since 2.0
  module ITokenScanner
    include_class_members ITokenScannerImports
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # Configures the scanner by providing access to the document range that should
    # be scanned.
    # 
    # @param document the document to scan
    # @param offset the offset of the document range to scan
    # @param length the length of the document range to scan
    def set_range(document, offset, length)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the next token in the document.
    # 
    # @return the next token in the document
    def next_token
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the offset of the last token read by this scanner.
    # 
    # @return the offset of the last token read by this scanner
    def get_token_offset
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the length of the last token read by this scanner.
    # 
    # @return the length of the last token read by this scanner
    def get_token_length
      raise NotImplementedError
    end
  end
  
end
