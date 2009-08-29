require "rjava"

# Copyright (c) 2005 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module DialogTrayImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # <p>
  # This class is the abstract superclass of all dialog trays. A tray can be opened
  # in any <code>TrayDialog</code>.
  # </p>
  # 
  # @see org.eclipse.jface.dialogs.TrayDialog
  # @since 3.2
  class DialogTray 
    include_class_members DialogTrayImports
    
    typesig { [Composite] }
    # Creates the contents (widgets) that will be contained in the tray.
    # <p>
    # Tray implementions must not set a layout on the parent composite, or assume
    # a particular layout on the parent. The tray dialog will allocate space
    # according to the natural size of the tray, and will fill the tray area with the
    # tray's contents.
    # </p>
    # 
    # @param parent the composite that will contain the tray
    # @return the contents of the tray, as a <code>Control</code>
    def create_contents(parent)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__dialog_tray, :initialize
  end
  
end
