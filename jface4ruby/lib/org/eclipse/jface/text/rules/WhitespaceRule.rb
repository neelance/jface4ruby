require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Anton Leherbauer (Wind River Systems) - [misc] Allow custom token for WhitespaceRule - https://bugs.eclipse.org/bugs/show_bug.cgi?id=251224
module Org::Eclipse::Jface::Text::Rules
  module WhitespaceRuleImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Rules
      include_const ::Org::Eclipse::Core::Runtime, :Assert
    }
  end
  
  # An implementation of <code>IRule</code> capable of detecting whitespace.
  # A whitespace rule uses a whitespace detector in order to find out which
  # characters are whitespace characters.
  # 
  # @see IWhitespaceDetector
  class WhitespaceRule 
    include_class_members WhitespaceRuleImports
    include IRule
    
    # The whitespace detector used by this rule
    attr_accessor :f_detector
    alias_method :attr_f_detector, :f_detector
    undef_method :f_detector
    alias_method :attr_f_detector=, :f_detector=
    undef_method :f_detector=
    
    # The token returned for whitespace.
    # @since 3.5
    attr_accessor :f_whitespace_token
    alias_method :attr_f_whitespace_token, :f_whitespace_token
    undef_method :f_whitespace_token
    alias_method :attr_f_whitespace_token=, :f_whitespace_token=
    undef_method :f_whitespace_token=
    
    typesig { [IWhitespaceDetector] }
    # Creates a rule which, with the help of an whitespace detector, will return
    # {@link Token#WHITESPACE} when a whitespace is detected.
    # 
    # @param detector the rule's whitespace detector
    def initialize(detector)
      initialize__whitespace_rule(detector, Token::WHITESPACE)
    end
    
    typesig { [IWhitespaceDetector, IToken] }
    # Creates a rule which, with the help of an whitespace detector, will return the given
    # whitespace token when a whitespace is detected.
    # 
    # @param detector the rule's whitespace detector
    # @param token the token returned for whitespace
    # @since 3.5
    def initialize(detector, token)
      @f_detector = nil
      @f_whitespace_token = nil
      Assert.is_not_null(detector)
      Assert.is_not_null(token)
      @f_detector = detector
      @f_whitespace_token = token
    end
    
    typesig { [ICharacterScanner] }
    # {@inheritDoc}
    # 
    # @return {@link #fWhitespaceToken} if whitespace got detected, {@link Token#UNDEFINED}
    # otherwise
    def evaluate(scanner)
      c = scanner.read
      if (@f_detector.is_whitespace(RJava.cast_to_char(c)))
        begin
          c = scanner.read
        end while (@f_detector.is_whitespace(RJava.cast_to_char(c)))
        scanner.unread
        return @f_whitespace_token
      end
      scanner.unread
      return Token::UNDEFINED
    end
    
    private
    alias_method :initialize__whitespace_rule, :initialize
  end
  
end
