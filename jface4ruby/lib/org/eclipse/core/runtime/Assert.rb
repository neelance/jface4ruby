require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Runtime
  module AssertImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Runtime
    }
  end
  
  # <code>Assert</code> is useful for for embedding runtime sanity checks
  # in code. The predicate methods all test a condition and throw some
  # type of unchecked exception if the condition does not hold.
  # <p>
  # Assertion failure exceptions, like most runtime exceptions, are
  # thrown when something is misbehaving. Assertion failures are invariably
  # unspecified behavior; consequently, clients should never rely on
  # these being thrown (and certainly should not being catching them
  # specifically).
  # </p><p>
  # This class can be used without OSGi running.
  # </p><p>
  # This class is not intended to be instantiated or sub-classed by clients.
  # </p>
  # @since org.eclipse.equinox.common 3.2
  # @noinstantiate This class is not intended to be instantiated by clients.
  class Assert 
    include_class_members AssertImports
    
    typesig { [] }
    # This class is not intended to be instantiated.
    def initialize
      # not allowed
    end
    
    class_module.module_eval {
      typesig { [::Java::Boolean] }
      # Asserts that an argument is legal. If the given boolean is
      # not <code>true</code>, an <code>IllegalArgumentException</code>
      # is thrown.
      # 
      # @param expression the outcode of the check
      # @return <code>true</code> if the check passes (does not return
      # if the check fails)
      # @exception IllegalArgumentException if the legality test failed
      def is_legal(expression)
        return is_legal(expression, "") # $NON-NLS-1$
      end
      
      typesig { [::Java::Boolean, String] }
      # Asserts that an argument is legal. If the given boolean is
      # not <code>true</code>, an <code>IllegalArgumentException</code>
      # is thrown.
      # The given message is included in that exception, to aid debugging.
      # 
      # @param expression the outcode of the check
      # @param message the message to include in the exception
      # @return <code>true</code> if the check passes (does not return
      # if the check fails)
      # @exception IllegalArgumentException if the legality test failed
      def is_legal(expression, message)
        if (!expression)
          raise IllegalArgumentException.new(message)
        end
        return expression
      end
      
      typesig { [Object] }
      # Asserts that the given object is not <code>null</code>. If this
      # is not the case, some kind of unchecked exception is thrown.
      # 
      # @param object the value to test
      def is_not_null(object)
        is_not_null(object, "") # $NON-NLS-1$
      end
      
      typesig { [Object, String] }
      # Asserts that the given object is not <code>null</code>. If this
      # is not the case, some kind of unchecked exception is thrown.
      # The given message is included in that exception, to aid debugging.
      # 
      # @param object the value to test
      # @param message the message to include in the exception
      def is_not_null(object, message)
        if ((object).nil?)
          raise AssertionFailedException.new("null argument:" + message)
        end # $NON-NLS-1$
      end
      
      typesig { [::Java::Boolean] }
      # Asserts that the given boolean is <code>true</code>. If this
      # is not the case, some kind of unchecked exception is thrown.
      # 
      # @param expression the outcode of the check
      # @return <code>true</code> if the check passes (does not return
      # if the check fails)
      def is_true(expression)
        return is_true(expression, "") # $NON-NLS-1$
      end
      
      typesig { [::Java::Boolean, String] }
      # Asserts that the given boolean is <code>true</code>. If this
      # is not the case, some kind of unchecked exception is thrown.
      # The given message is included in that exception, to aid debugging.
      # 
      # @param expression the outcode of the check
      # @param message the message to include in the exception
      # @return <code>true</code> if the check passes (does not return
      # if the check fails)
      def is_true(expression, message)
        if (!expression)
          raise AssertionFailedException.new("assertion failed: " + message)
        end # $NON-NLS-1$
        return expression
      end
    }
    
    private
    alias_method :initialize__assert, :initialize
  end
  
end
