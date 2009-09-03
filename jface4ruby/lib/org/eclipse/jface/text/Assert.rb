require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module AssertImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # <code>Assert</code> is useful for for embedding runtime sanity checks
  # in code. The static predicate methods all test a condition and throw some
  # type of unchecked exception if the condition does not hold.
  # <p>
  # Assertion failure exceptions, like most runtime exceptions, are
  # thrown when something is misbehaving. Assertion failures are invariably
  # unspecified behavior; consequently, clients should never rely on
  # these being thrown (or not thrown). <b>If you find yourself in the
  # position where you need to catch an assertion failure, you have most
  # certainly written your program incorrectly.</b>
  # </p>
  # <p>
  # Note that an <code>assert</code> statement is slated to be added to the
  # Java language in JDK 1.4, rending this class obsolete.
  # </p>
  # 
  # @deprecated As of 3.3, replaced by {@link org.eclipse.core.runtime.Assert}
  # @noinstantiate This class is not intended to be instantiated by clients.
  class Assert 
    include_class_members AssertImports
    
    class_module.module_eval {
      # <code>AssertionFailedException</code> is a runtime exception thrown
      # by some of the methods in <code>Assert</code>.
      # <p>
      # This class is not declared public to prevent some misuses; programs that catch
      # or otherwise depend on assertion failures are susceptible to unexpected
      # breakage when assertions in the code are added or removed.
      # </p>
      # <p>
      # This class is not intended to be serialized.
      # </p>
      const_set_lazy(:AssertionFailedException) { Class.new(RuntimeException) do
        include_class_members Assert
        
        class_module.module_eval {
          # Serial version UID for this class.
          # <p>
          # Note: This class is not intended to be serialized.
          # </p>
          # @since 3.1
          const_set_lazy(:SerialVersionUID) { 3689918374733886002 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [String] }
        # Constructs a new exception with the given message.
        # 
        # @param detail the detailed message
        def initialize(detail)
          super(detail)
        end
        
        private
        alias_method :initialize__assertion_failed_exception, :initialize
      end }
    }
    
    typesig { [] }
    # This class is not intended to be instantiated.
    def initialize
    end
    
    class_module.module_eval {
      typesig { [::Java::Boolean] }
      # Asserts that an argument is legal. If the given boolean is
      # not <code>true</code>, an <code>IllegalArgumentException</code>
      # is thrown.
      # 
      # @param expression the outcome of the check
      # @return <code>true</code> if the check passes (does not return
      # if the check fails)
      # @exception IllegalArgumentException if the legality test failed
      def is_legal(expression)
        # succeed as quickly as possible
        if (expression)
          return true
        end
        return is_legal(expression, "") # $NON-NLS-1$
      end
      
      typesig { [::Java::Boolean, String] }
      # Asserts that an argument is legal. If the given boolean is
      # not <code>true</code>, an <code>IllegalArgumentException</code>
      # is thrown.
      # The given message is included in that exception, to aid debugging.
      # 
      # @param expression the outcome of the check
      # @param message the message to include in the exception
      # @return <code>true</code> if the check passes (does not return
      # if the check fails)
      # @exception IllegalArgumentException if the legality test failed
      def is_legal(expression, message)
        if (!expression)
          raise IllegalArgumentException.new("assertion failed; " + message)
        end # $NON-NLS-1$
        return expression
      end
      
      typesig { [Object] }
      # Asserts that the given object is not <code>null</code>. If this
      # is not the case, some kind of unchecked exception is thrown.
      # <p>
      # As a general rule, parameters passed to API methods must not be
      # <code>null</code> unless <b>explicitly</b> allowed in the method's
      # specification. Similarly, results returned from API methods are never
      # <code>null</code> unless <b>explicitly</b> allowed in the method's
      # specification. Implementations are encouraged to make regular use of
      # <code>Assert.isNotNull</code> to ensure that <code>null</code>
      # parameters are detected as early as possible.
      # </p>
      # 
      # @param object the value to test
      # @exception RuntimeException an unspecified unchecked exception if the object
      # is <code>null</code>
      def is_not_null(object)
        # succeed as quickly as possible
        if (!(object).nil?)
          return
        end
        is_not_null(object, "") # $NON-NLS-1$
      end
      
      typesig { [Object, String] }
      # Asserts that the given object is not <code>null</code>. If this
      # is not the case, some kind of unchecked exception is thrown.
      # The given message is included in that exception, to aid debugging.
      # <p>
      # As a general rule, parameters passed to API methods must not be
      # <code>null</code> unless <b>explicitly</b> allowed in the method's
      # specification. Similarly, results returned from API methods are never
      # <code>null</code> unless <b>explicitly</b> allowed in the method's
      # specification. Implementations are encouraged to make regular use of
      # <code>Assert.isNotNull</code> to ensure that <code>null</code>
      # parameters are detected as early as possible.
      # </p>
      # 
      # @param object the value to test
      # @param message the message to include in the exception
      # @exception RuntimeException an unspecified unchecked exception if the object
      # is <code>null</code>
      def is_not_null(object, message)
        if ((object).nil?)
          raise AssertionFailedException.new("null argument;" + message)
        end # $NON-NLS-1$
      end
      
      typesig { [::Java::Boolean] }
      # Asserts that the given boolean is <code>true</code>. If this
      # is not the case, some kind of unchecked exception is thrown.
      # 
      # @param expression the outcome of the check
      # @return <code>true</code> if the check passes (does not return
      # if the check fails)
      def is_true(expression)
        # succeed as quickly as possible
        if (expression)
          return true
        end
        return is_true(expression, "") # $NON-NLS-1$
      end
      
      typesig { [::Java::Boolean, String] }
      # Asserts that the given boolean is <code>true</code>. If this
      # is not the case, some kind of unchecked exception is thrown.
      # The given message is included in that exception, to aid debugging.
      # 
      # @param expression the outcome of the check
      # @param message the message to include in the exception
      # @return <code>true</code> if the check passes (does not return
      # if the check fails)
      def is_true(expression, message)
        if (!expression)
          raise AssertionFailedException.new("Assertion failed: " + message)
        end # $NON-NLS-1$
        return expression
      end
    }
    
    private
    alias_method :initialize__assert, :initialize
  end
  
end
