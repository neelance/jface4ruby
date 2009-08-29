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
  module IWizardImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Wizard
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogSettings
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
    }
  end
  
  # Interface for a wizard.  A wizard maintains a list of wizard pages,
  # stacked on top of each other in card layout fashion.
  # <p>
  # The class <code>Wizard</code> provides an abstract implementation
  # of this interface. However, clients are also free to implement this
  # interface if <code>Wizard</code> does not suit their needs.
  # </p>
  # @see Wizard
  module IWizard
    include_class_members IWizardImports
    
    typesig { [] }
    # Adds any last-minute pages to this wizard.
    # <p>
    # This method is called just before the wizard becomes visible, to give the
    # wizard the opportunity to add any lazily created pages.
    # </p>
    def add_pages
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this wizard could be finished without further user
    # interaction.
    # <p>
    # The result of this method is typically used by the wizard container to enable
    # or disable the Finish button.
    # </p>
    # 
    # @return <code>true</code> if the wizard could be finished,
    # and <code>false</code> otherwise
    def can_finish
      raise NotImplementedError
    end
    
    typesig { [Composite] }
    # Creates this wizard's controls in the given parent control.
    # <p>
    # The wizard container calls this method to create the controls
    # for the wizard's pages before the wizard is opened. This allows
    # the wizard to size correctly; otherwise a resize may occur when
    # moving to a new page.
    # </p>
    # 
    # @param pageContainer the parent control
    def create_page_controls(page_container)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Disposes of this wizard and frees all SWT resources.
    def dispose
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the container of this wizard.
    # 
    # @return the wizard container, or <code>null</code> if this
    # wizard has yet to be added to a container
    def get_container
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the default page image for this wizard.
    # <p>
    # This image can be used for pages which do not
    # supply their own image.
    # </p>
    # 
    # @return the default page image
    def get_default_page_image
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the dialog settings for this wizard.
    # <p>
    # The dialog store is used to record state between
    # wizard invocations (for example, radio button selections,
    # last directory, etc.).
    # </p>
    # 
    # @return the dialog settings, or <code>null</code> if none
    def get_dialog_settings
      raise NotImplementedError
    end
    
    typesig { [IWizardPage] }
    # Returns the successor of the given page.
    # <p>
    # This method is typically called by a wizard page
    # </p>
    # 
    # @param page the page
    # @return the next page, or <code>null</code> if none
    def get_next_page(page)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns the wizard page with the given name belonging to this wizard.
    # 
    # @param pageName the name of the wizard page
    # @return the wizard page with the given name, or <code>null</code> if none
    def get_page(page_name)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the number of pages in this wizard.
    # 
    # @return the number of wizard pages
    def get_page_count
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns all the pages in this wizard.
    # 
    # @return a list of pages
    def get_pages
      raise NotImplementedError
    end
    
    typesig { [IWizardPage] }
    # Returns the predecessor of the given page.
    # <p>
    # This method is typically called by a wizard page
    # </p>
    # 
    # @param page the page
    # @return the previous page, or <code>null</code> if none
    def get_previous_page(page)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the first page to be shown in this wizard.
    # 
    # @return the first wizard page
    def get_starting_page
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the title bar color for this wizard.
    # 
    # @return the title bar color
    def get_title_bar_color
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the window title string for this wizard.
    # 
    # @return the window title string, or <code>null</code> for no title
    def get_window_title
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether help is available for this wizard.
    # <p>
    # The result of this method is typically used by the container to
    # show or hide the Help button.
    # </p>
    # 
    # @return <code>true</code> if help is available,
    # and <code>false</code> if this wizard is helpless
    def is_help_available
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this wizard needs Previous and Next buttons.
    # <p>
    # The result of this method is typically used by the container.
    # </p>
    # 
    # @return <code>true</code> if Previous and Next buttons are required,
    # and <code>false</code> if none are needed
    def needs_previous_and_next_buttons
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns whether this wizard needs a progress monitor.
    # <p>
    # The result of this method is typically used by the container.
    # </p>
    # 
    # @return <code>true</code> if a progress monitor is required,
    # and <code>false</code> if none is needed
    def needs_progress_monitor
      raise NotImplementedError
    end
    
    typesig { [] }
    # Performs any actions appropriate in response to the user
    # having pressed the Cancel button, or refuse if canceling
    # now is not permitted.
    # 
    # @return <code>true</code> to indicate the cancel request
    # was accepted, and <code>false</code> to indicate
    # that the cancel request was refused
    def perform_cancel
      raise NotImplementedError
    end
    
    typesig { [] }
    # Performs any actions appropriate in response to the user
    # having pressed the Finish button, or refuse if finishing
    # now is not permitted.
    # 
    # Normally this method is only called on the container's
    # current wizard. However if the current wizard is a nested wizard
    # this method will also be called on all wizards in its parent chain.
    # Such parents may use this notification to save state etc. However,
    # the value the parents return from this method is ignored.
    # 
    # @return <code>true</code> to indicate the finish request
    # was accepted, and <code>false</code> to indicate
    # that the finish request was refused
    def perform_finish
      raise NotImplementedError
    end
    
    typesig { [IWizardContainer] }
    # Sets or clears the container of this wizard.
    # 
    # @param wizardContainer the wizard container, or <code>null</code>
    def set_container(wizard_container)
      raise NotImplementedError
    end
  end
  
end
