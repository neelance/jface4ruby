require "rjava"

# Copyright (c) 2000, 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text::Link::Contentassist
  module Helper2Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text::Link::Contentassist
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # Helper class for testing widget state.
  class Helper2 
    include_class_members Helper2Imports
    
    class_module.module_eval {
      typesig { [Widget] }
      # Returns whether the widget is <code>null</code> or disposed.
      # 
      # @param widget the widget to check
      # @return <code>true</code> if the widget is neither <code>null</code> nor disposed
      def ok_to_use(widget)
        return (!(widget).nil? && !widget.is_disposed)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__helper2, :initialize
  end
  
end
