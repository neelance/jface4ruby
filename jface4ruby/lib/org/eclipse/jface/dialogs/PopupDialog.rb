require "rjava"

# Copyright (c) 2005, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Stefan Xenos, IBM - bug 156790: Adopt GridLayoutFactory within JFace
module Org::Eclipse::Jface::Dialogs
  module PopupDialogImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Dialogs
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Jface::Action, :Action
      include_const ::Org::Eclipse::Jface::Action, :GroupMarker
      include_const ::Org::Eclipse::Jface::Action, :IAction
      include_const ::Org::Eclipse::Jface::Action, :IMenuManager
      include_const ::Org::Eclipse::Jface::Action, :MenuManager
      include_const ::Org::Eclipse::Jface::Action, :Separator
      include_const ::Org::Eclipse::Jface::Layout, :GridDataFactory
      include_const ::Org::Eclipse::Jface::Layout, :GridLayoutFactory
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Jface::Window, :Window
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Events, :DisposeEvent
      include_const ::Org::Eclipse::Swt::Events, :DisposeListener
      include_const ::Org::Eclipse::Swt::Events, :MouseAdapter
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :SelectionAdapter
      include_const ::Org::Eclipse::Swt::Events, :SelectionEvent
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :Font
      include_const ::Org::Eclipse::Swt::Graphics, :FontData
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Label
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :Shell
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
      include_const ::Org::Eclipse::Swt::Widgets, :ToolItem
      include_const ::Org::Eclipse::Swt::Widgets, :Tracker
    }
  end
  
  # A lightweight, transient dialog that is popped up to show contextual or
  # temporal information and is easily dismissed. Clients control whether the
  # dialog should be able to receive input focus. An optional title area at the
  # top and an optional info area at the bottom can be used to provide additional
  # information.
  # <p>
  # Because the dialog is short-lived, most of the configuration of the dialog is
  # done in the constructor. Set methods are only provided for those values that
  # are expected to be dynamically computed based on a particular instance's
  # internal state.
  # <p>
  # Clients are expected to override the creation of the main dialog area, and
  # may optionally override the creation of the title area and info area in order
  # to add content. In general, however, the creation of stylistic features, such
  # as the dialog menu, separator styles, and fonts, is kept private so that all
  # popup dialogs will have a similar appearance.
  # 
  # @since 3.2
  class PopupDialog < PopupDialogImports.const_get :Window
    include_class_members PopupDialogImports
    
    class_module.module_eval {
      const_set_lazy(:LAYOUTDATA_GRAB_BOTH) { GridDataFactory.fill_defaults.grab(true, true) }
      const_attr_reader  :LAYOUTDATA_GRAB_BOTH
      
      # The dialog settings key name for stored dialog x location.
      const_set_lazy(:DIALOG_ORIGIN_X) { "DIALOG_X_ORIGIN" }
      const_attr_reader  :DIALOG_ORIGIN_X
      
      # $NON-NLS-1$
      # 
      # The dialog settings key name for stored dialog y location.
      const_set_lazy(:DIALOG_ORIGIN_Y) { "DIALOG_Y_ORIGIN" }
      const_attr_reader  :DIALOG_ORIGIN_Y
      
      # $NON-NLS-1$
      # 
      # The dialog settings key name for stored dialog width.
      const_set_lazy(:DIALOG_WIDTH) { "DIALOG_WIDTH" }
      const_attr_reader  :DIALOG_WIDTH
      
      # $NON-NLS-1$
      # 
      # The dialog settings key name for stored dialog height.
      const_set_lazy(:DIALOG_HEIGHT) { "DIALOG_HEIGHT" }
      const_attr_reader  :DIALOG_HEIGHT
      
      # $NON-NLS-1$
      # 
      # The dialog settings key name for remembering if the persisted bounds
      # should be accessed.
      # 
      # @deprecated Since 3.4, this is retained only for backward compatibility.
      const_set_lazy(:DIALOG_USE_PERSISTED_BOUNDS) { "DIALOG_USE_PERSISTED_BOUNDS" }
      const_attr_reader  :DIALOG_USE_PERSISTED_BOUNDS
      
      # $NON-NLS-1$
      # 
      # The dialog settings key name for remembering if the bounds persisted
      # prior to 3.4 have been migrated to the 3.4 settings.
      # 
      # @since 3.4
      # @deprecated This is marked deprecated at its introduction to discourage
      # future dependency
      const_set_lazy(:DIALOG_VALUE_MIGRATED_TO_34) { "hasBeenMigratedTo34" }
      const_attr_reader  :DIALOG_VALUE_MIGRATED_TO_34
      
      # $NON-NLS-1$
      # 
      # The dialog settings key name for remembering if the persisted size should
      # be accessed.
      const_set_lazy(:DIALOG_USE_PERSISTED_SIZE) { "DIALOG_USE_PERSISTED_SIZE" }
      const_attr_reader  :DIALOG_USE_PERSISTED_SIZE
      
      # $NON-NLS-1$
      # 
      # The dialog settings key name for remembering if the persisted location
      # should be accessed.
      const_set_lazy(:DIALOG_USE_PERSISTED_LOCATION) { "DIALOG_USE_PERSISTED_LOCATION" }
      const_attr_reader  :DIALOG_USE_PERSISTED_LOCATION
      
      # $NON-NLS-1$
      # 
      # Move action for the dialog.
      const_set_lazy(:MoveAction) { Class.new(Action) do
        extend LocalClass
        include_class_members PopupDialog
        
        typesig { [] }
        def initialize
          # $NON-NLS-1$
          super(JFaceResources.get_string("PopupDialog.move"), IAction::AS_PUSH_BUTTON)
        end
        
        typesig { [] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.action.IAction#run()
        def run
          perform_tracker_action(SWT::NONE)
        end
        
        private
        alias_method :initialize__move_action, :initialize
      end }
      
      # Resize action for the dialog.
      const_set_lazy(:ResizeAction) { Class.new(Action) do
        extend LocalClass
        include_class_members PopupDialog
        
        typesig { [] }
        def initialize
          # $NON-NLS-1$
          super(JFaceResources.get_string("PopupDialog.resize"), IAction::AS_PUSH_BUTTON)
        end
        
        typesig { [] }
        # @see org.eclipse.jface.action.Action#run()
        def run
          perform_tracker_action(SWT::RESIZE)
        end
        
        private
        alias_method :initialize__resize_action, :initialize
      end }
      
      # Remember bounds action for the dialog.
      const_set_lazy(:PersistBoundsAction) { Class.new(Action) do
        extend LocalClass
        include_class_members PopupDialog
        
        typesig { [] }
        def initialize
          # $NON-NLS-1$
          super(JFaceResources.get_string("PopupDialog.persistBounds"), IAction::AS_CHECK_BOX)
          set_checked(self.attr_persist_location && self.attr_persist_size)
        end
        
        typesig { [] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.action.IAction#run()
        def run
          self.attr_persist_size = is_checked
          self.attr_persist_location = self.attr_persist_size
        end
        
        private
        alias_method :initialize__persist_bounds_action, :initialize
      end }
      
      # Remember bounds action for the dialog.
      const_set_lazy(:PersistSizeAction) { Class.new(Action) do
        extend LocalClass
        include_class_members PopupDialog
        
        typesig { [] }
        def initialize
          # $NON-NLS-1$
          super(JFaceResources.get_string("PopupDialog.persistSize"), IAction::AS_CHECK_BOX)
          set_checked(self.attr_persist_size)
        end
        
        typesig { [] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.action.IAction#run()
        def run
          self.attr_persist_size = is_checked
        end
        
        private
        alias_method :initialize__persist_size_action, :initialize
      end }
      
      # Remember location action for the dialog.
      const_set_lazy(:PersistLocationAction) { Class.new(Action) do
        extend LocalClass
        include_class_members PopupDialog
        
        typesig { [] }
        def initialize
          # $NON-NLS-1$
          super(JFaceResources.get_string("PopupDialog.persistLocation"), IAction::AS_CHECK_BOX)
          set_checked(self.attr_persist_location)
        end
        
        typesig { [] }
        # (non-Javadoc)
        # 
        # @see org.eclipse.jface.action.IAction#run()
        def run
          self.attr_persist_location = is_checked
        end
        
        private
        alias_method :initialize__persist_location_action, :initialize
      end }
      
      # Shell style appropriate for a simple hover popup that cannot get focus.
      const_set_lazy(:HOVER_SHELLSTYLE) { SWT::NO_FOCUS | SWT::ON_TOP | SWT::TOOL }
      const_attr_reader  :HOVER_SHELLSTYLE
      
      # Shell style appropriate for an info popup that can get focus.
      const_set_lazy(:INFOPOPUP_SHELLSTYLE) { SWT::TOOL }
      const_attr_reader  :INFOPOPUP_SHELLSTYLE
      
      # Shell style appropriate for a resizable info popup that can get focus.
      const_set_lazy(:INFOPOPUPRESIZE_SHELLSTYLE) { SWT::RESIZE }
      const_attr_reader  :INFOPOPUPRESIZE_SHELLSTYLE
      
      # Margin width (in pixels) to be used in layouts inside popup dialogs
      # (value is 0).
      const_set_lazy(:POPUP_MARGINWIDTH) { 0 }
      const_attr_reader  :POPUP_MARGINWIDTH
      
      # Margin height (in pixels) to be used in layouts inside popup dialogs
      # (value is 0).
      const_set_lazy(:POPUP_MARGINHEIGHT) { 0 }
      const_attr_reader  :POPUP_MARGINHEIGHT
      
      # Vertical spacing (in pixels) between cells in the layouts inside popup
      # dialogs (value is 1).
      const_set_lazy(:POPUP_VERTICALSPACING) { 1 }
      const_attr_reader  :POPUP_VERTICALSPACING
      
      # Vertical spacing (in pixels) between cells in the layouts inside popup
      # dialogs (value is 1).
      const_set_lazy(:POPUP_HORIZONTALSPACING) { 1 }
      const_attr_reader  :POPUP_HORIZONTALSPACING
      
      # Image registry key for menu image.
      # 
      # @since 3.4
      const_set_lazy(:POPUP_IMG_MENU) { "popup_menu_image" }
      const_attr_reader  :POPUP_IMG_MENU
      
      # $NON-NLS-1$
      # 
      # Image registry key for disabled menu image.
      # 
      # @since 3.4
      const_set_lazy(:POPUP_IMG_MENU_DISABLED) { "popup_menu_image_diabled" }
      const_attr_reader  :POPUP_IMG_MENU_DISABLED
      
      # $NON-NLS-1$
      const_set_lazy(:POPUP_LAYOUT_FACTORY) { GridLayoutFactory.fill_defaults.margins(POPUP_MARGINWIDTH, POPUP_MARGINHEIGHT).spacing(POPUP_HORIZONTALSPACING, POPUP_VERTICALSPACING) }
      const_attr_reader  :POPUP_LAYOUT_FACTORY
    }
    
    # The dialog's toolbar for the move and resize capabilities.
    attr_accessor :tool_bar
    alias_method :attr_tool_bar, :tool_bar
    undef_method :tool_bar
    alias_method :attr_tool_bar=, :tool_bar=
    undef_method :tool_bar=
    
    # The dialog's menu manager.
    attr_accessor :menu_manager
    alias_method :attr_menu_manager, :menu_manager
    undef_method :menu_manager
    alias_method :attr_menu_manager=, :menu_manager=
    undef_method :menu_manager=
    
    # The control representing the main dialog area.
    attr_accessor :dialog_area
    alias_method :attr_dialog_area, :dialog_area
    undef_method :dialog_area
    alias_method :attr_dialog_area=, :dialog_area=
    undef_method :dialog_area=
    
    # Labels that contain title and info text. Cached so they can be updated
    # dynamically if possible.
    attr_accessor :title_label
    alias_method :attr_title_label, :title_label
    undef_method :title_label
    alias_method :attr_title_label=, :title_label=
    undef_method :title_label=
    
    attr_accessor :info_label
    alias_method :attr_info_label, :info_label
    undef_method :info_label
    alias_method :attr_info_label=, :info_label=
    undef_method :info_label=
    
    # Separator controls. Cached so they can be excluded from color changes.
    attr_accessor :title_separator
    alias_method :attr_title_separator, :title_separator
    undef_method :title_separator
    alias_method :attr_title_separator=, :title_separator=
    undef_method :title_separator=
    
    attr_accessor :info_separator
    alias_method :attr_info_separator, :info_separator
    undef_method :info_separator
    alias_method :attr_info_separator=, :info_separator=
    undef_method :info_separator=
    
    # Font to be used for the info area text. Computed based on the dialog's
    # font.
    attr_accessor :info_font
    alias_method :attr_info_font, :info_font
    undef_method :info_font
    alias_method :attr_info_font=, :info_font=
    undef_method :info_font=
    
    # Font to be used for the title area text. Computed based on the dialog's
    # font.
    attr_accessor :title_font
    alias_method :attr_title_font, :title_font
    undef_method :title_font
    alias_method :attr_title_font=, :title_font=
    undef_method :title_font=
    
    # Flags indicating whether we are listening for shell deactivate events,
    # either those or our parent's. Used to prevent closure when a menu command
    # is chosen or a secondary popup is launched.
    attr_accessor :listen_to_deactivate
    alias_method :attr_listen_to_deactivate, :listen_to_deactivate
    undef_method :listen_to_deactivate
    alias_method :attr_listen_to_deactivate=, :listen_to_deactivate=
    undef_method :listen_to_deactivate=
    
    attr_accessor :listen_to_parent_deactivate
    alias_method :attr_listen_to_parent_deactivate, :listen_to_parent_deactivate
    undef_method :listen_to_parent_deactivate
    alias_method :attr_listen_to_parent_deactivate=, :listen_to_parent_deactivate=
    undef_method :listen_to_parent_deactivate=
    
    attr_accessor :parent_deactivate_listener
    alias_method :attr_parent_deactivate_listener, :parent_deactivate_listener
    undef_method :parent_deactivate_listener
    alias_method :attr_parent_deactivate_listener=, :parent_deactivate_listener=
    undef_method :parent_deactivate_listener=
    
    # Flag indicating whether focus should be taken when the dialog is opened.
    attr_accessor :take_focus_on_open
    alias_method :attr_take_focus_on_open, :take_focus_on_open
    undef_method :take_focus_on_open
    alias_method :attr_take_focus_on_open=, :take_focus_on_open=
    undef_method :take_focus_on_open=
    
    # Flag specifying whether a menu should be shown that allows the user to
    # move and resize.
    attr_accessor :show_dialog_menu
    alias_method :attr_show_dialog_menu, :show_dialog_menu
    undef_method :show_dialog_menu
    alias_method :attr_show_dialog_menu=, :show_dialog_menu=
    undef_method :show_dialog_menu=
    
    # Flag specifying whether menu actions allowing the user to choose whether
    # the dialog bounds and location should be persisted are to be shown.
    attr_accessor :show_persist_actions
    alias_method :attr_show_persist_actions, :show_persist_actions
    undef_method :show_persist_actions
    alias_method :attr_show_persist_actions=, :show_persist_actions=
    undef_method :show_persist_actions=
    
    # Flag specifying whether the size of the popup should be persisted. This
    # flag is used as initial default and updated by the menu if it is shown.
    attr_accessor :persist_size
    alias_method :attr_persist_size, :persist_size
    undef_method :persist_size
    alias_method :attr_persist_size=, :persist_size=
    undef_method :persist_size=
    
    # Flag specifying whether the location of the popup should be persisted.
    # This flag is used as initial default and updated by the menu if it is
    # shown.
    attr_accessor :persist_location
    alias_method :attr_persist_location, :persist_location
    undef_method :persist_location
    alias_method :attr_persist_location=, :persist_location=
    undef_method :persist_location=
    
    # Flag specifying whether to use new 3.4 API instead of the old one.
    # 
    # @since 3.4
    attr_accessor :is_using34api
    alias_method :attr_is_using34api, :is_using34api
    undef_method :is_using34api
    alias_method :attr_is_using34api=, :is_using34api=
    undef_method :is_using34api=
    
    # Text to be shown in an optional title area (on top).
    attr_accessor :title_text
    alias_method :attr_title_text, :title_text
    undef_method :title_text
    alias_method :attr_title_text=, :title_text=
    undef_method :title_text=
    
    # Text to be shown in an optional info area (at the bottom).
    attr_accessor :info_text
    alias_method :attr_info_text, :info_text
    undef_method :info_text
    alias_method :attr_info_text=, :info_text=
    undef_method :info_text=
    
    typesig { [Shell, ::Java::Int, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, String, String] }
    # Constructs a new instance of <code>PopupDialog</code>.
    # 
    # @param parent
    # The parent shell.
    # @param shellStyle
    # The shell style.
    # @param takeFocusOnOpen
    # A boolean indicating whether focus should be taken by this
    # popup when it opens.
    # @param persistBounds
    # A boolean indicating whether the bounds (size and location) of
    # the dialog should be persisted upon close of the dialog. The
    # bounds can only be persisted if the dialog settings for
    # persisting the bounds are also specified. If a menu action
    # will be provided that allows the user to control this feature,
    # then the last known value of the user's setting will be used
    # instead of this flag.
    # @param showDialogMenu
    # A boolean indicating whether a menu for moving and resizing
    # the popup should be provided.
    # @param showPersistActions
    # A boolean indicating whether actions allowing the user to
    # control the persisting of the dialog size and location should
    # be shown in the dialog menu. This parameter has no effect if
    # <code>showDialogMenu</code> is <code>false</code>.
    # @param titleText
    # Text to be shown in an upper title area, or <code>null</code>
    # if there is no title.
    # @param infoText
    # Text to be shown in a lower info area, or <code>null</code>
    # if there is no info area.
    # 
    # @see PopupDialog#getDialogSettings()
    # @deprecated As of 3.4, replaced by
    # {@link #PopupDialog(Shell, int, boolean, boolean, boolean, boolean, boolean, String, String)}
    def initialize(parent, shell_style, take_focus_on_open, persist_bounds, show_dialog_menu, show_persist_actions, title_text, info_text)
      initialize__popup_dialog(parent, shell_style, take_focus_on_open, persist_bounds, persist_bounds, show_dialog_menu, show_persist_actions, title_text, info_text, false)
    end
    
    typesig { [Shell, ::Java::Int, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, String, String] }
    # Constructs a new instance of <code>PopupDialog</code>.
    # 
    # @param parent
    # The parent shell.
    # @param shellStyle
    # The shell style.
    # @param takeFocusOnOpen
    # A boolean indicating whether focus should be taken by this
    # popup when it opens.
    # @param persistSize
    # A boolean indicating whether the size should be persisted upon
    # close of the dialog. The size can only be persisted if the
    # dialog settings for persisting the bounds are also specified.
    # If a menu action will be provided that allows the user to
    # control this feature and the user hasn't changed that setting,
    # then this flag is used as initial default for the menu.
    # @param persistLocation
    # A boolean indicating whether the location should be persisted
    # upon close of the dialog. The location can only be persisted
    # if the dialog settings for persisting the bounds are also
    # specified. If a menu action will be provided that allows the
    # user to control this feature and the user hasn't changed that
    # setting, then this flag is used as initial default for the
    # menu. default for the menu until the user changed it.
    # @param showDialogMenu
    # A boolean indicating whether a menu for moving and resizing
    # the popup should be provided.
    # @param showPersistActions
    # A boolean indicating whether actions allowing the user to
    # control the persisting of the dialog bounds and location
    # should be shown in the dialog menu. This parameter has no
    # effect if <code>showDialogMenu</code> is <code>false</code>.
    # @param titleText
    # Text to be shown in an upper title area, or <code>null</code>
    # if there is no title.
    # @param infoText
    # Text to be shown in a lower info area, or <code>null</code>
    # if there is no info area.
    # 
    # @see PopupDialog#getDialogSettings()
    # 
    # @since 3.4
    def initialize(parent, shell_style, take_focus_on_open, persist_size, persist_location, show_dialog_menu, show_persist_actions, title_text, info_text)
      initialize__popup_dialog(parent, shell_style, take_focus_on_open, persist_size, persist_location, show_dialog_menu, show_persist_actions, title_text, info_text, true)
    end
    
    typesig { [Shell, ::Java::Int, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, String, String, ::Java::Boolean] }
    # Constructs a new instance of <code>PopupDialog</code>.
    # 
    # @param parent
    # The parent shell.
    # @param shellStyle
    # The shell style.
    # @param takeFocusOnOpen
    # A boolean indicating whether focus should be taken by this
    # popup when it opens.
    # @param persistSize
    # A boolean indicating whether the size should be persisted upon
    # close of the dialog. The size can only be persisted if the
    # dialog settings for persisting the bounds are also specified.
    # If a menu action will be provided that allows the user to
    # control this feature and the user hasn't changed that setting,
    # then this flag is used as initial default for the menu.
    # @param persistLocation
    # A boolean indicating whether the location should be persisted
    # upon close of the dialog. The location can only be persisted
    # if the dialog settings for persisting the bounds are also
    # specified. If a menu action will be provided that allows the
    # user to control this feature and the user hasn't changed that
    # setting, then this flag is used as initial default for the
    # menu. default for the menu until the user changed it.
    # @param showDialogMenu
    # A boolean indicating whether a menu for moving and resizing
    # the popup should be provided.
    # @param showPersistActions
    # A boolean indicating whether actions allowing the user to
    # control the persisting of the dialog bounds and location
    # should be shown in the dialog menu. This parameter has no
    # effect if <code>showDialogMenu</code> is <code>false</code>.
    # @param titleText
    # Text to be shown in an upper title area, or <code>null</code>
    # if there is no title.
    # @param infoText
    # Text to be shown in a lower info area, or <code>null</code>
    # if there is no info area.
    # @param use34API
    # <code>true</code> if 3.4 API should be used
    # 
    # @see PopupDialog#getDialogSettings()
    # 
    # @since 3.4
    def initialize(parent, shell_style, take_focus_on_open, persist_size, persist_location, show_dialog_menu, show_persist_actions, title_text, info_text, use34api)
      @tool_bar = nil
      @menu_manager = nil
      @dialog_area = nil
      @title_label = nil
      @info_label = nil
      @title_separator = nil
      @info_separator = nil
      @info_font = nil
      @title_font = nil
      @listen_to_deactivate = false
      @listen_to_parent_deactivate = false
      @parent_deactivate_listener = nil
      @take_focus_on_open = false
      @show_dialog_menu = false
      @show_persist_actions = false
      @persist_size = false
      @persist_location = false
      @is_using34api = false
      @title_text = nil
      @info_text = nil
      super(parent)
      @tool_bar = nil
      @menu_manager = nil
      @take_focus_on_open = false
      @show_dialog_menu = false
      @show_persist_actions = false
      @persist_size = false
      @persist_location = false
      @is_using34api = true
      # Prior to 3.4, we encouraged use of SWT.NO_TRIM and provided a
      # border using a black composite background and margin. Now we
      # use SWT.TOOL to get the border for some cases and this conflicts
      # with SWT.NO_TRIM. Clients who previously have used SWT.NO_TRIM
      # and still had a border drawn for them would find their border go
      # away unless we do the following:
      # see https://bugs.eclipse.org/bugs/show_bug.cgi?id=219743
      if (!((shell_style & SWT::NO_TRIM)).equal?(0))
        shell_style &= ~(SWT::NO_TRIM | SWT::SHELL_TRIM)
      end
      set_shell_style(shell_style)
      @take_focus_on_open = take_focus_on_open
      @show_dialog_menu = show_dialog_menu
      @show_persist_actions = show_persist_actions
      @title_text = title_text
      @info_text = info_text
      set_block_on_open(false)
      @is_using34api = use34api
      @persist_size = persist_size
      @persist_location = persist_location
      migrate_bounds_setting
      initialize_widget_state
    end
    
    typesig { [Shell] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#configureShell(Shell)
    def configure_shell(shell)
      GridLayoutFactory.fill_defaults.margins(0, 0).spacing(5, 5).apply_to(shell)
      shell.add_listener(SWT::Deactivate, Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members PopupDialog
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |event|
          # Close if we are deactivating and have no child shells. If we
          # have child shells, we are deactivating due to their opening.
          # On X, we receive this when a menu child (such as the system
          # menu) of the shell opens, but I have not found a way to
          # distinguish that case here. Hence bug #113577 still exists.
          if (self.attr_listen_to_deactivate && (event.attr_widget).equal?(get_shell) && (get_shell.get_shells.attr_length).equal?(0))
            async_close
          else
            # We typically ignore deactivates to work around
            # platform-specific event ordering. Now that we've ignored
            # whatever we were supposed to, start listening to
            # deactivates. Example issues can be found in
            # https://bugs.eclipse.org/bugs/show_bug.cgi?id=123392
            self.attr_listen_to_deactivate = true
          end
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      shell.add_listener(SWT::Activate, # Set this true whenever we activate. It may have been turned
      # off by a menu or secondary popup showing.
      Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members PopupDialog
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |event|
          # ignore this event if we have launched a child
          if ((event.attr_widget).equal?(get_shell) && (get_shell.get_shells.attr_length).equal?(0))
            self.attr_listen_to_deactivate = true
            # Typically we start listening for parent deactivate after
            # we are activated, except on the Mac, where the deactivate
            # is received after activate.
            # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=100668
            self.attr_listen_to_parent_deactivate = !Util.is_mac
          end
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      if (!((get_shell_style & SWT::ON_TOP)).equal?(0) && !(shell.get_parent).nil?)
        @parent_deactivate_listener = Class.new(Listener.class == Class ? Listener : Object) do
          extend LocalClass
          include_class_members PopupDialog
          include Listener if Listener.class == Module
          
          typesig { [Event] }
          define_method :handle_event do |event|
            if (self.attr_listen_to_parent_deactivate)
              async_close
            else
              # Our first deactivate, now start listening on the Mac.
              self.attr_listen_to_parent_deactivate = self.attr_listen_to_deactivate
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        shell.get_parent.add_listener(SWT::Deactivate, @parent_deactivate_listener)
      end
      shell.add_dispose_listener(Class.new(DisposeListener.class == Class ? DisposeListener : Object) do
        extend LocalClass
        include_class_members PopupDialog
        include DisposeListener if DisposeListener.class == Module
        
        typesig { [DisposeEvent] }
        define_method :widget_disposed do |event|
          handle_dispose
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
    def async_close
      get_shell.get_display.async_exec(# workaround for https://bugs.eclipse.org/bugs/show_bug.cgi?id=152010
      Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members PopupDialog
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          close
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Composite] }
    # The <code>PopupDialog</code> implementation of this <code>Window</code>
    # method creates and lays out the top level composite for the dialog. It
    # then calls the <code>createTitleMenuArea</code>,
    # <code>createDialogArea</code>, and <code>createInfoTextArea</code>
    # methods to create an optional title and menu area on the top, a dialog
    # area in the center, and an optional info text area at the bottom.
    # Overriding <code>createDialogArea</code> and (optionally)
    # <code>createTitleMenuArea</code> and <code>createTitleMenuArea</code>
    # are recommended rather than overriding this method.
    # 
    # @param parent
    # the composite used to parent the contents.
    # 
    # @return the control representing the contents.
    def create_contents(parent)
      composite = Composite.new(parent, SWT::NONE)
      POPUP_LAYOUT_FACTORY.apply_to(composite)
      LAYOUTDATA_GRAB_BOTH.apply_to(composite)
      # Title area
      if (has_title_area)
        create_title_menu_area(composite)
        @title_separator = create_horizontal_separator(composite)
      end
      # Content
      @dialog_area = create_dialog_area(composite)
      # Create a grid data layout data if one was not provided.
      # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=118025
      if ((@dialog_area.get_layout_data).nil?)
        LAYOUTDATA_GRAB_BOTH.apply_to(@dialog_area)
      end
      # Info field
      if (has_info_area)
        @info_separator = create_horizontal_separator(composite)
        create_info_text_area(composite)
      end
      apply_colors(composite)
      apply_fonts(composite)
      return composite
    end
    
    typesig { [Composite] }
    # Creates and returns the contents of the dialog (the area below the title
    # area and above the info text area.
    # <p>
    # The <code>PopupDialog</code> implementation of this framework method
    # creates and returns a new <code>Composite</code> with standard margins
    # and spacing.
    # <p>
    # The returned control's layout data must be an instance of
    # <code>GridData</code>. This method must not modify the parent's
    # layout.
    # <p>
    # Subclasses must override this method but may call <code>super</code> as
    # in the following example:
    # 
    # <pre>
    # Composite composite = (Composite) super.createDialogArea(parent);
    # //add controls to composite as necessary
    # return composite;
    # </pre>
    # 
    # @param parent
    # the parent composite to contain the dialog area
    # @return the dialog area control
    def create_dialog_area(parent)
      composite = Composite.new(parent, SWT::NONE)
      POPUP_LAYOUT_FACTORY.apply_to(composite)
      LAYOUTDATA_GRAB_BOTH.apply_to(composite)
      return composite
    end
    
    typesig { [] }
    # Returns the control that should get initial focus. Subclasses may
    # override this method.
    # 
    # @return the Control that should receive focus when the popup opens.
    def get_focus_control
      return @dialog_area
    end
    
    typesig { [Composite] }
    # Sets the tab order for the popup. Clients should override to introduce
    # specific tab ordering.
    # 
    # @param composite
    # the composite in which all content, including the title area
    # and info area, was created. This composite's parent is the
    # shell.
    def set_tab_order(composite)
      # default is to do nothing
    end
    
    typesig { [] }
    # Returns a boolean indicating whether the popup should have a title area
    # at the top of the dialog. Subclasses may override. Default behavior is to
    # have a title area if there is to be a menu or title text.
    # 
    # @return <code>true</code> if a title area should be created,
    # <code>false</code> if it should not.
    def has_title_area
      return !(@title_text).nil? || @show_dialog_menu
    end
    
    typesig { [] }
    # Returns a boolean indicating whether the popup should have an info area
    # at the bottom of the dialog. Subclasses may override. Default behavior is
    # to have an info area if info text was provided at the time of creation.
    # 
    # @return <code>true</code> if a title area should be created,
    # <code>false</code> if it should not.
    def has_info_area
      return !(@info_text).nil?
    end
    
    typesig { [Composite] }
    # Creates the title and menu area. Subclasses typically need not override
    # this method, but instead should use the constructor parameters
    # <code>showDialogMenu</code> and <code>showPersistAction</code> to
    # indicate whether a menu should be shown, and
    # <code>createTitleControl</code> to to customize the presentation of the
    # title.
    # 
    # <p>
    # If this method is overridden, the returned control's layout data must be
    # an instance of <code>GridData</code>. This method must not modify the
    # parent's layout.
    # 
    # @param parent
    # The parent composite.
    # @return The Control representing the title and menu area.
    def create_title_menu_area(parent)
      title_area_composite = Composite.new(parent, SWT::NONE)
      POPUP_LAYOUT_FACTORY.copy.num_columns(2).apply_to(title_area_composite)
      GridDataFactory.fill_defaults.align(SWT::FILL, SWT::CENTER).grab(true, false).apply_to(title_area_composite)
      create_title_control(title_area_composite)
      if (@show_dialog_menu)
        create_dialog_menu(title_area_composite)
      end
      return title_area_composite
    end
    
    typesig { [Composite] }
    # Creates the control to be used to represent the dialog's title text.
    # Subclasses may override if a different control is desired for
    # representing the title text, or if something different than the title
    # should be displayed in location where the title text typically is shown.
    # 
    # <p>
    # If this method is overridden, the returned control's layout data must be
    # an instance of <code>GridData</code>. This method must not modify the
    # parent's layout.
    # 
    # @param parent
    # The parent composite.
    # @return The Control representing the title area.
    def create_title_control(parent)
      @title_label = Label.new(parent, SWT::NONE)
      GridDataFactory.fill_defaults.align(SWT::FILL, SWT::CENTER).grab(true, false).span(@show_dialog_menu ? 1 : 2, 1).apply_to(@title_label)
      if (!(@title_text).nil?)
        @title_label.set_text(@title_text)
      end
      return @title_label
    end
    
    typesig { [Composite] }
    # Creates the optional info text area. This method is only called if the
    # <code>hasInfoArea()</code> method returns true. Subclasses typically
    # need not override this method, but may do so.
    # 
    # <p>
    # If this method is overridden, the returned control's layout data must be
    # an instance of <code>GridData</code>. This method must not modify the
    # parent's layout.
    # 
    # 
    # @param parent
    # The parent composite.
    # @return The control representing the info text area.
    # 
    # @see PopupDialog#hasInfoArea()
    # @see PopupDialog#createTitleControl(Composite)
    def create_info_text_area(parent)
      # Status label
      @info_label = Label.new(parent, SWT::RIGHT)
      @info_label.set_text(@info_text)
      GridDataFactory.fill_defaults.grab(true, false).align(SWT::FILL, SWT::BEGINNING).apply_to(@info_label)
      @info_label.set_foreground(parent.get_display.get_system_color(SWT::COLOR_WIDGET_DARK_SHADOW))
      return @info_label
    end
    
    typesig { [Composite] }
    # Create a horizontal separator for the given parent.
    # 
    # @param parent
    # The parent composite.
    # @return The Control representing the horizontal separator.
    def create_horizontal_separator(parent)
      separator = Label.new(parent, SWT::SEPARATOR | SWT::HORIZONTAL | SWT::LINE_DOT)
      GridDataFactory.fill_defaults.align(SWT::FILL, SWT::CENTER).grab(true, false).apply_to(separator)
      return separator
    end
    
    typesig { [Composite] }
    # Create the dialog's menu for the move and resize actions.
    # 
    # @param parent
    # The parent composite.
    def create_dialog_menu(parent)
      @tool_bar = ToolBar.new(parent, SWT::FLAT)
      view_menu_button = ToolItem.new(@tool_bar, SWT::PUSH, 0)
      GridDataFactory.fill_defaults.align(SWT::END_, SWT::CENTER).apply_to(@tool_bar)
      view_menu_button.set_image(JFaceResources.get_image(POPUP_IMG_MENU))
      view_menu_button.set_disabled_image(JFaceResources.get_image(POPUP_IMG_MENU_DISABLED))
      view_menu_button.set_tool_tip_text(JFaceResources.get_string("PopupDialog.menuTooltip")) # $NON-NLS-1$
      view_menu_button.add_selection_listener(Class.new(SelectionAdapter.class == Class ? SelectionAdapter : Object) do
        extend LocalClass
        include_class_members PopupDialog
        include SelectionAdapter if SelectionAdapter.class == Module
        
        typesig { [SelectionEvent] }
        define_method :widget_selected do |e|
          show_dialog_menu
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      @tool_bar.add_mouse_listener(# See https://bugs.eclipse.org/bugs/show_bug.cgi?id=177183
      Class.new(MouseAdapter.class == Class ? MouseAdapter : Object) do
        extend LocalClass
        include_class_members PopupDialog
        include MouseAdapter if MouseAdapter.class == Module
        
        typesig { [MouseEvent] }
        define_method :mouse_down do |e|
          show_dialog_menu
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [IMenuManager] }
    # Fill the dialog's menu. Subclasses may extend or override.
    # 
    # @param dialogMenu
    # The dialog's menu.
    def fill_dialog_menu(dialog_menu)
      dialog_menu.add(GroupMarker.new("SystemMenuStart")) # $NON-NLS-1$
      dialog_menu.add(MoveAction.new_local(self))
      dialog_menu.add(ResizeAction.new_local(self))
      if (@show_persist_actions)
        if (@is_using34api)
          dialog_menu.add(PersistLocationAction.new_local(self))
          dialog_menu.add(PersistSizeAction.new_local(self))
        else
          dialog_menu.add(PersistBoundsAction.new_local(self))
        end
      end
      dialog_menu.add(Separator.new("SystemMenuEnd")) # $NON-NLS-1$
    end
    
    typesig { [::Java::Int] }
    # Perform the requested tracker action (resize or move).
    # 
    # @param style
    # The track style (resize or move).
    def perform_tracker_action(style)
      shell = get_shell
      if ((shell).nil? || shell.is_disposed)
        return
      end
      tracker = Tracker.new(shell.get_display, style)
      tracker.set_stippled(true)
      r = Array.typed(Rectangle).new([shell.get_bounds])
      tracker.set_rectangles(r)
      # Ignore any deactivate events caused by opening the tracker.
      # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=120656
      old_listen_to_deactivate = @listen_to_deactivate
      @listen_to_deactivate = false
      if (tracker.open)
        if (!(shell).nil? && !shell.is_disposed)
          shell.set_bounds(tracker.get_rectangles[0])
        end
      end
      @listen_to_deactivate = old_listen_to_deactivate
    end
    
    typesig { [] }
    # Show the dialog's menu. This message has no effect if the receiver was
    # not configured to show a menu. Clients may call this method in order to
    # trigger the menu via keystrokes or other gestures. Subclasses typically
    # do not override method.
    def show_dialog_menu
      if (!@show_dialog_menu)
        return
      end
      if ((@menu_manager).nil?)
        @menu_manager = MenuManager.new
        fill_dialog_menu(@menu_manager)
      end
      # Setting this flag works around a problem that remains on X only,
      # whereby activating the menu deactivates our shell.
      @listen_to_deactivate = !Util.is_gtk
      menu = @menu_manager.create_context_menu(get_shell)
      bounds = @tool_bar.get_bounds
      top_left = Point.new(bounds.attr_x, bounds.attr_y + bounds.attr_height)
      top_left = get_shell.to_display(top_left)
      menu.set_location(top_left.attr_x, top_left.attr_y)
      menu.set_visible(true)
    end
    
    typesig { [String] }
    # Set the text to be shown in the popup's info area. This message has no
    # effect if there was no info text supplied when the dialog first opened.
    # Subclasses may override this method.
    # 
    # @param text
    # the text to be shown when the info area is displayed.
    def set_info_text(text)
      @info_text = text
      if (!(@info_label).nil?)
        @info_label.set_text(text)
      end
    end
    
    typesig { [String] }
    # Set the text to be shown in the popup's title area. This message has no
    # effect if there was no title label specified when the dialog was
    # originally opened. Subclasses may override this method.
    # 
    # @param text
    # the text to be shown when the title area is displayed.
    def set_title_text(text)
      @title_text = text
      if (!(@title_label).nil?)
        @title_label.set_text(text)
      end
    end
    
    typesig { [] }
    # Return a boolean indicating whether this dialog will persist its bounds.
    # This value is initially set in the dialog's constructor, but can be
    # modified if the persist bounds action is shown on the menu and the user
    # has changed its value. Subclasses may override this method.
    # 
    # @return <code>true</code> if the dialog's bounds will be persisted,
    # <code>false</code> if it will not.
    # 
    # @deprecated As of 3.4, please use {@link #getPersistLocation()} or
    # {@link #getPersistSize()} to determine separately whether
    # size or location should be persisted.
    def get_persist_bounds
      return @persist_location && @persist_size
    end
    
    typesig { [] }
    # Return a boolean indicating whether this dialog will persist its
    # location. This value is initially set in the dialog's constructor, but
    # can be modified if the persist location action is shown on the menu and
    # the user has changed its value. Subclasses may override this method.
    # 
    # @return <code>true</code> if the dialog's location will be persisted,
    # <code>false</code> if it will not.
    # 
    # @see #getPersistSize()
    # @since 3.4
    def get_persist_location
      return @persist_location
    end
    
    typesig { [] }
    # Return a boolean indicating whether this dialog will persist its size.
    # This value is initially set in the dialog's constructor, but can be
    # modified if the persist size action is shown on the menu and the user has
    # changed its value. Subclasses may override this method.
    # 
    # @return <code>true</code> if the dialog's size will be persisted,
    # <code>false</code> if it will not.
    # 
    # @see #getPersistLocation()
    # @since 3.4
    def get_persist_size
      return @persist_size
    end
    
    typesig { [] }
    # Opens this window, creating it first if it has not yet been created.
    # <p>
    # This method is reimplemented for special configuration of PopupDialogs.
    # It never blocks on open, immediately returning <code>OK</code> if the
    # open is successful, or <code>CANCEL</code> if it is not. It provides
    # framework hooks that allow subclasses to set the focus and tab order, and
    # avoids the use of <code>shell.open()</code> in cases where the focus
    # should not be given to the shell initially.
    # 
    # @return the return code
    # 
    # @see org.eclipse.jface.window.Window#open()
    def open
      shell = get_shell
      if ((shell).nil? || shell.is_disposed)
        shell = nil
        # create the window
        create
        shell = get_shell
      end
      # provide a hook for adjusting the bounds. This is only
      # necessary when there is content driven sizing that must be
      # adjusted each time the dialog is opened.
      adjust_bounds
      # limit the shell size to the display size
      constrain_shell_size
      # set up the tab order for the dialog
      set_tab_order(get_contents)
      # initialize flags for listening to deactivate
      @listen_to_deactivate = false
      @listen_to_parent_deactivate = false
      # open the window
      if (@take_focus_on_open)
        shell.open
        get_focus_control.set_focus
      else
        shell.set_visible(true)
      end
      return OK
    end
    
    typesig { [] }
    # Closes this window, disposes its shell, and removes this window from its
    # window manager (if it has one).
    # <p>
    # This method is extended to save the dialog bounds and initialize widget
    # state so that the widgets can be recreated if the dialog is reopened.
    # This method may be extended (<code>super.close</code> must be called).
    # </p>
    # 
    # @return <code>true</code> if the window is (or was already) closed, and
    # <code>false</code> if it is still open
    def close
      # If already closed, there is nothing to do.
      # See https://bugs.eclipse.org/bugs/show_bug.cgi?id=127505
      if ((get_shell).nil? || get_shell.is_disposed)
        return true
      end
      save_dialog_bounds(get_shell)
      # Widgets are about to be disposed, so null out any state
      # related to them that was not handled in dispose listeners.
      # We do this before disposal so that any received activate or
      # deactivate events are duly ignored.
      initialize_widget_state
      if (!(@parent_deactivate_listener).nil?)
        get_shell.get_parent.remove_listener(SWT::Deactivate, @parent_deactivate_listener)
        @parent_deactivate_listener = nil
      end
      return super
    end
    
    typesig { [] }
    # Gets the dialog settings that should be used for remembering the bounds
    # of the dialog. Subclasses should override this method when they wish to
    # persist the bounds of the dialog.
    # 
    # @return settings the dialog settings used to store the dialog's location
    # and/or size, or <code>null</code> if the dialog's bounds should
    # never be stored.
    def get_dialog_settings
      return nil
    end
    
    typesig { [Shell] }
    # Saves the bounds of the shell in the appropriate dialog settings. The
    # bounds are recorded relative to the parent shell, if there is one, or
    # display coordinates if there is no parent shell. Subclasses typically
    # need not override this method, but may extend it (calling
    # <code>super.saveDialogBounds</code> if additional bounds information
    # should be stored. Clients may also call this method to persist the bounds
    # at times other than closing the dialog.
    # 
    # @param shell
    # The shell whose bounds are to be stored
    def save_dialog_bounds(shell)
      settings = get_dialog_settings
      if (!(settings).nil?)
        shell_location = shell.get_location
        shell_size = shell.get_size
        parent = get_parent_shell
        if (!(parent).nil?)
          parent_location = parent.get_location
          shell_location.attr_x -= parent_location.attr_x
          shell_location.attr_y -= parent_location.attr_y
        end
        prefix = get_class.get_name
        if (@persist_size)
          settings.put(prefix + DIALOG_WIDTH, shell_size.attr_x)
          settings.put(prefix + DIALOG_HEIGHT, shell_size.attr_y)
        end
        if (@persist_location)
          settings.put(prefix + DIALOG_ORIGIN_X, shell_location.attr_x)
          settings.put(prefix + DIALOG_ORIGIN_Y, shell_location.attr_y)
        end
        if (@show_persist_actions && @show_dialog_menu)
          settings.put(RJava.cast_to_string(get_class.get_name) + DIALOG_USE_PERSISTED_SIZE, @persist_size)
          settings.put(RJava.cast_to_string(get_class.get_name) + DIALOG_USE_PERSISTED_LOCATION, @persist_location)
        end
      end
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#getInitialSize()
    def get_initial_size
      result = get_default_size
      if (@persist_size)
        settings = get_dialog_settings
        if (!(settings).nil?)
          begin
            width = settings.get_int(RJava.cast_to_string(get_class.get_name) + DIALOG_WIDTH)
            height = settings.get_int(RJava.cast_to_string(get_class.get_name) + DIALOG_HEIGHT)
            result = Point.new(width, height)
          rescue NumberFormatException => e
          end
        end
      end
      # No attempt is made to constrain the bounds. The default
      # constraining behavior in Window will be used.
      return result
    end
    
    typesig { [] }
    # Return the default size to use for the shell. This default size is used
    # if the dialog does not have any persisted size to restore. The default
    # implementation returns the preferred size of the shell. Subclasses should
    # override this method when an alternate default size is desired, rather
    # than overriding {@link #getInitialSize()}.
    # 
    # @return the initial size of the shell
    # 
    # @see #getPersistSize()
    # @since 3.4
    def get_default_size
      return Window.instance_method(:get_initial_size).bind(self).call
    end
    
    typesig { [Point] }
    # Returns the default location to use for the shell. This default location
    # is used if the dialog does not have any persisted location to restore.
    # The default implementation uses the location computed by
    # {@link org.eclipse.jface.window.Window#getInitialLocation(Point)}.
    # Subclasses should override this method when an alternate default location
    # is desired, rather than overriding {@link #getInitialLocation(Point)}.
    # 
    # @param initialSize
    # the initial size of the shell, as returned by
    # <code>getInitialSize</code>.
    # @return the initial location of the shell
    # 
    # @see #getPersistLocation()
    # @since 3.4
    def get_default_location(initial_size)
      return Window.instance_method(:get_initial_location).bind(self).call(initial_size)
    end
    
    typesig { [] }
    # Adjust the bounds of the popup as necessary prior to opening the dialog.
    # Default is to do nothing, which honors any bounds set directly by clients
    # or those that have been saved in the dialog settings. Subclasses should
    # override this method when there are bounds computations that must be
    # checked each time the dialog is opened.
    def adjust_bounds
    end
    
    typesig { [Point] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.window.Window#getInitialLocation(org.eclipse.swt.graphics.Point)
    def get_initial_location(initial_size)
      result = get_default_location(initial_size)
      if (@persist_location)
        settings = get_dialog_settings
        if (!(settings).nil?)
          begin
            x = settings.get_int(RJava.cast_to_string(get_class.get_name) + DIALOG_ORIGIN_X)
            y = settings.get_int(RJava.cast_to_string(get_class.get_name) + DIALOG_ORIGIN_Y)
            result = Point.new(x, y)
            # The coordinates were stored relative to the parent shell.
            # Convert to display coordinates.
            parent = get_parent_shell
            if (!(parent).nil?)
              parent_location = parent.get_location
              result.attr_x += parent_location.attr_x
              result.attr_y += parent_location.attr_y
            end
          rescue NumberFormatException => e
          end
        end
      end
      # No attempt is made to constrain the bounds. The default
      # constraining behavior in Window will be used.
      return result
    end
    
    typesig { [Composite] }
    # Apply any desired color to the specified composite and its children.
    # 
    # @param composite
    # the contents composite
    def apply_colors(composite)
      # The getForeground() and getBackground() methods
      # should not answer null, but IColorProvider clients
      # are accustomed to null meaning use the default, so we guard
      # against this assumption.
      color = get_foreground
      if ((color).nil?)
        color = get_default_foreground
      end
      apply_foreground_color(color, composite, get_foreground_color_exclusions)
      color = get_background
      if ((color).nil?)
        color = get_default_background
      end
      apply_background_color(color, composite, get_background_color_exclusions)
    end
    
    typesig { [] }
    # Get the foreground color that should be used for this popup. Subclasses
    # may override.
    # 
    # @return the foreground color to be used. Should not be <code>null</code>.
    # 
    # @since 3.4
    # 
    # @see #getForegroundColorExclusions()
    def get_foreground
      return get_default_foreground
    end
    
    typesig { [] }
    # Get the background color that should be used for this popup. Subclasses
    # may override.
    # 
    # @return the background color to be used. Should not be <code>null</code>.
    # 
    # @since 3.4
    # 
    # @see #getBackgroundColorExclusions()
    def get_background
      return get_default_background
    end
    
    typesig { [] }
    # Return the default foreground color used for popup dialogs.
    # 
    # @return the default foreground color.
    def get_default_foreground
      return get_shell.get_display.get_system_color(SWT::COLOR_INFO_FOREGROUND)
    end
    
    typesig { [] }
    # Return the default background color used for popup dialogs.
    # 
    # @return the default background color
    def get_default_background
      return get_shell.get_display.get_system_color(SWT::COLOR_INFO_BACKGROUND)
    end
    
    typesig { [Composite] }
    # Apply any desired fonts to the specified composite and its children.
    # 
    # @param composite
    # the contents composite
    def apply_fonts(composite)
      Dialog.apply_dialog_font(composite)
      if (!(@title_label).nil?)
        font = @title_label.get_font
        font_datas = font.get_font_data
        i = 0
        while i < font_datas.attr_length
          font_datas[i].set_style(SWT::BOLD)
          i += 1
        end
        @title_font = Font.new(@title_label.get_display, font_datas)
        @title_label.set_font(@title_font)
      end
      if (!(@info_label).nil?)
        font = @info_label.get_font
        font_datas = font.get_font_data
        i = 0
        while i < font_datas.attr_length
          font_datas[i].set_height(font_datas[i].get_height * 9 / 10)
          i += 1
        end
        @info_font = Font.new(@info_label.get_display, font_datas)
        @info_label.set_font(@info_font)
      end
    end
    
    typesig { [Color, Control, JavaList] }
    # Set the specified foreground color for the specified control and all of
    # its children, except for those specified in the list of exclusions.
    # 
    # @param color
    # the color to use as the foreground color
    # @param control
    # the control whose color is to be changed
    # @param exclusions
    # a list of controls who are to be excluded from getting their
    # color assigned
    def apply_foreground_color(color, control, exclusions)
      if (!exclusions.contains(control))
        control.set_foreground(color)
      end
      if (control.is_a?(Composite))
        children = (control).get_children
        i = 0
        while i < children.attr_length
          apply_foreground_color(color, children[i], exclusions)
          i += 1
        end
      end
    end
    
    typesig { [Color, Control, JavaList] }
    # Set the specified background color for the specified control and all of
    # its children, except for those specified in the list of exclusions.
    # 
    # @param color
    # the color to use as the background color
    # @param control
    # the control whose color is to be changed
    # @param exclusions
    # a list of controls who are to be excluded from getting their
    # color assigned
    def apply_background_color(color, control, exclusions)
      if (!exclusions.contains(control))
        control.set_background(color)
      end
      if (control.is_a?(Composite))
        children = (control).get_children
        i = 0
        while i < children.attr_length
          apply_background_color(color, children[i], exclusions)
          i += 1
        end
      end
    end
    
    typesig { [Color, Control] }
    # Set the specified foreground color for the specified control and all of
    # its children. Subclasses may override this method, but typically do not.
    # If a subclass wishes to exclude a particular control in its contents from
    # getting the specified foreground color, it may instead override
    # {@link #getForegroundColorExclusions()}.
    # 
    # @param color
    # the color to use as the foreground color
    # @param control
    # the control whose color is to be changed
    # @see PopupDialog#getForegroundColorExclusions()
    def apply_foreground_color(color, control)
      apply_foreground_color(color, control, get_foreground_color_exclusions)
    end
    
    typesig { [Color, Control] }
    # Set the specified background color for the specified control and all of
    # its children. Subclasses may override this method, but typically do not.
    # If a subclass wishes to exclude a particular control in its contents from
    # getting the specified background color, it may instead override
    # {@link #getBackgroundColorExclusions()}
    # 
    # @param color
    # the color to use as the background color
    # @param control
    # the control whose color is to be changed
    # @see PopupDialog#getBackgroundColorExclusions()
    def apply_background_color(color, control)
      apply_background_color(color, control, get_background_color_exclusions)
    end
    
    typesig { [] }
    # Return a list of controls which should never have their foreground color
    # reset. Subclasses may extend this method, but should always call
    # <code>super.getForegroundColorExclusions</code> to aggregate the list.
    # 
    # 
    # @return the List of controls
    def get_foreground_color_exclusions
      list = ArrayList.new(3)
      if (!(@info_label).nil?)
        list.add(@info_label)
      end
      if (!(@title_separator).nil?)
        list.add(@title_separator)
      end
      if (!(@info_separator).nil?)
        list.add(@info_separator)
      end
      return list
    end
    
    typesig { [] }
    # Return a list of controls which should never have their background color
    # reset. Subclasses may extend this method, but should always call
    # <code>super.getBackgroundColorExclusions</code> to aggregate the list.
    # 
    # @return the List of controls
    def get_background_color_exclusions
      list = ArrayList.new(2)
      if (!(@title_separator).nil?)
        list.add(@title_separator)
      end
      if (!(@info_separator).nil?)
        list.add(@info_separator)
      end
      return list
    end
    
    typesig { [] }
    # Initialize any state related to the widgetry that should be set up each
    # time widgets are created.
    def initialize_widget_state
      @menu_manager = nil
      @dialog_area = nil
      @title_label = nil
      @title_separator = nil
      @info_separator = nil
      @info_label = nil
      @tool_bar = nil
      # If the menu item for persisting bounds is displayed, use the stored
      # value to determine whether any persisted bounds should be honored at
      # all.
      if (@show_dialog_menu && @show_persist_actions)
        settings = get_dialog_settings
        if (!(settings).nil?)
          key = RJava.cast_to_string(get_class.get_name) + DIALOG_USE_PERSISTED_SIZE
          if (!(settings.get(key)).nil? || !@is_using34api)
            @persist_size = settings.get_boolean(key)
          end
          key = RJava.cast_to_string(get_class.get_name) + DIALOG_USE_PERSISTED_LOCATION
          if (!(settings.get(key)).nil? || !@is_using34api)
            @persist_location = settings.get_boolean(key)
          end
        end
      end
    end
    
    typesig { [] }
    def migrate_bounds_setting
      settings = get_dialog_settings
      if ((settings).nil?)
        return
      end
      class_name = get_class.get_name
      key = class_name + DIALOG_USE_PERSISTED_BOUNDS
      value = settings.get(key)
      if ((value).nil? || (DIALOG_VALUE_MIGRATED_TO_34 == value))
        return
      end
      store_bounds = settings.get_boolean(key)
      settings.put(class_name + DIALOG_USE_PERSISTED_LOCATION, store_bounds)
      settings.put(class_name + DIALOG_USE_PERSISTED_SIZE, store_bounds)
      settings.put(key, DIALOG_VALUE_MIGRATED_TO_34)
    end
    
    typesig { [] }
    # The dialog is being disposed. Dispose of any resources allocated.
    def handle_dispose
      if (!(@info_font).nil? && !@info_font.is_disposed)
        @info_font.dispose
      end
      @info_font = nil
      if (!(@title_font).nil? && !@title_font.is_disposed)
        @title_font.dispose
      end
      @title_font = nil
    end
    
    private
    alias_method :initialize__popup_dialog, :initialize
  end
  
end
