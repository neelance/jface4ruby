require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Stefan Xenos, IBM - bug 156790: Adopt GridLayoutFactory within JFace
module Org::Eclipse::Jface::Dialogs
  module IconAndMessageDialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Jface::Layout, :GridDataFactory
      include_const ::Org::Eclipse::Jface::Layout, :GridLayoutFactory
      include_const ::Org::Eclipse::Jface::Layout, :LayoutConstants
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Accessibility, :AccessibleAdapter
      include_const ::Org::Eclipse::Swt::Accessibility, :AccessibleEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Image
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
    }
  end
  
  # The IconAndMessageDialog is the abstract superclass of dialogs that have an
  # icon and a message as the first two widgets. In this dialog the icon and
  # message are direct children of the shell in order that they can be read by
  # accessibility tools more easily.
  # <p>
  # <strong>Note:</strong> Clients are expected to call {@link #createMessageArea(Composite)},
  # otherwise neither the icon nor the message will appear.
  # </p>
  class IconAndMessageDialog < IconAndMessageDialogImports.const_get :Dialog
    include_class_members IconAndMessageDialogImports
    
    # Message (a localized string).
    attr_accessor :message
    alias_method :attr_message, :message
    undef_method :message
    alias_method :attr_message=, :message=
    undef_method :message=
    
    # Message label is the label the message is shown on.
    attr_accessor :message_label
    alias_method :attr_message_label, :message_label
    undef_method :message_label
    alias_method :attr_message_label=, :message_label=
    undef_method :message_label=
    
    # Return the label for the image.
    attr_accessor :image_label
    alias_method :attr_image_label, :image_label
    undef_method :image_label
    alias_method :attr_image_label=, :image_label=
    undef_method :image_label=
    
    typesig { [Shell] }
    # Constructor for IconAndMessageDialog.
    # 
    # @param parentShell
    # the parent shell, or <code>null</code> to create a top-level
    # shell
    def initialize(parent_shell)
      @message = nil
      @message_label = nil
      @image_label = nil
      super(parent_shell)
    end
    
    typesig { [Composite] }
    # Create the area the message will be shown in.
    # <p>
    # The parent composite is assumed to use GridLayout as its layout manager,
    # since the parent is typically the composite created in
    # {@link Dialog#createDialogArea}.
    # </p>
    # <p>
    # <strong>Note:</strong> Clients are expected to call this method, otherwise
    # neither the icon nor the message will appear.
    # </p>
    # 
    # @param composite
    # The composite to parent from.
    # @return Control
    def create_message_area(composite)
      # create composite
      # create image
      image = get_image
      if (!(image).nil?)
        @image_label = Label.new(composite, SWT::NULL)
        image.set_background(@image_label.get_background)
        @image_label.set_image(image)
        add_accessible_listeners(@image_label, image)
        GridDataFactory.fill_defaults.align(SWT::CENTER, SWT::BEGINNING).apply_to(@image_label)
      end
      # create message
      if (!(@message).nil?)
        @message_label = Label.new(composite, get_message_label_style)
        @message_label.set_text(@message)
        GridDataFactory.fill_defaults.align(SWT::FILL, SWT::BEGINNING).grab(true, false).hint(convert_horizontal_dlus_to_pixels(IDialogConstants::MINIMUM_MESSAGE_AREA_WIDTH), SWT::DEFAULT).apply_to(@message_label)
      end
      return composite
    end
    
    typesig { [Image] }
    def get_accessible_message_for(image)
      if ((image == get_error_image))
        return JFaceResources.get_string("error") # $NON-NLS-1$
      end
      if ((image == get_warning_image))
        return JFaceResources.get_string("warning") # $NON-NLS-1$
      end
      if ((image == get_info_image))
        return JFaceResources.get_string("info") # $NON-NLS-1$
      end
      if ((image == get_question_image))
        return JFaceResources.get_string("question") # $NON-NLS-1$
      end
      return nil
    end
    
    typesig { [Label, Image] }
    # Add an accessible listener to the label if it can be inferred from the
    # image.
    # 
    # @param label
    # @param image
    def add_accessible_listeners(label, image)
      label.get_accessible.add_accessible_listener(Class.new(AccessibleAdapter.class == Class ? AccessibleAdapter : Object) do
        extend LocalClass
        include_class_members IconAndMessageDialog
        include AccessibleAdapter if AccessibleAdapter.class == Module
        
        typesig { [AccessibleEvent] }
        define_method :get_name do |event|
          accessible_message = get_accessible_message_for(image)
          if ((accessible_message).nil?)
            return
          end
          event.attr_result = accessible_message
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [] }
    # Returns the style for the message label.
    # 
    # @return the style for the message label
    # 
    # @since 3.0
    def get_message_label_style
      return SWT::WRAP
    end
    
    typesig { [Composite] }
    # @see Dialog.createButtonBar()
    def create_button_bar(parent)
      composite = Composite.new(parent, SWT::NONE)
      # this is incremented
      # by createButton
      GridLayoutFactory.fill_defaults.num_columns(0).equal_width(true).apply_to(composite)
      GridDataFactory.fill_defaults.align(SWT::END_, SWT::CENTER).span(2, 1).apply_to(composite)
      composite.set_font(parent.get_font)
      # Add the buttons to the button bar.
      create_buttons_for_button_bar(composite)
      return composite
    end
    
    typesig { [] }
    # Returns the image to display beside the message in this dialog.
    # <p>
    # Subclasses may override.
    # </p>
    # 
    # @return the image to display beside the message
    # @since 2.0
    def get_image
      raise NotImplementedError
    end
    
    typesig { [Composite] }
    # @see Dialog.createContents(Composite)
    def create_contents(parent)
      # initialize the dialog units
      initialize_dialog_units(parent)
      default_spacing = LayoutConstants.get_spacing
      GridLayoutFactory.fill_defaults.margins(LayoutConstants.get_margins).spacing(default_spacing.attr_x * 2, default_spacing.attr_y).num_columns(get_column_count).apply_to(parent)
      GridDataFactory.fill_defaults.grab(true, true).apply_to(parent)
      create_dialog_and_button_area(parent)
      return parent
    end
    
    typesig { [] }
    # Get the number of columns in the layout of the Shell of the dialog.
    # 
    # @return int
    # @since 3.3
    def get_column_count
      return 2
    end
    
    typesig { [Composite] }
    # Create the dialog area and the button bar for the receiver.
    # 
    # @param parent
    def create_dialog_and_button_area(parent)
      # create the dialog area and button bar
      self.attr_dialog_area = create_dialog_area(parent)
      self.attr_button_bar = create_button_bar(parent)
      # Apply to the parent so that the message gets it too.
      apply_dialog_font(parent)
    end
    
    typesig { [] }
    # Return the <code>Image</code> to be used when displaying an error.
    # 
    # @return image the error image
    def get_error_image
      return get_swtimage(SWT::ICON_ERROR)
    end
    
    typesig { [] }
    # Return the <code>Image</code> to be used when displaying a warning.
    # 
    # @return image the warning image
    def get_warning_image
      return get_swtimage(SWT::ICON_WARNING)
    end
    
    typesig { [] }
    # Return the <code>Image</code> to be used when displaying information.
    # 
    # @return image the information image
    def get_info_image
      return get_swtimage(SWT::ICON_INFORMATION)
    end
    
    typesig { [] }
    # Return the <code>Image</code> to be used when displaying a question.
    # 
    # @return image the question image
    def get_question_image
      return get_swtimage(SWT::ICON_QUESTION)
    end
    
    typesig { [::Java::Int] }
    # Get an <code>Image</code> from the provide SWT image constant.
    # 
    # @param imageID
    # the SWT image constant
    # @return image the image
    def get_swtimage(image_id)
      shell = get_shell
      display = nil
      if ((shell).nil? || shell.is_disposed)
        shell = get_parent_shell
      end
      if ((shell).nil? || shell.is_disposed)
        display = Display.get_current
      else
        display = shell.get_display
      end
      image = Array.typed(Image).new(1) { nil }
      display.sync_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members IconAndMessageDialog
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          image[0] = display.get_system_image(image_id)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      return image[0]
    end
    
    private
    alias_method :initialize__icon_and_message_dialog, :initialize
  end
  
end
