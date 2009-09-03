require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Formatter
  module IContentFormatterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Formatter
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IRegion
    }
  end
  
  # The interface of a document content formatter. The formatter formats ranges
  # within documents. The documents are modified by the formatter.<p>
  # The content formatter is assumed to determine the partitioning of the document
  # range to be formatted. For each partition, the formatter determines based
  # on the partition's content type the formatting strategy to be used. Before
  # the first strategy is activated all strategies are informed about the
  # start of the formatting process. After that, the formatting strategies are
  # activated in the sequence defined by the partitioning of the document range to be
  # formatted. It is assumed that a strategy must be finished before the next strategy
  # can be activated. After the last strategy has been finished, all strategies are
  # informed about the termination of the formatting process.</p>
  # <p>
  # The interface can be implemented by clients. By default, clients use <code>ContentFormatter</code>
  # or <code>MultiPassContentFormatter</code> as the standard implementers of this interface.</p>
  # 
  # @see IDocument
  # @see IFormattingStrategy
  module IContentFormatter
    include_class_members IContentFormatterImports
    
    typesig { [IDocument, IRegion] }
    # Formats the given region of the specified document.The formatter may safely
    # assume that it is the only subject that modifies the document at this point in time.
    # 
    # @param document the document to be formatted
    # @param region the region within the document to be formatted
    def format(document, region)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns the formatting strategy registered for the given content type.
    # 
    # @param contentType the content type for which to look up the formatting strategy
    # @return the formatting strategy for the given content type, or
    # <code>null</code> if there is no such strategy
    def get_formatting_strategy(content_type)
      raise NotImplementedError
    end
  end
  
end
