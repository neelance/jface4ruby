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
  module ExternalActionManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Action
      include_const ::Java::Text, :MessageFormat
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :JavaSet
      include_const ::Org::Eclipse::Core::Commands, :Command
      include_const ::Org::Eclipse::Core::Commands, :CommandEvent
      include_const ::Org::Eclipse::Core::Commands, :CommandManager
      include_const ::Org::Eclipse::Core::Commands, :ExecutionEvent
      include_const ::Org::Eclipse::Core::Commands, :ExecutionException
      include_const ::Org::Eclipse::Core::Commands, :ICommandListener
      include_const ::Org::Eclipse::Core::Commands, :NotEnabledException
      include_const ::Org::Eclipse::Core::Commands, :ParameterizedCommand
      include_const ::Org::Eclipse::Core::Commands::Common, :NotDefinedException
      include_const ::Org::Eclipse::Core::Runtime, :IStatus
      include_const ::Org::Eclipse::Core::Runtime, :ListenerList
      include_const ::Org::Eclipse::Core::Runtime, :Status
      include_const ::Org::Eclipse::Jface::Bindings, :BindingManager
      include_const ::Org::Eclipse::Jface::Bindings, :BindingManagerEvent
      include_const ::Org::Eclipse::Jface::Bindings, :IBindingManagerListener
      include_const ::Org::Eclipse::Jface::Bindings, :Trigger
      include_const ::Org::Eclipse::Jface::Bindings, :TriggerSequence
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeySequence
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :KeyStroke
      include_const ::Org::Eclipse::Jface::Bindings::Keys, :SWTKeySupport
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :Policy
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Jface::Util, :Util
      include_const ::Org::Eclipse::Swt::Widgets, :Event
    }
  end
  
  # <p>
  # A manager for a callback facility which is capable of querying external
  # interfaces for additional information about actions and action contribution
  # items. This information typically includes things like accelerators and
  # textual representations.
  # </p>
  # <p>
  # <em>It is only necessary to use this mechanism if you will be using a mix of
  # actions and commands, and wish the interactions to work properly.</em>
  # </p>
  # <p>
  # For example, in the Eclipse workbench, this mechanism is used to allow the
  # command architecture to override certain values in action contribution items.
  # </p>
  # <p>
  # This class is not intended to be called or extended by any external clients.
  # </p>
  # 
  # @since 3.0
  class ExternalActionManager 
    include_class_members ExternalActionManagerImports
    
    class_module.module_eval {
      # A simple implementation of the <code>ICallback</code> mechanism that
      # simply takes a <code>BindingManager</code> and a
      # <code>CommandManager</code>.
      # <p>
      # <b>Note:</b> this class is not intended to be subclassed by clients.
      # </p>
      # 
      # @since 3.1
      const_set_lazy(:CommandCallback) { Class.new do
        include_class_members ExternalActionManager
        include IBindingManagerListener
        include IBindingManagerCallback
        include IExecuteCallback
        
        class_module.module_eval {
          # The internationalization bundle for text produced by this class.
          const_set_lazy(:RESOURCE_BUNDLE) { ResourceBundle.get_bundle(ExternalActionManager.get_name) }
          const_attr_reader  :RESOURCE_BUNDLE
        }
        
        # The callback capable of responding to whether a command is active.
        attr_accessor :active_checker
        alias_method :attr_active_checker, :active_checker
        undef_method :active_checker
        alias_method :attr_active_checker=, :active_checker=
        undef_method :active_checker=
        
        # Check the applicability of firing an execution event for an action.
        attr_accessor :applicability_checker
        alias_method :attr_applicability_checker, :applicability_checker
        undef_method :applicability_checker
        alias_method :attr_applicability_checker=, :applicability_checker=
        undef_method :applicability_checker=
        
        # The binding manager for your application. Must not be
        # <code>null</code>.
        attr_accessor :binding_manager
        alias_method :attr_binding_manager, :binding_manager
        undef_method :binding_manager
        alias_method :attr_binding_manager=, :binding_manager=
        undef_method :binding_manager=
        
        # Whether a listener has been attached to the binding manager yet.
        attr_accessor :binding_manager_listener_attached
        alias_method :attr_binding_manager_listener_attached, :binding_manager_listener_attached
        undef_method :binding_manager_listener_attached
        alias_method :attr_binding_manager_listener_attached=, :binding_manager_listener_attached=
        undef_method :binding_manager_listener_attached=
        
        # The command manager for your application. Must not be
        # <code>null</code>.
        attr_accessor :command_manager
        alias_method :attr_command_manager, :command_manager
        undef_method :command_manager
        alias_method :attr_command_manager=, :command_manager=
        undef_method :command_manager=
        
        # A set of all the command identifiers that have been logged as broken
        # so far. For each of these, there will be a listener on the
        # corresponding command. If the command ever becomes defined, the item
        # will be removed from this set and the listener removed. This value
        # may be empty, but never <code>null</code>.
        attr_accessor :logged_command_ids
        alias_method :attr_logged_command_ids, :logged_command_ids
        undef_method :logged_command_ids
        alias_method :attr_logged_command_ids=, :logged_command_ids=
        undef_method :logged_command_ids=
        
        # The list of listeners that have registered for property change
        # notification. This is a map of command identifiers (<code>String</code>)
        # to listeners (<code>IPropertyChangeListener</code> or
        # <code>ListenerList</code> of <code>IPropertyChangeListener</code>).
        attr_accessor :registered_listeners
        alias_method :attr_registered_listeners, :registered_listeners
        undef_method :registered_listeners
        alias_method :attr_registered_listeners=, :registered_listeners=
        undef_method :registered_listeners=
        
        typesig { [class_self::BindingManager, class_self::CommandManager] }
        # Constructs a new instance of <code>CommandCallback</code> with the
        # workbench it should be using. All commands will be considered active.
        # 
        # @param bindingManager
        # The binding manager which will provide the callback; must
        # not be <code>null</code>.
        # @param commandManager
        # The command manager which will provide the callback; must
        # not be <code>null</code>.
        # 
        # @since 3.1
        def initialize(binding_manager, command_manager)
          initialize__command_callback(binding_manager, command_manager, Class.new(self.class::IActiveChecker.class == Class ? self.class::IActiveChecker : Object) do
            extend LocalClass
            include_class_members CommandCallback
            include class_self::IActiveChecker if class_self::IActiveChecker.class == Module
            
            typesig { [String] }
            define_method :is_active do |command_id|
              return true
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self), Class.new(self.class::IExecuteApplicable.class == Class ? self.class::IExecuteApplicable : Object) do
            extend LocalClass
            include_class_members CommandCallback
            include class_self::IExecuteApplicable if class_self::IExecuteApplicable.class == Module
            
            typesig { [class_self::IAction] }
            define_method :is_applicable do |action|
              return true
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        
        typesig { [class_self::BindingManager, class_self::CommandManager, class_self::IActiveChecker] }
        # Constructs a new instance of <code>CommandCallback</code> with the
        # workbench it should be using.
        # 
        # @param bindingManager
        # The binding manager which will provide the callback; must
        # not be <code>null</code>.
        # @param commandManager
        # The command manager which will provide the callback; must
        # not be <code>null</code>.
        # @param activeChecker
        # The callback mechanism for checking whether a command is
        # active; must not be <code>null</code>.
        # 
        # @since 3.1
        def initialize(binding_manager, command_manager, active_checker)
          initialize__command_callback(binding_manager, command_manager, active_checker, Class.new(self.class::IExecuteApplicable.class == Class ? self.class::IExecuteApplicable : Object) do
            extend LocalClass
            include_class_members CommandCallback
            include class_self::IExecuteApplicable if class_self::IExecuteApplicable.class == Module
            
            typesig { [class_self::IAction] }
            define_method :is_applicable do |action|
              return true
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        
        typesig { [class_self::BindingManager, class_self::CommandManager, class_self::IActiveChecker, class_self::IExecuteApplicable] }
        # Constructs a new instance of <code>CommandCallback</code> with the
        # workbench it should be using.
        # 
        # @param bindingManager
        # The binding manager which will provide the callback; must
        # not be <code>null</code>.
        # @param commandManager
        # The command manager which will provide the callback; must
        # not be <code>null</code>.
        # @param activeChecker
        # The callback mechanism for checking whether a command is
        # active; must not be <code>null</code>.
        # @param checker
        # The callback to check if an IAction should fire execution
        # events.
        # 
        # @since 3.4
        def initialize(binding_manager, command_manager, active_checker, checker)
          @active_checker = nil
          @applicability_checker = nil
          @binding_manager = nil
          @binding_manager_listener_attached = false
          @command_manager = nil
          @logged_command_ids = self.class::HashSet.new
          @registered_listeners = self.class::HashMap.new
          if ((binding_manager).nil?)
            raise self.class::NullPointerException.new("The callback needs a binding manager") # $NON-NLS-1$
          end
          if ((command_manager).nil?)
            raise self.class::NullPointerException.new("The callback needs a command manager") # $NON-NLS-1$
          end
          if ((active_checker).nil?)
            raise self.class::NullPointerException.new("The callback needs an active callback") # $NON-NLS-1$
          end
          if ((checker).nil?)
            raise self.class::NullPointerException.new("The callback needs an applicable callback") # $NON-NLS-1$
          end
          @active_checker = active_checker
          @binding_manager = binding_manager
          @command_manager = command_manager
          @applicability_checker = checker
        end
        
        typesig { [String, class_self::IPropertyChangeListener] }
        # @see org.eclipse.jface.action.ExternalActionManager.ICallback#addPropertyChangeListener(String,
        # IPropertyChangeListener)
        def add_property_change_listener(command_id, listener)
          existing = @registered_listeners.get(command_id)
          if (existing.is_a?(self.class::ListenerList))
            (existing).add(listener)
          else
            if (!(existing).nil?)
              listeners = self.class::ListenerList.new(ListenerList::IDENTITY)
              listeners.add(existing)
              listeners.add(listener)
              @registered_listeners.put(command_id, listeners)
            else
              @registered_listeners.put(command_id, listener)
            end
          end
          if (!@binding_manager_listener_attached)
            @binding_manager.add_binding_manager_listener(self)
            @binding_manager_listener_attached = true
          end
        end
        
        typesig { [class_self::BindingManagerEvent] }
        def binding_manager_changed(event)
          if (event.is_active_bindings_changed)
            listener_itr = @registered_listeners.entry_set.iterator
            while (listener_itr.has_next)
              entry = listener_itr.next_
              command_id = entry.get_key
              command = @command_manager.get_command(command_id)
              parameterized_command = self.class::ParameterizedCommand.new(command, nil)
              if (event.is_active_bindings_changed_for(parameterized_command))
                value = entry.get_value
                property_change_event = self.class::PropertyChangeEvent.new(event.get_manager, IAction::TEXT, nil, nil)
                if (value.is_a?(self.class::ListenerList))
                  listeners = (value).get_listeners
                  i = 0
                  while i < listeners.attr_length
                    listener = listeners[i]
                    listener.property_change(property_change_event)
                    i += 1
                  end
                else
                  listener = value
                  listener.property_change(property_change_event)
                end
              end
            end
          end
        end
        
        typesig { [String] }
        # @see org.eclipse.jface.action.ExternalActionManager.ICallback#getAccelerator(String)
        def get_accelerator(command_id)
          trigger_sequence = @binding_manager.get_best_active_binding_for(command_id)
          if (!(trigger_sequence).nil?)
            triggers = trigger_sequence.get_triggers
            if ((triggers.attr_length).equal?(1))
              trigger = triggers[0]
              if (trigger.is_a?(self.class::KeyStroke))
                key_stroke = trigger
                accelerator = SWTKeySupport.convert_key_stroke_to_accelerator(key_stroke)
                return accelerator
              end
            end
          end
          return nil
        end
        
        typesig { [String] }
        # @see org.eclipse.jface.action.ExternalActionManager.ICallback#getAcceleratorText(String)
        def get_accelerator_text(command_id)
          trigger_sequence = @binding_manager.get_best_active_binding_for(command_id)
          if ((trigger_sequence).nil?)
            return nil
          end
          return trigger_sequence.format
        end
        
        typesig { [String] }
        # Returns the active bindings for a particular command identifier.
        # 
        # @param commandId
        # The identifier of the command whose bindings are
        # requested. This argument may be <code>null</code>. It
        # is assumed that the command has no parameters.
        # @return The array of active triggers (<code>TriggerSequence</code>)
        # for a particular command identifier. This value is guaranteed
        # not to be <code>null</code>, but it may be empty.
        # @since 3.2
        def get_active_bindings_for(command_id)
          return @binding_manager.get_active_bindings_for(command_id)
        end
        
        typesig { [::Java::Int] }
        # @see org.eclipse.jface.action.ExternalActionManager.ICallback#isAcceleratorInUse(int)
        def is_accelerator_in_use(accelerator)
          key_sequence = KeySequence.get_instance(SWTKeySupport.convert_accelerator_to_key_stroke(accelerator))
          return @binding_manager.is_perfect_match(key_sequence) || @binding_manager.is_partial_match(key_sequence)
        end
        
        typesig { [String] }
        # {@inheritDoc}
        # 
        # Calling this method with an undefined command id will generate a log
        # message.
        def is_active(command_id)
          if (!(command_id).nil?)
            command = @command_manager.get_command(command_id)
            if (!command.is_defined && (!@logged_command_ids.contains(command_id)))
              # The command is not yet defined, so we should log this.
              # $NON-NLS-1$
              message = MessageFormat.format(Util.translate_string(self.class::RESOURCE_BUNDLE, "undefinedCommand.WarningMessage", nil), Array.typed(String).new([command.get_id]))
              # $NON-NLS-1$
              status = self.class::Status.new(IStatus::ERROR, "org.eclipse.jface", 0, message, self.class::JavaException.new)
              Policy.get_log.log(status)
              # And remember this item so we don't log it again.
              @logged_command_ids.add(command_id)
              command.add_command_listener(Class.new(self.class::ICommandListener.class == Class ? self.class::ICommandListener : Object) do
                extend LocalClass
                include_class_members CommandCallback
                include class_self::ICommandListener if class_self::ICommandListener.class == Module
                
                typesig { [class_self::CommandEvent] }
                # (non-Javadoc)
                # 
                # @see org.eclipse.ui.commands.ICommandListener#commandChanged(org.eclipse.ui.commands.CommandEvent)
                define_method :command_changed do |command_event|
                  if (command.is_defined)
                    command.remove_command_listener(self)
                    self.attr_logged_command_ids.remove(command_id)
                  end
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
              return true
            end
            return @active_checker.is_active(command_id)
          end
          return true
        end
        
        typesig { [String, class_self::IPropertyChangeListener] }
        # @see org.eclipse.jface.action.ExternalActionManager.ICallback#removePropertyChangeListener(String,
        # IPropertyChangeListener)
        def remove_property_change_listener(command_id, listener)
          existing = @registered_listeners.get(command_id)
          if ((existing).equal?(listener))
            @registered_listeners.remove(command_id)
            if (@registered_listeners.is_empty)
              @binding_manager.remove_binding_manager_listener(self)
              @binding_manager_listener_attached = false
            end
          else
            if (existing.is_a?(self.class::ListenerList))
              existing_list = existing
              existing_list.remove(listener)
              if ((existing_list.size).equal?(1))
                @registered_listeners.put(command_id, existing_list.get_listeners[0])
              end
            end
          end
        end
        
        typesig { [class_self::IAction, class_self::Event] }
        # @since 3.4
        def pre_execute(action, event)
          action_definition_id = action.get_action_definition_id
          if ((action_definition_id).nil? || !@applicability_checker.is_applicable(action))
            return
          end
          command = @command_manager.get_command(action_definition_id)
          execution_event = self.class::ExecutionEvent.new(command, Collections::EMPTY_MAP, event, nil)
          @command_manager.fire_pre_execute(action_definition_id, execution_event)
        end
        
        typesig { [class_self::IAction, Object] }
        # @since 3.4
        def post_execute_success(action, return_value)
          action_definition_id = action.get_action_definition_id
          if ((action_definition_id).nil? || !@applicability_checker.is_applicable(action))
            return
          end
          @command_manager.fire_post_execute_success(action_definition_id, return_value)
        end
        
        typesig { [class_self::IAction, class_self::ExecutionException] }
        # @since 3.4
        def post_execute_failure(action, exception)
          action_definition_id = action.get_action_definition_id
          if ((action_definition_id).nil? || !@applicability_checker.is_applicable(action))
            return
          end
          @command_manager.fire_post_execute_failure(action_definition_id, exception)
        end
        
        typesig { [class_self::IAction, class_self::NotDefinedException] }
        # @since 3.4
        def not_defined(action, exception)
          action_definition_id = action.get_action_definition_id
          if ((action_definition_id).nil? || !@applicability_checker.is_applicable(action))
            return
          end
          @command_manager.fire_not_defined(action_definition_id, exception)
        end
        
        typesig { [class_self::IAction, class_self::NotEnabledException] }
        # @since 3.4
        def not_enabled(action, exception)
          action_definition_id = action.get_action_definition_id
          if ((action_definition_id).nil? || !@applicability_checker.is_applicable(action))
            return
          end
          @command_manager.fire_not_enabled(action_definition_id, exception)
        end
        
        private
        alias_method :initialize__command_callback, :initialize
      end }
      
      # Defines a callback mechanism for developer who wish to further control
      # the visibility of legacy action-based contribution items.
      # 
      # @since 3.1
      const_set_lazy(:IActiveChecker) { Module.new do
        include_class_members ExternalActionManager
        
        typesig { [String] }
        # Checks whether the command with the given identifier should be
        # considered active. This can be used in systems using some kind of
        # user interface filtering (e.g., activities in the Eclipse workbench).
        # 
        # @param commandId
        # The identifier for the command; must not be
        # <code>null</code>
        # @return <code>true</code> if the command is active;
        # <code>false</code> otherwise.
        def is_active(command_id)
          raise NotImplementedError
        end
      end }
      
      # <p>
      # A callback which communicates with the applications binding manager. This
      # interface provides more information from the binding manager, which
      # allows greater integration. Implementing this interface is preferred over
      # {@link ExternalActionManager.ICallback}.
      # </p>
      # <p>
      # Clients may implement this interface, but must not extend.
      # </p>
      # 
      # @since 3.2
      const_set_lazy(:IBindingManagerCallback) { Module.new do
        include_class_members ExternalActionManager
        include ICallback
        
        typesig { [String] }
        # <p>
        # Returns the active bindings for a particular command identifier.
        # </p>
        # 
        # @param commandId
        # The identifier of the command whose bindings are
        # requested. This argument may be <code>null</code>. It
        # is assumed that the command has no parameters.
        # @return The array of active triggers (<code>TriggerSequence</code>)
        # for a particular command identifier. This value is guaranteed
        # not to be <code>null</code>, but it may be empty.
        def get_active_bindings_for(command_id)
          raise NotImplementedError
        end
      end }
      
      # An overridable mechanism to filter certain IActions from the execution
      # bridge.
      # 
      # @since 3.4
      const_set_lazy(:IExecuteApplicable) { Module.new do
        include_class_members ExternalActionManager
        
        typesig { [IAction] }
        # Allow the callback to filter out actions that should not fire
        # execution events.
        # 
        # @param action
        # The action with an actionDefinitionId
        # @return true if this action should be considered.
        def is_applicable(action)
          raise NotImplementedError
        end
      end }
      
      # <p>
      # A callback for executing execution events. Allows
      # <code>ActionContributionItems</code> to fire useful events.
      # </p>
      # <p>
      # Clients must not implement this interface and must not extend.
      # </p>
      # 
      # @since 3.4
      const_set_lazy(:IExecuteCallback) { Module.new do
        include_class_members ExternalActionManager
        
        typesig { [IAction, NotEnabledException] }
        # Fires a <code>NotEnabledException</code> because the action was not
        # enabled.
        # 
        # @param action
        # The action contribution that caused the exception,
        # never <code>null</code>.
        # @param exception
        # The <code>NotEnabledException</code>, never <code>null</code>.
        def not_enabled(action, exception)
          raise NotImplementedError
        end
        
        typesig { [IAction, NotDefinedException] }
        # Fires a <code>NotDefinedException</code> because the action was not
        # defined.
        # 
        # @param action
        # The action contribution that caused the exception,
        # never <code>null</code>.
        # @param exception
        # The <code>NotDefinedException</code>, never <code>null</code>.
        def not_defined(action, exception)
          raise NotImplementedError
        end
        
        typesig { [IAction, Event] }
        # Fires an execution event before an action is run.
        # 
        # @param action
        # The action contribution that requires an
        # execution event to be fired. Cannot be <code>null</code>.
        # @param e
        # The SWT Event, may be <code>null</code>.
        def pre_execute(action, e)
          raise NotImplementedError
        end
        
        typesig { [IAction, Object] }
        # Fires an execution event when the action returned a success.
        # 
        # @param action
        # The action contribution that requires an
        # execution event to be fired. Cannot be <code>null</code>.
        # @param returnValue
        # The command's result, may be <code>null</code>.
        def post_execute_success(action, return_value)
          raise NotImplementedError
        end
        
        typesig { [IAction, ExecutionException] }
        # Creates an <code>ExecutionException</code> when the action returned
        # a failure.
        # 
        # @param action
        # The action contribution that caused the exception,
        # never <code>null</code>.
        # @param exception
        # The <code>ExecutionException</code>, never <code>null</code>.
        def post_execute_failure(action, exception)
          raise NotImplementedError
        end
      end }
      
      # A callback mechanism for some external tool to communicate extra
      # information to actions and action contribution items.
      # 
      # @since 3.0
      const_set_lazy(:ICallback) { Module.new do
        include_class_members ExternalActionManager
        
        typesig { [String, IPropertyChangeListener] }
        # <p>
        # Adds a listener to the object referenced by <code>identifier</code>.
        # This listener will be notified if a property of the item is to be
        # changed. This identifier is specific to mechanism being used. In the
        # case of the Eclipse workbench, this is the command identifier.
        # </p>
        # <p>
        # Has no effect if an identical listener has already been added for
        # the <code>identifier</code>.
        # </p>
        # 
        # @param identifier
        # The identifier of the item to which the listener should be
        # attached; must not be <code>null</code>.
        # @param listener
        # The listener to be added; must not be <code>null</code>.
        def add_property_change_listener(identifier, listener)
          raise NotImplementedError
        end
        
        typesig { [String] }
        # An accessor for the accelerator associated with the item indicated by
        # the identifier. This identifier is specific to mechanism being used.
        # In the case of the Eclipse workbench, this is the command identifier.
        # 
        # @param identifier
        # The identifier of the item from which the accelerator
        # should be obtained ; must not be <code>null</code>.
        # @return An integer representation of the accelerator. This is the
        # same accelerator format used by SWT.
        def get_accelerator(identifier)
          raise NotImplementedError
        end
        
        typesig { [String] }
        # An accessor for the accelerator text associated with the item
        # indicated by the identifier. This identifier is specific to mechanism
        # being used. In the case of the Eclipse workbench, this is the command
        # identifier.
        # 
        # @param identifier
        # The identifier of the item from which the accelerator text
        # should be obtained ; must not be <code>null</code>.
        # @return A string representation of the accelerator. This is the
        # string representation that should be displayed to the user.
        def get_accelerator_text(identifier)
          raise NotImplementedError
        end
        
        typesig { [::Java::Int] }
        # Checks to see whether the given accelerator is being used by some
        # other mechanism (outside of the menus controlled by JFace). This is
        # used to keep JFace from trying to grab accelerators away from someone
        # else.
        # 
        # @param accelerator
        # The accelerator to check -- in SWT's internal accelerator
        # format.
        # @return <code>true</code> if the accelerator is already being used
        # and shouldn't be used again; <code>false</code> otherwise.
        def is_accelerator_in_use(accelerator)
          raise NotImplementedError
        end
        
        typesig { [String] }
        # Checks whether the item matching this identifier is active. This is
        # used to decide whether a contribution item with this identifier
        # should be made visible. An inactive item is not visible.
        # 
        # @param identifier
        # The identifier of the item from which the active state
        # should be retrieved; must not be <code>null</code>.
        # @return <code>true</code> if the item is active; <code>false</code>
        # otherwise.
        def is_active(identifier)
          raise NotImplementedError
        end
        
        typesig { [String, IPropertyChangeListener] }
        # Removes a listener from the object referenced by
        # <code>identifier</code>. This identifier is specific to mechanism
        # being used. In the case of the Eclipse workbench, this is the command
        # identifier.
        # 
        # @param identifier
        # The identifier of the item to from the listener should be
        # removed; must not be <code>null</code>.
        # @param listener
        # The listener to be removed; must not be <code>null</code>.
        def remove_property_change_listener(identifier, listener)
          raise NotImplementedError
        end
      end }
      
      # The singleton instance of this class. This value may be <code>null</code>--
      # if it has not yet been initialized.
      
      def instance
        defined?(@@instance) ? @@instance : @@instance= nil
      end
      alias_method :attr_instance, :instance
      
      def instance=(value)
        @@instance = value
      end
      alias_method :attr_instance=, :instance=
      
      typesig { [] }
      # Retrieves the current singleton instance of this class.
      # 
      # @return The singleton instance; this value is never <code>null</code>.
      def get_instance
        if ((self.attr_instance).nil?)
          self.attr_instance = ExternalActionManager.new
        end
        return self.attr_instance
      end
    }
    
    # The callback mechanism to use to retrieve extra information.
    attr_accessor :callback
    alias_method :attr_callback, :callback
    undef_method :callback
    alias_method :attr_callback=, :callback=
    undef_method :callback=
    
    typesig { [] }
    # Constructs a new instance of <code>ExternalActionManager</code>.
    def initialize
      @callback = nil
      # This is a singleton class. Only this class should create an instance.
    end
    
    typesig { [] }
    # An accessor for the current call back.
    # 
    # @return The current callback mechanism being used. This is the callback
    # that should be queried for extra information about actions and
    # action contribution items. This value may be <code>null</code>
    # if there is no extra information.
    def get_callback
      return @callback
    end
    
    typesig { [ICallback] }
    # A mutator for the current call back
    # 
    # @param callbackToUse
    # The new callback mechanism to use; this value may be
    # <code>null</code> if the default is acceptable (i.e., no
    # extra information will provided to actions).
    def set_callback(callback_to_use)
      @callback = callback_to_use
    end
    
    private
    alias_method :initialize__external_action_manager, :initialize
  end
  
end
