require "rjava"

# Copyright (c) 2004, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Bindings::Keys
  module ParseExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Bindings::Keys
    }
  end
  
  # <p>
  # An exception indicating problems while parsing formal string representations
  # of either <code>KeyStroke</code> or <code>KeySequence</code> objects.
  # </p>
  # <p>
  # <code>ParseException</code> objects are immutable. Clients are not
  # permitted to extend this class.
  # </p>
  # 
  # @since 3.1
  class ParseException < ParseExceptionImports.const_get :JavaException
    include_class_members ParseExceptionImports
    
    class_module.module_eval {
      # Generated serial version UID for this class.
      # 
      # @since 3.1
      const_set_lazy(:SerialVersionUID) { 3257009864814376241 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    # Constructs a <code>ParseException</code> with the specified detail
    # message.
    # 
    # @param s
    # the detail message.
    def initialize(s)
      super(s)
    end
    
    private
    alias_method :initialize__parse_exception, :initialize
  end
  
end
