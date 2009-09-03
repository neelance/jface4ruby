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
  module RuleBasedPartitionScannerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Org::Eclipse::Jface::Text, :IDocument
    }
  end
  
  # Scanner that exclusively uses predicate rules.
  # @since 2.0
  class RuleBasedPartitionScanner < RuleBasedPartitionScannerImports.const_get :BufferedRuleBasedScanner
    include_class_members RuleBasedPartitionScannerImports
    overload_protected {
      include IPartitionTokenScanner
    }
    
    # The content type of the partition in which to resume scanning.
    attr_accessor :f_content_type
    alias_method :attr_f_content_type, :f_content_type
    undef_method :f_content_type
    alias_method :attr_f_content_type=, :f_content_type=
    undef_method :f_content_type=
    
    # The offset of the partition inside which to resume.
    attr_accessor :f_partition_offset
    alias_method :attr_f_partition_offset, :f_partition_offset
    undef_method :f_partition_offset
    alias_method :attr_f_partition_offset=, :f_partition_offset=
    undef_method :f_partition_offset=
    
    typesig { [Array.typed(IRule)] }
    # Disallow setting the rules since this scanner
    # exclusively uses predicate rules.
    # 
    # @param rules the sequence of rules controlling this scanner
    def set_rules(rules)
      raise UnsupportedOperationException.new
    end
    
    typesig { [Array.typed(IPredicateRule)] }
    # @see RuleBasedScanner#setRules(IRule[])
    def set_predicate_rules(rules)
      BufferedRuleBasedScanner.instance_method(:set_rules).bind(self).call(rules)
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int] }
    # @see ITokenScanner#setRange(IDocument, int, int)
    def set_range(document, offset, length)
      set_partial_range(document, offset, length, nil, -1)
    end
    
    typesig { [IDocument, ::Java::Int, ::Java::Int, String, ::Java::Int] }
    # @see IPartitionTokenScanner#setPartialRange(IDocument, int, int, String, int)
    def set_partial_range(document, offset, length, content_type, partition_offset)
      @f_content_type = content_type
      @f_partition_offset = partition_offset
      if (partition_offset > -1)
        delta = offset - partition_offset
        if (delta > 0)
          BufferedRuleBasedScanner.instance_method(:set_range).bind(self).call(document, partition_offset, length + delta)
          self.attr_f_offset = offset
          return
        end
      end
      BufferedRuleBasedScanner.instance_method(:set_range).bind(self).call(document, offset, length)
    end
    
    typesig { [] }
    # @see ITokenScanner#nextToken()
    def next_token
      if ((@f_content_type).nil? || (self.attr_f_rules).nil?)
        # don't try to resume
        return super
      end
      # inside a partition
      self.attr_f_column = UNDEFINED
      resume = (@f_partition_offset > -1 && @f_partition_offset < self.attr_f_offset)
      self.attr_f_token_offset = resume ? @f_partition_offset : self.attr_f_offset
      rule = nil
      token = nil
      i = 0
      while i < self.attr_f_rules.attr_length
        rule = self.attr_f_rules[i]
        token = rule.get_success_token
        if ((@f_content_type == token.get_data))
          token = rule.evaluate(self, resume)
          if (!token.is_undefined)
            @f_content_type = RJava.cast_to_string(nil)
            return token
          end
        end
        i += 1
      end
      # haven't found any rule for this type of partition
      @f_content_type = RJava.cast_to_string(nil)
      if (resume)
        self.attr_f_offset = @f_partition_offset
      end
      return super
    end
    
    typesig { [] }
    def initialize
      @f_content_type = nil
      @f_partition_offset = 0
      super()
    end
    
    private
    alias_method :initialize__rule_based_partition_scanner, :initialize
  end
  
end
