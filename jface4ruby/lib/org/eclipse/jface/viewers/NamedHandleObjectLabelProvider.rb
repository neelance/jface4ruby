require "rjava"

# Copyright (c) 2005, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module NamedHandleObjectLabelProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Org::Eclipse::Core::Commands::Common, :NamedHandleObject
      include_const ::Org::Eclipse::Core::Commands::Common, :NotDefinedException
    }
  end
  
  # A label provider for instances of <code>NamedHandlerObject</code>, which
  # exposes the name as the label.
  # 
  # @since 3.2
  class NamedHandleObjectLabelProvider < NamedHandleObjectLabelProviderImports.const_get :LabelProvider
    include_class_members NamedHandleObjectLabelProviderImports
    
    typesig { [Object] }
    # The text of the element is simply the name of the element if its a
    # defined instance of <code>NamedHandleObject</code>. Otherwise, this
    # method just returns <code>null</code>.
    # 
    # @param element
    # The element for which the text should be retrieved; may be
    # <code>null</code>.
    # @return the name of the handle object; <code>null</code> if there is no
    # name or if the element is not a named handle object.
    def get_text(element)
      if (element.is_a?(NamedHandleObject))
        begin
          return (element).get_name
        rescue NotDefinedException => e
          return nil
        end
      end
      return nil
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__named_handle_object_label_provider, :initialize
  end
  
end
