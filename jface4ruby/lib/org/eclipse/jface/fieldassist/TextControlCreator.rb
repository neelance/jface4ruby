require "rjava"

# Copyright (c) 2005, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Fieldassist
  module TextControlCreatorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Fieldassist
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Text
    }
  end
  
  # An {@link IControlCreator} for SWT Text controls. This is a convenience class
  # for creating text controls to be supplied to a decorated field.
  # 
  # @since 3.2
  # @deprecated As of 3.3, clients should use {@link ControlDecoration} instead
  # of {@link DecoratedField}.
  class TextControlCreator 
    include_class_members TextControlCreatorImports
    include IControlCreator
    
    typesig { [Composite, ::Java::Int] }
    def create_control(parent, style)
      return Text.new(parent, style)
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__text_control_creator, :initialize
  end
  
end
