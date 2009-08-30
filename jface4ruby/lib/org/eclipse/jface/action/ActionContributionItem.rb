require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module ActionContributionItemImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Core::Commands, :ExecutionException
      include_const ::Org::Eclipse::Core::Commands, :NotEnabledException
      include_const ::Org::Eclipse::Jface::Action::ExternalActionManager, :IBindingManagerCallback
      include_const ::Org::Eclipse::Jface::Bindings, :Trigger
      include_const ::Org::Eclipse::Jface::Bindings, :TriggerSequence
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :IKeyLookup
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyLookupFactory
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyStroke
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Jface::Resource, :LocalResourceManager
      include_const ::Org::Eclipse::Jface::Resource, :ResourceManager
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Button
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Item
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
      include_const ::Org::Eclipse::Swt::Widgets, :MenuItem
      include_const ::Org::Eclipse::Swt::Widgets, :ToolBar
      include_const ::Org::Eclipse::Swt::Widgets, :ToolItem
      include_const ::Org::Eclipse::Swt::Widgets, :Widget
    }
  end
  
  # A contribution item which delegates to an action.
  # <p>
  # This class may be instantiated; it is not intended to be subclassed.
  # </p>
  # @noextend This class is not intended to be subclassed by clients.
  class ActionContributionItem < ActionContributionItemImports.const_get :ContributionItem
    include_class_members ActionContributionItemImports
    
    class_module.module_eval {
      # Mode bit: Show text on tool items or buttons, even if an image is
      # present. If this mode bit is not set, text is only shown on tool items if
      # there is no image present.
      # 
      # @since 3.0
      
      def mode_force_text
        defined?(@@mode_force_text) ? @@mode_force_text : @@mode_force_text= 1
      end
      alias_method :attr_mode_force_text, :mode_force_text
      
      def mode_force_text=(value)
        @@mode_force_text = value
      end
      alias_method :attr_mode_force_text=, :mode_force_text=
      
      # a string inserted in the middle of text that has been shortened
      const_set_lazy(:Ellipsis) { "..." }
      const_attr_reader  :Ellipsis
    }
    
    # $NON-NLS-1$
    # 
    # Stores the result of the action. False when the action returned failure.
    attr_accessor :result
    alias_method :attr_result, :result
    undef_method :result
    alias_method :attr_result=, :result=
    undef_method :result=
    
    class_module.module_eval {
      
      def use_color_icons
        defined?(@@use_color_icons) ? @@use_color_icons : @@use_color_icons= true
      end
      alias_method :attr_use_color_icons, :use_color_icons
      
      def use_color_icons=(value)
        @@use_color_icons = value
      end
      alias_method :attr_use_color_icons=, :use_color_icons=
      
      typesig { [] }
      # Returns whether color icons should be used in toolbars.
      # 
      # @return <code>true</code> if color icons should be used in toolbars,
      # <code>false</code> otherwise
      def get_use_color_icons_in_toolbars
        return self.attr_use_color_icons
      end
      
      typesig { [::Java::Boolean] }
      # Sets whether color icons should be used in toolbars.
      # 
      # @param useColorIcons
      # <code>true</code> if color icons should be used in toolbars,
      # <code>false</code> otherwise
      def set_use_color_icons_in_toolbars(use_color_icons)
        self.attr_use_color_icons = use_color_icons
      end
    }
    
    # The presentation mode.
    attr_accessor :mode
    alias_method :attr_mode, :mode
    undef_method :mode
    alias_method :attr_mode=, :mode=
    undef_method :mode=
    
    # The action.
    attr_accessor :action
    alias_method :attr_action, :action
    undef_method :action
    alias_method :attr_action=, :action=
    undef_method :action=
    
    # The listener for changes to the text of the action contributed by an
    # external source.
    attr_accessor :action_text_listener
    alias_method :attr_action_text_listener, :action_text_listener
    undef_method :action_text_listener
    alias_method :attr_action_text_listener=, :action_text_listener=
    undef_method :action_text_listener=
    
    # Remembers all images in use by this contribution item
    attr_accessor :image_manager
    alias_method :attr_image_manager, :image_manager
    undef_method :image_manager
    alias_method :attr_image_manager=, :image_manager=
    undef_method :image_manager=
    
    # Listener for SWT button widget events.
    attr_accessor :button_listener
    alias_method :attr_button_listener, :button_listener
    undef_method :button_listener
    alias_method :attr_button_listener=, :button_listener=
    undef_method :button_listener=
    
    # Listener for SWT menu item widget events.
    attr_accessor :menu_item_listener
    alias_method :attr_menu_item_listener, :menu_item_listener
    undef_method :menu_item_listener
    alias_method :attr_menu_item_listener=, :menu_item_listener=
    undef_method :menu_item_listener=
    
    # Listener for action property change notifications.
    attr_accessor :property_listener
    alias_method :attr_property_listener, :property_listener
    undef_method :property_listener
    alias_method :attr_property_listener=, :property_listener=
    undef_method :property_listener=
    
    # Listener for SWT tool item widget events.
    attr_accessor :tool_item_listener
    alias_method :attr_tool_item_listener, :tool_item_listener
    undef_method :tool_item_listener
    alias_method :attr_tool_item_listener=, :tool_item_listener=
    undef_method :tool_item_listener=
    
    # The widget created for this item; <code>null</code> before creation and
    # after disposal.
    attr_accessor :widget
    alias_method :attr_widget, :widget
    undef_method :widget
    alias_method :attr_widget=, :widget=
    undef_method :widget=
    
    attr_accessor :menu_creator_listener
    alias_method :attr_menu_creator_listener, :menu_creator_listener
    undef_method :menu_creator_listener
    alias_method :attr_menu_creator_listener=, :menu_creator_listener=
    undef_method :menu_creator_listener=
    
    typesig { [IAction] }
    # Creates a new contribution item from the given action. The id of the
    # action is used as the id of the item.
    # 
    # @param action
    # the action
    def initialize(action)
      @result = nil
      @mode = 0
      @action = nil
      @action_text_listener = nil
      @image_manager = nil
      @button_listener = nil
      @menu_item_listener = nil
      @property_listener = nil
      @tool_item_listener = nil
      @widget = nil
      @menu_creator_listener = nil
      @hold_menu = nil
      @menu_creator_called = false
      super(action.get_id)
      @result = nil
      @mode = 0
      @action_text_listener = Class.new(IPropertyChangeListener.class == Class ? IPropertyChangeListener : Object) do
        extend LocalClass
        include_class_members ActionContributionItem
        include IPropertyChangeListener if IPropertyChangeListener.class == Module
        
        typesig { [PropertyChangeEvent] }
        # @see IPropertyChangeListener#propertyChange(PropertyChangeEvent)
        define_method :property_change do |event|
          update(event.get_property)
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @property_listener = Class.new(IPropertyChangeListener.class == Class ? IPropertyChangeListener : Object) do
        extend LocalClass
        include_class_members ActionContributionItem
        include IPropertyChangeListener if IPropertyChangeListener.class == Module
        
        typesig { [PropertyChangeEvent] }
        define_method :property_change do |event|
          action_property_change(event)
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      @widget = nil
      @hold_menu = nil
      @menu_creator_called = false
      @action = action
    end
    
    typesig { [PropertyChangeEvent] }
    # Handles a property change event on the action (forwarded by nested
    # listener).
    def action_property_change(e)
      # This code should be removed. Avoid using free asyncExec
      if (is_visible && !(@widget).nil?)
        display = @widget.get_display
        if ((display.get_thread).equal?(JavaThread.current_thread))
          update(e.get_property)
        else
          display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            extend LocalClass
            include_class_members ActionContributionItem
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              update(e.get_property)
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
      end
    end
    
    typesig { [Object] }
    # Compares this action contribution item with another object. Two action
    # contribution items are equal if they refer to the identical Action.
    def ==(o)
      if (!(o.is_a?(ActionContributionItem)))
        return false
      end
      return (@action == (o).attr_action)
    end
    
    typesig { [Composite] }
    # The <code>ActionContributionItem</code> implementation of this
    # <code>IContributionItem</code> method creates an SWT
    # <code>Button</code> for the action using the action's style. If the
    # action's checked property has been set, the button is created and primed
    # to the value of the checked property.
    def fill(parent)
      if ((@widget).nil? && !(parent).nil?)
        flags = SWT::PUSH
        if (!(@action).nil?)
          if ((@action.get_style).equal?(IAction::AS_CHECK_BOX))
            flags = SWT::TOGGLE
          end
          if ((@action.get_style).equal?(IAction::AS_RADIO_BUTTON))
            flags = SWT::RADIO
          end
        end
        b = Button.new(parent, flags)
        b.set_data(self)
        b.add_listener(SWT::Dispose, get_button_listener)
        # Don't hook a dispose listener on the parent
        b.add_listener(SWT::Selection, get_button_listener)
        if (!(@action.get_help_listener).nil?)
          b.add_help_listener(@action.get_help_listener)
        end
        @widget = b
        update(nil)
        # Attach some extra listeners.
        @action.add_property_change_listener(@property_listener)
        if (!(@action).nil?)
          command_id = @action.get_action_definition_id
          callback = ExternalActionManager.get_instance.get_callback
          if ((!(callback).nil?) && (!(command_id).nil?))
            callback.add_property_change_listener(command_id, @action_text_listener)
          end
        end
      end
    end
    
    typesig { [Menu, ::Java::Int] }
    # The <code>ActionContributionItem</code> implementation of this
    # <code>IContributionItem</code> method creates an SWT
    # <code>MenuItem</code> for the action using the action's style. If the
    # action's checked property has been set, a button is created and primed to
    # the value of the checked property. If the action's menu creator property
    # has been set, a cascading submenu is created.
    def fill(parent, index)
      if ((@widget).nil? && !(parent).nil?)
        flags = SWT::PUSH
        if (!(@action).nil?)
          style = @action.get_style
          if ((style).equal?(IAction::AS_CHECK_BOX))
            flags = SWT::CHECK
          else
            if ((style).equal?(IAction::AS_RADIO_BUTTON))
              flags = SWT::RADIO
            else
              if ((style).equal?(IAction::AS_DROP_DOWN_MENU))
                flags = SWT::CASCADE
              end
            end
          end
        end
        mi = nil
        if (index >= 0)
          mi = MenuItem.new(parent, flags, index)
        else
          mi = MenuItem.new(parent, flags)
        end
        @widget = mi
        mi.set_data(self)
        mi.add_listener(SWT::Dispose, get_menu_item_listener)
        mi.add_listener(SWT::Selection, get_menu_item_listener)
        if (!(@action.get_help_listener).nil?)
          mi.add_help_listener(@action.get_help_listener)
        end
        if ((flags).equal?(SWT::CASCADE))
          # just create a proxy for now, if the user shows it then
          # fill it in
          sub_menu = Menu.new(parent)
          sub_menu.add_listener(SWT::Show, get_menu_creator_listener)
          sub_menu.add_listener(SWT::Hide, get_menu_creator_listener)
          mi.set_menu(sub_menu)
        end
        update(nil)
        # Attach some extra listeners.
        @action.add_property_change_listener(@property_listener)
        if (!(@action).nil?)
          command_id = @action.get_action_definition_id
          callback = ExternalActionManager.get_instance.get_callback
          if ((!(callback).nil?) && (!(command_id).nil?))
            callback.add_property_change_listener(command_id, @action_text_listener)
          end
        end
      end
    end
    
    typesig { [ToolBar, ::Java::Int] }
    # The <code>ActionContributionItem</code> implementation of this ,
    # <code>IContributionItem</code> method creates an SWT
    # <code>ToolItem</code> for the action using the action's style. If the
    # action's checked property has been set, a button is created and primed to
    # the value of the checked property. If the action's menu creator property
    # has been set, a drop-down tool item is created.
    def fill(parent, index)
      if ((@widget).nil? && !(parent).nil?)
        flags = SWT::PUSH
        if (!(@action).nil?)
          style = @action.get_style
          if ((style).equal?(IAction::AS_CHECK_BOX))
            flags = SWT::CHECK
          else
            if ((style).equal?(IAction::AS_RADIO_BUTTON))
              flags = SWT::RADIO
            else
              if ((style).equal?(IAction::AS_DROP_DOWN_MENU))
                flags = SWT::DROP_DOWN
              end
            end
          end
        end
        ti = nil
        if (index >= 0)
          ti = ToolItem.new(parent, flags, index)
        else
          ti = ToolItem.new(parent, flags)
        end
        ti.set_data(self)
        ti.add_listener(SWT::Selection, get_tool_item_listener)
        ti.add_listener(SWT::Dispose, get_tool_item_listener)
        @widget = ti
        update(nil)
        # Attach some extra listeners.
        @action.add_property_change_listener(@property_listener)
        if (!(@action).nil?)
          command_id = @action.get_action_definition_id
          callback = ExternalActionManager.get_instance.get_callback
          if ((!(callback).nil?) && (!(command_id).nil?))
            callback.add_property_change_listener(command_id, @action_text_listener)
          end
        end
      end
    end
    
    typesig { [] }
    # Returns the action associated with this contribution item.
    # 
    # @return the action
    def get_action
      return @action
    end
    
    typesig { [] }
    # Returns the listener for SWT button widget events.
    # 
    # @return a listener for button events
    def get_button_listener
      if ((@button_listener).nil?)
        @button_listener = Class.new(Listener.class == Class ? Listener : Object) do
          extend LocalClass
          include_class_members ActionContributionItem
          include Listener if Listener.class == Module
          
          typesig { [Event] }
          define_method :handle_event do |event|
            case (event.attr_type)
            when SWT::Dispose
              handle_widget_dispose(event)
            when SWT::Selection
              ew = event.attr_widget
              if (!(ew).nil?)
                handle_widget_selection(event, (ew).get_selection)
              end
            end
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return @button_listener
    end
    
    typesig { [] }
    # Returns the listener for SWT menu item widget events.
    # 
    # @return a listener for menu item events
    def get_menu_item_listener
      if ((@menu_item_listener).nil?)
        @menu_item_listener = Class.new(Listener.class == Class ? Listener : Object) do
          extend LocalClass
          include_class_members ActionContributionItem
          include Listener if Listener.class == Module
          
          typesig { [Event] }
          define_method :handle_event do |event|
            case (event.attr_type)
            when SWT::Dispose
              handle_widget_dispose(event)
            when SWT::Selection
              ew = event.attr_widget
              if (!(ew).nil?)
                handle_widget_selection(event, (ew).get_selection)
              end
            end
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return @menu_item_listener
    end
    
    typesig { [] }
    # Returns the presentation mode, which is the bitwise-or of the
    # <code>MODE_*</code> constants. The default mode setting is 0, meaning
    # that for menu items, both text and image are shown (if present), but for
    # tool items, the text is shown only if there is no image.
    # 
    # @return the presentation mode settings
    # 
    # @since 3.0
    def get_mode
      return @mode
    end
    
    typesig { [] }
    # Returns the listener for SWT tool item widget events.
    # 
    # @return a listener for tool item events
    def get_tool_item_listener
      if ((@tool_item_listener).nil?)
        @tool_item_listener = Class.new(Listener.class == Class ? Listener : Object) do
          extend LocalClass
          include_class_members ActionContributionItem
          include Listener if Listener.class == Module
          
          typesig { [Event] }
          define_method :handle_event do |event|
            case (event.attr_type)
            when SWT::Dispose
              handle_widget_dispose(event)
            when SWT::Selection
              ew = event.attr_widget
              if (!(ew).nil?)
                handle_widget_selection(event, (ew).get_selection)
              end
            end
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return @tool_item_listener
    end
    
    typesig { [Event] }
    # Handles a widget dispose event for the widget corresponding to this item.
    def handle_widget_dispose(e)
      # Check if our widget is the one being disposed.
      if ((e.attr_widget).equal?(@widget))
        # Dispose of the menu creator.
        if ((@action.get_style).equal?(IAction::AS_DROP_DOWN_MENU) && @menu_creator_called)
          mc = @action.get_menu_creator
          if (!(mc).nil?)
            mc.dispose
          end
        end
        # Unhook all of the listeners.
        @action.remove_property_change_listener(@property_listener)
        if (!(@action).nil?)
          command_id = @action.get_action_definition_id
          callback = ExternalActionManager.get_instance.get_callback
          if ((!(callback).nil?) && (!(command_id).nil?))
            callback.remove_property_change_listener(command_id, @action_text_listener)
          end
        end
        # Clear the widget field.
        @widget = nil
        dispose_old_images
      end
    end
    
    typesig { [Event, ::Java::Boolean] }
    # Handles a widget selection event.
    def handle_widget_selection(e, selection)
      item = e.attr_widget
      if (!(item).nil?)
        style = item.get_style
        if (!((style & (SWT::TOGGLE | SWT::CHECK))).equal?(0))
          if ((@action.get_style).equal?(IAction::AS_CHECK_BOX))
            @action.set_checked(selection)
          end
        else
          if (!((style & SWT::RADIO)).equal?(0))
            if ((@action.get_style).equal?(IAction::AS_RADIO_BUTTON))
              @action.set_checked(selection)
            end
          else
            if (!((style & SWT::DROP_DOWN)).equal?(0))
              if ((e.attr_detail).equal?(4))
                # on drop-down button
                if ((@action.get_style).equal?(IAction::AS_DROP_DOWN_MENU))
                  mc = @action.get_menu_creator
                  @menu_creator_called = true
                  ti = item
                  # we create the menu as a sub-menu of "dummy" so that
                  # we can use
                  # it in a cascading menu too.
                  # If created on a SWT control we would get an SWT
                  # error...
                  # Menu dummy= new Menu(ti.getParent());
                  # Menu m= mc.getMenu(dummy);
                  # dummy.dispose();
                  if (!(mc).nil?)
                    m = mc.get_menu(ti.get_parent)
                    if (!(m).nil?)
                      # position the menu below the drop down item
                      point = ti.get_parent.to_display(Point.new(e.attr_x, e.attr_y))
                      m.set_location(point.attr_x, point.attr_y) # waiting
                      # for SWT
                      # 0.42
                      m.set_visible(true)
                      return # we don't fire the action
                    end
                  end
                end
              end
            end
          end
        end
        callback = nil
        action_definition_id = @action.get_action_definition_id
        if (!(action_definition_id).nil?)
          obj = ExternalActionManager.get_instance.get_callback
          if (obj.is_a?(ExternalActionManager::IExecuteCallback))
            callback = obj
          end
        end
        # Ensure action is enabled first.
        # See 1GAN3M6: ITPUI:WINNT - Any IAction in the workbench can be
        # executed while disabled.
        if (@action.is_enabled)
          trace = Policy::TRACE_ACTIONS
          ms = 0
          if (trace)
            ms = System.current_time_millis
            System.out.println("Running action: " + RJava.cast_to_string(@action.get_text)) # $NON-NLS-1$
          end
          result_listener = nil
          if (!(callback).nil?)
            result_listener = Class.new(IPropertyChangeListener.class == Class ? IPropertyChangeListener : Object) do
              extend LocalClass
              include_class_members ActionContributionItem
              include IPropertyChangeListener if IPropertyChangeListener.class == Module
              
              typesig { [PropertyChangeEvent] }
              define_method :property_change do |event|
                # Check on result
                if ((event.get_property == IAction::RESULT))
                  if (event.get_new_value.is_a?(Boolean))
                    self.attr_result = event.get_new_value
                  end
                end
              end
              
              typesig { [Object] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
            @action.add_property_change_listener(result_listener)
            callback.pre_execute(@action, e)
          end
          @action.run_with_event(e)
          if (!(callback).nil?)
            if ((@result).nil? || (@result == Boolean::TRUE))
              callback.post_execute_success(@action, Boolean::TRUE)
            else
              callback.post_execute_failure(@action, ExecutionException.new(RJava.cast_to_string(@action.get_text) + " returned failure.")) # $NON-NLS-1$
            end
          end
          if (!(result_listener).nil?)
            @result = nil
            @action.remove_property_change_listener(result_listener)
          end
          if (trace)
            System.out.println(RJava.cast_to_string((System.current_time_millis - ms)) + " ms to run action: " + RJava.cast_to_string(@action.get_text)) # $NON-NLS-1$
          end
        else
          if (!(callback).nil?)
            callback.not_enabled(@action, NotEnabledException.new(RJava.cast_to_string(@action.get_text) + " is not enabled.")) # $NON-NLS-1$
          end
        end
      end
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on Object.
    def hash_code
      return @action.hash_code
    end
    
    typesig { [IAction] }
    # Returns whether the given action has any images.
    # 
    # @param actionToCheck
    # the action
    # @return <code>true</code> if the action has any images,
    # <code>false</code> if not
    def has_images(action_to_check)
      return !(action_to_check.get_image_descriptor).nil? || !(action_to_check.get_hover_image_descriptor).nil? || !(action_to_check.get_disabled_image_descriptor).nil?
    end
    
    typesig { [] }
    # Returns whether the command corresponding to this action is active.
    def is_command_active
      action_to_check = get_action
      if (!(action_to_check).nil?)
        command_id = action_to_check.get_action_definition_id
        callback = ExternalActionManager.get_instance.get_callback
        if (!(callback).nil?)
          return callback.is_active(command_id)
        end
      end
      return true
    end
    
    typesig { [] }
    # The action item implementation of this <code>IContributionItem</code>
    # method returns <code>true</code> for menu items and <code>false</code>
    # for everything else.
    def is_dynamic
      if (@widget.is_a?(MenuItem))
        # Optimization. Only recreate the item is the check or radio style
        # has changed.
        item_is_check = !((@widget.get_style & SWT::CHECK)).equal?(0)
        action_is_check = !(get_action).nil? && (get_action.get_style).equal?(IAction::AS_CHECK_BOX)
        item_is_radio = !((@widget.get_style & SWT::RADIO)).equal?(0)
        action_is_radio = !(get_action).nil? && (get_action.get_style).equal?(IAction::AS_RADIO_BUTTON)
        return (!(item_is_check).equal?(action_is_check)) || (!(item_is_radio).equal?(action_is_radio))
      end
      return false
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IContributionItem.
    def is_enabled
      return !(@action).nil? && @action.is_enabled
    end
    
    typesig { [] }
    # Returns <code>true</code> if this item is allowed to enable,
    # <code>false</code> otherwise.
    # 
    # @return if this item is allowed to be enabled
    # @since 2.0
    def is_enabled_allowed
      if ((get_parent).nil?)
        return true
      end
      value = get_parent.get_overrides.get_enabled(self)
      return ((value).nil?) ? true : value.boolean_value
    end
    
    typesig { [] }
    # The <code>ActionContributionItem</code> implementation of this
    # <code>ContributionItem</code> method extends the super implementation
    # by also checking whether the command corresponding to this action is
    # active.
    def is_visible
      return super && is_command_active
    end
    
    typesig { [::Java::Int] }
    # Sets the presentation mode, which is the bitwise-or of the
    # <code>MODE_*</code> constants.
    # 
    # @param mode
    # the presentation mode settings
    # 
    # @since 3.0
    def set_mode(mode)
      @mode = mode
      update
    end
    
    typesig { [] }
    # The action item implementation of this <code>IContributionItem</code>
    # method calls <code>update(null)</code>.
    def update
      update(nil)
    end
    
    typesig { [String] }
    # Synchronizes the UI with the given property.
    # 
    # @param propertyName
    # the name of the property, or <code>null</code> meaning all
    # applicable properties
    def update(property_name)
      if (!(@widget).nil?)
        # determine what to do
        text_changed = (property_name).nil? || (property_name == IAction::TEXT)
        image_changed = (property_name).nil? || (property_name == IAction::IMAGE)
        tooltip_text_changed = (property_name).nil? || (property_name == IAction::TOOL_TIP_TEXT)
        enable_state_changed = (property_name).nil? || (property_name == IAction::ENABLED) || (property_name == IContributionManagerOverrides::P_ENABLED)
        check_changed = ((@action.get_style).equal?(IAction::AS_CHECK_BOX) || (@action.get_style).equal?(IAction::AS_RADIO_BUTTON)) && ((property_name).nil? || (property_name == IAction::CHECKED))
        if (@widget.is_a?(ToolItem))
          ti = @widget
          text = @action.get_text
          # the set text is shown only if there is no image or if forced
          # by MODE_FORCE_TEXT
          show_text = !(text).nil? && (!((get_mode & self.attr_mode_force_text)).equal?(0) || !has_images(@action))
          # only do the trimming if the text will be used
          if (show_text && !(text).nil?)
            text = RJava.cast_to_string(Action.remove_accelerator_text(text))
            text = RJava.cast_to_string(Action.remove_mnemonics(text))
          end
          if (text_changed)
            text_to_set = show_text ? text : "" # $NON-NLS-1$
            right_style = !((ti.get_parent.get_style & SWT::RIGHT)).equal?(0)
            if (right_style || !(ti.get_text == text_to_set))
              # In addition to being required to update the text if
              # it
              # gets nulled out in the action, this is also a
              # workaround
              # for bug 50151: Using SWT.RIGHT on a ToolBar leaves
              # blank space
              ti.set_text(text_to_set)
            end
          end
          if (image_changed)
            # only substitute a missing image if it has no text
            update_images(!show_text)
          end
          if (tooltip_text_changed || text_changed)
            tool_tip = @action.get_tool_tip_text
            if (((tool_tip).nil?) || ((tool_tip.length).equal?(0)))
              tool_tip = text
            end
            callback = ExternalActionManager.get_instance.get_callback
            command_id = @action.get_action_definition_id
            if ((!(callback).nil?) && (!(command_id).nil?) && (!(tool_tip).nil?))
              accelerator_text = callback.get_accelerator_text(command_id)
              if (!(accelerator_text).nil? && !(accelerator_text.length).equal?(0))
                # $NON-NLS-1$
                tool_tip = RJava.cast_to_string(JFaceResources.format("Toolbar_Tooltip_Accelerator", Array.typed(Object).new([tool_tip, accelerator_text])))
              end
            end
            # if the text is showing, then only set the tooltip if
            # different
            if (!show_text || !(tool_tip).nil? && !(tool_tip == text))
              ti.set_tool_tip_text(tool_tip)
            else
              ti.set_tool_tip_text(nil)
            end
          end
          if (enable_state_changed)
            should_be_enabled = @action.is_enabled && is_enabled_allowed
            if (!(ti.get_enabled).equal?(should_be_enabled))
              ti.set_enabled(should_be_enabled)
            end
          end
          if (check_changed)
            bv = @action.is_checked
            if (!(ti.get_selection).equal?(bv))
              ti.set_selection(bv)
            end
          end
          return
        end
        if (@widget.is_a?(MenuItem))
          mi = @widget
          if (text_changed)
            accelerator = 0
            accelerator_text = nil
            updated_action = get_action
            text = nil
            accelerator = updated_action.get_accelerator
            callback = ExternalActionManager.get_instance.get_callback
            # Block accelerators that are already in use.
            if ((!(accelerator).equal?(0)) && (!(callback).nil?) && (callback.is_accelerator_in_use(accelerator)))
              accelerator = 0
            end
            # Process accelerators on GTK in a special way to avoid Bug
            # 42009. We will override the native input method by
            # allowing these reserved accelerators to be placed on the
            # menu. We will only do this for "Ctrl+Shift+[0-9A-FU]".
            command_id = updated_action.get_action_definition_id
            if ((Util.is_gtk) && (callback.is_a?(IBindingManagerCallback)) && (!(command_id).nil?))
              binding_manager_callback = callback
              lookup = KeyLookupFactory.get_default
              trigger_sequences = binding_manager_callback.get_active_bindings_for(command_id)
              i = 0
              while i < trigger_sequences.attr_length
                trigger_sequence = trigger_sequences[i]
                triggers = trigger_sequence.get_triggers
                if ((triggers.attr_length).equal?(1))
                  trigger = triggers[0]
                  if (trigger.is_a?(KeyStroke))
                    current_key_stroke = trigger
                    current_natural_key = current_key_stroke.get_natural_key
                    if (((current_key_stroke.get_modifier_keys).equal?((lookup.get_ctrl | lookup.get_shift))) && ((current_natural_key >= Character.new(?0.ord) && current_natural_key <= Character.new(?9.ord)) || (current_natural_key >= Character.new(?A.ord) && current_natural_key <= Character.new(?F.ord)) || ((current_natural_key).equal?(Character.new(?U.ord)))))
                      accelerator = current_key_stroke.get_modifier_keys | current_natural_key
                      accelerator_text = RJava.cast_to_string(trigger_sequence.format)
                      break
                    end
                  end
                end
                i += 1
              end
            end
            if ((accelerator).equal?(0))
              if ((!(callback).nil?) && (!(command_id).nil?))
                accelerator_text = RJava.cast_to_string(callback.get_accelerator_text(command_id))
              end
            end
            overrides = nil
            if (!(get_parent).nil?)
              overrides = get_parent.get_overrides
            end
            if (!(overrides).nil?)
              text = RJava.cast_to_string(get_parent.get_overrides.get_text(self))
            end
            mi.set_accelerator(accelerator)
            if ((text).nil?)
              text = RJava.cast_to_string(updated_action.get_text)
            end
            if (!(text).nil? && (accelerator_text).nil?)
              # use extracted accelerator text in case accelerator
              # cannot be fully represented in one int (e.g.
              # multi-stroke keys)
              accelerator_text = RJava.cast_to_string(LegacyActionTools.extract_accelerator_text(text))
              if ((accelerator_text).nil? && !(accelerator).equal?(0))
                accelerator_text = RJava.cast_to_string(Action.convert_accelerator(accelerator))
              end
            end
            if ((text).nil?)
              text = "" # $NON-NLS-1$
            else
              text = RJava.cast_to_string(Action.remove_accelerator_text(text))
            end
            if ((accelerator_text).nil?)
              mi.set_text(text)
            else
              mi.set_text(text + RJava.cast_to_string(Character.new(?\t.ord)) + accelerator_text)
            end
          end
          if (image_changed)
            update_images(false)
          end
          if (enable_state_changed)
            should_be_enabled = @action.is_enabled && is_enabled_allowed
            if (!(mi.get_enabled).equal?(should_be_enabled))
              mi.set_enabled(should_be_enabled)
            end
          end
          if (check_changed)
            bv = @action.is_checked
            if (!(mi.get_selection).equal?(bv))
              mi.set_selection(bv)
            end
          end
          return
        end
        if (@widget.is_a?(Button))
          button = @widget
          if (image_changed)
            update_images(false)
          end
          if (text_changed)
            text = @action.get_text
            show_text = !(text).nil? && (!((get_mode & self.attr_mode_force_text)).equal?(0) || !has_images(@action))
            # only do the trimming if the text will be used
            if (show_text)
              text = RJava.cast_to_string(Action.remove_accelerator_text(text))
            end
            text_to_set = show_text ? text : "" # $NON-NLS-1$
            button.set_text(text_to_set)
          end
          if (tooltip_text_changed)
            button.set_tool_tip_text(@action.get_tool_tip_text)
          end
          if (enable_state_changed)
            should_be_enabled = @action.is_enabled && is_enabled_allowed
            if (!(button.get_enabled).equal?(should_be_enabled))
              button.set_enabled(should_be_enabled)
            end
          end
          if (check_changed)
            bv = @action.is_checked
            if (!(button.get_selection).equal?(bv))
              button.set_selection(bv)
            end
          end
          return
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # Updates the images for this action.
    # 
    # @param forceImage
    # <code>true</code> if some form of image is compulsory, and
    # <code>false</code> if it is acceptable for this item to have
    # no image
    # @return <code>true</code> if there are images for this action,
    # <code>false</code> if not
    def update_images(force_image)
      parent_resource_manager = JFaceResources.get_resources
      if (@widget.is_a?(ToolItem))
        if (self.attr_use_color_icons)
          image = @action.get_hover_image_descriptor
          if ((image).nil?)
            image = @action.get_image_descriptor
          end
          disabled_image = @action.get_disabled_image_descriptor
          # Make sure there is a valid image.
          if ((image).nil? && force_image)
            image = ImageDescriptor.get_missing_image_descriptor
          end
          local_manager = LocalResourceManager.new(parent_resource_manager)
          # performance: more efficient in SWT to set disabled and hot
          # image before regular image
          (@widget).set_disabled_image((disabled_image).nil? ? nil : local_manager.create_image_with_default(disabled_image))
          (@widget).set_image((image).nil? ? nil : local_manager.create_image_with_default(image))
          dispose_old_images
          @image_manager = local_manager
          return !(image).nil?
        end
        image = @action.get_image_descriptor
        hover_image = @action.get_hover_image_descriptor
        disabled_image = @action.get_disabled_image_descriptor
        # If there is no regular image, but there is a hover image,
        # convert the hover image to gray and use it as the regular image.
        if ((image).nil? && !(hover_image).nil?)
          image = ImageDescriptor.create_with_flags(@action.get_hover_image_descriptor, SWT::IMAGE_GRAY)
        else
          # If there is no hover image, use the regular image as the
          # hover image,
          # and convert the regular image to gray
          if ((hover_image).nil? && !(image).nil?)
            hover_image = image
            image = ImageDescriptor.create_with_flags(@action.get_image_descriptor, SWT::IMAGE_GRAY)
          end
        end
        # Make sure there is a valid image.
        if ((hover_image).nil? && (image).nil? && force_image)
          image = ImageDescriptor.get_missing_image_descriptor
        end
        # Create a local resource manager to remember the images we've
        # allocated for this tool item
        local_manager = LocalResourceManager.new(parent_resource_manager)
        # performance: more efficient in SWT to set disabled and hot image
        # before regular image
        (@widget).set_disabled_image((disabled_image).nil? ? nil : local_manager.create_image_with_default(disabled_image))
        (@widget).set_hot_image((hover_image).nil? ? nil : local_manager.create_image_with_default(hover_image))
        (@widget).set_image((image).nil? ? nil : local_manager.create_image_with_default(image))
        # Now that we're no longer referencing the old images, clear them
        # out.
        dispose_old_images
        @image_manager = local_manager
        return !(image).nil?
      else
        if (@widget.is_a?(Item) || @widget.is_a?(Button))
          # Use hover image if there is one, otherwise use regular image.
          image = @action.get_hover_image_descriptor
          if ((image).nil?)
            image = @action.get_image_descriptor
          end
          # Make sure there is a valid image.
          if ((image).nil? && force_image)
            image = ImageDescriptor.get_missing_image_descriptor
          end
          # Create a local resource manager to remember the images we've
          # allocated for this widget
          local_manager = LocalResourceManager.new(parent_resource_manager)
          if (@widget.is_a?(Item))
            (@widget).set_image((image).nil? ? nil : local_manager.create_image_with_default(image))
          else
            if (@widget.is_a?(Button))
              (@widget).set_image((image).nil? ? nil : local_manager.create_image_with_default(image))
            end
          end
          # Now that we're no longer referencing the old images, clear them
          # out.
          dispose_old_images
          @image_manager = local_manager
          return !(image).nil?
        end
      end
      return false
    end
    
    typesig { [] }
    # Dispose any images allocated for this contribution item
    def dispose_old_images
      if (!(@image_manager).nil?)
        @image_manager.dispose
        @image_manager = nil
      end
    end
    
    typesig { [String, ToolItem] }
    # Shorten the given text <code>t</code> so that its length doesn't exceed
    # the width of the given ToolItem.The default implementation replaces
    # characters in the center of the original string with an ellipsis ("...").
    # Override if you need a different strategy.
    # 
    # @param textValue
    # the text to shorten
    # @param item
    # the tool item the text belongs to
    # @return the shortened string
    def shorten_text(text_value, item)
      if ((text_value).nil?)
        return nil
      end
      gc = GC.new(item.get_parent)
      max_width = item.get_image.get_bounds.attr_width * 4
      if (gc.text_extent(text_value).attr_x < max_width)
        gc.dispose
        return text_value
      end
      i = text_value.length
      while i > 0
        test = text_value.substring(0, i)
        test = test + Ellipsis
        if (gc.text_extent(test).attr_x < max_width)
          gc.dispose
          return test
        end
        i -= 1
      end
      gc.dispose
      # If for some reason we fall through abort
      return text_value
    end
    
    typesig { [] }
    # (non-Javadoc)
    # 
    # @see org.eclipse.jface.action.ContributionItem#dispose()
    def dispose
      if (!(@widget).nil?)
        @widget.dispose
        @widget = nil
      end
      @hold_menu = nil
    end
    
    typesig { [] }
    # Handle show and hide on the proxy menu for IAction.AS_DROP_DOWN_MENU
    # actions.
    # 
    # @return the appropriate listener
    # @since 3.4
    def get_menu_creator_listener
      if ((@menu_creator_listener).nil?)
        @menu_creator_listener = Class.new(Listener.class == Class ? Listener : Object) do
          extend LocalClass
          include_class_members ActionContributionItem
          include Listener if Listener.class == Module
          
          typesig { [Event] }
          define_method :handle_event do |event|
            case (event.attr_type)
            when SWT::Show
              handle_show_proxy(event.attr_widget)
            when SWT::Hide
              handle_hide_proxy(event.attr_widget)
            end
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return @menu_creator_listener
    end
    
    # This is the easiest way to hold the menu until we can swap it in to the
    # proxy.
    attr_accessor :hold_menu
    alias_method :attr_hold_menu, :hold_menu
    undef_method :hold_menu
    alias_method :attr_hold_menu=, :hold_menu=
    undef_method :hold_menu=
    
    attr_accessor :menu_creator_called
    alias_method :attr_menu_creator_called, :menu_creator_called
    undef_method :menu_creator_called
    alias_method :attr_menu_creator_called=, :menu_creator_called=
    undef_method :menu_creator_called=
    
    typesig { [Menu] }
    # The proxy menu is being shown, we better get the real menu.
    # 
    # @param proxy
    # the proxy menu
    # @since 3.4
    def handle_show_proxy(proxy)
      proxy.remove_listener(SWT::Show, get_menu_creator_listener)
      mc = @action.get_menu_creator
      @menu_creator_called = true
      if ((mc).nil?)
        return
      end
      @hold_menu = mc.get_menu(proxy.get_parent_menu)
      if ((@hold_menu).nil?)
        return
      end
      copy_menu(@hold_menu, proxy)
    end
    
    typesig { [Menu, Menu] }
    # Create MenuItems in the proxy menu that can execute the real menu items
    # if selected. Create proxy menus for any real item submenus.
    # 
    # @param realMenu
    # the real menu to copy from
    # @param proxy
    # the proxy menu to populate
    # @since 3.4
    def copy_menu(real_menu, proxy)
      if (real_menu.is_disposed || proxy.is_disposed)
        return
      end
      # we notify the real menu so it can populate itself if it was
      # listening for SWT.Show
      real_menu.notify_listeners(SWT::Show, nil)
      pass_through = Class.new(Listener.class == Class ? Listener : Object) do
        extend LocalClass
        include_class_members ActionContributionItem
        include Listener if Listener.class == Module
        
        typesig { [Event] }
        define_method :handle_event do |event|
          if (!event.attr_widget.is_disposed)
            real_item = event.attr_widget.get_data
            if (!real_item.is_disposed)
              style = event.attr_widget.get_style
              if ((event.attr_type).equal?(SWT::Selection) && (!((style & (SWT::TOGGLE | SWT::CHECK | SWT::RADIO))).equal?(0)) && real_item.is_a?(self.class::MenuItem))
                (real_item).set_selection((event.attr_widget).get_selection)
              end
              event.attr_widget = real_item
              real_item.notify_listeners(event.attr_type, event)
            end
          end
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
      items = real_menu.get_items
      i = 0
      while i < items.attr_length
        real_item = items[i]
        proxy_item = MenuItem.new(proxy, real_item.get_style)
        proxy_item.set_data(real_item)
        proxy_item.set_accelerator(real_item.get_accelerator)
        proxy_item.set_enabled(real_item.get_enabled)
        proxy_item.set_image(real_item.get_image)
        proxy_item.set_selection(real_item.get_selection)
        proxy_item.set_text(real_item.get_text)
        # pass through any events
        proxy_item.add_listener(SWT::Selection, pass_through)
        proxy_item.add_listener(SWT::Arm, pass_through)
        proxy_item.add_listener(SWT::Help, pass_through)
        item_menu = real_item.get_menu
        if (!(item_menu).nil?)
          # create a proxy for any sub menu items
          sub_menu = Menu.new(proxy)
          sub_menu.set_data(item_menu)
          proxy_item.set_menu(sub_menu)
          sub_menu.add_listener(SWT::Show, Class.new(Listener.class == Class ? Listener : Object) do
            extend LocalClass
            include_class_members ActionContributionItem
            include Listener if Listener.class == Module
            
            typesig { [Event] }
            define_method :handle_event do |event|
              event.attr_widget.remove_listener(SWT::Show, self)
              if ((event.attr_type).equal?(SWT::Show))
                copy_menu(item_menu, sub_menu)
              end
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          sub_menu.add_listener(SWT::Help, pass_through)
          sub_menu.add_listener(SWT::Hide, pass_through)
        end
        i += 1
      end
    end
    
    typesig { [Menu] }
    # The proxy menu is being hidden, so we need to make it go away.
    # 
    # @param proxy
    # the proxy menu
    # @since 3.4
    def handle_hide_proxy(proxy)
      proxy.remove_listener(SWT::Hide, get_menu_creator_listener)
      proxy.get_display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
        extend LocalClass
        include_class_members ActionContributionItem
        include Runnable if Runnable.class == Module
        
        typesig { [] }
        define_method :run do
          if (!proxy.is_disposed)
            parent_item = proxy.get_parent_item
            proxy.dispose
            parent_item.set_menu(self.attr_hold_menu)
          end
          if (!(self.attr_hold_menu).nil? && !self.attr_hold_menu.is_disposed)
            self.attr_hold_menu.notify_listeners(SWT::Hide, nil)
          end
          self.attr_hold_menu = nil
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [] }
    # Return the widget associated with this contribution item. It should not
    # be cached, as it can be disposed and re-created by its containing
    # ContributionManager, which controls all of the widgets lifecycle methods.
    # <p>
    # This can be used to set layout data on the widget if appropriate. The
    # actual type of the widget can be any valid control for this
    # ContributionItem's current ContributionManager.
    # </p>
    # 
    # @return the widget, or <code>null</code> depending on the lifecycle.
    # @since 3.4
    def get_widget
      return @widget
    end
    
    private
    alias_method :initialize__action_contribution_item, :initialize
  end
  
end
