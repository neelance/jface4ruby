require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Util
  module SafeRunnableDialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Util
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collection
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Jface::Dialogs, :ErrorDialog
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogConstants
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Viewers, :CellLabelProvider
      include_const ::Org::Eclipse::Jface::Viewers, :ISelection
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionChangedListener
      include_const ::Org::Eclipse::Jface::Viewers, :IStructuredContentProvider
      include_const ::Org::Eclipse::Jface::Viewers, :IStructuredSelection
      include_const ::Org::Eclipse::Jface::Viewers, :SelectionChangedEvent
      include_const ::Org::Eclipse::Jface::Viewers, :TableViewer
      include_const ::Org::Eclipse::Jface::Viewers, :Viewer
      include_const ::Org::Eclipse::Jface::Viewers, :ViewerCell
      include_const ::Org::Eclipse::Jface::Viewers, :ViewerComparator
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Layout, :GridData
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
    }
  end
  
  # SafeRunnableDialog is a dialog that can show the results of multiple safe
  # runnable errors.
  class SafeRunnableDialog < SafeRunnableDialogImports.const_get :ErrorDialog
    include_class_members SafeRunnableDialogImports
    
    attr_accessor :status_list_viewer
    alias_method :attr_status_list_viewer, :status_list_viewer
    undef_method :status_list_viewer
    alias_method :attr_status_list_viewer=, :status_list_viewer=
    undef_method :status_list_viewer=
    
    attr_accessor :statuses
    alias_method :attr_statuses, :statuses
    undef_method :statuses
    alias_method :attr_statuses=, :statuses=
    undef_method :statuses=
    
    typesig { [IStatus] }
    # Create a new instance of the receiver on a status.
    # 
    # @param status
    # The status to display.
    def initialize(status)
      # $NON-NLS-1$
      @status_list_viewer = nil
      @statuses = nil
      super(nil, JFaceResources.get_string("error"), status.get_message, status, IStatus::ERROR)
      @statuses = ArrayList.new
      set_shell_style(SWT::DIALOG_TRIM | SWT::MODELESS | SWT::RESIZE | SWT::MIN | SWT::MAX | get_default_orientation)
      set_status(status)
      @statuses.add(status)
      set_block_on_open(false)
      reason = JFaceResources.get_string("SafeRunnableDialog_checkDetailsMessage") # $NON-NLS-1$
      if (!(status.get_exception).nil?)
        reason = RJava.cast_to_string((status.get_exception.get_message).nil? ? status.get_exception.to_s : status.get_exception.get_message)
      end
      # $NON-NLS-1$
      self.attr_message = JFaceResources.format("SafeRunnableDialog_reason", Array.typed(Object).new([status.get_message, reason]))
    end
    
    typesig { [] }
    # Method which should be invoked when new errors become available for
    # display
    def refresh
      if (AUTOMATED_MODE)
        return
      end
      create_status_list(self.attr_dialog_area)
      update_enablements
    end
    
    typesig { [Composite] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.ErrorDialog#createDialogArea(org.eclipse.swt.widgets.Composite)
    def create_dialog_area(parent)
      area = super(parent)
      create_status_list(area)
      return area
    end
    
    typesig { [Composite] }
    # Create the status list if required.
    # 
    # @param parent
    # the Control to create it in.
    def create_status_list(parent)
      if (is_multiple_status_dialog)
        if ((@status_list_viewer).nil?)
          # The job list doesn't exist so create it.
          set_message(JFaceResources.get_string("SafeRunnableDialog_MultipleErrorsMessage")) # $NON-NLS-1$
          get_shell.set_text(JFaceResources.get_string("SafeRunnableDialog_MultipleErrorsTitle")) # $NON-NLS-1$
          create_status_list_area(parent)
          show_details_area
        end
        refresh_status_list
      end
    end
    
    typesig { [] }
    # Update the button enablements
    def update_enablements
      details = get_button(IDialogConstants::DETAILS_ID)
      if (!(details).nil?)
        details.set_enabled(true)
      end
    end
    
    typesig { [String] }
    # This method sets the message in the message label.
    # 
    # @param messageString -
    # the String for the message area
    def set_message(message_string)
      # must not set null text in a label
      self.attr_message = (message_string).nil? ? "" : message_string # $NON-NLS-1$
      if ((self.attr_message_label).nil? || self.attr_message_label.is_disposed)
        return
      end
      self.attr_message_label.set_text(self.attr_message)
    end
    
    typesig { [Composite] }
    # Create an area that allow the user to select one of multiple jobs that
    # have reported errors
    # 
    # @param parent -
    # the parent of the area
    def create_status_list_area(parent)
      # Display a list of jobs that have reported errors
      @status_list_viewer = TableViewer.new(parent, SWT::SINGLE | SWT::H_SCROLL | SWT::V_SCROLL | SWT::BORDER)
      @status_list_viewer.set_comparator(get_viewer_comparator)
      control = @status_list_viewer.get_control
      data = GridData.new(GridData::FILL_BOTH | GridData::GRAB_HORIZONTAL | GridData::GRAB_VERTICAL)
      data.attr_height_hint = convert_height_in_chars_to_pixels(10)
      data.attr_horizontal_span = 2
      control.set_layout_data(data)
      @status_list_viewer.set_content_provider(get_status_content_provider)
      @status_list_viewer.set_label_provider(get_status_list_label_provider)
      @status_list_viewer.add_selection_changed_listener(Class.new(ISelectionChangedListener.class == Class ? ISelectionChangedListener : Object) do
        extend LocalClass
        include_class_members SafeRunnableDialog
        include ISelectionChangedListener if ISelectionChangedListener.class == Module
        
        typesig { [SelectionChangedEvent] }
        define_method :selection_changed do |event|
          handle_selection_change
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      apply_dialog_font(parent)
      @status_list_viewer.set_input(self)
    end
    
    typesig { [] }
    # Return the label provider for the status list.
    # 
    # @return CellLabelProvider
    def get_status_list_label_provider
      return Class.new(CellLabelProvider.class == Class ? CellLabelProvider : Object) do
        extend LocalClass
        include_class_members SafeRunnableDialog
        include CellLabelProvider if CellLabelProvider.class == Module
        
        typesig { [ViewerCell] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.viewers.CellLabelProvider#update(org.eclipse.jface.viewers.ViewerCell)
        define_method :update do |cell|
          cell.set_text((cell.get_element).get_message)
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [] }
    # Return the content provider for the statuses.
    # 
    # @return IStructuredContentProvider
    def get_status_content_provider
      return Class.new(IStructuredContentProvider.class == Class ? IStructuredContentProvider : Object) do
        extend LocalClass
        include_class_members SafeRunnableDialog
        include IStructuredContentProvider if IStructuredContentProvider.class == Module
        
        typesig { [Object] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.viewers.IStructuredContentProvider#getElements(java.lang.Object)
        define_method :get_elements do |input_element|
          return self.attr_statuses.to_array
        end
        
        typesig { [] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.viewers.IContentProvider#dispose()
        define_method :dispose do
        end
        
        typesig { [Viewer, Object, Object] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.viewers.IContentProvider#inputChanged(org.eclipse.jface.viewers.Viewer,
        # java.lang.Object, java.lang.Object)
        define_method :input_changed do |viewer, old_input, new_input|
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [] }
    # Return whether there are multiple errors to be displayed
    def is_multiple_status_dialog
      return @statuses.size > 1
    end
    
    typesig { [] }
    # Return a viewer sorter for looking at the jobs.
    # 
    # @return ViewerSorter
    def get_viewer_comparator
      return Class.new(ViewerComparator.class == Class ? ViewerComparator : Object) do
        extend LocalClass
        include_class_members SafeRunnableDialog
        include ViewerComparator if ViewerComparator.class == Module
        
        typesig { [Viewer, Object, Object] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.viewers.ViewerComparator#compare(org.eclipse.jface.viewers.Viewer,
        # java.lang.Object, java.lang.Object)
        define_method :compare do |test_viewer, e1, e2|
          message1 = (e1).get_message
          message2 = (e2).get_message
          if ((message1).nil?)
            return 1
          end
          if ((message2).nil?)
            return -1
          end
          return (message1 <=> message2)
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [] }
    # Refresh the contents of the viewer.
    def refresh_status_list
      if (!(@status_list_viewer).nil? && !@status_list_viewer.get_control.is_disposed)
        @status_list_viewer.refresh
        new_size = get_shell.compute_size(SWT::DEFAULT, SWT::DEFAULT)
        get_shell.set_size(new_size)
      end
    end
    
    typesig { [] }
    # Get the single selection. Return null if the selection is not just one
    # element.
    # 
    # @return IStatus or <code>null</code>.
    def get_single_selection
      raw_selection = @status_list_viewer.get_selection
      if (!(raw_selection).nil? && raw_selection.is_a?(IStructuredSelection))
        selection = raw_selection
        if ((selection.size).equal?(1))
          return selection.get_first_element
        end
      end
      return nil
    end
    
    typesig { [] }
    # The selection in the multiple job list has changed. Update widget
    # enablements and repopulate the list.
    def handle_selection_change
      new_selection = get_single_selection
      set_status(new_selection)
      update_enablements
      show_details_area
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.dialogs.ErrorDialog#shouldShowDetailsButton()
    def should_show_details_button
      return true
    end
    
    typesig { [IStatus] }
    # Add the status to the receiver.
    # @param status
    def add_status(status)
      @statuses.add(status)
      refresh
    end
    
    private
    alias_method :initialize__safe_runnable_dialog, :initialize
  end
  
end
