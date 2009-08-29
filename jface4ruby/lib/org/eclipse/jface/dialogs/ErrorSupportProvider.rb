require "rjava"

# Copyright (c) 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module ErrorSupportProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # A ErrorSupportProvider defines the area to be shown in an error dialog for extra support information.
  # @since 3.3
  class ErrorSupportProvider 
    include_class_members ErrorSupportProviderImports
    
    typesig { [Composite, IStatus] }
    # Create an area for adding support components as a child of parent.
    # @param parent The parent {@link Composite}
    # @param status The {@link IStatus} that is being displayed.
    # @return Control
    def create_support_area(parent, status)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__error_support_provider, :initialize
  end
  
end
