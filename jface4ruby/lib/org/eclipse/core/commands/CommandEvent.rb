require "rjava"

# Copyright (c) 2004, 2007 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Core::Commands
  module CommandEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Core::Commands
      include_const ::Org::Eclipse::Core::Commands::Common, :AbstractNamedHandleEvent
    }
  end
  
  # An instance of this class describes changes to an instance of
  # <code>Command</code>.
  # <p>
  # This class is not intended to be extended by clients.
  # </p>
  # 
  # @since 3.1
  # @see ICommandListener#commandChanged(CommandEvent)
  class CommandEvent < CommandEventImports.const_get :AbstractNamedHandleEvent
    include_class_members CommandEventImports
    
    class_module.module_eval {
      # The bit used to represent whether the command has changed its category.
      const_set_lazy(:CHANGED_CATEGORY) { LAST_USED_BIT << 1 }
      const_attr_reader  :CHANGED_CATEGORY
      
      # The bit used to represent whether the command has changed its handler.
      const_set_lazy(:CHANGED_HANDLED) { LAST_USED_BIT << 2 }
      const_attr_reader  :CHANGED_HANDLED
      
      # The bit used to represent whether the command has changed its parameters.
      const_set_lazy(:CHANGED_PARAMETERS) { LAST_USED_BIT << 3 }
      const_attr_reader  :CHANGED_PARAMETERS
      
      # The bit used to represent whether the command has changed its return
      # type.
      # 
      # @since 3.2
      const_set_lazy(:CHANGED_RETURN_TYPE) { LAST_USED_BIT << 4 }
      const_attr_reader  :CHANGED_RETURN_TYPE
      
      # The bit used to represent whether the command has changed its help
      # context identifier.
      # 
      # @since 3.2
      const_set_lazy(:CHANGED_HELP_CONTEXT_ID) { LAST_USED_BIT << 5 }
      const_attr_reader  :CHANGED_HELP_CONTEXT_ID
      
      # The bit used to represent whether this commands active handler has
      # changed its enablement state.
      # 
      # @since 3.3
      const_set_lazy(:CHANGED_ENABLED) { LAST_USED_BIT << 6 }
      const_attr_reader  :CHANGED_ENABLED
    }
    
    # The command that has changed; this value is never <code>null</code>.
    attr_accessor :command
    alias_method :attr_command, :command
    undef_method :command
    alias_method :attr_command=, :command=
    undef_method :command=
    
    typesig { [Command, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Creates a new instance of this class.
    # 
    # @param command
    # the instance of the interface that changed.
    # @param categoryChanged
    # <code>true</code>, iff the category property changed.
    # @param definedChanged
    # <code>true</code>, iff the defined property changed.
    # @param descriptionChanged
    # <code>true</code>, iff the description property changed.
    # @param handledChanged
    # <code>true</code>, iff the handled property changed.
    # @param nameChanged
    # <code>true</code>, iff the name property changed.
    # @param parametersChanged
    # <code>true</code> if the parameters have changed;
    # <code>false</code> otherwise.
    def initialize(command, category_changed, defined_changed, description_changed, handled_changed, name_changed, parameters_changed)
      initialize__command_event(command, category_changed, defined_changed, description_changed, handled_changed, name_changed, parameters_changed, false)
    end
    
    typesig { [Command, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Creates a new instance of this class.
    # 
    # @param command
    # the instance of the interface that changed.
    # @param categoryChanged
    # <code>true</code>, iff the category property changed.
    # @param definedChanged
    # <code>true</code>, iff the defined property changed.
    # @param descriptionChanged
    # <code>true</code>, iff the description property changed.
    # @param handledChanged
    # <code>true</code>, iff the handled property changed.
    # @param nameChanged
    # <code>true</code>, iff the name property changed.
    # @param parametersChanged
    # <code>true</code> if the parameters have changed;
    # <code>false</code> otherwise.
    # @param returnTypeChanged
    # <code>true</code> iff the return type property changed;
    # <code>false</code> otherwise.
    # @since 3.2
    def initialize(command, category_changed, defined_changed, description_changed, handled_changed, name_changed, parameters_changed, return_type_changed)
      initialize__command_event(command, category_changed, defined_changed, description_changed, handled_changed, name_changed, parameters_changed, return_type_changed, false)
    end
    
    typesig { [Command, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Creates a new instance of this class.
    # 
    # @param command
    # the instance of the interface that changed.
    # @param categoryChanged
    # <code>true</code>, iff the category property changed.
    # @param definedChanged
    # <code>true</code>, iff the defined property changed.
    # @param descriptionChanged
    # <code>true</code>, iff the description property changed.
    # @param handledChanged
    # <code>true</code>, iff the handled property changed.
    # @param nameChanged
    # <code>true</code>, iff the name property changed.
    # @param parametersChanged
    # <code>true</code> if the parameters have changed;
    # <code>false</code> otherwise.
    # @param returnTypeChanged
    # <code>true</code> iff the return type property changed;
    # <code>false</code> otherwise.
    # @param helpContextIdChanged
    # <code>true</code> iff the help context identifier changed;
    # <code>false</code> otherwise.
    # @since 3.2
    def initialize(command, category_changed, defined_changed, description_changed, handled_changed, name_changed, parameters_changed, return_type_changed, help_context_id_changed)
      initialize__command_event(command, category_changed, defined_changed, description_changed, handled_changed, name_changed, parameters_changed, return_type_changed, help_context_id_changed, false)
    end
    
    typesig { [Command, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean, ::Java::Boolean] }
    # Creates a new instance of this class.
    # 
    # @param command
    # the instance of the interface that changed.
    # @param categoryChanged
    # <code>true</code>, iff the category property changed.
    # @param definedChanged
    # <code>true</code>, iff the defined property changed.
    # @param descriptionChanged
    # <code>true</code>, iff the description property changed.
    # @param handledChanged
    # <code>true</code>, iff the handled property changed.
    # @param nameChanged
    # <code>true</code>, iff the name property changed.
    # @param parametersChanged
    # <code>true</code> if the parameters have changed;
    # <code>false</code> otherwise.
    # @param returnTypeChanged
    # <code>true</code> iff the return type property changed;
    # <code>false</code> otherwise.
    # @param helpContextIdChanged
    # <code>true</code> iff the help context identifier changed;
    # <code>false</code> otherwise.
    # @param enabledChanged
    # <code>true</code> iff the comand enablement changed;
    # <code>false</code> otherwise.
    # @since 3.3
    def initialize(command, category_changed, defined_changed, description_changed, handled_changed, name_changed, parameters_changed, return_type_changed, help_context_id_changed, enabled_changed)
      @command = nil
      super(defined_changed, description_changed, name_changed)
      if ((command).nil?)
        raise NullPointerException.new
      end
      @command = command
      if (category_changed)
        self.attr_changed_values |= CHANGED_CATEGORY
      end
      if (handled_changed)
        self.attr_changed_values |= CHANGED_HANDLED
      end
      if (parameters_changed)
        self.attr_changed_values |= CHANGED_PARAMETERS
      end
      if (return_type_changed)
        self.attr_changed_values |= CHANGED_RETURN_TYPE
      end
      if (help_context_id_changed)
        self.attr_changed_values |= CHANGED_HELP_CONTEXT_ID
      end
      if (enabled_changed)
        self.attr_changed_values |= CHANGED_ENABLED
      end
    end
    
    typesig { [] }
    # Returns the instance of the interface that changed.
    # 
    # @return the instance of the interface that changed. Guaranteed not to be
    # <code>null</code>.
    def get_command
      return @command
    end
    
    typesig { [] }
    # Returns whether or not the category property changed.
    # 
    # @return <code>true</code>, iff the category property changed.
    def is_category_changed
      return (!((self.attr_changed_values & CHANGED_CATEGORY)).equal?(0))
    end
    
    typesig { [] }
    # Returns whether or not the handled property changed.
    # 
    # @return <code>true</code>, iff the handled property changed.
    def is_handled_changed
      return (!((self.attr_changed_values & CHANGED_HANDLED)).equal?(0))
    end
    
    typesig { [] }
    # Returns whether or not the help context identifier changed.
    # 
    # @return <code>true</code>, iff the help context identifier changed.
    # @since 3.2
    def is_help_context_id_changed
      return (!((self.attr_changed_values & CHANGED_HELP_CONTEXT_ID)).equal?(0))
    end
    
    typesig { [] }
    # Returns whether or not the parameters have changed.
    # 
    # @return <code>true</code>, iff the parameters property changed.
    def is_parameters_changed
      return (!((self.attr_changed_values & CHANGED_PARAMETERS)).equal?(0))
    end
    
    typesig { [] }
    # Returns whether or not the return type property changed.
    # 
    # @return <code>true</code>, iff the return type property changed.
    # @since 3.2
    def is_return_type_changed
      return (!((self.attr_changed_values & CHANGED_RETURN_TYPE)).equal?(0))
    end
    
    typesig { [] }
    # Return whether the enable property changed.
    # 
    # @return <code>true</code> iff the comand enablement changed
    # @since 3.3
    def is_enabled_changed
      return (!((self.attr_changed_values & CHANGED_ENABLED)).equal?(0))
    end
    
    private
    alias_method :initialize__command_event, :initialize
  end
  
end
