require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module DefaultAutoIndentStrategyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Default implementation of {@link org.eclipse.jface.text.IAutoIndentStrategy}.
  # This strategy always copies the indentation of the previous line.
  # <p>
  # This class is not intended to be subclassed.</p>
  # 
  # @deprecated since 3.1 use {@link org.eclipse.jface.text.DefaultIndentLineAutoEditStrategy} instead
  # @noextend This class is not intended to be subclassed by clients.
  class DefaultAutoIndentStrategy < DefaultAutoIndentStrategyImports.const_get :DefaultIndentLineAutoEditStrategy
    include_class_members DefaultAutoIndentStrategyImports
    overload_protected {
      include IAutoIndentStrategy
    }
    
    typesig { [] }
    # Creates a new default auto indent strategy.
    def initialize
      super()
    end
    
    private
    alias_method :initialize__default_auto_indent_strategy, :initialize
  end
  
end
