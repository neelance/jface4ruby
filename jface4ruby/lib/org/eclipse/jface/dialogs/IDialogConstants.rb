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
  module IDialogConstantsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
    }
  end
  
  # Various dialog-related constants.
  # <p>
  # Within the dialog framework, all buttons are referred to by a button id.
  # Various common buttons, like "OK", "Cancel", and "Finish", have pre-assigned
  # button ids for convenience. If an application requires other dialog buttons,
  # they should be assigned application-specific button ids counting up from
  # <code>CLIENT_ID</code>.
  # </p>
  # <p>
  # Button label constants are also provided for the common buttons. JFace
  # automatically localizes these strings to the current locale; that is,
  # <code>YES_LABEL</code> would be bound to the string <code>"Si"</code> in
  # a Spanish locale, but to <code>"Oui"</code> in a French one.
  # </p>
  # <p>
  # All margins, spacings, and sizes are given in "dialog units" (DLUs), where
  # <ul>
  # <li>1 horizontal DLU = 1/4 average character width</li>
  # <li>1 vertical DLU = 1/8 average character height</li>
  # </ul>
  # </p>
  # 
  # 
  # IDialogConstants is the interface for common dialog strings and ids
  # used throughout JFace.
  # It is recommended that you use these labels and ids whereever
  # for consistency with the JFace dialogs.
  module IDialogConstants
    include_class_members IDialogConstantsImports
    
    class_module.module_eval {
      # button ids
      # Note:  if new button ids are added, see
      # MessageDialogWithToggle.mapButtonLabelToButtonID(String, int)
      # 
      # Button id for an "Ok" button (value 0).
      const_set_lazy(:OK_ID) { 0 }
      const_attr_reader  :OK_ID
      
      # Button id for a "Cancel" button (value 1).
      const_set_lazy(:CANCEL_ID) { 1 }
      const_attr_reader  :CANCEL_ID
      
      # Button id for a "Yes" button (value 2).
      const_set_lazy(:YES_ID) { 2 }
      const_attr_reader  :YES_ID
      
      # Button id for a "No" button (value 3).
      const_set_lazy(:NO_ID) { 3 }
      const_attr_reader  :NO_ID
      
      # Button id for a "Yes to All" button (value 4).
      const_set_lazy(:YES_TO_ALL_ID) { 4 }
      const_attr_reader  :YES_TO_ALL_ID
      
      # Button id for a "Skip" button (value 5).
      const_set_lazy(:SKIP_ID) { 5 }
      const_attr_reader  :SKIP_ID
      
      # Button id for a "Stop" button (value 6).
      const_set_lazy(:STOP_ID) { 6 }
      const_attr_reader  :STOP_ID
      
      # Button id for an "Abort" button (value 7).
      const_set_lazy(:ABORT_ID) { 7 }
      const_attr_reader  :ABORT_ID
      
      # Button id for a "Retry" button (value 8).
      const_set_lazy(:RETRY_ID) { 8 }
      const_attr_reader  :RETRY_ID
      
      # Button id for an "Ignore" button (value 9).
      const_set_lazy(:IGNORE_ID) { 9 }
      const_attr_reader  :IGNORE_ID
      
      # Button id for a "Proceed" button (value 10).
      const_set_lazy(:PROCEED_ID) { 10 }
      const_attr_reader  :PROCEED_ID
      
      # Button id for an "Open" button (value 11).
      const_set_lazy(:OPEN_ID) { 11 }
      const_attr_reader  :OPEN_ID
      
      # Button id for a "Close" button (value 12).
      const_set_lazy(:CLOSE_ID) { 12 }
      const_attr_reader  :CLOSE_ID
      
      # Button id for a "Details" button (value 13).
      const_set_lazy(:DETAILS_ID) { 13 }
      const_attr_reader  :DETAILS_ID
      
      # Button id for a "Back" button (value 14).
      const_set_lazy(:BACK_ID) { 14 }
      const_attr_reader  :BACK_ID
      
      # Button id for a "Next" button (value 15).
      const_set_lazy(:NEXT_ID) { 15 }
      const_attr_reader  :NEXT_ID
      
      # Button id for a "Finish" button (value 16).
      const_set_lazy(:FINISH_ID) { 16 }
      const_attr_reader  :FINISH_ID
      
      # Button id for a "Help" button (value 17).
      const_set_lazy(:HELP_ID) { 17 }
      const_attr_reader  :HELP_ID
      
      # Button id for a "Select All" button (value 18).
      const_set_lazy(:SELECT_ALL_ID) { 18 }
      const_attr_reader  :SELECT_ALL_ID
      
      # Button id for a "Deselect All" button (value 19).
      const_set_lazy(:DESELECT_ALL_ID) { 19 }
      const_attr_reader  :DESELECT_ALL_ID
      
      # Button id for a "Select types" button (value 20).
      const_set_lazy(:SELECT_TYPES_ID) { 20 }
      const_attr_reader  :SELECT_TYPES_ID
      
      # Button id for a "No to All" button (value 21).
      const_set_lazy(:NO_TO_ALL_ID) { 21 }
      const_attr_reader  :NO_TO_ALL_ID
      
      # Starting button id reserved for internal use by JFace (value 256). JFace
      # classes make ids by adding to this number.
      const_set_lazy(:INTERNAL_ID) { 256 }
      const_attr_reader  :INTERNAL_ID
      
      # Starting button id reserved for use by clients of JFace (value 1024).
      # Clients of JFace should make ids by adding to this number.
      const_set_lazy(:CLIENT_ID) { 1024 }
      const_attr_reader  :CLIENT_ID
      
      # button labels
      # 
      # The label for OK buttons.
      const_set_lazy(:OK_LABEL) { JFaceResources.get_string("ok") }
      const_attr_reader  :OK_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for cancel buttons.
      const_set_lazy(:CANCEL_LABEL) { JFaceResources.get_string("cancel") }
      const_attr_reader  :CANCEL_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for yes buttons.
      const_set_lazy(:YES_LABEL) { JFaceResources.get_string("yes") }
      const_attr_reader  :YES_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for no buttons.
      const_set_lazy(:NO_LABEL) { JFaceResources.get_string("no") }
      const_attr_reader  :NO_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for not to all buttons.
      const_set_lazy(:NO_TO_ALL_LABEL) { JFaceResources.get_string("notoall") }
      const_attr_reader  :NO_TO_ALL_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for yes to all buttons.
      const_set_lazy(:YES_TO_ALL_LABEL) { JFaceResources.get_string("yestoall") }
      const_attr_reader  :YES_TO_ALL_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for skip buttons.
      const_set_lazy(:SKIP_LABEL) { JFaceResources.get_string("skip") }
      const_attr_reader  :SKIP_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for stop buttons.
      const_set_lazy(:STOP_LABEL) { JFaceResources.get_string("stop") }
      const_attr_reader  :STOP_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for abort buttons.
      const_set_lazy(:ABORT_LABEL) { JFaceResources.get_string("abort") }
      const_attr_reader  :ABORT_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for retry buttons.
      const_set_lazy(:RETRY_LABEL) { JFaceResources.get_string("retry") }
      const_attr_reader  :RETRY_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for ignore buttons.
      const_set_lazy(:IGNORE_LABEL) { JFaceResources.get_string("ignore") }
      const_attr_reader  :IGNORE_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for proceed buttons.
      const_set_lazy(:PROCEED_LABEL) { JFaceResources.get_string("proceed") }
      const_attr_reader  :PROCEED_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for open buttons.
      const_set_lazy(:OPEN_LABEL) { JFaceResources.get_string("open") }
      const_attr_reader  :OPEN_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for close buttons.
      const_set_lazy(:CLOSE_LABEL) { JFaceResources.get_string("close") }
      const_attr_reader  :CLOSE_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for show details buttons.
      const_set_lazy(:SHOW_DETAILS_LABEL) { JFaceResources.get_string("showDetails") }
      const_attr_reader  :SHOW_DETAILS_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for hide details buttons.
      const_set_lazy(:HIDE_DETAILS_LABEL) { JFaceResources.get_string("hideDetails") }
      const_attr_reader  :HIDE_DETAILS_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for back buttons.
      const_set_lazy(:BACK_LABEL) { JFaceResources.get_string("backButton") }
      const_attr_reader  :BACK_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for next buttons.
      const_set_lazy(:NEXT_LABEL) { JFaceResources.get_string("nextButton") }
      const_attr_reader  :NEXT_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for finish buttons.
      const_set_lazy(:FINISH_LABEL) { JFaceResources.get_string("finish") }
      const_attr_reader  :FINISH_LABEL
      
      # $NON-NLS-1$
      # 
      # The label for help buttons.
      const_set_lazy(:HELP_LABEL) { JFaceResources.get_string("help") }
      const_attr_reader  :HELP_LABEL
      
      # $NON-NLS-1$
      # Margins, spacings, and sizes
      # 
      # Vertical margin in dialog units (value 7).
      const_set_lazy(:VERTICAL_MARGIN) { 7 }
      const_attr_reader  :VERTICAL_MARGIN
      
      # Vertical spacing in dialog units (value 4).
      const_set_lazy(:VERTICAL_SPACING) { 4 }
      const_attr_reader  :VERTICAL_SPACING
      
      # Horizontal margin in dialog units (value 7).
      const_set_lazy(:HORIZONTAL_MARGIN) { 7 }
      const_attr_reader  :HORIZONTAL_MARGIN
      
      # Horizontal spacing in dialog units (value 4).
      const_set_lazy(:HORIZONTAL_SPACING) { 4 }
      const_attr_reader  :HORIZONTAL_SPACING
      
      # Height of button bar in dialog units (value 25).
      const_set_lazy(:BUTTON_BAR_HEIGHT) { 25 }
      const_attr_reader  :BUTTON_BAR_HEIGHT
      
      # Left margin in dialog units (value 20).
      const_set_lazy(:LEFT_MARGIN) { 20 }
      const_attr_reader  :LEFT_MARGIN
      
      # Button margin in dialog units (value 4).
      const_set_lazy(:BUTTON_MARGIN) { 4 }
      const_attr_reader  :BUTTON_MARGIN
      
      # Button height in dialog units (value 14).
      # 
      # @deprecated This constant is no longer in use.
      # The button heights are now determined by the layout.
      const_set_lazy(:BUTTON_HEIGHT) { 14 }
      const_attr_reader  :BUTTON_HEIGHT
      
      # Button width in dialog units (value 61).
      const_set_lazy(:BUTTON_WIDTH) { 61 }
      const_attr_reader  :BUTTON_WIDTH
      
      # Indent in dialog units (value 21).
      const_set_lazy(:INDENT) { 21 }
      const_attr_reader  :INDENT
      
      # Small indent in dialog units (value 7).
      const_set_lazy(:SMALL_INDENT) { 7 }
      const_attr_reader  :SMALL_INDENT
      
      # Entry field width in dialog units (value 200).
      const_set_lazy(:ENTRY_FIELD_WIDTH) { 200 }
      const_attr_reader  :ENTRY_FIELD_WIDTH
      
      # Minimum width of message area in dialog units (value 300).
      const_set_lazy(:MINIMUM_MESSAGE_AREA_WIDTH) { 300 }
      const_attr_reader  :MINIMUM_MESSAGE_AREA_WIDTH
    }
  end
  
end
