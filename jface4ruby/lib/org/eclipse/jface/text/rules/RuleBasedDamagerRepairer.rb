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
  module RuleBasedDamagerRepairerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Org::Eclipse::Jface::Text, :TextAttribute
    }
  end
  
  # @deprecated use <code>DefaultDamagerRepairer</code>
  class RuleBasedDamagerRepairer < RuleBasedDamagerRepairerImports.const_get :DefaultDamagerRepairer
    include_class_members RuleBasedDamagerRepairerImports
    
    typesig { [RuleBasedScanner, TextAttribute] }
    # Creates a damager/repairer that uses the given scanner and returns the given default
    # text attribute if the current token does not carry a text attribute.
    # 
    # @param scanner the rule based scanner to be used
    # @param defaultTextAttribute the text attribute to be returned if none is specified by the current token,
    # may not be <code>null</code>
    # 
    # @deprecated use RuleBasedDamagerRepairer(RuleBasedScanner) instead
    def initialize(scanner, default_text_attribute)
      super(scanner, default_text_attribute)
    end
    
    typesig { [RuleBasedScanner] }
    # Creates a damager/repairer that uses the given scanner. The scanner may not be <code>null</code>
    # and is assumed to return only token that carry text attributes.
    # 
    # @param scanner the rule based scanner to be used, may not be <code>null</code>
    # @since 2.0
    def initialize(scanner)
      super(scanner)
    end
    
    private
    alias_method :initialize__rule_based_damager_repairer, :initialize
  end
  
end
