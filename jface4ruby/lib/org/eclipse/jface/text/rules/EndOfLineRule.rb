require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Christopher Lenz (cmlenz@gmx.de) - support for line continuation
module Org::Eclipse::Jface::Text::Rules
  module EndOfLineRuleImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
    }
  end
  
  # A specific configuration of a single line rule
  # whereby the pattern begins with a specific sequence but
  # is only ended by a line delimiter.
  class EndOfLineRule < EndOfLineRuleImports.const_get :SingleLineRule
    include_class_members EndOfLineRuleImports
    
    typesig { [String, IToken] }
    # Creates a rule for the given starting sequence
    # which, if detected, will return the specified token.
    # 
    # @param startSequence the pattern's start sequence
    # @param token the token to be returned on success
    def initialize(start_sequence, token)
      initialize__end_of_line_rule(start_sequence, token, RJava.cast_to_char(0))
    end
    
    typesig { [String, IToken, ::Java::Char] }
    # Creates a rule for the given starting sequence
    # which, if detected, will return the specified token.
    # Any character which follows the given escape character
    # will be ignored.
    # 
    # @param startSequence the pattern's start sequence
    # @param token the token to be returned on success
    # @param escapeCharacter the escape character
    def initialize(start_sequence, token, escape_character)
      super(start_sequence, nil, token, escape_character, true)
    end
    
    typesig { [String, IToken, ::Java::Char, ::Java::Boolean] }
    # Creates a rule for the given starting sequence
    # which, if detected, will return the specified token.
    # Any character which follows the given escape character
    # will be ignored. In addition, an escape character
    # immediately before an end of line can be set to continue
    # the line.
    # 
    # @param startSequence the pattern's start sequence
    # @param token the token to be returned on success
    # @param escapeCharacter the escape character
    # @param escapeContinuesLine indicates whether the specified escape
    # character is used for line continuation, so that an end of
    # line immediately after the escape character does not
    # terminate the line, even if <code>breakOnEOL</code> is true
    # @since 3.0
    def initialize(start_sequence, token, escape_character, escape_continues_line)
      super(start_sequence, nil, token, escape_character, true, escape_continues_line)
    end
    
    private
    alias_method :initialize__end_of_line_rule, :initialize
  end
  
end
