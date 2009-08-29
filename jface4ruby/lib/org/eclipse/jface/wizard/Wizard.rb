require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Wizard
  module WizardImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Wizard
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogSettings
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # An abstract base implementation of a wizard. A typical client subclasses
  # <code>Wizard</code> to implement a particular wizard.
  # <p>
  # Subclasses may call the following methods to configure the wizard:
  # <ul>
  # <li><code>addPage</code></li>
  # <li><code>setHelpAvailable</code></li>
  # <li><code>setDefaultPageImageDescriptor</code></li>
  # <li><code>setDialogSettings</code></li>
  # <li><code>setNeedsProgressMonitor</code></li>
  # <li><code>setTitleBarColor</code></li>
  # <li><code>setWindowTitle</code></li>
  # </ul>
  # </p>
  # <p>
  # Subclasses may override these methods if required:
  # <ul>
  # <li>reimplement <code>createPageControls</code></li>
  # <li>reimplement <code>performCancel</code></li>
  # <li>extend <code>addPages</code></li>
  # <li>reimplement <code>performFinish</code></li>
  # <li>extend <code>dispose</code></li>
  # </ul>
  # </p>
  # <p>
  # Note that clients are free to implement <code>IWizard</code> from scratch
  # instead of subclassing <code>Wizard</code>. Correct implementations of
  # <code>IWizard</code> will work with any correct implementation of
  # <code>IWizardPage</code>.
  # </p>
  class Wizard 
    include_class_members WizardImports
    include IWizard
    
    class_module.module_eval {
      # Image registry key of the default image for wizard pages (value
      # <code>"org.eclipse.jface.wizard.Wizard.pageImage"</code>).
      const_set_lazy(:DEFAULT_IMAGE) { "org.eclipse.jface.wizard.Wizard.pageImage" }
      const_attr_reader  :DEFAULT_IMAGE
    }
    
    # $NON-NLS-1$
    # 
    # The wizard container this wizard belongs to; <code>null</code> if none.
    attr_accessor :container
    alias_method :attr_container, :container
    undef_method :container
    alias_method :attr_container=, :container=
    undef_method :container=
    
    # This wizard's list of pages (element type: <code>IWizardPage</code>).
    attr_accessor :pages
    alias_method :attr_pages, :pages
    undef_method :pages
    alias_method :attr_pages=, :pages=
    undef_method :pages=
    
    # Indicates whether this wizard needs a progress monitor.
    attr_accessor :needs_progress_monitor
    alias_method :attr_needs_progress_monitor, :needs_progress_monitor
    undef_method :needs_progress_monitor
    alias_method :attr_needs_progress_monitor=, :needs_progress_monitor=
    undef_method :needs_progress_monitor=
    
    # Indicates whether this wizard needs previous and next buttons even if the
    # wizard has only one page.
    attr_accessor :force_previous_and_next_buttons
    alias_method :attr_force_previous_and_next_buttons, :force_previous_and_next_buttons
    undef_method :force_previous_and_next_buttons
    alias_method :attr_force_previous_and_next_buttons=, :force_previous_and_next_buttons=
    undef_method :force_previous_and_next_buttons=
    
    # Indicates whether this wizard supports help.
    attr_accessor :is_help_available
    alias_method :attr_is_help_available, :is_help_available
    undef_method :is_help_available
    alias_method :attr_is_help_available=, :is_help_available=
    undef_method :is_help_available=
    
    # The default page image for pages without one of their one;
    # <code>null</code> if none.
    attr_accessor :default_image
    alias_method :attr_default_image, :default_image
    undef_method :default_image
    alias_method :attr_default_image=, :default_image=
    undef_method :default_image=
    
    # The default page image descriptor, used for creating a default page image
    # if required; <code>null</code> if none.
    attr_accessor :default_image_descriptor
    alias_method :attr_default_image_descriptor, :default_image_descriptor
    undef_method :default_image_descriptor
    alias_method :attr_default_image_descriptor=, :default_image_descriptor=
    undef_method :default_image_descriptor=
    
    # The color of the wizard title bar; <code>null</code> if none.
    attr_accessor :title_bar_color
    alias_method :attr_title_bar_color, :title_bar_color
    undef_method :title_bar_color
    alias_method :attr_title_bar_color=, :title_bar_color=
    undef_method :title_bar_color=
    
    # The window title string for this wizard; <code>null</code> if none.
    attr_accessor :window_title
    alias_method :attr_window_title, :window_title
    undef_method :window_title
    alias_method :attr_window_title=, :window_title=
    undef_method :window_title=
    
    # The dialog settings for this wizard; <code>null</code> if none.
    attr_accessor :dialog_settings
    alias_method :attr_dialog_settings, :dialog_settings
    undef_method :dialog_settings
    alias_method :attr_dialog_settings=, :dialog_settings=
    undef_method :dialog_settings=
    
    typesig { [] }
    # Creates a new empty wizard.
    def initialize
      @container = nil
      @pages = ArrayList.new
      @needs_progress_monitor = false
      @force_previous_and_next_buttons = false
      @is_help_available = false
      @default_image = nil
      @default_image_descriptor = JFaceResources.get_image_registry.get_descriptor(DEFAULT_IMAGE)
      @title_bar_color = nil
      @window_title = nil
      @dialog_settings = nil
    end
    
    typesig { [IWizardPage] }
    # Adds a new page to this wizard. The page is inserted at the end of the
    # page list.
    # 
    # @param page
    # the new page
    def add_page(page)
      @pages.add(page)
      page.set_wizard(self)
    end
    
    typesig { [] }
    # The <code>Wizard</code> implementation of this <code>IWizard</code>
    # method does nothing. Subclasses should extend if extra pages need to be
    # added before the wizard opens. New pages should be added by calling
    # <code>addPage</code>.
    def add_pages
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizard.
    def can_finish
      # Default implementation is to check if all pages are complete.
      i = 0
      while i < @pages.size
        if (!(@pages.get(i)).is_page_complete)
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [Composite] }
    # The <code>Wizard</code> implementation of this <code>IWizard</code>
    # method creates all the pages controls using
    # <code>IDialogPage.createControl</code>. Subclasses should reimplement
    # this method if they want to delay creating one or more of the pages
    # lazily. The framework ensures that the contents of a page will be created
    # before attempting to show it.
    def create_page_controls(page_container)
      # the default behavior is to create all the pages controls
      i = 0
      while i < @pages.size
        page = @pages.get(i)
        page.create_control(page_container)
        # page is responsible for ensuring the created control is
        # accessable
        # via getControl.
        Assert.is_not_null(page.get_control)
        i += 1
      end
    end
    
    typesig { [] }
    # The <code>Wizard</code> implementation of this <code>IWizard</code>
    # method disposes all the pages controls using
    # <code>DialogPage.dispose</code>. Subclasses should extend this method
    # if the wizard instance maintains addition SWT resource that need to be
    # disposed.
    def dispose
      # notify pages
      i = 0
      while i < @pages.size
        (@pages.get(i)).dispose
        i += 1
      end
      # dispose of image
      if (!(@default_image).nil?)
        JFaceResources.get_resources.destroy_image(@default_image_descriptor)
        @default_image = nil
      end
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizard.
    def get_container
      return @container
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizard.
    def get_default_page_image
      if ((@default_image).nil?)
        @default_image = JFaceResources.get_resources.create_image_with_default(@default_image_descriptor)
      end
      return @default_image
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizard.
    def get_dialog_settings
      return @dialog_settings
    end
    
    typesig { [IWizardPage] }
    # (non-Javadoc) Method declared on IWizard. The default behavior is to
    # return the page that was added to this wizard after the given page.
    def get_next_page(page)
      index = @pages.index_of(page)
      if ((index).equal?(@pages.size - 1) || (index).equal?(-1))
        # last page or page not found
        return nil
      end
      return @pages.get(index + 1)
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IWizard.
    def get_page(name)
      i = 0
      while i < @pages.size
        page = @pages.get(i)
        page_name = page.get_name
        if ((page_name == name))
          return page
        end
        i += 1
      end
      return nil
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizard.
    def get_page_count
      return @pages.size
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizard.
    def get_pages
      return @pages.to_array(Array.typed(IWizardPage).new(@pages.size) { nil })
    end
    
    typesig { [IWizardPage] }
    # (non-Javadoc) Method declared on IWizard. The default behavior is to
    # return the page that was added to this wizard before the given page.
    def get_previous_page(page)
      index = @pages.index_of(page)
      if ((index).equal?(0) || (index).equal?(-1))
        # first page or page not found
        return nil
      end
      return @pages.get(index - 1)
    end
    
    typesig { [] }
    # Returns the wizard's shell if the wizard is visible. Otherwise
    # <code>null</code> is returned.
    # 
    # @return Shell
    def get_shell
      if ((@container).nil?)
        return nil
      end
      return @container.get_shell
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizard. By default this is the first
    # page inserted into the wizard.
    def get_starting_page
      if ((@pages.size).equal?(0))
        return nil
      end
      return @pages.get(0)
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizard.
    def get_title_bar_color
      return @title_bar_color
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizard.
    def get_window_title
      return @window_title
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizard.
    def is_help_available
      return @is_help_available
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizard.
    def needs_previous_and_next_buttons
      return @force_previous_and_next_buttons || @pages.size > 1
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IWizard.
    def needs_progress_monitor
      return @needs_progress_monitor
    end
    
    typesig { [] }
    # The <code>Wizard</code> implementation of this <code>IWizard</code>
    # method does nothing and returns <code>true</code>. Subclasses should
    # reimplement this method if they need to perform any special cancel
    # processing for their wizard.
    def perform_cancel
      return true
    end
    
    typesig { [] }
    # Subclasses must implement this <code>IWizard</code> method to perform
    # any special finish processing for their wizard.
    def perform_finish
      raise NotImplementedError
    end
    
    typesig { [IWizardContainer] }
    # (non-Javadoc) Method declared on IWizard.
    def set_container(wizard_container)
      @container = wizard_container
    end
    
    typesig { [ImageDescriptor] }
    # Sets the default page image descriptor for this wizard.
    # <p>
    # This image descriptor will be used to generate an image for a page with
    # no image of its own; the image will be computed once and cached.
    # </p>
    # 
    # @param imageDescriptor
    # the default page image descriptor
    def set_default_page_image_descriptor(image_descriptor)
      @default_image_descriptor = image_descriptor
    end
    
    typesig { [IDialogSettings] }
    # Sets the dialog settings for this wizard.
    # <p>
    # The dialog settings is used to record state between wizard invocations
    # (for example, radio button selection, last import directory, etc.)
    # </p>
    # 
    # @param settings
    # the dialog settings, or <code>null</code> if none
    # @see #getDialogSettings
    def set_dialog_settings(settings)
      @dialog_settings = settings
    end
    
    typesig { [::Java::Boolean] }
    # Controls whether the wizard needs Previous and Next buttons even if it
    # currently contains only one page.
    # <p>
    # This flag should be set on wizards where the first wizard page adds
    # follow-on wizard pages based on user input.
    # </p>
    # 
    # @param b
    # <code>true</code> to always show Next and Previous buttons,
    # and <code>false</code> to suppress Next and Previous buttons
    # for single page wizards
    def set_force_previous_and_next_buttons(b)
      @force_previous_and_next_buttons = b
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether help is available for this wizard.
    # <p>
    # The result of this method is typically used by the container to show or
    # hide the Help button.
    # </p>
    # 
    # @param b
    # <code>true</code> if help is available, and
    # <code>false</code> if this wizard is helpless
    # @see #isHelpAvailable()
    def set_help_available(b)
      @is_help_available = b
    end
    
    typesig { [::Java::Boolean] }
    # Sets whether this wizard needs a progress monitor.
    # 
    # @param b
    # <code>true</code> if a progress monitor is required, and
    # <code>false</code> if none is needed
    # @see #needsProgressMonitor()
    def set_needs_progress_monitor(b)
      @needs_progress_monitor = b
    end
    
    typesig { [RGB] }
    # Sets the title bar color for this wizard.
    # 
    # @param color
    # the title bar color
    def set_title_bar_color(color)
      @title_bar_color = color
    end
    
    typesig { [String] }
    # Sets the window title for the container that hosts this page to the given
    # string.
    # 
    # @param newTitle
    # the window title for the container
    def set_window_title(new_title)
      @window_title = new_title
      if (!(@container).nil?)
        @container.update_window_title
      end
    end
    
    private
    alias_method :initialize__wizard, :initialize
  end
  
end
