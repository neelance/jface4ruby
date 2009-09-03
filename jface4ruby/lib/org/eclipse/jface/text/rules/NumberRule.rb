require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Rules
  module NumberRuleImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # An implementation of <code>IRule</code> detecting a numerical value.
  class NumberRule 
    include_class_members NumberRuleImports
    include IRule
    
    class_module.module_eval {
      # Internal setting for the un-initialized column constraint
      const_set_lazy(:UNDEFINED) { -1 }
      const_attr_reader  :UNDEFINED
    }
    
    # The token to be returned when this rule is successful
    attr_accessor :f_token
    alias_method :attr_f_token, :f_token
    undef_method :f_token
    alias_method :attr_f_token=, :f_token=
    undef_method :f_token=
    
    # The column constraint
    attr_accessor :f_column
    alias_method :attr_f_column, :f_column
    undef_method :f_column
    alias_method :attr_f_column=, :f_column=
    undef_method :f_column=
    
    typesig { [IToken] }
    # Creates a rule which will return the specified
    # token when a numerical sequence is detected.
    # 
    # @param token the token to be returned
    def initialize(token)
      @f_token = nil
      @f_column = UNDEFINED
      Assert.is_not_null(token)
      @f_token = token
    end
    
    typesig { [::Java::Int] }
    # Sets a column constraint for this rule. If set, the rule's token
    # will only be returned if the pattern is detected starting at the
    # specified column. If the column is smaller then 0, the column
    # constraint is considered removed.
    # 
    # @param column the column in which the pattern starts
    def set_column_constraint(column)
      if (column < 0)
        column = UNDEFINED
      end
      @f_column = column
    end
    
    typesig { [ICharacterScanner] }
    # @see IRule#evaluate(ICharacterScanner)
    def evaluate(scanner)
      c = scanner.read
      if (Character.is_digit(RJava.cast_to_char(c)))
        if ((@f_column).equal?(UNDEFINED) || ((@f_column).equal?(scanner.get_column - 1)))
          begin
            c = scanner.read
          end while (Character.is_digit(RJava.cast_to_char(c)))
          scanner.unread
          return @f_token
        end
      end
      scanner.unread
      return Token::UNDEFINED
    end
    
    private
    alias_method :initialize__number_rule, :initialize
  end
  
end
