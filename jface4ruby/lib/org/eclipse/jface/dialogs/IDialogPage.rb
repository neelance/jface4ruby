require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Dialogs
  module IDialogPageImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # Interface for a page in a multi-page dialog.
  module IDialogPage
    include_class_members IDialogPageImports
    
    typesig { [Composite] }
    # Creates the top level control for this dialog
    # page under the given parent composite.
    # <p>
    # Implementors are responsible for ensuring that
    # the created control can be accessed via <code>getControl</code>
    # </p>
    # 
    # @param parent the parent composite
    def create_control(parent)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Disposes the SWT resources allocated by this
    # dialog page.
    def dispose
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the top level control for this dialog page.
    # <p>
    # May return <code>null</code> if the control
    # has not been created yet.
    # </p>
    # 
    # @return the top level control or <code>null</code>
    def get_control
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns this dialog page's description text.
    # 
    # @return the description text for this dialog page,
    # or <code>null</code> if none
    def get_description
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the current error message for this dialog page.
    # May be <code>null</code> to indicate no error message.
    # <p>
    # An error message should describe some error state,
    # as opposed to a message which may simply provide instruction
    # or information to the user.
    # </p>
    # 
    # @return the error message, or <code>null</code> if none
    def get_error_message
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns this dialog page's image.
    # 
    # @return the image for this dialog page, or <code>null</code>
    # if none
    def get_image
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the current message for this wizard page.
    # <p>
    # A message provides instruction or information to the
    # user, as opposed to an error message which should
    # describe some error state.
    # </p>
    # 
    # @return the message, or <code>null</code> if none
    def get_message
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns this dialog page's title.
    # 
    # @return the title of this dialog page,
    # or <code>null</code> if none
    def get_title
      raise NotImplementedError
    end
    
    typesig { [] }
    # Notifies that help has been requested for this dialog page.
    def perform_help
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Sets this dialog page's description text.
    # 
    # @param description the description text for this dialog
    # page, or <code>null</code> if none
    def set_description(description)
      raise NotImplementedError
    end
    
    typesig { [ImageDescriptor] }
    # Sets this dialog page's image.
    # 
    # @param image the image for this dialog page,
    # or <code>null</code> if none
    def set_image_descriptor(image)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Set this dialog page's title.
    # 
    # @param title the title of this dialog page,
    # or <code>null</code> if none
    def set_title(title)
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Sets the visibility of this dialog page.
    # 
    # @param visible <code>true</code> to make this page visible,
    # and <code>false</code> to hide it
    def set_visible(visible)
      raise NotImplementedError
    end
  end
  
end
