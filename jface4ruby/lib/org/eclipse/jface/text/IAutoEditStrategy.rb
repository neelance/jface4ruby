require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module IAutoEditStrategyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # An auto edit strategy can adapt changes that will be applied to
  # a text viewer's document. The strategy is informed by the text viewer
  # about each upcoming change in form of a document command. By manipulating
  # this document command, the strategy can influence in which way the text
  # viewer's document is changed. Clients may implement this interface.
  # 
  # @since 2.1
  module IAutoEditStrategy
    include_class_members IAutoEditStrategyImports
    
    typesig { [IDocument, DocumentCommand] }
    # Allows the strategy to manipulate the document command.
    # 
    # @param document the document that will be changed
    # @param command the document command describing the change
    def customize_document_command(document, command)
      raise NotImplementedError
    end
  end
  
end
