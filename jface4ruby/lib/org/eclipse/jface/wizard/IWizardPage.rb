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
  module IWizardPageImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Wizard
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogPage
    }
  end
  
  # Interface for a wizard page.
  # <p>
  # The class <code>WizardPage</code> provides an abstract implementation
  # of this interface. However, clients are also free to implement this
  # interface if <code>WizardPage</code> does not suit their needs.
  # </p>
  module IWizardPage
    include_class_members IWizardPageImports
    include IDialogPage
    
    typesig { [] }
    # Returns whether the next page could be displayed.
    # 
    # @return <code>true</code> if the next page could be displayed,
    # and <code>false</code> otherwise
    def can_flip_to_next_page
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns this page's name.
    # 
    # @return the name of this page
    def get_name
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the wizard page that would to be shown if the user was to
    # press the Next button.
    # 
    # @return the next wizard page, or <code>null</code> if none
    def get_next_page
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the wizard page that would to be shown if the user was to
    # press the Back button.
    # 
    # @return the previous wizard page, or <code>null</code> if none
    def get_previous_page
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the wizard that hosts this wizard page.
    # 
    # @return the wizard, or <code>null</code> if this page has not been
    # added to any wizard
    # @see #setWizard
    def get_wizard
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this page is complete or not.
    # <p>
    # This information is typically used by the wizard to decide
    # when it is okay to finish.
    # </p>
    # 
    # @return <code>true</code> if this page is complete, and
    # <code>false</code> otherwise
    def is_page_complete
      raise NotImplementedError
    end
    
    typesig { [IWizardPage] }
    # Sets the wizard page that would typically be shown
    # if the user was to press the Back button.
    # <p>
    # This method is called by the container.
    # </p>
    # 
    # @param page the previous wizard page
    def set_previous_page(page)
      raise NotImplementedError
    end
    
    typesig { [IWizard] }
    # Sets the wizard that hosts this wizard page.
    # Once established, a page's wizard cannot be changed
    # to a different wizard.
    # 
    # @param newWizard the wizard
    # @see #getWizard
    def set_wizard(new_wizard)
      raise NotImplementedError
    end
  end
  
end
