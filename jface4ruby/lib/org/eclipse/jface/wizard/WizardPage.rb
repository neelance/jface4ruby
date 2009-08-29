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
  module WizardPageImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Wizard
      include_const ::Org::Eclipse::Jface::Dialogs, :DialogPage
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogSettings
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # An abstract base implementation of a wizard page.
  # <p>
  # Subclasses must implement the <code>createControl</code> method
  # to create the specific controls for the wizard page.
  # </p>
  # <p>
  # Subclasses may call the following methods to configure the wizard page:
  # <ul>
  # <li><code>setDescription</code></li>
  # <li><code>setErrorMessage</code></li>
  # <li><code>setImageDescriptor</code></li>
  # <li><code>setMessage</code></li>
  # <li><code>setPageComplete</code></li>
  # <li><code>setPreviousPage</code></li>
  # <li><code>setTitle</code></li>
  # </ul>
  # </p>
  # <p>
  # Subclasses may override these methods if required:
  # <ul>
  # <li><code>performHelp</code> - may be reimplemented to display help for the page</li>
  # <li><code>canFlipToNextPage</code> - may be extended or reimplemented</li>
  # <li><code>isPageComplete</code> - may be extended </li>
  # <li><code>setDescription</code> - may be extended </li>
  # <li><code>setTitle</code> - may be extended </li>
  # <li><code>dispose</code> - may be extended to dispose additional allocated SWT resources</li>
  # </ul>
  # </p>
  # <p>
  # Note that clients are free to implement <code>IWizardPage</code> from scratch
  # instead of subclassing <code>WizardPage</code>. Correct implementations of
  # <code>IWizardPage</code> will work with any correct implementation of
  # <code>IWizard</code>.
  # </p>
  class WizardPage < WizardPageImports.const_get :DialogPage
    include_class_members WizardPageImports
    overload_protected {
      include IWizardPage
    }
    
    # This page's name.
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # The wizard to which this page belongs; <code>null</code>
    # if this page has yet to be added to a wizard.
    attr_accessor :wizard
    alias_method :attr_wizard, :wizard
    undef_method :wizard
    alias_method :attr_wizard=, :wizard=
    undef_method :wizard=
    
    # Indicates whether this page is complete.
    attr_accessor :is_page_complete
    alias_method :attr_is_page_complete, :is_page_complete
    undef_method :is_page_complete
    alias_method :attr_is_page_complete=, :is_page_complete=
    undef_method :is_page_complete=
    
    # The page that was shown right before this page became visible;
    # <code>null</code> if none.
    attr_accessor :previous_page
    alias_method :attr_previous_page, :previous_page
    undef_method :previous_page
    alias_method :attr_previous_page=, :previous_page=
    undef_method :previous_page=
    
    typesig { [String] }
    # Creates a new wizard page with the given name, and
    # with no title or image.
    # 
    # @param pageName the name of the page
    def initialize(page_name)
      initialize__wizard_page(page_name, nil, nil)
    end
    
    typesig { [String, String, ImageDescriptor] }
    # Creates a new wizard page with the given name, title, and image.
    # 
    # @param pageName the name of the page
    # @param title the title for this wizard page,
    # or <code>null</code> if none
    # @param titleImage the image descriptor for the title of this wizard page,
    # or <code>null</code> if none
    def initialize(page_name, title, title_image)
      @name = nil
      @wizard = nil
      @is_page_complete = false
      @previous_page = nil
      super(title, title_image)
      @wizard = nil
      @is_page_complete = true
      @previous_page = nil
      Assert.is_not_null(page_name) # page name must not be null
      @name = page_name
    end
    
    typesig { [] }
    # The <code>WizardPage</code> implementation of this <code>IWizardPage</code>
    # method returns <code>true</code> if this page is complete (<code>isPageComplete</code>)
    # and there is a next page to flip to. Subclasses may override (extend or reimplement).
    # 
    # @see #getNextPage
    # @see #isPageComplete()
    def can_flip_to_next_page
      return is_page_complete && !(get_next_page).nil?
    end
    
    typesig { [] }
    # Returns the wizard container for this wizard page.
    # 
    # @return the wizard container, or <code>null</code> if this
    # wizard page has yet to be added to a wizard, or the
    # wizard has yet to be added to a container
    def get_container
      if ((@wizard).nil?)
        return nil
      end
      return @wizard.get_container
    end
    
    typesig { [] }
    # Returns the dialog settings for this wizard page.
    # 
    # @return the dialog settings, or <code>null</code> if none
    def get_dialog_settings
      if ((@wizard).nil?)
        return nil
      end
      return @wizard.get_dialog_settings
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IDialogPage.
    def get_image
      result = super
      if ((result).nil? && !(@wizard).nil?)
        return @wizard.get_default_page_image
      end
      return result
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IWizardPage.
    def get_name
      return @name
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IWizardPage.
    # The default behavior is to ask the wizard for the next page.
    def get_next_page
      if ((@wizard).nil?)
        return nil
      end
      return @wizard.get_next_page(self)
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IWizardPage.
    # The default behavior is return the cached previous back or,
    # lacking that, to ask the wizard for the previous page.
    def get_previous_page
      if (!(@previous_page).nil?)
        return @previous_page
      end
      if ((@wizard).nil?)
        return nil
      end
      return @wizard.get_previous_page(self)
    end
    
    typesig { [] }
    # The <code>WizardPage</code> implementation of this method declared on
    # <code>DialogPage</code> returns the shell of the container.
    # The advantage of this implementation is that the shell is accessable
    # once the container is created even though this page's control may not
    # yet be created.
    def get_shell
      container = get_container
      if ((container).nil?)
        return nil
      end
      # Ask the wizard since our contents may not have been created.
      return container.get_shell
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on IWizardPage.
    def get_wizard
      return @wizard
    end
    
    typesig { [] }
    # Returns whether this page is the current one in the wizard's container.
    # 
    # @return <code>true</code> if the page is active,
    # and <code>false</code> otherwise
    def is_current_page
      return (!(get_container).nil? && (self).equal?(get_container.get_current_page))
    end
    
    typesig { [] }
    # The <code>WizardPage</code> implementation of this <code>IWizard</code> method
    # returns the value of an internal state variable set by
    # <code>setPageComplete</code>. Subclasses may extend.
    def is_page_complete
      return @is_page_complete
    end
    
    typesig { [String] }
    # The <code>WizardPage</code> implementation of this <code>IDialogPage</code>
    # method extends the <code>DialogPage</code> implementation to update
    # the wizard container title bar. Subclasses may extend.
    def set_description(description)
      super(description)
      if (is_current_page)
        get_container.update_title_bar
      end
    end
    
    typesig { [String] }
    # The <code>WizardPage</code> implementation of this method
    # declared on <code>DialogPage</code> updates the container
    # if this is the current page.
    def set_error_message(new_message)
      super(new_message)
      if (is_current_page)
        get_container.update_message
      end
    end
    
    typesig { [ImageDescriptor] }
    # The <code>WizardPage</code> implementation of this method
    # declared on <code>DialogPage</code> updates the container
    # if this page is the current page.
    def set_image_descriptor(image)
      super(image)
      if (is_current_page)
        get_container.update_title_bar
      end
    end
    
    typesig { [String, ::Java::Int] }
    # The <code>WizardPage</code> implementation of this method
    # declared on <code>DialogPage</code> updates the container
    # if this is the current page.
    def set_message(new_message, new_type)
      super(new_message, new_type)
      if (is_current_page)
        get_container.update_message
      end
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether this page is complete.
    # <p>
    # This information is typically used by the wizard to decide
    # when it is okay to move on to the next page or finish up.
    # </p>
    # 
    # @param complete <code>true</code> if this page is complete, and
    # and <code>false</code> otherwise
    # @see #isPageComplete()
    def set_page_complete(complete)
      @is_page_complete = complete
      if (is_current_page)
        get_container.update_buttons
      end
    end
    
    typesig { [IWizardPage] }
    # (non-Javadoc)
    # Method declared on IWizardPage.
    def set_previous_page(page)
      @previous_page = page
    end
    
    typesig { [String] }
    # The <code>WizardPage</code> implementation of this <code>IDialogPage</code>
    # method extends the <code>DialogPage</code> implementation to update
    # the wizard container title bar. Subclasses may extend.
    def set_title(title)
      super(title)
      if (is_current_page)
        get_container.update_title_bar
      end
    end
    
    typesig { [IWizard] }
    # (non-Javadoc)
    # Method declared on IWizardPage.
    def set_wizard(new_wizard)
      @wizard = new_wizard
    end
    
    typesig { [] }
    # Returns a printable representation of this wizard page suitable
    # only for debug purposes.
    def to_s
      return @name
    end
    
    private
    alias_method :initialize__wizard_page, :initialize
  end
  
end
