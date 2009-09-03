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
  module MultiLineRuleImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
    }
  end
  
  # A rule for detecting patterns which begin with a given
  # sequence and may end with a given sequence thereby spanning
  # multiple lines.
  class MultiLineRule < MultiLineRuleImports.const_get :PatternRule
    include_class_members MultiLineRuleImports
    
    typesig { [String, String, IToken] }
    # Creates a rule for the given starting and ending sequence
    # which, if detected, will return the specified token.
    # 
    # @param startSequence the pattern's start sequence
    # @param endSequence the pattern's end sequence
    # @param token the token to be returned on success
    def initialize(start_sequence, end_sequence, token)
      initialize__multi_line_rule(start_sequence, end_sequence, token, RJava.cast_to_char(0))
    end
    
    typesig { [String, String, IToken, ::Java::Char] }
    # Creates a rule for the given starting and ending sequence
    # which, if detected, will return the specific token.
    # Any character which follows the given escape character will be ignored.
    # 
    # @param startSequence the pattern's start sequence
    # @param endSequence the pattern's end sequence
    # @param token the token to be returned on success
    # @param escapeCharacter the escape character
    def initialize(start_sequence, end_sequence, token, escape_character)
      initialize__multi_line_rule(start_sequence, end_sequence, token, escape_character, false)
    end
    
    typesig { [String, String, IToken, ::Java::Char, ::Java::Boolean] }
    # Creates a rule for the given starting and ending sequence
    # which, if detected, will return the specific token. Any character that follows the
    # given escape character will be ignored. <code>breakOnEOF</code> indicates whether
    # EOF is equivalent to detecting the <code>endSequence</code>.
    # 
    # @param startSequence the pattern's start sequence
    # @param endSequence the pattern's end sequence
    # @param token the token to be returned on success
    # @param escapeCharacter the escape character
    # @param breaksOnEOF indicates whether the end of the file terminates this rule successfully
    # @since 2.1
    def initialize(start_sequence, end_sequence, token, escape_character, breaks_on_eof)
      super(start_sequence, end_sequence, token, escape_character, false, breaks_on_eof)
    end
    
    private
    alias_method :initialize__multi_line_rule, :initialize
  end
  
end
