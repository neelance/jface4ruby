require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Rules
  module IRuleImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
    }
  end
  
  # Defines the interface for a rule used in the scanning of text for the purpose of document
  # partitioning or text styling.
  # 
  # @see ICharacterScanner
  module IRule
    include_class_members IRuleImports
    
    typesig { [ICharacterScanner] }
    # Evaluates the rule by examining the characters available from the provided character scanner.
    # The token returned by this rule returns <code>true</code> when calling
    # <code>isUndefined</code>, if the text that the rule investigated does not match the rule's
    # requirements
    # 
    # @param scanner the character scanner to be used by this rule
    # @return the token computed by the rule
    def evaluate(scanner)
      raise NotImplementedError
    end
  end
  
end
