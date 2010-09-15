require "rjava"

# Copyright (c) 2000, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Action
  module ActionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Org::Eclipse::Jface::Resource, :ImageDescriptor
      include_const ::Org::Eclipse::Swt::Events, :HelpListener
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Menu
    }
  end
  
  # The standard abstract implementation of an action.
  # <p>
  # Subclasses must implement the <code>IAction.run</code> method to carry out
  # the action's semantics.
  # </p>
  class Action < ActionImports.const_get :AbstractAction
    include_class_members ActionImports
    overload_protected {
      include IAction
    }
    
    class_module.module_eval {
      const_set_lazy(:VAL_DROP_DOWN_MENU) { Class.new(IMenuCreator.class == Class ? IMenuCreator : Object) do
        local_class_in Action
        include_class_members Action
        include IMenuCreator if IMenuCreator.class == Module
        
        typesig { [] }
        define_method :dispose do
          # do nothing
        end
        
        typesig { [Control] }
        define_method :get_menu do |parent|
          # do nothing
          return nil
        end
        
        typesig { [Menu] }
        define_method :get_menu do |parent|
          # do nothing
          return nil
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self) }
      const_attr_reader  :VAL_DROP_DOWN_MENU
      
      # The list of default values the action can have. These values will
      # determine the style of the action.
      const_set_lazy(:VAL_PUSH_BTN) { "PUSH_BTN" }
      const_attr_reader  :VAL_PUSH_BTN
      
      # $NON-NLS-1$
      const_set_lazy(:VAL_RADIO_BTN_OFF) { 0 }
      const_attr_reader  :VAL_RADIO_BTN_OFF
      
      const_set_lazy(:VAL_RADIO_BTN_ON) { 1 }
      const_attr_reader  :VAL_RADIO_BTN_ON
      
      const_set_lazy(:VAL_TOGGLE_BTN_OFF) { Boolean::FALSE }
      const_attr_reader  :VAL_TOGGLE_BTN_OFF
      
      const_set_lazy(:VAL_TOGGLE_BTN_ON) { Boolean::TRUE }
      const_attr_reader  :VAL_TOGGLE_BTN_ON
      
      typesig { [::Java::Int] }
      # Converts an accelerator key code to a string representation.
      # 
      # @param keyCode
      # the key code to be translated
      # @return a string representation of the key code
      def convert_accelerator(key_code)
        return LegacyActionTools.convert_accelerator(key_code)
      end
      
      typesig { [String] }
      # Parses the given accelerator text, and converts it to an accelerator key
      # code.
      # 
      # @param acceleratorText
      # the accelerator text
      # @return the SWT key code, or 0 if there is no accelerator
      def convert_accelerator(accelerator_text)
        return LegacyActionTools.convert_accelerator(accelerator_text)
      end
      
      typesig { [String] }
      # Maps a standard keyboard key name to an SWT key code. Key names are
      # converted to upper case before comparison. If the key name is a single
      # letter, for example "S", its character code is returned.
      # <p>
      # The following key names are known (case is ignored):
      # <ul>
      # <li><code>"BACKSPACE"</code></li>
      # <li><code>"TAB"</code></li>
      # <li><code>"RETURN"</code></li>
      # <li><code>"ENTER"</code></li>
      # <li><code>"ESC"</code></li>
      # <li><code>"ESCAPE"</code></li>
      # <li><code>"DELETE"</code></li>
      # <li><code>"SPACE"</code></li>
      # <li><code>"ARROW_UP"</code>, <code>"ARROW_DOWN"</code>,
      # <code>"ARROW_LEFT"</code>, and <code>"ARROW_RIGHT"</code></li>
      # <li><code>"PAGE_UP"</code> and <code>"PAGE_DOWN"</code></li>
      # <li><code>"HOME"</code></li>
      # <li><code>"END"</code></li>
      # <li><code>"INSERT"</code></li>
      # <li><code>"F1"</code>, <code>"F2"</code> through <code>"F12"</code></li>
      # </ul>
      # </p>
      # 
      # @param token
      # the key name
      # @return the SWT key code, <code>-1</code> if no match was found
      # @see org.eclipse.swt.SWT
      def find_key_code(token)
        return LegacyActionTools.find_key_code(token)
      end
      
      typesig { [::Java::Int] }
      # Maps an SWT key code to a standard keyboard key name. The key code is
      # stripped of modifiers (SWT.CTRL, SWT.ALT, SWT.SHIFT, and SWT.COMMAND). If
      # the key code is not an SWT code (for example if it a key code for the key
      # 'S'), a string containing a character representation of the key code is
      # returned.
      # 
      # @param keyCode
      # the key code to be translated
      # @return the string representation of the key code
      # @see org.eclipse.swt.SWT
      # @since 2.0
      def find_key_string(key_code)
        return LegacyActionTools.find_key_string(key_code)
      end
      
      typesig { [String] }
      # Maps standard keyboard modifier key names to the corresponding SWT
      # modifier bit. The following modifier key names are recognized (case is
      # ignored): <code>"CTRL"</code>, <code>"SHIFT"</code>,
      # <code>"ALT"</code>, and <code>"COMMAND"</code>. The given modifier
      # key name is converted to upper case before comparison.
      # 
      # @param token
      # the modifier key name
      # @return the SWT modifier bit, or <code>0</code> if no match was found
      # @see org.eclipse.swt.SWT
      def find_modifier(token)
        return LegacyActionTools.find_modifier(token)
      end
      
      typesig { [::Java::Int] }
      # Returns a string representation of an SWT modifier bit (SWT.CTRL,
      # SWT.ALT, SWT.SHIFT, and SWT.COMMAND). Returns <code>null</code> if the
      # key code is not an SWT modifier bit.
      # 
      # @param keyCode
      # the SWT modifier bit to be translated
      # @return the string representation of the SWT modifier bit, or
      # <code>null</code> if the key code was not an SWT modifier bit
      # @see org.eclipse.swt.SWT
      # @since 2.0
      def find_modifier_string(key_code)
        return LegacyActionTools.find_modifier_string(key_code)
      end
      
      typesig { [String] }
      # Convenience method for removing any optional accelerator text from the
      # given string. The accelerator text appears at the end of the text, and is
      # separated from the main part by a single tab character <code>'\t'</code>.
      # 
      # @param text
      # the text
      # @return the text sans accelerator
      def remove_accelerator_text(text)
        return LegacyActionTools.remove_accelerator_text(text)
      end
      
      typesig { [String] }
      # Convenience method for removing any mnemonics from the given string. For
      # example, <code>removeMnemonics("&Open")</code> will return
      # <code>"Open"</code>.
      # 
      # @param text
      # the text
      # @return the text sans mnemonics
      # 
      # @since 3.0
      def remove_mnemonics(text)
        return LegacyActionTools.remove_mnemonics(text)
      end
    }
    
    # This action's accelerator; <code>0</code> means none.
    attr_accessor :accelerator
    alias_method :attr_accelerator, :accelerator
    undef_method :accelerator
    alias_method :attr_accelerator=, :accelerator=
    undef_method :accelerator=
    
    # This action's action definition id, or <code>null</code> if none.
    attr_accessor :action_definition_id
    alias_method :attr_action_definition_id, :action_definition_id
    undef_method :action_definition_id
    alias_method :attr_action_definition_id=, :action_definition_id=
    undef_method :action_definition_id=
    
    # This action's description, or <code>null</code> if none.
    attr_accessor :description
    alias_method :attr_description, :description
    undef_method :description
    alias_method :attr_description=, :description=
    undef_method :description=
    
    # This action's disabled image, or <code>null</code> if none.
    attr_accessor :disabled_image
    alias_method :attr_disabled_image, :disabled_image
    undef_method :disabled_image
    alias_method :attr_disabled_image=, :disabled_image=
    undef_method :disabled_image=
    
    # Indicates this action is enabled.
    attr_accessor :enabled
    alias_method :attr_enabled, :enabled
    undef_method :enabled
    alias_method :attr_enabled=, :enabled=
    undef_method :enabled=
    
    # An action's help listener, or <code>null</code> if none.
    attr_accessor :help_listener
    alias_method :attr_help_listener, :help_listener
    undef_method :help_listener
    alias_method :attr_help_listener=, :help_listener=
    undef_method :help_listener=
    
    # This action's hover image, or <code>null</code> if none.
    attr_accessor :hover_image
    alias_method :attr_hover_image, :hover_image
    undef_method :hover_image
    alias_method :attr_hover_image=, :hover_image=
    undef_method :hover_image=
    
    # This action's id, or <code>null</code> if none.
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    # This action's image, or <code>null</code> if none.
    attr_accessor :image
    alias_method :attr_image, :image
    undef_method :image
    alias_method :attr_image=, :image=
    undef_method :image=
    
    # This action's text, or <code>null</code> if none.
    attr_accessor :text
    alias_method :attr_text, :text
    undef_method :text
    alias_method :attr_text=, :text=
    undef_method :text=
    
    # This action's tool tip text, or <code>null</code> if none.
    attr_accessor :tool_tip_text
    alias_method :attr_tool_tip_text, :tool_tip_text
    undef_method :tool_tip_text
    alias_method :attr_tool_tip_text=, :tool_tip_text=
    undef_method :tool_tip_text=
    
    # Holds the action's menu creator (an IMenuCreator) or checked state (a
    # Boolean for toggle button, or an Integer for radio button), or
    # <code>null</code> if neither have been set.
    # <p>
    # The value of this field affects the value of <code>getStyle()</code>.
    # </p>
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    typesig { [] }
    # Creates a new action with no text and no image.
    # <p>
    # Configure the action later using the set methods.
    # </p>
    def initialize
      @accelerator = 0
      @action_definition_id = nil
      @description = nil
      @disabled_image = nil
      @enabled = false
      @help_listener = nil
      @hover_image = nil
      @id = nil
      @image = nil
      @text = nil
      @tool_tip_text = nil
      @value = nil
      super()
      @accelerator = 0
      @enabled = true
      @value = nil
      # do nothing
    end
    
    typesig { [String] }
    # Creates a new action with the given text and no image. Calls the zero-arg
    # constructor, then <code>setText</code>.
    # 
    # @param text
    # the string used as the text for the action, or
    # <code>null</code> if there is no text
    # @see #setText
    def initialize(text)
      initialize__action()
      set_text(text)
    end
    
    typesig { [String, ImageDescriptor] }
    # Creates a new action with the given text and image. Calls the zero-arg
    # constructor, then <code>setText</code> and
    # <code>setImageDescriptor</code>.
    # 
    # @param text
    # the action's text, or <code>null</code> if there is no text
    # @param image
    # the action's image, or <code>null</code> if there is no
    # image
    # @see #setText
    # @see #setImageDescriptor
    def initialize(text, image)
      initialize__action(text)
      set_image_descriptor(image)
    end
    
    typesig { [String, ::Java::Int] }
    # Creates a new action with the given text and style.
    # 
    # @param text
    # the action's text, or <code>null</code> if there is no text
    # @param style
    # one of <code>AS_PUSH_BUTTON</code>,
    # <code>AS_CHECK_BOX</code>, <code>AS_DROP_DOWN_MENU</code>,
    # <code>AS_RADIO_BUTTON</code>, and
    # <code>AS_UNSPECIFIED</code>.
    def initialize(text, style)
      initialize__action(text)
      case (style)
      when AS_PUSH_BUTTON
        @value = VAL_PUSH_BTN
      when AS_CHECK_BOX
        @value = VAL_TOGGLE_BTN_OFF
      when AS_DROP_DOWN_MENU
        @value = VAL_DROP_DOWN_MENU
      when AS_RADIO_BUTTON
        @value = VAL_RADIO_BTN_OFF
      end
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def get_accelerator
      return @accelerator
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def get_action_definition_id
      return @action_definition_id
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def get_description
      if (!(@description).nil?)
        return @description
      end
      return get_tool_tip_text
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def get_disabled_image_descriptor
      return @disabled_image
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def get_help_listener
      return @help_listener
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def get_hover_image_descriptor
      return @hover_image
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def get_id
      return @id
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def get_image_descriptor
      return @image
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def get_menu_creator
      # The default drop down menu value is only used
      # to mark this action requested style. So do not
      # return it. For backward compatibility reasons.
      if ((@value).equal?(VAL_DROP_DOWN_MENU))
        return nil
      end
      if (@value.is_a?(IMenuCreator))
        return @value
      end
      return nil
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def get_style
      # Infer the style from the value field.
      if ((@value).equal?(VAL_PUSH_BTN) || (@value).nil?)
        return AS_PUSH_BUTTON
      end
      if ((@value).equal?(VAL_TOGGLE_BTN_ON) || (@value).equal?(VAL_TOGGLE_BTN_OFF))
        return AS_CHECK_BOX
      end
      if ((@value).equal?(VAL_RADIO_BTN_ON) || (@value).equal?(VAL_RADIO_BTN_OFF))
        return AS_RADIO_BUTTON
      end
      if (@value.is_a?(IMenuCreator))
        return AS_DROP_DOWN_MENU
      end
      # We should never get to this line...
      return AS_PUSH_BUTTON
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def get_text
      return @text
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def get_tool_tip_text
      return @tool_tip_text
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def is_checked
      return (@value).equal?(VAL_TOGGLE_BTN_ON) || (@value).equal?(VAL_RADIO_BTN_ON)
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def is_enabled
      return @enabled
    end
    
    typesig { [] }
    # (non-Javadoc) Method declared on IAction.
    def is_handled
      return true
    end
    
    typesig { [::Java::Boolean] }
    # Reports the outcome of the running of this action via the
    # {@link IAction#RESULT} property.
    # 
    # @param success
    # <code>true</code> if the action succeeded and
    # <code>false</code> if the action failed or was not completed
    # @see IAction#RESULT
    # @since 3.0
    def notify_result(success)
      # avoid Boolean.valueOf(boolean) to allow compilation against JCL
      # Foundation (bug 80059)
      fire_property_change(RESULT, nil, success ? Boolean::TRUE : Boolean::FALSE)
    end
    
    typesig { [] }
    # The default implementation of this <code>IAction</code> method does
    # nothing. Subclasses should override this method if they do not need
    # information from the triggering event, or override
    # <code>runWithEvent(Event)</code> if they do.
    def run
      # do nothing
    end
    
    typesig { [Event] }
    # The default implementation of this <code>IAction</code> method ignores
    # the event argument, and simply calls <code>run()</code>. Subclasses
    # should override this method if they need information from the triggering
    # event, or override <code>run()</code> if not.
    # 
    # @param event
    # the SWT event which triggered this action being run
    # @since 2.0
    def run_with_event(event)
      run
    end
    
    typesig { [::Java::Int] }
    # @see IAction#setAccelerator(int)
    def set_accelerator(keycode)
      @accelerator = keycode
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IAction.
    def set_action_definition_id(id)
      @action_definition_id = id
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc) Method declared on IAction.
    def set_checked(checked)
      new_value = nil
      # For backward compatibility, if the style is not
      # set yet, then convert it to a toggle button.
      if ((@value).nil? || (@value).equal?(VAL_TOGGLE_BTN_ON) || (@value).equal?(VAL_TOGGLE_BTN_OFF))
        new_value = checked ? VAL_TOGGLE_BTN_ON : VAL_TOGGLE_BTN_OFF
      else
        if ((@value).equal?(VAL_RADIO_BTN_ON) || (@value).equal?(VAL_RADIO_BTN_OFF))
          new_value = checked ? VAL_RADIO_BTN_ON : VAL_RADIO_BTN_OFF
        else
          # Some other style already, so do nothing.
          return
        end
      end
      if (!(new_value).equal?(@value))
        @value = new_value
        if (checked)
          fire_property_change(CHECKED, Boolean::FALSE, Boolean::TRUE)
        else
          fire_property_change(CHECKED, Boolean::TRUE, Boolean::FALSE)
        end
      end
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IAction.
    def set_description(text)
      if (((@description).nil? && !(text).nil?) || (!(@description).nil? && (text).nil?) || (!(@description).nil? && !(text).nil? && !(text == @description)))
        old_description = @description
        @description = text
        fire_property_change(DESCRIPTION, old_description, @description)
      end
    end
    
    typesig { [ImageDescriptor] }
    # (non-Javadoc) Method declared on IAction.
    def set_disabled_image_descriptor(new_image)
      if (!(@disabled_image).equal?(new_image))
        old_image = @disabled_image
        @disabled_image = new_image
        fire_property_change(IMAGE, old_image, new_image)
      end
    end
    
    typesig { [::Java::Boolean] }
    # (non-Javadoc) Method declared on IAction.
    def set_enabled(enabled)
      if (!(enabled).equal?(@enabled))
        old_val = @enabled ? Boolean::TRUE : Boolean::FALSE
        new_val = enabled ? Boolean::TRUE : Boolean::FALSE
        @enabled = enabled
        fire_property_change(ENABLED, old_val, new_val)
      end
    end
    
    typesig { [HelpListener] }
    # (non-Javadoc) Method declared on IAction.
    def set_help_listener(listener)
      @help_listener = listener
    end
    
    typesig { [ImageDescriptor] }
    # (non-Javadoc) Method declared on IAction.
    def set_hover_image_descriptor(new_image)
      if (!(@hover_image).equal?(new_image))
        old_image = @hover_image
        @hover_image = new_image
        fire_property_change(IMAGE, old_image, new_image)
      end
    end
    
    typesig { [String] }
    # (non-Javadoc) Method declared on IAction.
    def set_id(id)
      @id = id
    end
    
    typesig { [ImageDescriptor] }
    # (non-Javadoc) Method declared on IAction.
    def set_image_descriptor(new_image)
      if (!(@image).equal?(new_image))
        old_image = @image
        @image = new_image
        fire_property_change(IMAGE, old_image, new_image)
      end
    end
    
    typesig { [IMenuCreator] }
    # Sets the menu creator for this action.
    # <p>
    # Note that if this method is called, it overrides the check status.
    # </p>
    # 
    # @param creator
    # the menu creator, or <code>null</code> if none
    def set_menu_creator(creator)
      # For backward compatibility, if the style is not
      # set yet, then convert it to a drop down menu.
      if ((@value).nil?)
        @value = creator
        return
      end
      if (@value.is_a?(IMenuCreator))
        @value = (creator).nil? ? VAL_DROP_DOWN_MENU : creator
      end
    end
    
    typesig { [String] }
    # Sets the text for this action.
    # <p>
    # Fires a property change event for the <code>TEXT</code> property if the
    # text actually changes as a consequence.
    # </p>
    # <p>
    # The accelerator is identified by the last index of a tab character. If
    # there are no tab characters, then it is identified by the last index of a
    # '@' character. If neither, then there is no accelerator text. Note that
    # if you want to insert a '@' character into the text (but no accelerator,
    # you can simply insert a '@' or a tab at the end of the text.
    # </p>
    # 
    # @param text
    # the text, or <code>null</code> if none
    def set_text(text)
      old_text = @text
      old_accel = @accelerator
      @text = text
      if (!(text).nil?)
        accelerator_text = LegacyActionTools.extract_accelerator_text(text)
        if (!(accelerator_text).nil?)
          new_accelerator = LegacyActionTools.convert_localized_accelerator(accelerator_text)
          # Be sure to not wipe out the accelerator if nothing found
          if (new_accelerator > 0)
            set_accelerator(new_accelerator)
          end
        end
      end
      if (!((@accelerator).equal?(old_accel) && ((old_text).nil? ? (@text).nil? : (old_text == @text))))
        fire_property_change(TEXT, old_text, @text)
      end
    end
    
    typesig { [String] }
    # Sets the tool tip text for this action.
    # <p>
    # Fires a property change event for the <code>TOOL_TIP_TEXT</code>
    # property if the tool tip text actually changes as a consequence.
    # </p>
    # 
    # @param toolTipText
    # the tool tip text, or <code>null</code> if none
    def set_tool_tip_text(tool_tip_text)
      old_tool_tip_text = @tool_tip_text
      if (!((old_tool_tip_text).nil? ? (tool_tip_text).nil? : (old_tool_tip_text == tool_tip_text)))
        @tool_tip_text = tool_tip_text
        fire_property_change(TOOL_TIP_TEXT, old_tool_tip_text, tool_tip_text)
      end
    end
    
    private
    alias_method :initialize__action, :initialize
  end
  
end
