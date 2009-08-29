require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Wizard
  module IWizardContainerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Wizard
      include_const ::Org::Eclipse::Jface::Operation, :IRunnableContext
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # Interface for containers that can host a wizard. It displays
  # wizard pages, at most one of which is considered
  # the current page. <code>getCurrentPage</code> returns the
  # current page; <code>showPage</code> programmatically changes the
  # the current page. Note that the pages need not all belong
  # to the same wizard.
  # <p>
  # The class <code>WizardDialog</code> provides a fully functional
  # implementation of this interface which will meet the needs of
  # most clients. However, clients are also free to implement this
  # interface if <code>WizardDialog</code> does not suit their needs.
  # </p>
  # <p>
  # Implementors are responsible for disposing of their wizards.
  # </p>
  # 
  # @see org.eclipse.jface.wizard.IWizardContainer2
  module IWizardContainer
    include_class_members IWizardContainerImports
    include IRunnableContext
    
    typesig { [] }
    # Returns the current wizard page for this container.
    # 
    # @return the current wizard page, or <code>null</code> if the container
    # is not yet showing the wizard
    # @see #showPage
    def get_current_page
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the shell for this wizard container.
    # 
    # @return the shell, or <code>null</code> if this wizard
    # container does not have a shell
    def get_shell
      raise NotImplementedError
    end
    
    typesig { [IWizardPage] }
    # Makes the given page visible.
    # <p>
    # This method should not be use for normal page
    # sequencing (back, next) which is handled by the
    # container itself. It may, however, be used to
    # move to another page in response to some custom
    # action such as double clicking in a list.
    # </p>
    # 
    # @param page the page to show
    # @see #getCurrentPage
    def show_page(page)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Adjusts the enable state of the Back, Next, and Finish
    # buttons to reflect the state of the currently active
    # page in this container.
    # <p>
    # This method is called by the container itself
    # when its wizard page changes and may be called
    # by the page at other times to force a button state
    # update.
    # </p>
    def update_buttons
      raise NotImplementedError
    end
    
    typesig { [] }
    # Updates the message (or error message) shown in the message line to
    # reflect the state of the currently active page in this container.
    # <p>
    # This method is called by the container itself
    # when its wizard page changes and may be called
    # by the page at other times to force a message
    # update.
    # </p>
    def update_message
      raise NotImplementedError
    end
    
    typesig { [] }
    # Updates the title bar (title, description, and image) to
    # reflect the state of the currently active page in this container.
    # <p>
    # This method is called by the container itself
    # when its wizard page changes and may be called
    # by the page at other times to force a title bar
    # update.
    # </p>
    def update_title_bar
      raise NotImplementedError
    end
    
    typesig { [] }
    # Updates the window title to reflect the state of the current wizard.
    # <p>
    # This method is called by the container itself
    # when its wizard changes and may be called
    # by the wizard at other times to force a window
    # title change.
    # </p>
    def update_window_title
      raise NotImplementedError
    end
  end
  
end
